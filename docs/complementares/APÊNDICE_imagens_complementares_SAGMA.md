# APÊNDICE A - Imagens Complementares SAGMA

Este documento reúne, de forma sistematizada, as capturas de tela, mockups e demais evidências visuais relacionadas ao aplicativo SAGMA, apresentando os arquivos já renomeados de maneira descritiva para facilitar sua referência ao longo do texto acadêmico.

## Galeria de imagens

As imagens abaixo permanecem como registros visuais do apêndice; o diagrama a seguir organiza, em um único mapa, toda a sequência temática do material.

```mermaid
flowchart TD
    A[APÊNDICE A] --> B1[A.1 Fluxo Inicial e Autenticação\nFiguras 1 a 10]
    A --> B2[A.2 Infraestrutura, Diagnóstico e Governança\nFiguras 11 a 30]
    A --> B3[A.3 Experiência do Cliente e Histórico de Atendimentos\nFiguras 31 a 38]
    A --> B4[A.4 Agendamentos e Operação Administrativa\nFiguras 39 e 40]
    A --> B5[A.5 Personalização Visual e Governança de Interface\nFiguras 41 a 57]
    A --> B6[A.6 Esboço APP Caderno\nFiguras 58 a 60]

    B1 --> C1[Boas-vindas, login, cadastro e LGPD]
    B1 --> C2[Consolidação inicial e arquitetura]
    B2 --> C3[Emulador, dashboard e agenda]
    B2 --> C4[Temas, ajustes e configurações]
    B3 --> C5[Perfil, histórico e pacotes]
    B4 --> C6[Operação administrativa inicial]
    B5 --> C7[Seleção, confirmação e métricas]
    B6 --> C8[Esboço visual do aplicativo]
```

## Diagramas do Sistema

### Diagrama de Atividades do Admin

```mermaid
flowchart TD
    A[Início] --> B[Autenticar no sistema]
    B --> C{Senha master ou biometria valida?}
    C -- Sim --> D[Painel administrativo]
    C -- Nao --> E[Exibir erro de autenticacao]
    D --> F[Aprovar agenda]
    D --> G[Registrar atendimento realizado]
    D --> H[Debitar sessao]
    D --> I[Gerenciar estoque]
    D --> J[Ajustar configuracoes gerais]
    D --> K[Importar planilha CSV]
    D --> L[Auditar solicitacoes LGPD]
    F --> M[Fim]
    G --> M
    H --> M
    I --> M
    J --> M
    K --> M
    L --> M
    E --> M
```

### Diagrama de Atividades do Cliente

```mermaid
flowchart TD
    A[Início] --> B[Abrir aplicativo e onboarding]
    B --> C[Login/Cadastro]
    C --> D{Novo usuario?}
    D -- Sim --> E[Cadastro novo]
    D -- Nao --> F[Login existente]
    E --> G[Area logada]
    F --> G
    G --> H[Agendar]
    G --> I[Historico]
    G --> J[WhatsApp]
    H --> K[Fim]
    I --> K
    J --> K
```

### Diagrama de Casos de Uso da Administradora

```mermaid
flowchart LR
    A[Administradora] --> U1[Aprovar / recusar agendamento]
    A --> U2[Registrar atendimento realizado]
    A --> U3[Debitar sessao do saldo]
    A --> U4[Gerenciar estoque]
    A --> U5[Ajustar configuracoes gerais]
    A --> U6[Importar planilha CSV]
    A --> U7[Auditar solicitacoes LGPD]
```

### Diagrama de Casos de Uso do Cliente

```mermaid
flowchart LR
    A[Cliente] --> U1[Cadastrar / autenticar]
    A --> U2[Solicitar agendamento]
    A --> U3[Consultar horarios disponiveis]
    A --> U4[Consultar historico]
    A --> U5[Ver saldo de sessoes]
    A --> U6[Solicitar alteracao de horario]
```

### Diagrama de Classes

