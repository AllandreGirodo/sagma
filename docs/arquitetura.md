# Arquitetura do SAGMA — Visão Geral do Código

## Estrutura de Pastas

```
Agenda/
├── lib/                          ← Código Flutter/Dart
│   ├── main.dart                 ← Ponto de entrada, inicialização Firebase
│   ├── app_localizations.dart    ← Internacionalização (PT/EN/ES)
│   ├── config/
│   │   ├── firebase_options.dart ← Gerado pelo FlutterFire CLI
│   │   ├── firestore.rules       ← Regras de segurança Firestore
│   │   └── firestore.indexes.json
│   ├── core/
│   │   ├── models/               ← Modelos de dados puros (sem lógica UI)
│   │   ├── services/             ← Acesso a dados e regras de negócio
│   │   ├── utils/                ← Utilitários, validadores, strings
│   │   └── widgets/              ← Componentes UI reutilizáveis
│   ├── features/                 ← Módulos organizados por domínio
│   │   ├── admin/
│   │   ├── agendamento/
│   │   ├── auth/
│   │   ├── cupom/
│   │   ├── estoque/
│   │   ├── financeiro/
│   │   ├── perfil/
│   │   └── tools/
│   └── view/                     ← Views globais e administrativas
├── functions/
│   └── index.js                  ← Cloud Functions (Node.js 20)
├── android/                      ← Configuração nativa Android
├── ios/                          ← Configuração nativa iOS
├── web/                          ← Configuração web (manifest, index.html)
├── docs/                         ← Documentação do projeto
├── firebase.json                 ← Configuração Firebase (hosting, emulators)
└── pubspec.yaml                  ← Dependências Flutter
```

---

## Camada de Modelos (`lib/core/models/`)

Objetos de dados puros — sem lógica de UI. Cada modelo tem `toMap()` e `fromMap()`.

| Arquivo | Classe | Coleção Firestore |
|---|---|---|
| `usuario_model.dart` | `UsuarioModel` | `usuarios/{email}` |
| `agendamento_model.dart` | `Agendamento` | `agendamentos/{id}` |
| `transacao_model.dart` | `TransacaoFinanceira` | `transacoes/{id}` |
| `estoque_model.dart` | `ItemEstoque` | `estoque/{id}` |
| `cupom_model.dart` | `CupomModel` | `cupons/{codigo}` |
| `chat_model.dart` | `ChatMensagem` | `agendamentos/{id}/mensagens/{id}` |
| `config_model.dart` | `ConfigModel` | `configuracoes/geral` |
| `app_software_config_model.dart` | `AppSoftwareConfig` | `app_software/config` |
| `changelog_model.dart` | `ChangeLogModel` | `app_changelog/{id}` |
| `log_model.dart` | `LogModel` | `logs/{id}` |
| `firestore_structure_helper.dart` | `FirestoreStructureHelper` | — (utilitário) |

**Subcollections:**

```
usuarios/{email}/perfil/cliente    → ClienteModel  (features/perfil/models/)
agendamentos/{id}/mensagens/{id}   → ChatMensagem
```

---

## Camada de Serviços (`lib/core/services/`)

Toda a lógica de acesso a dados está centralizada aqui, desacoplando a UI do banco.

### `FirestoreService` — serviço principal

Mais de 3.600 linhas. Responsável por:

| Grupo de métodos | O que faz |
|---|---|
| Usuários | CRUD, aprovação, busca por email/uid |
| Agendamentos | Stream em tempo real, criação, aprovação, cancelamento |
| Financeiro | Transações, cálculo de faturamento mensal |
| Estoque | CRUD de itens, baixa automática |
| Cupons | Validação de código, CRUD admin |
| Configurações | Leitura/escrita de `configuracoes/geral` e subdocumentos |
| Push notifications | `enviarNotificacaoPush()` → chama Cloud Function callable |
| LGPD | `anonimizarConta()`, `registrarLgpdLog()` |
| App governance | Versão mínima, changelog |
| Exportação/importação | `exportarDados()`, `importarDados()` (DevTools) |

### `AuthService`

Login, logout, registro, reset de senha, integração Google OAuth.

### `AuthSecurityService`

Controle de tentativas de login e bloqueio temporário por IP/email.

### `AppGovernanceService`

Verifica se a versão instalada atende a `min_required_version` de `app_software/config`. Força atualização se necessário.

### `SchedulingService`

Lógica de disponibilidade de horários: filtra slots ocupados, respeita intervalo entre sessões e horário de funcionamento configurado em `configuracoes/geral`.

---

## Camada de Utilitários (`lib/core/utils/`)

| Arquivo | Conteúdo |
|---|---|
| `app_strings.dart` | Todas as strings da UI em PT/EN/ES (helper `_isPt`) |
| `app_styles.dart` | Estilos e cores compartilhados |
| `validadores.dart` | Validação de CPF (Módulo 11), e-mail, CEP, telefone |
| `logger.dart` | Logger estruturado para Cloud Logging |
| `massage_type_catalog.dart` | Catálogo de tipos de massagem e suas durações |
| `international_phone_input_formatter.dart` | Máscara de telefone internacional |
| `app_check_debug_token*.dart` | Stub/web para token de debug App Check |

