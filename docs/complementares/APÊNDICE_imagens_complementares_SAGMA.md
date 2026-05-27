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

Os diagramas a seguir complementam as imagens do apêndice e resumem, em linguagem de modelagem, o comportamento principal do sistema.

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

As figuras desta seção reúnem a sequência inicial de interação com o sistema, abrangendo elementos de apresentação, autenticação, cadastro e consentimento.

**Figura 1. Tela Firestore Perfil Cliente Dados**
![Tela Firestore Perfil Cliente Dados](Tela_Firestore_Perfil_Cliente_Dados.png)
**Fonte: Autores (2026).**
A presente figura evidencia a estrutura de dados vinculada ao perfil do cliente, na qual se observa a organização dos campos destinados ao cadastro, ao acompanhamento e ao histórico das informações registradas.


**Figura 2. Tela Onboarding Bem Vindo Principal**
![Tela Onboarding Bem Vindo Principal](Tela_Onboarding_Bem_Vindo_Principal.png)
**Fonte: Autores (2026).**
A presente captura ilustra a primeira interação do usuário com o aplicativo, destacando a mensagem inicial de acolhimento e orientação ao acesso ao sistema.


**Figura 3. Tela Onboarding Notificacoes Automaticas**
![Tela Onboarding Notificacoes Automaticas](Tela_Onboarding_Notificacoes_Automaticas.png)
**Fonte: Autores (2026).**
A presente figura evidencia a apresentação de recursos de notificações automáticas ao usuário, evidenciando a preocupação do sistema com a comunicação proativa já na etapa inicial de navegação.


**Figura 4. Tela Onboarding Historico Completo**
![Tela Onboarding Historico Completo](Tela_Onboarding_Historico_Completo.png)
**Fonte: Autores (2026).**
A referida etapa de onboarding demonstra a contextualização do histórico de uso e da continuidade da interação do usuário com a plataforma.


**Figura 5. Tela Login Cliente Completo Principal**
![Tela Login Cliente Completo Principal](Tela_Login_Cliente_Completo_Principal.png)
**Fonte: Autores (2026).**
A presente captura apresenta a interface de autenticação do cliente, configurada como porta de entrada para o acesso ao sistema e às funcionalidades disponibilizadas.


**Figura 6. Tela Cadastro Cliente Novo Completo**
![Tela Cadastro Cliente Novo Completo](Tela_Cadastro_Cliente_Novo_Completo.png)
**Fonte: Autores (2026).**
A presente figura ilustra o formulário destinado ao cadastro de um novo cliente, contemplando os campos essenciais para sua identificação e posterior vinculação ao ambiente da aplicação.


**Figura 7. Tela Termos Uso Privacidade Cliente**
![Tela Termos Uso Privacidade Cliente](Tela_Termos_Uso_Privacidade_Cliente.png)
**Fonte: Autores (2026).**
A presente figura apresenta a etapa de aceite dos termos de uso e privacidade, requisito indispensável para o atendimento às exigências de conformidade e tratamento adequado dos dados.


**Figura 8. Tela Cadastro Aguardando Aprovacao Admin**
![Tela Cadastro Aguardando Aprovacao Admin](Tela_Cadastro_Aguardando_Aprovacao_Admin.png)
**Fonte: Autores (2026).**
A captura evidencia o estado intermediário do cadastro, o qual permanece pendente até a validação e aprovação pela instância administrativa competente.


**Figura 9. Diagrama Arquitetura Total SAGMA Completo**
![Diagrama Arquitetura Total SAGMA Completo](Diagrama_Arquitetura_Total_SAGMA_Completo.png)
**Fonte: Autores (2026).**
O diagrama sintetiza a arquitetura do sistema, articulando a interface, o banco de dados e os serviços de integração externa de forma integrada e coerente.


**Figura 10. Tela Compartilhar WhatsApp Aprovacao**
![Tela Compartilhar WhatsApp Aprovacao](Tela_Compartilhar_WhatsApp_Aprovacao.png)
**Fonte: Autores (2026).**
A presente figura demonstra a integração com o WhatsApp, utilizada como mecanismo de comunicação para o compartilhamento de confirmações e orientações ao cliente.


## A.2 Infraestrutura, Diagnóstico e Governança

As figuras a seguir documentam o ambiente técnico de apoio, contemplando emulação, governança de versão e recursos de diagnóstico utilizados durante o desenvolvimento.

