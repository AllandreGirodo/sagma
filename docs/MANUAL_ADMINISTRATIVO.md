# 🛠️ Manual Operacional da Administradora

## Visão Geral
O painel operativo do **SAGMA (Sistema de Agendamento e Gestão para Massoterapia)** foi projetado para centralizar a governança da clínica. Ele é responsivo, adaptando-se automaticamente a telas mobile e terminais web, e é dividido em quatro módulos principais: **Dash, Agenda, Clientes e Pendentes**.

---

## 1. Dashboard (Indicadores Analíticos)
A aba **Dash** atua como o centro de inteligência do negócio. Os dados nela apresentados derivam de *snapshots* registrados reativamente na coleção `metricas_diarias`.

- **Volumetria Diária/Semanal/Mensal:** Total de agendamentos realizados e pendentes.
- **Estimativa de Faturamento:** Projeção de receita baseada nas sessões confirmadas e realizadas no mês.
- **Taxa de Absenteísmo e Cancelamentos:** Indicadores percentuais de clientes que desmarcaram, categorizados entre "cancelado" (dentro do prazo) e "cancelado_tardio" (com ônus).

---

## 2. Gestão de Agenda e Integrações
A aba **Agenda** exibe a grade cronológica da profissional.

```mermaid
flowchart LR
    A([Novo Pedido]) --> B{Triagem}
    B -- Aprovar --> C[Aprovado]
    B -- Recusar --> D[Recusado]
    C --> E[Sync Google Agenda]
    style C fill:#c8e6c9,stroke:#388e3c
    style D fill:#ffcdd2,stroke:#d32f2f
```

- **Triagem de Solicitações (Aba Pendentes):** Novos pedidos entram no estado inicial `solicitado`. A administradora possui a alçada para *Aprovar* ou *Recusar*, evitando sobreposições de horários.
- **Google Calendar Sync:** Uma integração unidirecional garante que todas as sessões validadas pelo aplicativo reflitam de forma imediata na grade do Google Agenda pessoal da profissional.
- **Notificações:** Ações tomadas na agenda disparam eventos e podem acionar o WhatsApp para comunicação direta com o cliente.

---

## 3. Gestão de Clientes e Pacotes
O módulo **Clientes** apresenta a base de usuários registrados (coleção `usuarios`).

- **Busca Avançada:** Localização de cadastros via Nome, E-mail ou ID.
- **Fichas Detalhadas:** Informações críticas do paciente (anamnese), saldo atualizado de sessões (pacotes ativos) e histórico financeiro de pagamentos.
- **Controle de Saldo:** Possibilidade de abater sessões consumidas e gerenciar métricas de recorrência (frequência histórica).

---

## 4. Personalização da Experiência (UI/UX)
O sistema permite que o administrador ajuste a interface para seu conforto ergonômico e perfil de atendimento:

- **Temas Dinâmicos:** Acesso a 10 esquemas de cores pré-configurados (incluindo o *Dark Mode* / Tema Escuro), com aplicação e pré-visualização em tempo real.
- **Internacionalização (i18n):** Suporte nativo e troca instantânea entre 5 idiomas:
  - 🇧🇷 Português (Brasileiro)
  - 🇺🇸 Inglês (English)
  - 🇪🇸 Espanhol (Español)
  - 🇫🇷 Francês (Français)
  - 🇯🇵 Japonês (日本語)

---

> *Nota Técnica: Todas as configurações globais descritas (incluindo chaves de personalização e regras de cancelamento) são persistidas diretamente no Cloud Firestore (coleções `configuracoes/geral` e `configuracoes_gerais`), propagando as regras de negócio de maneira instantânea sem necessidade de atualizações nas lojas de aplicativos.*