---

## Módulos de Features (`lib/features/`)

Cada feature é autocontida: `view/`, `controller/` (se houver), `widgets/`, `models/`.

### `auth/`
- `login_view.dart` — tela de login com Google e email/senha
- `signup_view.dart` — cadastro de nova cliente
- `login_controller.dart` — lógica de login, detecção de emulador, App Check
- `aguardando_aprovacao_view.dart` — tela exibida após cadastro pendente
- `google_profile_completion_view.dart` — completa perfil após login Google

### `agendamento/`
- `agendamento_view.dart` — fluxo de agendamento para o cliente (calendário → horário → confirmação)
- `admin_agendamentos_view.dart` — painel admin: lista por status, aprovação, lista de clientes, WhatsApp
- `chat_agendamento_view.dart` — chat por agendamento (cliente ↔ admin)
- `widgets/calendar_color_picker.dart` — calendário com cores por status

### `financeiro/`
- `admin_financeiro_view.dart` — gráfico de barras mensal + exportação PDF

### `perfil/`
- `perfil_view.dart` — formulário de perfil do cliente (anamnese, foto, contatos, LGPD)

### `estoque/`
- `admin_estoque_view.dart` — CRUD de itens do estoque

### `cupom/`
- `admin_cupons_view.dart` — criação e gestão de cupons

### `admin/`
- `config_view.dart` — configurações gerais do sistema
- `logs_view.dart` — visualização de logs de sistema
- `lgpd_logs_view.dart` — logs de anonimização (somente admin)
- `relatorios_view.dart` — relatórios gerenciais avançados
- `admin_senha_setup_view.dart` — configuração de senha para DevTools

### `tools/`
- `services_view.dart` — visão de serviços e health check do sistema

---

## Views Globais (`lib/view/`)

| Arquivo | Finalidade |
|---|---|
| `dashboard_view.dart` | Dashboard principal pós-login (admin e cliente) |
| `dev_tools_view.dart` | Ferramentas de desenvolvedor (acesso restrito por senha) |
| `onboarding_view.dart` | Tela de boas-vindas para novos usuários |
| `manutencao_view.dart` | Tela exibida quando o sistema está em manutenção |
| `app_initialization_view.dart` | Splash + verificação de versão e manutenção |
| `termos_uso_view.dart` | Termos de uso e privacidade (LGPD) |
| `config_error_view.dart` | Tela de erro de configuração Firebase |
| `admin_nova_transacao_view.dart` | Registro manual de transação financeira |
| `db_seeder.dart` | Semeador de dados de teste (DevTools) |

---

## Cloud Functions (`functions/index.js`)

Node.js 20, região `southamerica-east1`. Ver referência completa em [`cloud_functions.md`](cloud_functions.md).

```
limparLogsLgpdAntigos         → Scheduled 03:00 diário
enviarPushNotificacao         → HTTPS Callable
notificarNovoAgendamento      → Firestore trigger (agendamentos create)
enviarLembretesManual         → HTTPS Callable
enviarLembretesDiarios        → Scheduled 08:00 diário (Brasília)
dispararMensagensAleatoriasClientesManual → HTTPS Callable
```

---

## Internacionalização

O arquivo `app_localizations.dart` define traduções completas para PT-BR, EN-US e ES.  
As strings de UI usam `AppStrings` (helper estático) ou `AppLocalizations.of(context)`.

**Adicionando uma nova string:**
1. Adicione em `AppStrings` (PT como padrão)
2. Adicione a tradução EN e ES no mesmo getter
3. Use `AppStrings.suaChave` nas Views

---

## Fluxo de Inicialização (`main.dart`)

```
main()
  └── WidgetsFlutterBinding.ensureInitialized()
  └── Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
  └── FirebaseMessaging.onBackgroundMessage(_handler)
  └── runApp(MaterialApp)
        └── AppInitializationView
              ├── Verifica configuracoes/geral.manutencao → ManutencaoView
              ├── Verifica versão mínima → AppGovernanceDialog
              └── FirebaseAuth.authStateChanges()
                    ├── null → LoginView / OnboardingView
                    ├── aprovado=false → AguardandoAprovacaoView
                    └── aprovado=true → DashboardView (admin ou cliente)
```

---

## Principais Dependências (`pubspec.yaml`)

| Pacote | Versão | Finalidade |
|---|---|---|
| `firebase_core` | — | Inicialização Firebase |
| `firebase_auth` | — | Autenticação |
| `cloud_firestore` | — | Banco de dados |
| `firebase_messaging` | — | Push notifications (FCM) |
| `firebase_storage` | — | Upload de fotos de perfil |
| `firebase_app_check` | — | Proteção contra abuso de API |
| `fl_chart` | — | Gráfico de barras financeiro |
| `pdf` | 3.10.4 | Geração de PDF |
| `share_plus` | 12.x | Compartilhamento nativo |
| `path_provider` | — | Diretório temporário (mobile) |
| `url_launcher` | — | Abrir WhatsApp / links externos |
| `image_picker` | — | Seleção de foto de perfil |
| `flutter_localizations` | SDK | Suporte a i18n |
| `intl` | — | Formatação de datas e moedas |