**Figura 11. Tela Firebase Emulator Firestore Data**
![Tela Firebase Emulator Firestore Data](Tela_Firebase_Emulator_Firestore_Data.png)
**Fonte: Autores (2026).**
A presente figura apresenta uma evidência do ambiente de emulação do Firebase, utilizado na fase de testes e validação.


**Figura 12. Tela Admin Dashboard Resumo Geral**
![Tela Admin Dashboard Resumo Geral](Tela_Admin_Dashboard_Resumo_Geral.png)
**Fonte: Autores (2026).**
A presente figura evidencia o painel administrativo com A presente figura indicadores resumidos de acompanhamento do sistema.


**Figura 13. Tela Admin Agendamentos Vazios Lista**
![Tela Admin Agendamentos Vazios Lista](Tela_Admin_Agendamentos_Vazios_Lista.png)
**Fonte: Autores (2026).**
A presente figura exibe a visão administrativa quando ainda não há agendamentos carregados na listagem.


**Figura 14. Tela Admin Clientes Detalhes Completos**
![Tela Admin Clientes Detalhes Completos](Tela_Admin_Clientes_Detalhes_Completos.png)
**Fonte: Autores (2026).**
A presente figura apresenta a área administrativa com informações detalhadas de um cliente selecionado.


**Figura 15. Tela Admin Pendentes Aprovacao Cadastro**
![Tela Admin Pendentes Aprovacao Cadastro](Tela_Admin_Pendentes_Aprovacao_Cadastro.png)
**Fonte: Autores (2026).**
A presente figura indica a fila de cadastros pendentes aguardando aprovação da profissional ou administradora.


**Figura 16. Tela Google Agenda Semana Horarios**
![Tela Google Agenda Semana Horarios](Tela_Google_Agenda_Semana_Horarios.png)
**Fonte: Autores (2026).**
A presente figura registra a integração visual com a agenda externa, exibindo a organização semanal dos horários.


**Figura 17. Tela Agendamentos Visao Cliente Vazia**
![Tela Agendamentos Visao Cliente Vazia](Tela_Agendamentos_Visao_Cliente_Vazia.png)
**Fonte: Autores (2026).**
A presente figura evidencia a visão do cliente quando não há agendamentos cadastrados ou ativos.


**Figura 18. Tela Agendamento Novo Tipo Horario**
![Tela Agendamento Novo Tipo Horario](Tela_Agendamento_Novo_Tipo_Horario.png)
**Fonte: Autores (2026).**
A presente figura apresenta a seleção inicial do tipo de atendimento e do horário desejado pelo cliente.


**Figura 19. Tela Agendamento Data Selecao Calendario**
![Tela Agendamento Data Selecao Calendario](Tela_Agendamento_Data_Selecao_Calendario.png)
**Fonte: Autores (2026).**
A presente figura exibe o calendário de seleção de data, etapa essencial para definir o agendamento.


**Figura 20. Tela Agendamento Favoritos Tipo Servico**
![Tela Agendamento Favoritos Tipo Servico](Tela_Agendamento_Favoritos_Tipo_Servico.png)
**Fonte: Autores (2026).**
A presente figura evidencia a seleção de tipos de serviço favoritados para agilizar o fluxo de agendamento.


**Figura 21. Tela Agendamento Horarios Disponiveis Lista**
![Tela Agendamento Horarios Disponiveis Lista](Tela_Agendamento_Horarios_Disponiveis_Lista.png)
**Fonte: Autores (2026).**
A presente figura apresenta a relação de horários disponíveis após a verificação de conflito na agenda.


**Figura 22. Tela Agendamento Confirmacao Final Completa**
![Tela Agendamento Confirmacao Final Completa](Tela_Agendamento_Confirmacao_Final_Completa.png)
**Fonte: Autores (2026).**
A presente figura registra a etapa final de confirmação do agendamento antes do envio ou persistência da solicitação.


**Figura 23. Tela Administracao Tema Teste Listagem**
![Tela Administracao Tema Teste Listagem](Tela_Administracao_Tema_Teste_Listagem.png)
**Fonte: Autores (2026).**
A presente figura evidencia a aplicação de tema em modo de teste na listagem administrativa.