```mermaid
classDiagram
    class UsuarioModel {
        +id
        +nome
        +email
        +tipo
        +aprovado
        +reprovado
        +dataCadastro
        +lgpdConsentido
    }

    class Cliente {
        +idCliente
        +nomeCliente
        +nomePreferidoCliente
        +telefonePrincipalCliente
        +cpfCliente
        +enderecoCliente
        +saldoSessoesCliente
        +anamneseOkCliente
        +agendaFixaSemanalCliente
    }

    class Agendamento {
        +id
        +clienteId
        +dataHora
        +tipo
        +status
        +motivoCancelamento
        +dataCriacao
        +clienteNomeSnapshot
        +clienteTelefoneSnapshot
        +valorOriginal
        +valorFinal
        +administradoraAtrelada
    }

    class TransacaoFinanceira {
        +id
        +agendamentoId
        +clienteId
        +valorBruto
        +valorDesconto
        +valorLiquido
        +metodoPagamento
        +statusPagamento
        +createdAt
        +createdBy
    }

    class LogModel {
        +tipo
        +mensagem
        +dataHora
        +usuarioId
    }

    class ConfiguracaoGeral {
        +currentVersion
        +minRequiredVersion
    }

    UsuarioModel <|-- Cliente
    Cliente "1" --> "0..*" Agendamento
    Cliente "1" --> "0..*" TransacaoFinanceira
    Agendamento "1" --> "0..*" TransacaoFinanceira
    UsuarioModel "1" --> "0..*" LogModel
    ConfiguracaoGeral --> LogModel
```
## A.1 Fluxo Inicial e Autenticação

Fluxograma do fluxo do cliente: [Fluxo do Cliente (SVG)](../diagramas/generated_svgs/Tela_Fluxo_Cliente.svg)



As figuras desta seção reúnem a sequência inicial de interação com o sistema, abrangendo elementos de apresentação, autenticação, cadastro e consentimento.



