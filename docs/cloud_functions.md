# Cloud Functions — Referência Completa

**Arquivo fonte:** `functions/index.js`  
**Runtime:** Node.js 20  
**Região padrão:** `southamerica-east1` (São Paulo)  
**Deploy:** `firebase deploy --only functions`

---

## Visão Geral

| Função | Tipo | Gatilho | Finalidade |
|---|---|---|---|
| `limparLogsLgpdAntigos` | Scheduled | Diário 03:00 | Remove logs LGPD com mais de 5 anos |
| `enviarPushNotificacao` | HTTPS Callable | App Flutter | Envia push FCM para um token específico |
| `notificarNovoAgendamento` | Firestore Trigger | Criação em `agendamentos/{id}` | Notifica admins sobre nova solicitação |
| `enviarLembretesManual` | HTTPS Callable | App Flutter (admin) | Dispara lembretes manualmente |
| `enviarLembretesDiarios` | Scheduled | Diário 08:00 (Brasília) | Lembretes automáticos 24h antes |
| `dispararMensagensAleatoriasClientesManual` | HTTPS Callable | App Flutter (admin) | Envia mensagem de marketing aos clientes |

---

## 1. `limparLogsLgpdAntigos`

**Tipo:** Scheduled  
**Horário:** Todo dia às 03:00 (UTC)  
**Requisito LGPD:** RF008

### O que faz
Varre a coleção `lgpd_logs` e exclui em lote todos os documentos com campo `data` anterior a 5 anos atrás.

### Configuração
Nenhuma configuração necessária. Roda automaticamente após o deploy.

---

## 2. `enviarPushNotificacao`

**Tipo:** HTTPS Callable  
**Nome no app:** configurável via `PUSH_NOTIFICATION_FUNCTION_NAME=enviarPushNotificacao`  
**Chamada Flutter:**
```dart
FirestoreService.enviarNotificacaoPush(token, titulo, corpo)
// → FirebaseFunctions.instance.httpsCallable('enviarPushNotificacao').call({...})
```

### Payload de entrada
```json
{
  "token": "FCM_DEVICE_TOKEN",
  "titulo": "Título da notificação",
  "corpo": "Corpo da mensagem"
}
```

### Resposta de sucesso
```json
{ "success": true, "messageId": "projects/.../messages/..." }
```

### Erros possíveis
| Código | Causa |
|---|---|
| `invalid-argument` | `token`, `titulo` ou `corpo` ausentes/inválidos |
| `internal` | Falha na API do FCM |

---

## 3. `notificarNovoAgendamento`

**Tipo:** Firestore Trigger  
**Gatilho:** `onCreate` em `agendamentos/{agendamentoId}`  
**Nenhuma chamada manual necessária** — dispara automaticamente.

### O que faz
1. Lê os dados do novo documento de agendamento
2. Busca todos os usuários com `tipo == 'admin'` e `aprovado == true`
3. Para cada admin com `fcm_token` válido, envia push FCM com:
   - **Título:** `"Nova solicitação de agendamento"`
   - **Corpo:** `"[Nome do cliente] quer agendar [tipo] em [data/hora]"`
4. Inclui `data.agendamento_id` e `data.tipo = "novo_agendamento"` no payload para deep link

### Campos lidos do agendamento
| Campo | Fallback |
|---|---|
| `cliente_nome_snapshot` | `cliente_nome` → `"Cliente"` |
| `tipo_massagem` | `tipo` → `"massagem"` |
| `data_hora` (Timestamp) | `"horário não definido"` |

---

## 4. `enviarLembretesManual`

**Tipo:** HTTPS Callable  
**Chamada Flutter:**
```dart
// Em FirestoreService:
final callable = _functions.httpsCallable('enviarLembretesManual');
await callable.call({'horas': 24});
```

### Payload de entrada
```json
{ "horas": 24 }
```
> `horas` é opcional — padrão: `24`. Define quantas horas à frente buscar agendamentos.

### Resposta
```json
{ "enviados": 3, "erros": 0, "total": 3 }
```