**Figura 24. Tela Administracao Escolher Tema Personalizado**
![Tela Administracao Escolher Tema Personalizado](Tela_Administracao_Escolher_Tema_Personalizado.png)
**Fonte: Autores (2026).**
A presente figura apresenta a tela de seleção de tema personalizado para a interface administrativa.


**Figura 25. Tela Administracao Clientes Pesquisa Detalhes**
![Tela Administracao Clientes Pesquisa Detalhes](Tela_Administracao_Clientes_Pesquisa_Detalhes.png)
**Fonte: Autores (2026).**
A presente figura ilustra a busca de clientes com exibição de detalhes complementares para consulta administrativa.


**Figura 26. Tela Administracao Clientes Tema Escuro**
![Tela Administracao Clientes Tema Escuro](Tela_Administracao_Clientes_Tema_Escuro.png)
**Fonte: Autores (2026).**
A presente figura evidencia a listagem de clientes em tema escuro, útil para validação de contraste e leitura.


**Figura 27. Tela Administracao Agendamentos Detalhe Cliente**
![Tela Administracao Agendamentos Detalhe Cliente](Tela_Administracao_Agendamentos_Detalhe_Cliente.png)
**Fonte: Autores (2026).**
A presente figura apresenta os detalhes do cliente associados a um agendamento específico.


**Figura 28. Tela Administracao Agendamentos Detalhe Status**
![Tela Administracao Agendamentos Detalhe Status](Tela_Administracao_Agendamentos_Detalhe_Status.png)
**Fonte: Autores (2026).**
A presente figura evidencia o painel administrativo com foco na atualização e acompanhamento do status do agendamento.


**Figura 29. Tela Administracao Config Sistema Padrao**
![Tela Administracao Config Sistema Padrao](Tela_Administracao_Config_Sistema_Padrao.png)
**Fonte: Autores (2026).**
A presente figura exibe a configuração geral padrão utilizada pelo sistema.


**Figura 30. Tela Administracao WhatsApp Aprovacao Template**
![Tela Administracao WhatsApp Aprovacao Template](Tela_Administracao_WhatsApp_Aprovacao_Template.png)
**Fonte: Autores (2026).**
A presente figura evidencia o modelo de mensagem usado para aprovação por meio do WhatsApp.


## A.3 Experiência do Cliente e Histórico de Atendimentos

As imagens reunidas a seguir documentam o percurso visual do cliente, abrangendo cadastro, consentimento, perfil, histórico e informações financeiras associadas ao acompanhamento dos atendimentos.

**Figura 31. Tela Perfil Cliente Dados Pessoais Formulario**
![Tela Perfil Cliente Dados Pessoais Formulario](Tela_Perfil_Cliente_Dados_Pessoais_Formulario.png)
**Fonte: Autores (2026).**
A presente figura apresenta o formulário de dados pessoais do cliente para edição e acompanhamento.


**Figura 32. Tela Perfil Cliente Endereco Anamnese Formulario**
![Tela Perfil Cliente Endereco Anamnese Formulario](Tela_Perfil_Cliente_Endereco_Anamnese_Formulario.png)
**Fonte: Autores (2026).**
A presente figura evidencia os campos de endereço e anamnese vinculados ao perfil do cliente.


**Figura 33. Tela Perfil Cliente Historico Atendimentos Detalhes**
![Tela Perfil Cliente Historico Atendimentos Detalhes](Tela_Perfil_Cliente_Historico_Atendimentos_Detalhes.png)
**Fonte: Autores (2026).**
A presente figura registra o histórico de atendimentos com detalhes do cliente e dos procedimentos realizados.


**Figura 34. Tela Perfil Cliente Financeiro Pacotes Detalhes**
![Tela Perfil Cliente Financeiro Pacotes Detalhes](Tela_Perfil_Cliente_Financeiro_Pacotes_Detalhes.png)
**Fonte: Autores (2026).**
A presente figura apresenta os pacotes financeiros vinculados ao cliente e seus respectivos detalhes.


**Figura 35. Tela Perfil Cliente Consentimento LGPD Visual**
![Tela Perfil Cliente Consentimento LGPD Visual](Tela_Perfil_Cliente_Consentimento_LGPD_Visual.png)
**Fonte: Autores (2026).**
A presente figura exibe a etapa de consentimento LGPD com foco na conformidade e transparência dos dados.


