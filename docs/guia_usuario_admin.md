# Guia da Administradora — SAGMA

Este guia é destinado à administradora do sistema (Andréia). Explica como usar cada função do painel de forma prática, sem linguagem técnica.

---

## Acessando o Sistema

1. Abra o app ou acesse o link web do SAGMA
2. Digite seu e-mail e senha
3. Você será direcionada ao **Painel Administrativo** automaticamente

> Se aparecer mensagem de erro no login, verifique se seu cadastro tem `tipo_usuario = Administrador` e `status_aprovacao = aprovado` no Firestore.

---

## Painel Principal (Dashboard)

Ao entrar, você verá um resumo do dia:

| Indicador | O que significa |
|---|---|
| Agendamentos hoje | Quantas sessões estão marcadas para hoje |
| Receita estimada | Soma dos valores dos agendamentos aprovados do dia |
| Pendentes de aprovação | Agendamentos que o cliente solicitou mas você ainda não aprovou |

---

## Gerenciar Agendamentos

**Caminho:** Menu → Agendamentos

### Aprovar ou recusar uma solicitação

1. Na aba **Pendentes**, toque no agendamento
2. Escolha **Aprovar** ou **Recusar**
3. Se recusar, escreva o motivo — o cliente verá essa mensagem no app

### Criar agendamento manualmente (pelo admin)

Útil para clientes que agendam por telefone:

1. Toque no botão **+** (canto inferior direito)
2. Selecione a cliente na lista
3. Escolha data, horário e tipo de massagem
4. Confirme — o agendamento já entra como **aprovado**

### Encerrar sessão como realizada

Após a sessão acontecer:

1. Abra o agendamento
2. Toque em **Marcar como Realizado**
3. O sistema faz a baixa automática no estoque dos produtos configurados para consumo automático

---

## Gerenciar Clientes

**Caminho:** Menu → Agendamentos → aba Clientes

### Aprovar um novo cadastro

Quando uma nova cliente se cadastra, ela fica com status **Pendente**:

1. Na lista de clientes, toque na cliente com indicador laranja
2. Toque no ícone ✅ (verde) para aprovar
3. Um SnackBar aparece com a opção **WhatsApp** — toque para enviar automaticamente a mensagem:
   > *"Olá [Nome]! Seu cadastro foi aprovado no SAGMA. Você já pode entrar no app e agendar sua sessão. Até logo!"*

### Entrar em contato pelo WhatsApp

Para qualquer cliente já cadastrada:

1. Localize-a na lista
2. Toque no ícone 💬 (verde-teal) ao lado do nome
3. O WhatsApp abre com a conversa pré-iniciada

---

## Controle Financeiro

**Caminho:** Menu → Financeiro

- O gráfico de barras mostra o faturamento mês a mês do ano selecionado
- Use o seletor de ano (canto superior direito) para ver anos anteriores
- O total anual aparece abaixo do gráfico

### Exportar Relatório PDF

1. Role até o final da tela financeira
2. Toque em **Exportar Relatório PDF**
3. Um PDF é gerado com tabela de faturamento mensal e total anual
4. O painel de compartilhamento do sistema se abre — salve ou envie por e-mail/WhatsApp

---

## Estoque

**Caminho:** Menu → Estoque

- Cadastre produtos usados nas sessões (óleos, toalhas, etc.)
- Marque **Consumo automático** para que o sistema desconte 1 unidade cada vez que uma sessão for marcada como realizada
- O sistema alerta quando a quantidade chegar a zero

---

## Cupons de Desconto

**Caminho:** Menu → Configurações → Cupons

- Crie cupons com código personalizado (ex: `BOAS-VINDAS`)
- Defina tipo: **Porcentagem** (%) ou **Valor fixo** (R$)
- Configure a data de validade
- A cliente digita o código ao agendar e o desconto é aplicado automaticamente

---

## Configurações Gerais

**Caminho:** Menu → Configurações

| Configuração | Para que serve |
|---|---|
| Preço da sessão | Valor padrão cobrado por atendimento |
| Horário de funcionamento | Início e fim do expediente (ex: 08:00 – 18:00) |
| Antecedência mínima | Quantas horas antes uma cliente pode cancelar sem taxa |
| WhatsApp da admin | Número de contato exibido para os clientes |
| Tipos de massagem | Lista de serviços disponíveis para agendamento |

---

## Notificações Push

Você recebe automaticamente uma notificação no celular quando:
- Uma nova cliente solicita um agendamento

As clientes recebem automaticamente:
- Um lembrete 24 horas antes da sessão agendada

> Para as notificações funcionarem, o app precisa estar instalado no celular com permissão de notificações concedida.

---

## Versão do App

**Caminho:** Menu → Sobre / Versão

- Mostra a versão atual instalada
- Se houver uma versão obrigatória mais recente, o app pedirá atualização antes de continuar

---

## Perguntas Frequentes

**Uma cliente disse que não consegue entrar no app — o que faço?**
Verifique se o cadastro dela está com status `aprovado`. Se estiver pendente, aprove pela aba Clientes.

**O relatório PDF mostra R$ 0,00 em todos os meses — o que pode ser?**
O relatório considera apenas agendamentos com `status = aprovado`. Verifique se os agendamentos foram aprovados e não apenas criados.

**A notificação não chegou no meu celular — como resolver?**
1. Abra o app e faça login novamente (isso atualiza o token FCM)
2. Verifique se as notificações do app estão habilitadas nas configurações do celular
3. No Android, verifique se o app não está em modo de economia de bateria agressiva

**Como trocar minha senha?**
No app, acesse seu perfil → **Alterar Senha**. Um e-mail de redefinição será enviado pelo Firebase.
