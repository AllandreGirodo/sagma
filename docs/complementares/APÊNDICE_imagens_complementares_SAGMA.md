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
<br>
![Tela Firestore Perfil Cliente Dados](Tela_Firestore_Perfil_Cliente_Dados.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia a estrutura de dados vinculada ao perfil do cliente, na qual se observa a organização dos campos destinados ao cadastro, ao acompanhamento e ao histórico das informações registradas.



**Figura 2. Tela Onboarding Bem Vindo Principal**
<br>
![Tela Onboarding Bem Vindo Principal](Tela_Onboarding_Bem_Vindo_Principal.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura A presente captura ilustra a primeira interação do usuário com o aplicativo, destacando a mensagem inicial de acolhimento e orientação ao acesso ao sistema.



**Figura 3. Tela Onboarding Notificacoes Automaticas**
<br>
![Tela Onboarding Notificacoes Automaticas](Tela_Onboarding_Notificacoes_Automaticas.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia a apresentação de recursos de notificações automáticas ao usuário, evidenciando a preocupação do sistema com a comunicação proativa já na etapa inicial de navegação.



**Figura 4. Tela Onboarding Historico Completo**
<br>
![Tela Onboarding Historico Completo](Tela_Onboarding_Historico_Completo.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura A referida etapa de onboarding demonstra a contextualização do histórico de uso e da continuidade da interação do usuário com a plataforma.



**Figura 5. Tela Login Cliente Completo Principal**
<br>
![Tela Login Cliente Completo Principal](Tela_Login_Cliente_Completo_Principal.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura A presente captura apresenta a interface de autenticação do cliente, configurada como porta de entrada para o acesso ao sistema e às funcionalidades disponibilizadas.



**Figura 6. Tela Cadastro Cliente Novo Completo**
<br>
![Tela Cadastro Cliente Novo Completo](Tela_Cadastro_Cliente_Novo_Completo.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Ilustra o formulário destinado ao cadastro de um novo cliente, contemplando os campos essenciais para sua identificação e posterior vinculação ao ambiente da aplicação.



**Figura 7. Tela Termos Uso Privacidade Cliente**
<br>
![Tela Termos Uso Privacidade Cliente](Tela_Termos_Uso_Privacidade_Cliente.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a etapa de aceite dos termos de uso e privacidade, requisito indispensável para o atendimento às exigências de conformidade e tratamento adequado dos dados.



**Figura 8. Tela Cadastro Aguardando Aprovacao Admin**
<br>
![Tela Cadastro Aguardando Aprovacao Admin](Tela_Cadastro_Aguardando_Aprovacao_Admin.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura A captura evidencia o estado intermediário do cadastro, o qual permanece pendente até a validação e aprovação pela instância administrativa competente.



**Figura 9. Diagrama Arquitetura Total SAGMA Completo**
<br>
![Diagrama Arquitetura Total SAGMA Completo](Diagrama_Arquitetura_Total_SAGMA_Completo.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura O diagrama sintetiza a arquitetura do sistema, articulando a interface, o banco de dados e os serviços de integração externa de forma integrada e coerente.



**Figura 10. Tela Compartilhar WhatsApp Aprovacao**
<br>
![Tela Compartilhar WhatsApp Aprovacao](Tela_Compartilhar_WhatsApp_Aprovacao.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Demonstra a integração com o WhatsApp, utilizada como mecanismo de comunicação para o compartilhamento de confirmações e orientações ao cliente.



## A.2 Infraestrutura, Diagnóstico e Governança

As figuras a seguir documentam o ambiente técnico de apoio, contemplando emulação, governança de versão e recursos de diagnóstico utilizados durante o desenvolvimento.

**Figura 11. Tela Firebase Emulator Firestore Data**
<br>
![Tela Firebase Emulator Firestore Data](Tela_Firebase_Emulator_Firestore_Data.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta uma evidência do ambiente de emulação do Firebase, utilizado na fase de testes e validação.



**Figura 12. Tela Admin Dashboard Resumo Geral**
<br>
![Tela Admin Dashboard Resumo Geral](Tela_Admin_Dashboard_Resumo_Geral.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia o painel administrativo com indicadores resumidos de acompanhamento do sistema.



**Figura 13. Tela Admin Agendamentos Vazios Lista**
<br>
![Tela Admin Agendamentos Vazios Lista](Tela_Admin_Agendamentos_Vazios_Lista.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Exibe a visão administrativa quando ainda não há agendamentos carregados na listagem.



**Figura 14. Tela Admin Clientes Detalhes Completos**
<br>
![Tela Admin Clientes Detalhes Completos](Tela_Admin_Clientes_Detalhes_Completos.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a área administrativa com informações detalhadas de um cliente selecionado.



**Figura 15. Tela Admin Pendentes Aprovacao Cadastro**
<br>
![Tela Admin Pendentes Aprovacao Cadastro](Tela_Admin_Pendentes_Aprovacao_Cadastro.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Indica a fila de cadastros pendentes aguardando aprovação da profissional ou administradora.



**Figura 16. Tela Google Agenda Semana Horarios**
<br>
![Tela Google Agenda Semana Horarios](Tela_Google_Agenda_Semana_Horarios.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Registra a integração visual com a agenda externa, exibindo a organização semanal dos horários.



**Figura 17. Tela Agendamentos Visao Cliente Vazia**
<br>
![Tela Agendamentos Visao Cliente Vazia](Tela_Agendamentos_Visao_Cliente_Vazia.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia a visão do cliente quando não há agendamentos cadastrados ou ativos.



**Figura 18. Tela Agendamento Novo Tipo Horario**
<br>
![Tela Agendamento Novo Tipo Horario](Tela_Agendamento_Novo_Tipo_Horario.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a seleção inicial do tipo de atendimento e do horário desejado pelo cliente.



**Figura 19. Tela Agendamento Data Selecao Calendario**
<br>
![Tela Agendamento Data Selecao Calendario](Tela_Agendamento_Data_Selecao_Calendario.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Exibe o calendário de seleção de data, etapa essencial para definir o agendamento.



**Figura 20. Tela Agendamento Favoritos Tipo Servico**
<br>
![Tela Agendamento Favoritos Tipo Servico](Tela_Agendamento_Favoritos_Tipo_Servico.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia a seleção de tipos de serviço favoritados para agilizar o fluxo de agendamento.



**Figura 21. Tela Agendamento Horarios Disponiveis Lista**
<br>
![Tela Agendamento Horarios Disponiveis Lista](Tela_Agendamento_Horarios_Disponiveis_Lista.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a relação de horários disponíveis após a verificação de conflito na agenda.



**Figura 22. Tela Agendamento Confirmacao Final Completa**
<br>
![Tela Agendamento Confirmacao Final Completa](Tela_Agendamento_Confirmacao_Final_Completa.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Registra a etapa final de confirmação do agendamento antes do envio ou persistência da solicitação.



**Figura 23. Tela Agendamento Novo Formulario**
<br>
![Tela Agendamento Novo Formulario](Tela_Agendamento_Novo_Formulario.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia o formulário modal de novo agendamento, com seleção de data, horário, tipo de serviço, cupom e confirmação final.



**Figura 24. Tela Administracao Escolher Tema Dialogo Preview**
<br>
![Tela Administracao Escolher Tema Dialogo Preview](Tela_Administracao_Escolher_Tema_Dialogo_Preview.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a pré-visualização do tema selecionado antes da aplicação definitiva na interface administrativa.



**Figura 25. Tela Instagram Popup Cadastro Entrar**
<br>
![Tela Instagram Popup Cadastro Entrar](Tela_Instagram_Popup_Cadastro_Entrar.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Ilustra o pop-up de cadastro e entrada exibido sobre a tela inicial do Instagram.



**Figura 26. Tela Administracao Clientes Tema Escuro**
<br>
![Tela Administracao Clientes Tema Escuro](Tela_Administracao_Clientes_Tema_Escuro.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia a listagem de clientes em tema escuro, útil para validação de contraste e leitura.



**Figura 27. Tela Administracao Agendamentos Detalhe Cliente**
<br>
![Tela Administracao Agendamentos Detalhe Cliente](Tela_Administracao_Agendamentos_Detalhe_Cliente.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta os detalhes do cliente associados a um agendamento específico.



**Figura 28. Tela Administracao Agendamentos Detalhe Status**
<br>
![Tela Administracao Agendamentos Detalhe Status](Tela_Administracao_Agendamentos_Detalhe_Status.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia o painel administrativo com foco na atualização e acompanhamento do status do agendamento.



**Figura 29. Tela Administracao Config Sistema Padrao**
<br>
![Tela Administracao Config Sistema Padrao](Tela_Administracao_Config_Sistema_Padrao.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Exibe a configuração geral padrão utilizada pelo sistema.



**Figura 30. Tela Administracao WhatsApp Aprovacao Template**
<br>
![Tela Administracao WhatsApp Aprovacao Template](Tela_Administracao_WhatsApp_Aprovacao_Template.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia o modelo de mensagem usado para aprovação por meio do WhatsApp.



## A.3 Experiência do Cliente e Histórico de Atendimentos

As imagens reunidas a seguir documentam o percurso visual do cliente, abrangendo cadastro, consentimento, perfil, histórico e informações financeiras associadas ao acompanhamento dos atendimentos.

**Figura 31. Tela Perfil Cliente Dados Pessoais Formulario**
<br>
![Tela Perfil Cliente Dados Pessoais Formulario](Tela_Perfil_Cliente_Dados_Pessoais_Formulario.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta o formulário de dados pessoais do cliente para edição e acompanhamento.



**Figura 32. Tela Perfil Cliente Endereco Anamnese Formulario**
<br>
![Tela Perfil Cliente Endereco Anamnese Formulario](Tela_Perfil_Cliente_Endereco_Anamnese_Formulario.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia os campos de endereço e anamnese vinculados ao perfil do cliente.



**Figura 33. Tela Perfil Cliente Historico Atendimentos Detalhes**
<br>
![Tela Perfil Cliente Historico Atendimentos Detalhes](Tela_Perfil_Cliente_Historico_Atendimentos_Detalhes.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Registra o histórico de atendimentos com detalhes do cliente e dos procedimentos realizados.



**Figura 34. Tela Perfil Cliente Financeiro Pacotes Detalhes**
<br>
![Tela Perfil Cliente Financeiro Pacotes Detalhes](Tela_Perfil_Cliente_Financeiro_Pacotes_Detalhes.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta os pacotes financeiros vinculados ao cliente e seus respectivos detalhes.



**Figura 35. Tela Perfil Cliente Consentimento LGPD Visual**
<br>
![Tela Perfil Cliente Consentimento LGPD Visual](Tela_Perfil_Cliente_Consentimento_LGPD_Visual.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Exibe a etapa de consentimento LGPD com foco na conformidade e transparência dos dados.



**Figura 36. Tela Perfil Cliente Atividades Historico Completo**
<br>
![Tela Perfil Cliente Atividades Historico Completo](Tela_Perfil_Cliente_Atividades_Historico_Completo.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia o histórico completo de atividades executadas no perfil do cliente.



**Figura 37. Tela Dashboard Cliente Meu Perfil Visao**
<br>
![Tela Dashboard Cliente Meu Perfil Visao](Tela_Dashboard_Cliente_Meu_Perfil_Visao.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a visão geral do perfil do cliente dentro do dashboard.



**Figura 38. Tela Dashboard Cliente Resumo Sessoes Pacotes**
<br>
![Tela Dashboard Cliente Resumo Sessoes Pacotes](Tela_Dashboard_Cliente_Resumo_Sessoes_Pacotes.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Exibe o resumo de sessões e pacotes disponíveis para o cliente.



## A.4 Agendamentos e Operação Administrativa

Esta seção concentra as evidências visuais da operação administrativa, incluindo panorama geral, gestão de clientes, pendências, calendário e parametrizações internas.

**Figura 39. Tela Dashboard Cliente Agendamentos Ativos Detalhes**
<br>
![Tela Dashboard Cliente Agendamentos Ativos Detalhes](Tela_Dashboard_Cliente_Agendamentos_Ativos_Detalhes.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Detalha os agendamentos ativos disponíveis no painel do cliente.



**Figura 40. Tela Firebase Emulator Firestore Perfil Cliente Dados**
<br>
![Tela Firebase Emulator Firestore Perfil Cliente Dados](Tela_Firebase_Emulator_Firestore_Perfil_Cliente_Dados.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a coleção de perfil do cliente no Firebase Emulator Suite, com os campos de dados persistidos no Firestore.



## A.5 Personalização Visual e Governança de Interface

As últimas figuras concentram a camada de personalização estética do sistema, incluindo temas, pré-visualização e aplicação final das configurações visuais.

**Figura 41. Tela Agendamentos Administracao Pendente Listagem**
<br>
![Tela Agendamentos Administracao Pendente Listagem](Tela_Agendamentos_Administracao_Pendente_Listagem.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a listagem de agendamentos pendentes aguardando análise.



**Figura 42. Tela Agendamentos Administracao Selecionar Tipo**
<br>
![Tela Agendamentos Administracao Selecionar Tipo](Tela_Agendamentos_Administracao_Selecionar_Tipo.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia a etapa administrativa de seleção do tipo de atendimento.



**Figura 43. Tela Agendamentos Administracao Selecionar Data**
<br>
![Tela Agendamentos Administracao Selecionar Data](Tela_Agendamentos_Administracao_Selecionar_Data.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Exibe a seleção de data para criação ou ajuste do agendamento.



**Figura 44. Tela Agendamentos Administracao Selecionar Horario**
<br>
![Tela Agendamentos Administracao Selecionar Horario](Tela_Agendamentos_Administracao_Selecionar_Horario.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a seleção de horário dentro do fluxo administrativo de agendamentos.



**Figura 45. Tela Agendamentos Administracao Cupom Desconto**
<br>
![Tela Agendamentos Administracao Cupom Desconto](Tela_Agendamentos_Administracao_Cupom_Desconto.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Registra a aplicação de cupom de desconto no agendamento administrativo.



**Figura 46. Tela Agendamentos Administracao Favoritos Tipo**
<br>
![Tela Agendamentos Administracao Favoritos Tipo](Tela_Agendamentos_Administracao_Favoritos_Tipo.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia os tipos de atendimento salvos como favoritos para agilizar a operação.



**Figura 47. Tela Agendamentos Administracao Remover Favorito**
<br>
![Tela Agendamentos Administracao Remover Favorito](Tela_Agendamentos_Administracao_Remover_Favorito.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a ação administrativa para remover um item da lista de favoritos.



**Figura 48. Tela Agendamentos Administracao Total Previsto**
<br>
![Tela Agendamentos Administracao Total Previsto](Tela_Agendamentos_Administracao_Total_Previsto.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Exibe o total previsto para o atendimento ou conjunto de agendamentos analisados.



**Figura 49. Tela Agendamentos Administracao Confirmar Reserva**
<br>
![Tela Agendamentos Administracao Confirmar Reserva](Tela_Agendamentos_Administracao_Confirmar_Reserva.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia a confirmação final da reserva dentro do fluxo administrativo.



**Figura 50. Tela Agendamentos Administracao Aviso Dica**
<br>
![Tela Agendamentos Administracao Aviso Dica](Tela_Agendamentos_Administracao_Aviso_Dica.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Registra um aviso ou dica operacional exibido na interface administrativa.



**Figura 51. Tela Perfil Cliente Historico Sem Agendamentos**
<br>
![Tela Perfil Cliente Historico Sem Agendamentos](Tela_Perfil_Cliente_Historico_Sem_Agendamentos.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a aba de histórico do perfil do cliente quando não há agendamentos registrados.



**Figura 52. Tela Acesso Banco Dados Senha Admin**
<br>
![Tela Acesso Banco Dados Senha Admin](Tela_Acesso_Banco_Dados_Senha_Admin.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia o acesso ao banco de dados por meio de confirmação de senha administrativa.



**Figura 53. Tela Perfil Cliente Excluir Conta Confirmacao**
<br>
![Tela Perfil Cliente Excluir Conta Confirmacao](Tela_Perfil_Cliente_Excluir_Conta_Confirmacao.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Registra o modal de confirmação para exclusão da conta do cliente.



**Figura 54. Tela Administracao Clientes Detalhes Resumo**
<br>
![Tela Administracao Clientes Detalhes Resumo](Tela_Administracao_Clientes_Detalhes_Resumo.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia o resumo administrativo de um cliente com seus principais indicadores e ações rápidas.



**Figura 55. Tela Administracao Escolher Tema Lista Opcoes**
<br>
![Tela Administracao Escolher Tema Lista Opcoes](Tela_Administracao_Escolher_Tema_Lista_Opcoes.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Evidencia a lista de opções disponíveis para personalização do tema, organizada em um seletor suspenso.



**Figura 56. Diagrama Arquitetura Geral SAGMA**
<br>
![Diagrama Arquitetura Geral SAGMA](Diagrama_Arquitetura_Geral_SAGMA.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a arquitetura geral do sistema SAGMA, com a relação entre perfil do cliente, perfil do administrador, banco de dados e integrações.



**Figura 57. Tela Diagrama Fluxo Total Sistema**
<br>
![Tela Diagrama Fluxo Total Sistema](Tela_Diagrama_Fluxo_Total_Sistema.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta o diagrama consolidado do fluxo total do sistema, reunindo os principais caminhos de interação.



## A.6 Esboço APP Caderno

O material de esboço do aplicativo encontra-se disponível no arquivo [Esboço APP caderno.pdf](Esboço%20APP%20caderno.pdf). As páginas seguintes reproduzem visualmente esse conteúdo para registro no apêndice.

**Figura 58. Esboço APP Caderno Pagina 1**
<br>
![Esboço APP Caderno Pagina 1](Esboco_APP_caderno_pagina_1.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Registra a primeira página do esboço do aplicativo, preservando a proposta visual inicial do projeto.



**Figura 59. Esboço APP Caderno Pagina 2**
<br>
![Esboço APP Caderno Pagina 2](Esboco_APP_caderno_pagina_2.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Apresenta a segunda página do esboço, com a continuidade das anotações e estudos de interface.



**Figura 60. Esboço APP Caderno Pagina 3**
<br>
![Esboço APP Caderno Pagina 3](Esboco_APP_caderno_pagina_3.png)
<br>
**Fonte: Autores (2026).**
<br>
A presente figura Registra a terceira página do esboço, consolidando as referências visuais preparatórias do aplicativo.
