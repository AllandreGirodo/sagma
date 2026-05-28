# 🛠️ Manual Operacional da Administradora

## Visão Geral
O painel operativo do **SAGMA (Sistema de Agendamento e Gestão para Massoterapia)** foi projetado para centralizar a governança da clínica. Ele é responsivo, adaptando-se automaticamente a telas mobile e terminais web, e é dividido em quatro módulos principais: **Dash, Agenda, Clientes e Pendentes**.

**Figura 1. Tela Admin Dashboard Resumo Geral**
<br>
![Tela Admin Dashboard Resumo Geral](complementares/Tela_Admin_Dashboard_Resumo_Geral.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura apresenta a visão consolidada dos indicadores analíticos da administradora, com métricas de acompanhamento diário e mensal.

---

## 1. Dashboard (Indicadores Analíticos)
A aba **Dash** atua como o centro de inteligência do negócio. Os dados nela apresentados derivam de *snapshots* registrados reativamente na coleção `metricas_diarias`.

- **Volumetria Diária/Semanal/Mensal:** Total de agendamentos realizados e pendentes.
- **Estimativa de Faturamento:** Projeção de receita baseada nas sessões confirmadas e realizadas no mês.
- **Taxa de Absenteísmo e Cancelamentos:** Indicadores percentuais de clientes que desmarcaram, categorizados entre "cancelado" (dentro do prazo) e "cancelado_tardio" (com ônus).

**Figura 2. Tela Admin Pendentes Aprovacao Cadastro**
<br>
![Tela Admin Pendentes Aprovacao Cadastro](complementares/Tela_Admin_Pendentes_Aprovacao_Cadastro.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura evidencia a fila de cadastros aguardando aprovação, etapa importante para a validação de novos clientes.

---

## 2. Gestão de Agenda e Integrações
A aba **Agenda** exibe a grade cronológica da profissional.

**Figura 3. Diagrama Casos Uso Admin Agenda Massoterapia**
<br>
![Diagrama Casos Uso Admin Agenda Massoterapia](diagramas/diagrama_casos_uso_admin_agenda_massoterapia.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura apresenta o diagrama de casos de uso da administradora, destacando as interações centrais entre triagem, aprovação, recusa e sincronização de agenda.

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

**Figura 4. Tela Google Agenda Semana Horarios**
<br>
![Tela Google Agenda Semana Horarios](complementares/Tela_Google_Agenda_Semana_Horarios.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura ilustra a integração visual com a agenda externa, exibindo a organização semanal dos horários da profissional.

**Figura 5. Tela Admin Agendamentos Vazios Lista**
<br>
![Tela Admin Agendamentos Vazios Lista](complementares/Tela_Admin_Agendamentos_Vazios_Lista.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura mostra a tela de agendamentos quando a lista está vazia, evidenciando o estado inicial da gestão da agenda.

---

## 3. Gestão de Clientes e Pacotes
O módulo **Clientes** apresenta a base de usuários registrados (coleção `usuarios`).

- **Busca Avançada:** Localização de cadastros via Nome, E-mail ou ID.
- **Fichas Detalhadas:** Informações críticas do paciente (anamnese), saldo atualizado de sessões (pacotes ativos) e histórico financeiro de pagamentos.
- **Controle de Saldo:** Possibilidade de abater sessões consumidas e gerenciar métricas de recorrência (frequência histórica).

**Figura 6. Tela Admin Clientes Detalhes Completos**
<br>
![Tela Admin Clientes Detalhes Completos](complementares/Tela_Admin_Clientes_Detalhes_Completos.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura apresenta a ficha detalhada de um cliente, reunindo informações cadastrais, histórico e controles administrativos.

**Figura 7. Tela Administracao Clientes Tema Escuro**
<br>
![Tela Administracao Clientes Tema Escuro](complementares/Tela_Administracao_Clientes_Tema_Escuro.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura ilustra a listagem de clientes no tema escuro, usada para validar contraste e conforto visual na administração.

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

**Figura 8. Tela Administracao Escolher Tema Dialogo Preview**
<br>
![Tela Administracao Escolher Tema Dialogo Preview](complementares/Tela_Administracao_Escolher_Tema_Dialogo_Preview.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura mostra a pré-visualização do tema antes da aplicação definitiva na interface administrativa.

**Figura 9. Tela Administracao Escolher Tema Lista Opcoes**
<br>
![Tela Administracao Escolher Tema Lista Opcoes](complementares/Tela_Administracao_Escolher_Tema_Lista_Opcoes.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura evidencia a lista de opções disponíveis para personalização do tema da interface.

---

> *Nota Técnica: Todas as configurações globais descritas (incluindo chaves de personalização e regras de cancelamento) são persistidas diretamente no Cloud Firestore (coleções `configuracoes/geral` e `configuracoes_gerais`), propagando as regras de negócio de maneira instantânea sem necessidade de atualizações nas lojas de aplicativos.*

---

## Links Relacionados

- Manual Administrativo: [MANUAL_ADMINISTRATIVO.md](MANUAL_ADMINISTRATIVO.md) (você está aqui!)
- Manual do Cliente: [MANUAL_CLIENTE.md](MANUAL_CLIENTE.md) (veja também)
- DevOps e Emuladores: [DEVOPS_AND_EMULATORS.md](DEVOPS_AND_EMULATORS.md) (veja também)