### Lógica interna
Delega para `_processarLembretes(horas)` — ver seção de helpers abaixo.

---

## 5. `enviarLembretesDiarios`

**Tipo:** Scheduled  
**Horário:** Todo dia às 08:00, fuso `America/Sao_Paulo`  
**Nenhuma chamada manual necessária.**

### O que faz
Chama `_processarLembretes(24)` automaticamente — envia lembretes para todos os agendamentos aprovados que ocorrem entre 23:30 e 24:30 a partir do momento da execução.

---

## 6. `dispararMensagensAleatoriasClientesManual`

**Tipo:** HTTPS Callable  
**Chamada Flutter:**
```dart
final callable = _functions.httpsCallable('dispararMensagensAleatoriasClientesManual');
await callable.call({
  'dryRun': false,     // true = apenas simula, não envia
  'limite': 0,         // 0 = sem limite (todos os clientes)
  'indiceMensagemSelecionada': -1  // -1 = aleatória
});
```

### Payload de entrada
| Campo | Tipo | Padrão | Descrição |
|---|---|---|---|
| `dryRun` | boolean | `true` | Se `true`, simula sem enviar |
| `limite` | number | `0` | Máximo de clientes; `0` = todos |
| `indiceMensagemSelecionada` | number | `-1` | Índice da mensagem em `configuracoes/notificacoes.mensagens_aleatorias`; `-1` = aleatório |

### Resposta (dryRun = true)
```json
{ "dryRun": true, "total": 12, "mensagem": "Cuide-se! Uma sessão de massagem..." }
```

### Resposta (dryRun = false)
```json
{ "dryRun": false, "enviados": 10, "erros": 2, "total": 12, "mensagem": "..." }
```

### Mensagens padrão (fallback quando Firestore não tem configuração)
1. "Seu bem-estar é nossa prioridade. Agende já sua sessão de massagem!"
2. "Cuide-se! Uma sessão de massagem pode transformar o seu dia."
3. "Que tal um momento de relaxamento? Temos horários disponíveis para você."

Para personalizar, crie o documento `configuracoes/notificacoes` com campo `mensagens_aleatorias: string[]`.

---

## Helper: `_processarLembretes(horas)`

Função interna (não exportada) usada por `enviarLembretesManual` e `enviarLembretesDiarios`.

### Algoritmo
1. Calcula janela: `[agora + horas - 30min, agora + horas + 30min]`
2. Busca `agendamentos` com `status == 'aprovado'` e `data_hora` dentro da janela
3. Para cada agendamento:
   a. Resolve o FCM token do cliente via `usuarios/{cliente_email_snapshot}` (primário)
   b. Fallback: `usuarios where id == cliente_id`
4. Envia push FCM com lembrete personalizado
5. Retorna `{ enviados, erros, total }`

---

## Pré-requisitos para funcionamento

### 1. Tokens FCM no Firestore
Cada usuário precisa ter o campo `fcm_token` atualizado no documento `usuarios/{email}`. O app Flutter salva este token automaticamente no login via `FirestoreService.salvarFcmToken()`.

### 2. Permissões IAM
A service account das Cloud Functions precisa da role `Firebase Cloud Messaging Admin` para enviar push. Isso é configurado automaticamente ao habilitar o Firebase Messaging no projeto.

### 3. Variáveis de ambiente do app
```
PUSH_NOTIFICATION_FUNCTION_NAME=enviarPushNotificacao
RANDOM_MESSAGES_FUNCTION_NAME=dispararMensagensAleatoriasClientesManual
```

---

## Deploy e Monitoramento

```bash
# Deploy de todas as funções
firebase deploy --only functions

# Apenas uma função específica
firebase deploy --only functions:enviarLembretesDiarios

# Ver logs em tempo real
firebase functions:log --only enviarLembretesDiarios

# Ver logs de todas as funções
firebase functions:log
```

Os logs estruturados são enviados ao **Cloud Logging** (Google Cloud Console → Logging) com as labels `function_name` e `severity`.