**Figura 36. Tela Perfil Cliente Atividades Historico Completo**
![Tela Perfil Cliente Atividades Historico Completo](Tela_Perfil_Cliente_Atividades_Historico_Completo.png)
**Fonte: Autores (2026).**
A presente figura evidencia o histórico completo de atividades executadas no perfil do cliente.


**Figura 37. Tela Dashboard Cliente Meu Perfil Visao**
![Tela Dashboard Cliente Meu Perfil Visao](Tela_Dashboard_Cliente_Meu_Perfil_Visao.png)
**Fonte: Autores (2026).**
A presente figura apresenta a visão geral do perfil do cliente dentro do dashboard.


**Figura 38. Tela Dashboard Cliente Resumo Sessoes Pacotes**
![Tela Dashboard Cliente Resumo Sessoes Pacotes](Tela_Dashboard_Cliente_Resumo_Sessoes_Pacotes.png)
**Fonte: Autores (2026).**
A presente figura exibe o resumo de sessões e pacotes disponíveis para o cliente.


## A.4 Agendamentos e Operação Administrativa

Esta seção concentra as evidências visuais da operação administrativa, incluindo panorama geral, gestão de clientes, pendências, calendário e parametrizações internas.

**Figura 39. Tela Dashboard Cliente Agendamentos Ativos Detalhes**
![Tela Dashboard Cliente Agendamentos Ativos Detalhes](Tela_Dashboard_Cliente_Agendamentos_Ativos_Detalhes.png)
**Fonte: Autores (2026).**
Detalha os agendamentos ativos disponíveis no painel do cliente.


**Figura 40. Tela Agendamentos Administracao Mensal Calendario**
![Tela Agendamentos Administracao Mensal Calendario](Tela_Agendamentos_Administracao_Mensal_Calendario.png)
**Fonte: Autores (2026).**
A presente figura evidencia o calendário mensal usado na administração dos agendamentos.


## A.5 Personalização Visual e Governança de Interface

As últimas figuras concentram a camada de personalização estética do sistema, incluindo temas, pré-visualização e aplicação final das configurações visuais.

**Figura 41. Tela Agendamentos Administracao Pendente Listagem**
![Tela Agendamentos Administracao Pendente Listagem](Tela_Agendamentos_Administracao_Pendente_Listagem.png)
**Fonte: Autores (2026).**
A presente figura apresenta a listagem de agendamentos pendentes aguardando análise.


**Figura 42. Tela Agendamentos Administracao Selecionar Tipo**
![Tela Agendamentos Administracao Selecionar Tipo](Tela_Agendamentos_Administracao_Selecionar_Tipo.png)
**Fonte: Autores (2026).**
A presente figura evidencia a etapa administrativa de seleção do tipo de atendimento.


**Figura 43. Tela Agendamentos Administracao Selecionar Data**
![Tela Agendamentos Administracao Selecionar Data](Tela_Agendamentos_Administracao_Selecionar_Data.png)
**Fonte: Autores (2026).**
A presente figura exibe a seleção de data para criação ou ajuste do agendamento.


**Figura 44. Tela Agendamentos Administracao Selecionar Horario**
![Tela Agendamentos Administracao Selecionar Horario](Tela_Agendamentos_Administracao_Selecionar_Horario.png)
**Fonte: Autores (2026).**
A presente figura apresenta a seleção de horário dentro do fluxo administrativo de agendamentos.


**Figura 45. Tela Agendamentos Administracao Cupom Desconto**
![Tela Agendamentos Administracao Cupom Desconto](Tela_Agendamentos_Administracao_Cupom_Desconto.png)
**Fonte: Autores (2026).**
A presente figura registra a aplicação de cupom de desconto no agendamento administrativo.


**Figura 46. Tela Agendamentos Administracao Favoritos Tipo**
![Tela Agendamentos Administracao Favoritos Tipo](Tela_Agendamentos_Administracao_Favoritos_Tipo.png)
**Fonte: Autores (2026).**
A presente figura evidencia os tipos de atendimento salvos como favoritos para agilizar a operação.


**Figura 47. Tela Agendamentos Administracao Remover Favorito**
![Tela Agendamentos Administracao Remover Favorito](Tela_Agendamentos_Administracao_Remover_Favorito.png)
**Fonte: Autores (2026).**
A presente figura apresenta a ação administrativa para remover um item da lista de favoritos.