**Figura 1. Tela Cadastro Aguardando Aprovacao Admin**
<br>
![Tela Cadastro Aguardando Aprovacao Admin](Tela_Cadastro_Aguardando_Aprovacao_Admin.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura A captura evidencia o estado intermediário do cadastro, o qual permanece pendente até a validação e aprovação pela instância administrativa competente.



**Figura 2. Tela Cadastro Cliente Novo Completo**
<br>
![Tela Cadastro Cliente Novo Completo](Tela_Cadastro_Cliente_Novo_Completo.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Ilustra o formulário destinado ao cadastro de um novo cliente, contemplando os campos essenciais para sua identificação e posterior vinculação ao ambiente da aplicação.



**Figura 3. Diagrama Arquitetura Total SAGMA Completo**
<br>
![Diagrama Arquitetura Total SAGMA Completo](Tela_Cadastro_Em_Analise.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura O diagrama sintetiza a arquitetura do sistema, articulando a interface, o banco de dados e os serviços de integração externa de forma integrada e coerente.



**Figura 4. Tela Compartilhar WhatsApp Aprovacao**
<br>
![Tela Compartilhar WhatsApp Aprovacao](Tela_Compartilhar_WhatsApp_Aprovacao.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Demonstra a integração com o WhatsApp, utilizada como mecanismo de comunicação para o compartilhamento de confirmações e orientações ao cliente.



**Figura 5. Tela Firestore Perfil Cliente Dados**
<br>
![Tela Firestore Perfil Cliente Dados](infra/Tela_Firestore_Perfil_Cliente_Dados.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia a estrutura de dados vinculada ao perfil do cliente, na qual se observa a organização dos campos destinados ao cadastro, ao acompanhamento e ao histórico das informações registradas.



**Figura 6. Tela Login Cliente Completo Principal**
<br>
![Tela Login Cliente Completo Principal](client_ui/Tela_Login_Cliente_Completo_Principal.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura A presente captura apresenta a interface de autenticação do cliente, configurada como porta de entrada para o acesso ao sistema e às funcionalidades disponibilizadas.



**Figura 7. Tela Onboarding Bem Vindo Principal**
<br>
![Tela Onboarding Bem Vindo Principal](client_ui/Tela_Onboarding_Bem_Vindo_Principal.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura A presente captura ilustra a primeira interação do usuário com o aplicativo, destacando a mensagem inicial de acolhimento e orientação ao acesso ao sistema.



**Figura 8. Tela Onboarding Historico Completo**
<br>
![Tela Onboarding Historico Completo](client_ui/Tela_Onboarding_Historico_Completo.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura A referida etapa de onboarding demonstra a contextualização do histórico de uso e da continuidade da interação do usuário com a plataforma.



**Figura 9. Tela Onboarding Notificacoes Automaticas**
<br>
![Tela Onboarding Notificacoes Automaticas](client_ui/Tela_Onboarding_Notificacoes_Automaticas.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia a apresentação de recursos de notificações automáticas ao usuário, evidenciando a preocupação do sistema com a comunicação proativa já na etapa inicial de navegação.


**Imagem adicional. Tela Device Preview**
<br>
![Tela Device Preview](Tela_DevicePreview.jpeg)
<br>
**Fonte: Autores (2026).**
<br>
Imagem capturada do Device Preview exibindo a pré-visualização responsiva (tablet) da etapa de notificações do onboarding.



**Figura 10. Tela Termos Uso Privacidade Cliente**
<br>
![Tela Termos Uso Privacidade Cliente](client_ui/Tela_Termos_Uso_Privacidade_Cliente.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a etapa de aceite dos termos de uso e privacidade, requisito indispensável para o atendimento às exigências de conformidade e tratamento adequado dos dados.

Consulte também: - [LGPD — Privacidade e Tratamento de Dados](../../lib/documents/LGPD_PRIVACIDADE.md)



## A.2 Infraestrutura, Diagnóstico e Governança



As figuras a seguir documentam o ambiente técnico de apoio, contemplando emulação, governança de versão e recursos de diagnóstico utilizados durante o desenvolvimento.

Documentos relacionados:
- [api_commands.md](../../lib/documents/api_commands.md)
- [IMPORT_DATA_GUIDE.md](../../IMPORT_DATA_GUIDE.md)
- [IMPORT_FINAL_SUMMARY.md](../../IMPORT_FINAL_SUMMARY.md)
- [IMPORT_FIXES_APPLIED.md](../../IMPORT_FIXES_APPLIED.md)
- [IMPLEMENTATION_GUIDE.md](../../IMPLEMENTATION_GUIDE.md)
- [Relatório de Correções e Melhorias - Projeto Agenda.md](../../lib/documents/Relatório%20de%20Correções%20e%20Melhorias%20-%20Projeto%20Agenda.md)



**Figura 11. Tela Admin Agendamentos Vazios Lista**
<br>
![Tela Admin Agendamentos Vazios Lista](Tela_Admin_Agendamentos_Vazios_Lista.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Exibe a visão administrativa quando ainda não há agendamentos carregados na listagem.



**Figura 12. Tela Admin Clientes Detalhes Completos**
<br>
![Tela Admin Clientes Detalhes Completos](Tela_Admin_Clientes_Detalhes_Completos.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a área administrativa com informações detalhadas de um cliente selecionado.



**Figura 13. Tela Admin Dashboard Resumo Geral**
<br>
![Tela Admin Dashboard Resumo Geral](Tela_Admin_Dashboard_Resumo_Geral.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia o painel administrativo com indicadores resumidos de acompanhamento do sistema.



**Figura 14. Tela Admin Pendentes Aprovacao Cadastro**
<br>
![Tela Admin Pendentes Aprovacao Cadastro](Tela_Admin_Pendentes_Aprovacao_Cadastro.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Indica a fila de cadastros pendentes aguardando aprovação da profissional ou administradora.



**Figura 15. Tela Administracao Clientes Tema Escuro**
<br>
![Tela Administracao Clientes Tema Escuro](admin_ui/Tela_Administracao_Clientes_Tema_Escuro.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia a listagem de clientes em tema escuro, útil para validação de contraste e leitura.



**Figura 16. Tela Administracao Config Sistema Padrao**
<br>
![Tela Administracao Config Sistema Padrao](Tela_Administracao_Config_Sistema_Padrao.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Exibe a configuração geral padrão utilizada pelo sistema.



**Figura 17. Tela Administracao Escolher Tema Dialogo Preview**
<br>
![Tela Administracao Escolher Tema Dialogo Preview](Tela_Administracao_Escolher_Tema_Dialogo_Preview.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a pré-visualização do tema selecionado antes da aplicação definitiva na interface administrativa.



**Figura 18. Tela Administracao Agendamentos Detalhe Status**
<br>
![Tela Administracao Agendamentos Detalhe Status](Tela_Administracao_Metricas_Diarias.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia o painel administrativo com foco na atualização e acompanhamento do status do agendamento.



**Figura 19. Tela Administracao Agendamentos Detalhe Cliente**
<br>
![Tela Administracao Agendamentos Detalhe Cliente](Tela_Administracao_Selecao_Idioma.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta os detalhes do cliente associados a um agendamento específico.



**Figura 20. Tela Administracao WhatsApp Aprovacao Template**
<br>
![Tela Administracao WhatsApp Aprovacao Template](Tela_Administracao_WhatsApp_Aprovacao_Template.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia o modelo de mensagem usado para aprovação por meio do WhatsApp.



**Figura 21. Tela Agendamento Confirmacao Final Completa**
<br>
![Tela Agendamento Confirmacao Final Completa](Tela_Agendamento_Confirmacao_Final_Completa.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Registra a etapa final de confirmação do agendamento antes do envio ou persistência da solicitação.



**Figura 22. Tela Agendamento Data Selecao Calendario**
<br>
![Tela Agendamento Data Selecao Calendario](Tela_Agendamento_Data_Selecao_Calendario.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Exibe o calendário de seleção de data, etapa essencial para definir o agendamento.



**Figura 23. Tela Agendamento Favoritos Tipo Servico**
<br>
![Tela Agendamento Favoritos Tipo Servico](Tela_Agendamento_Favoritos_Tipo_Servico.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia a seleção de tipos de serviço favoritados para agilizar o fluxo de agendamento.



**Figura 24. Tela Agendamento Horarios Disponiveis Lista**
<br>
![Tela Agendamento Horarios Disponiveis Lista](Tela_Agendamento_Horarios_Disponiveis_Lista.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a relação de horários disponíveis após a verificação de conflito na agenda.



**Figura 25. Tela Agendamento Novo Formulario**
<br>
![Tela Agendamento Novo Formulario](Tela_Agendamento_Novo_Formulario.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia o formulário modal de novo agendamento, com seleção de data, horário, tipo de serviço, cupom e confirmação final.



**Figura 26. Tela Agendamento Novo Tipo Horario**
<br>
![Tela Agendamento Novo Tipo Horario](Tela_Agendamento_Novo_Tipo_Horario.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a seleção inicial do tipo de atendimento e do horário desejado pelo cliente.



**Figura 27. Tela Agendamentos Visao Cliente Vazia**
<br>
![Tela Agendamentos Visao Cliente Vazia](Tela_Agendamentos_Visao_Cliente_Vazia.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia a visão do cliente quando não há agendamentos cadastrados ou ativos.



**Figura 28. Tela Firebase Emulator Firestore Data**
<br>
![Tela Firebase Emulator Firestore Data](infra/Tela_Firebase_Fluxo_Total_Infra_Nuvem.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta uma evidência do ambiente de emulação do Firebase, utilizado na fase de testes e validação.



**Figura 29. Tela Google Agenda Semana Horarios**
<br>
![Tela Google Agenda Semana Horarios](Tela_Google_Agenda_Semana_Horarios.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Registra a integração visual com a agenda externa, exibindo a organização semanal dos horários.



**Figura 30. Tela Instagram Popup Cadastro Entrar**
<br>
![Tela Instagram Popup Cadastro Entrar](client_ui/Tela_Instagram_Popup_Cadastro_Entrar.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Ilustra o pop-up de cadastro e entrada exibido sobre a tela inicial do Instagram.



## A.3 Experiência do Cliente e Histórico de Atendimentos



As imagens reunidas a seguir documentam o percurso visual do cliente, abrangendo cadastro, consentimento, perfil, histórico e informações financeiras associadas ao acompanhamento dos atendimentos.

Documento relacionado:
- [LGPD_PRIVACIDADE.md](../../lib/documents/LGPD_PRIVACIDADE.md)



**Figura 31. Tela Perfil Cliente Dados Pessoais Formulario**
<br>
![Tela Perfil Cliente Dados Pessoais Formulario](Tela_Administracao_Nova_Senha_Admin.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta o formulário de dados pessoais do cliente para edição e acompanhamento.



**Figura 32. Tela Dev Acesso Banco Dados Senha Admin**
<br>
![Tela Dev Acesso Banco Dados Senha Admin](Tela_Dev_Acesso_Banco_Dados_Senha_Admin.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura evidencia a proteção do acesso ao banco de dados em ambiente DEV, com senha administrativa definida conforme o padrão descrito em [.env.example](../../.env.example), habilitando as rotinas de diagnóstico.



**Figura 33. Tela Dev Confirmacao Senha Admin Env Etapa 2**
<br>
![Tela Dev Confirmacao Senha Admin Env Etapa 2](Tela_Dev_Confirmacao_Senha_Admin_Env_Etapa_2.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura registra a etapa 2 de confirmação da senha administrativa em ambiente DEV, usando a configuração definida no arquivo [.env.example](../../.env.example).



**Figura 34. Tela DevTools DB Manager Device Preview Csv Configuracao**
<br>
![Tela DevTools DB Manager Device Preview Csv Configuracao](infra/Tela_DevTools_DB_Manager_Device_Preview_CSV_Configuracao.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura apresenta o DevTools DB Manager com Device Preview ativado e apoio à exportação de CSV e configuração de ambiente DEV.



**Figura 35. Tela Dashboard Cliente Meu Perfil Visao**
<br>
![Tela Dashboard Cliente Meu Perfil Visao](infra/Tela_DevTools_DB_Manager_Listagem_Colecoes.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a visão geral do perfil do cliente dentro do dashboard.



**Figura 36. Tela Dashboard Cliente Resumo Sessoes Pacotes**
<br>
![Tela Dashboard Cliente Resumo Sessoes Pacotes](infra/Tela_DevTools_DB_Manager_Logs_Sistema_Tempo_Real.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Exibe o resumo de sessões e pacotes disponíveis para o cliente.



**Figura 37. Tela Perfil Cliente Consentimento LGPD Visual**
<br>
![Tela Perfil Cliente Consentimento LGPD Visual](infra/Tela_DevTools_DB_Manager_Menu_Exportacao_Preview_Dispositivo.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Exibe a etapa de consentimento LGPD com foco na conformidade e transparência dos dados.

Ver documentação de privacidade e consentimento: - [LGPD — Privacidade e Tratamento de Dados](../../lib/documents/LGPD_PRIVACIDADE.md)



**Figura 38. Tela Perfil Cliente Atividades Historico Completo**
<br>
![Tela Perfil Cliente Atividades Historico Completo](Tela_Swagger_OpenAPI_API_Agendamento_Clientes.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia o histórico completo de atividades executadas no perfil do cliente.

Documentos relacionados: - [Especificação OpenAPI (swagger.yaml)](../../lib/documents/swagger.yaml)  - [Comandos de API (api_commands.md)](../../lib/documents/api_commands.md)



## A.4 Agendamentos e Operação Administrativa



Esta seção concentra as evidências visuais da operação administrativa, incluindo panorama geral, gestão de clientes, pendências, calendário e parametrizações internas.

Documento relacionado:
- [MELHORIAS_INTERFACE_ADMIN_DEV.md](../../MELHORIAS_INTERFACE_ADMIN_DEV.md)



**Figura 39. Tela Firebase Emulator Firestore Perfil Cliente Dados**
<br>
![Tela Firebase Emulator Firestore Perfil Cliente Dados](infra/Tela_Firebase_Emulator_Firestore_Perfil_Cliente_Dados.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a coleção de perfil do cliente no Firebase Emulator Suite, com os campos de dados persistidos no Firestore.



**Figura 40. Tela Dashboard Cliente Agendamentos Ativos Detalhes**
<br>
![Tela Dashboard Cliente Agendamentos Ativos Detalhes](infra/Tela_Firebase_Emulator_Suite_Firestore_Requests.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Detalha os agendamentos ativos disponíveis no painel do cliente.



## A.5 Personalização Visual e Governança de Interface



As últimas figuras concentram a camada de personalização estética do sistema, incluindo temas, pré-visualização e aplicação final das configurações visuais.

Documento relacionado:
- [IMPLEMENTATION_GUIDE.md](../../IMPLEMENTATION_GUIDE.md)



**Figura 41. Diagrama Arquitetura Geral SAGMA**
<br>
![Diagrama Arquitetura Geral SAGMA](../diagramas/generated_svgs/Diagrama_Arquitetura_Geral_SAGMA.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a arquitetura geral do sistema SAGMA, com a relação entre perfil do cliente, perfil do administrador, banco de dados e integrações.



**Figura 42. Tela Administracao Clientes Detalhes Resumo**
<br>
![Tela Administracao Clientes Detalhes Resumo](admin_ui/Tela_Administracao_Clientes_Detalhes_Resumo.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia o resumo administrativo de um cliente com seus principais indicadores e ações rápidas.



**Figura 43. Tela Administracao Escolher Tema Lista Opcoes**
<br>
![Tela Administracao Escolher Tema Lista Opcoes](Tela_Administracao_Escolher_Tema_Lista_Opcoes.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia a lista de opções disponíveis para personalização do tema, organizada em um seletor suspenso.



**Figura 44. Tela Agendamentos Administracao Selecionar Data**
<br>
![Tela Agendamentos Administracao Selecionar Data](Tela_Agendamentos_Administracao_Selecionar_Data.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Exibe a seleção de data para criação ou ajuste do agendamento.



**Figura 45. Tela Agendamentos Administracao Selecionar Horario**
<br>
![Tela Agendamentos Administracao Selecionar Horario](Tela_Agendamentos_Administracao_Selecionar_Horario.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a seleção de horário dentro do fluxo administrativo de agendamentos.



**Figura 46. Tela Agendamentos Administracao Selecionar Tipo**
<br>
![Tela Agendamentos Administracao Selecionar Tipo](Tela_Agendamentos_Administracao_Selecionar_Tipo.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia a etapa administrativa de seleção do tipo de atendimento.



**Figura 47. Tela Agendamentos Administracao Total Previsto**
<br>
![Tela Agendamentos Administracao Total Previsto](Tela_Agendamentos_Administracao_Total_Previsto.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Exibe o total previsto para o atendimento ou conjunto de agendamentos analisados.



**Figura 48. Tela Agendamentos Administracao Aviso Dica**
<br>
![Tela Agendamentos Administracao Aviso Dica](Tela_Cliente_Alteracao_Cadastral_Ficha.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Registra um aviso ou dica operacional exibido na interface administrativa.



**Figura 49. Tela Dev Acesso Banco Dados Senha Admin**
<br>
![Tela Dev Acesso Banco Dados Senha Admin](Tela_Dev_Acesso_Banco_Dados_Senha_Admin.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura evidencia a proteção do acesso ao banco de dados em ambiente DEV, com senha administrativa definida conforme o padrão descrito em [.env.example](../../.env.example), habilitando as rotinas de diagnóstico.



**Figura 50. Tela Diagrama Fluxo Total Sistema**
<br>
![Tela Diagrama Fluxo Total Sistema](../diagramas/generated_svgs/Tela_Diagrama_Fluxo_Total_Sistema.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta o diagrama consolidado do fluxo total do sistema, reunindo os principais caminhos de interação.



**Figura 51. Tela Agendamentos Administracao Favoritos Tipo**
<br>
![Tela Agendamentos Administracao Favoritos Tipo](Tela_Esqueci_Senha_Cliente.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia os tipos de atendimento salvos como favoritos para agilizar a operação.



**Figura 52. Tela Agendamentos Administracao Remover Favorito**
<br>
![Tela Agendamentos Administracao Remover Favorito](infra/Tela_Health_Check_Servicos_Nuvem_App.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a ação administrativa para remover um item da lista de favoritos.



**Figura 53. Tela Agendamentos Administracao Cupom Desconto**
<br>
![Tela Agendamentos Administracao Cupom Desconto](client_ui/Tela_Login_Cliente.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Registra a aplicação de cupom de desconto no agendamento administrativo.



**Figura 54. Tela Agendamentos Administracao Confirmar Reserva**
<br>
![Tela Agendamentos Administracao Confirmar Reserva](Tela_Perfil_Cliente_Dados_Pessoais_Formulario_2.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia a confirmação final da reserva dentro do fluxo administrativo.



**Figura 55. Tela Perfil Cliente Excluir Conta Confirmacao**
<br>
![Tela Perfil Cliente Excluir Conta Confirmacao](Tela_Perfil_Cliente_Excluir_Conta_Confirmacao.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura registra o modal de confirmação para exclusão da conta do cliente, em conformidade com a [Lei nº 13.709, de 14 de agosto de 2018](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm) (LGPD). Os dados que precisarem permanecer na base por prazo legal são anonimizados; o restante é excluído.



**Figura 56. Tela Perfil Cliente Salvar Perfil Disparo WhatsApp Admin**
<br>
![Tela Perfil Cliente Salvar Perfil Disparo WhatsApp Admin](Tela_Perfil_Cliente_Salvar_Perfil_Disparo_WhatsApp_Admin.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura apresenta o botão de salvar perfil que dispara comunicação ao WhatsApp do administrador para acompanhamento do atendimento.



**Figura 57. Tela Agendamentos Administracao Pendente Listagem**
<br>
![Tela Agendamentos Administracao Pendente Listagem](Tela_Versao_App_Pendente_Listagem.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a listagem de agendamentos pendentes aguardando análise.



## A.6 Esboço APP Caderno



O material de esboço do aplicativo encontra-se disponível no arquivo [Esboço APP caderno.pdf](Esboço%20APP%20caderno.pdf). As páginas seguintes reproduzem visualmente esse conteúdo para registro no apêndice.





**Figura 58. Esboço APP Caderno Pagina 3**
<br>
![Esboço APP Caderno Pagina 3](Esboco_APP_caderno_pagina_3.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Registra a terceira página do esboço, consolidando as referências visuais preparatórias do aplicativo.



**Figura 59. Esboço APP Caderno Pagina 1**
<br>
![Esboço APP Caderno Pagina 1](Esboco_APP_caderno_pagina_1.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Registra a primeira página do esboço do aplicativo, preservando a proposta visual inicial do projeto.



**Figura 60. Esboço APP Caderno Pagina 2**
<br>
![Esboço APP Caderno Pagina 2](Esboco_APP_caderno_pagina_2.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a segunda página do esboço, com a continuidade das anotações e estudos de interface.


## A.7 Telas Administrativas — Complementares

As imagens a seguir complementam a seção administrativa com telas de auditoria, controle de estoque e configuração do sistema.


**Figura 61. Tela Administração — Cadastro de Estoque**
<br>
![Tela Administração Cadastro Estoque](admin_ui/Tela_Administracao_Cadastro_Estoque.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Mostra o formulário e validações relacionadas ao cadastro e atualização de itens de estoque no sistema administrativo.


**Figura 62. Tela Administração — Auditoria LGPD (Anonimização de Conta)**
<br>
![Tela Administração Auditoria LGPD](admin_ui/Tela_Administracao_Auditoria_LGPD_Anonimização_de_Conta_Usuário_Excluído.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Documenta o processo de auditoria e opções de anonimização de dados pessoais após exclusão de conta, conforme requisitos de privacidade.


**Figura 63. Tela Administração — Configurações (1)**
<br>
![Tela Administração Configurações 1](admin_ui/Tela_Administracao_Configurações1.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Exibe opções de configuração do sistema na primeira aba de parametrização.


**Figura 64. Tela Administração — Configurações (2)**
<br>
![Tela Administração Configurações 2](admin_ui/Tela_Administracao_Configurações2.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Complementa a visão de parametrização com ajustes avançados de integração e políticas.


**Figura 65. Tela Administração — Configurações (3)**
<br>
![Tela Administração Configurações 3](admin_ui/Tela_Administracao_Configurações3.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Mostra controles adicionais de personalização e segurança aplicáveis à administradora.


**Figura 66. Tela Administração — Configurações (4)**
<br>
![Tela Administração Configurações 4](admin_ui/Tela_Administracao_Configurações4.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a aba final de configurações com opções de versão e manutenção do sistema.


**Figura 67. Tela Administração — Controle de Estoque**
<br>
![Tela Administração Controle Estoque](admin_ui/Tela_Administracao_Controle_Estoque.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia a lista de itens em estoque, com filtros, ajustes de quantidade e exportação.


**Figura 68. Tela Administração — Relatório / Dash Resumo**
<br>
![Tela Administração Dash Resumo](admin_ui/Tela_Administracao_Dash_Resumo.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Exibe um resumo gerencial com indicadores financeiros e operacionais relevantes para a administradora.


**Figura 69. Vídeo: Visão Cliente / Administradora (demonstração)**
<br>
[VisãoCliente — Administradora (vídeo demonstrativo)](media/VisaoCliente_Administradora_Video_1.mp4)
<br>
**Fonte: Autores (2026).**
<br>
Vídeo demonstrativo que apresenta a interação entre a visão do cliente e a visão administrativa durante um fluxo de aprovação e confirmação de agendamento.



## Direcionamento ao Dossiê


Para continuidade e consulta das evidências qualitativas, consulte o dossiê: - [Dossiê de entrevistas e elicitação de requisitos](../dossie_entrevistas_elicitacao_requisitos.md)

## Direcionamento ao Fluxograma

Para visualizar o fluxograma principal do sistema e outros diagramas de fluxo, consulte: - [Fluxogramas do Sistema](../diagramas/fluxograma.md)

## REFERÊNCIAS

Para a lista completa de referências utilizadas neste apêndice, consulte: [REFERÊNCIAS](REFERENCIAS.md)