**Figura 48. Tela Agendamentos Administracao Total Previsto**
![Tela Agendamentos Administracao Total Previsto](Tela_Agendamentos_Administracao_Total_Previsto.png)
**Fonte: Autores (2026).**
A presente figura exibe o total previsto para o atendimento ou conjunto de agendamentos analisados.


**Figura 49. Tela Agendamentos Administracao Confirmar Reserva**
![Tela Agendamentos Administracao Confirmar Reserva](Tela_Agendamentos_Administracao_Confirmar_Reserva.png)
**Fonte: Autores (2026).**
A presente figura evidencia a confirmação final da reserva dentro do fluxo administrativo.


**Figura 50. Tela Agendamentos Administracao Aviso Dica**
![Tela Agendamentos Administracao Aviso Dica](Tela_Agendamentos_Administracao_Aviso_Dica.png)
**Fonte: Autores (2026).**
A presente figura registra um aviso ou dica operacional exibido na interface administrativa.


**Figura 51. Tela Administracao Painel Resumo Metrico**
![Tela Administracao Painel Resumo Metrico](Tela_Administracao_Painel_Resumo_Metrico.png)
**Fonte: Autores (2026).**
A presente figura apresenta um painel com métricas resumidas para suporte à tomada de decisão.


**Figura 52. Tela Administracao Agendamentos Calendario Semanal**
![Tela Administracao Agendamentos Calendario Semanal](Tela_Administracao_Agendamentos_Calendario_Semanal.png)
**Fonte: Autores (2026).**
A presente figura evidencia a visualização semanal dos agendamentos em ambiente administrativo.


**Figura 53. Tela Administracao Clientes Listagem Teste**
![Tela Administracao Clientes Listagem Teste](Tela_Administracao_Clientes_Listagem_Teste.png)
**Fonte: Autores (2026).**
A presente figura registra a listagem de clientes em contexto de teste ou validação do sistema.


**Figura 54. Tela Administracao Tema Lista Personalizada**
![Tela Administracao Tema Lista Personalizada](Tela_Administracao_Tema_Lista_Personalizada.png)
**Fonte: Autores (2026).**
A presente figura evidencia uma lista personalizada de temas disponíveis para aplicação no sistema.


**Figura 55. Tela Administracao Tema PreVisualizacao Personalizada**
![Tela Administracao Tema PreVisualizacao Personalizada](Tela_Administracao_Tema_PreVisualizacao_Personalizada.png)
**Fonte: Autores (2026).**
A presente figura exibe a pré-visualização do tema selecionado antes da aplicação definitiva.


**Figura 56. Tela Administracao Tema Aplicacao Confirmacao**
![Tela Administracao Tema Aplicacao Confirmacao](Tela_Administracao_Tema_Aplicacao_Confirmacao.png)
**Fonte: Autores (2026).**
A presente figura evidencia a confirmação de aplicação do tema personalizado na interface administrativa.


**Figura 57. Tela Diagrama Fluxo Total Sistema**
![Tela Diagrama Fluxo Total Sistema](Tela_Diagrama_Fluxo_Total_Sistema.png)
**Fonte: Autores (2026).**
A presente figura apresenta o diagrama consolidado do fluxo total do sistema, reunindo os principais caminhos de interação.


## A.6 Esboço APP Caderno

O material de esboço do aplicativo encontra-se disponível no arquivo [Esboço APP caderno.pdf](Esboço%20APP%20caderno.pdf). As páginas seguintes reproduzem visualmente esse conteúdo para registro no apêndice.

**Figura 58. Esboço APP Caderno Pagina 1**
![Esboço APP Caderno Pagina 1](Esboco_APP_caderno_pagina_1.png)
**Fonte: Autores (2026).**
Esta imagem registra a primeira página do esboço do aplicativo, preservando a proposta visual inicial do projeto.


**Figura 59. Esboço APP Caderno Pagina 2**
![Esboço APP Caderno Pagina 2](Esboco_APP_caderno_pagina_2.png)
**Fonte: Autores (2026).**
Esta imagem apresenta a segunda página do esboço, com a continuidade das anotações e estudos de interface.


**Figura 60. Esboço APP Caderno Pagina 3**
![Esboço APP Caderno Pagina 3](Esboco_APP_caderno_pagina_3.png)
**Fonte: Autores (2026).**
Esta imagem registra a terceira página do esboço, consolidando as referências visuais preparatórias do aplicativo.
