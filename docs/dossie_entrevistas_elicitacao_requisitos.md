# Dossiê Técnico de Entrevistas e Elicitação de Requisitos

**Projeto:** Sistema Multiplataforma de Agendamento e Gestão para Massoterapia
**Instituição:** FATEC Ribeirão Preto - Curso de Análise e Desenvolvimento de Sistemas (ADS)
**Data de consolidação:** maio de 2026
**Desenvolvedor:** Autor do projeto
**Entrevistada:** Andreia Araújo Campos Girodo

---

## 1. Introdução e escopo

Este documento reúne o histórico das entrevistas semiestruturadas realizadas com a massoterapeuta e esteticista Andreia Araújo Campos Girodo, usadas como base para definição do MVP do sistema de agendamento e gestão.

O levantamento foi direcionado a problemas reais do cotidiano de um negócio de estética corporal em Ribeirão Preto, onde a base de clientes local concentra-se na área de cobertura do DDD 16. As discussões priorizaram as fricções de agendamento, a organização de dados legados, o controle de pacotes comerciais e a rastreabilidade de insumos utilizados em atendimento.

Além dos sintomas operacionais, este dossiê explicita causas prováveis observadas no fluxo atual, como ausência de trava de concorrência, registros manuais sem validação automática, dados cadastrais sem padronização e falta de trilha de auditoria por lote ou sessão.

---

## 2. Ciclo de entrevistas semiestruturadas

### 2.1 Entrevista 1 - Organização da agenda e concorrência de horários

**Data:** 10 de setembro de 2025

**Síntese do relato e causas prováveis:**
O processo atual combina agenda em papel com troca de mensagens no WhatsApp. A sobreposição de horários ocorre principalmente porque não existe bloqueio automático do mesmo slot, nem confirmação imediata de disponibilidade. Como a profissional responde enquanto atende, a janela entre a solicitação e a validação manual aumenta o risco de dupla reserva.

**Requisito extraído:**
O sistema deve registrar o agendamento inicialmente como solicitado, permitindo aprovação manual pela profissional antes da confirmação final.

### 2.2 Entrevista 2 - Pacotes de sessões e inadimplência

**Data:** 24 de outubro de 2025

**Síntese do relato e causas prováveis:**
O controle manual de pacotes em fichas soltas dificulta a conferência de saldo porque o saldo depende de anotações humanas, sem atualização atômica ao fechar a sessão. O risco de perda de horário quando o pacote ainda está pendente de pagamento acontece porque não há travamento de solicitação por status financeiro, permitindo reservar vaga antes da confirmação do PIX.

**Requisitos extraídos:**
O sistema deve descontar automaticamente uma sessão do pacote quando o atendimento for marcado como realizado. Além disso, pacotes com pagamento pendente não devem liberar solicitações de agendamento até a confirmação financeira.

### 2.3 Entrevista 3 - Importação de dados brutos e foco no DDD 16

**Data:** 15 de novembro de 2025

**Síntese do relato e causas prováveis:**
Os contatos antigos estão salvos com nomes pouco padronizados e números de telefone em formatos variados porque a agenda cresceu ao longo do tempo sem um esquema único de cadastro. Como a entrada dos dados veio de WhatsApp e listas manuais, surgiram apelidos, abreviações, caracteres de formatação e números fora de padrão. Como todas as clientes pertencem à região do DDD 16, a higienização automática deve normalizar os números para esse padrão.

**Requisitos extraídos:**
O sistema deve extrair apenas o primeiro nome para mensagens. Deve remover caracteres não numéricos do telefone, completar números de 9 dígitos com o DDD 16 e, para números de 8 dígitos, inserir o nono dígito e o DDD 16. Linhas inválidas devem ser rejeitadas durante a importação.

### 2.4 Entrevista 4 - Biossegurança, restrições dermatológicas e estoque

**Data:** 18 de fevereiro de 2026

**Síntese do relato e causas prováveis:**
O trabalho utiliza cosméticos de alto custo e não permite reaproveitamento de sobras entre clientes porque há risco de contaminação cruzada e exigência de biossegurança. A necessidade de rastrear o lote exato do produto aplicado em uma sessão existe porque, em caso de reação adversa ou fiscalização, é preciso identificar rapidamente qual insumo foi usado, quando foi consumido e em qual atendimento.

**Requisitos extraídos:**
O sistema deve dar baixa automática de estoque ao encerrar uma sessão e vincular cada atendimento ao lote do insumo utilizado, preservando o histórico para auditoria e rastreabilidade.

---

## 3. Especificação de requisitos derivados

### 3.1 Requisitos funcionais

- **RF01 - Controle de acesso por perfil:** o sistema deve separar interfaces e permissões entre Profissional e Cliente.
- **RF02 - Importação e higienização de clientes:** o sistema deve ler listas de clientes, extrair apenas o primeiro nome para mensagens e higienizar números de telefone. Caso a string possua 9 dígitos numéricos isolados, o sistema deve inserir o prefixo de DDD 16.
- **RF03 - Máquina de estados de agendamento:** o campo `status` das consultas deve seguir o fluxo `solicitado` -> `aprovado` -> (`realizado` | `cancelado_com_onus` | `cancelado_sem_onus`).
- **RF04 - Bloqueio de inadimplência:** o sistema deve impedir solicitações de agendamento se o pacote vinculado estiver com status de pagamento pendente.
- **RF05 - Controle sanitário de estoque:** o sistema deve exigir a seleção do lote do cosmético utilizado ao encerrar a sessão como realizada, decrementando a quantidade correspondente do estoque.

### 3.2 Requisitos não funcionais

- **RNF01 - Execução segura de saldos:** a baixa de saldo de pacotes e de estoque deve ocorrer de forma atômica, garantindo consistência mesmo em cenários de queda de conexão móvel.
- **RNF02 - Proteção de concorrência de grade:** o sistema deve bloquear requisições assíncronas simultâneas para o mesmo horário na agenda da profissional.
- **RNF03 - Anonimização parcial e LGPD:** caso um usuário solicite exclusão de conta, o sistema deve apagar dados pessoais identificáveis, mas manter de forma mascarada os registros de faturamento e os logs de utilização de lotes por motivos de segurança jurídica.

---

## 4. Observações de modelagem e implementação

- A importação de clientes deve tratar nomes compostos e apelidos informais antes de gerar textos automáticos de confirmação.
- O fluxo de aprovação de agendamento precisa ser manual para evitar conflitos de horário e permitir validação operacional da profissional.
- O controle de pacotes deve ser integrado ao fechamento do atendimento, evitando divergência entre saldo exibido e saldo real.
- O módulo de estoque deve preservar rastreabilidade por lote, sem reaproveitamento de insumos entre clientes.
 - Observação sobre plataforma: a entrevistada informou utilizar dispositivos Android e tem familiaridade como usuária, mas não é desenvolvedora mobile; recomenda-se interfaces simples e consistentes para Android.
 Detalkhes técnicos dev Citado android mas mobile engloba também iOS, e o sistema deve ser multiplataforma (Flutter) para atender a ambos os públicos.

---

## 5. Diagramas de apoio aos requisitos

Os dois últimos diagramas consolidados também foram registrados neste dossiê para correlacionar os requisitos com os fluxos de uso do sistema.

**Diagrama 1. Casos de uso do cliente**
<br>
![Casos de uso do cliente](diagramas/diagrama_casos_uso_cliente_agenda_massoterapia.png)
<br>
**Fonte: Autores.**
<br>
Cumprido: o diagrama cobre autenticação, agendamento, acompanhamento de status e gestão de perfil do cliente.

**Diagrama 2. Casos de uso da administradora**
<br>
![Diagrama de Casos de Uso da Administradora](diagramas/diagrama_casos_uso_admin_agenda_massoterapia.png)
<br>
**Fonte: Autores.**
<br>
Cumprido: o diagrama cobre aprovação de agendamentos, gestão operacional e apoio à administração da agenda.

Os diagramas completos também podem ser consultados nos manuais correlatos: [Manual do Cliente](MANUAL_CLIENTE.md) e [Manual Administrativo](MANUAL_ADMINISTRATIVO.md).

---

## 6. Recursos visuais, logos e mensagens padrão (consentimento)

Para facilitar a correlação entre requisitos, interfaces e material de comunicação, registramos abaixo os recursos visuais utilizados no projeto, o consentimento da profissional para seu uso e as mensagens-padrão geradas pelo sistema que interagem com o WhatsApp.

**Logos e ícones**
<br>
<img src="../assets/Logo.jpg" alt="Logo do projeto" width="200" height="200" />
<br>
**Tela de Onboarding (apresentação)**
<br>
As três primeiras telas usadas para validar fluxos com a profissional foram incluídas como evidência visual:
<br>
<table>
	<tr>
		<td align="center">
			<img src="complementares/client_ui/Tela_Onboarding_Bem_Vindo_Principal.png" alt="Onboarding - Bem Vindo" width="280" />
			<br>
			<strong>Onboarding — Bem-vindo</strong>
		</td>
		<td align="center">
			<img src="complementares/client_ui/Tela_Onboarding_Historico_Completo.png" alt="Onboarding - Histórico" width="280" />
			<br>
			<strong>Onboarding — Histórico</strong>
		</td>
		<td align="center">
			<img src="complementares/client_ui/Tela_Onboarding_Notificacoes_Automaticas.png" alt="Onboarding - Notificações" width="280" />
			<br>
			<strong>Onboarding — Notificações</strong>
		</td>
	</tr>
</table>
<br>
**Login**
<br>
As telas de login utilizadas como referência (exibidas lado a lado):
<br>
<table>
	<tr>
		<td align="center">
			<img src="complementares/client_ui/Tela_Login_Cliente_Completo_Principal.png" alt="Login Completo" width="320" />
			<br>
			<strong>Login — Completo</strong>
		</td>
		<td align="center">
			<img src="complementares/client_ui/Tela_Login_Cliente.png" alt="Login Simples" width="320" />
			<br>
			<strong>Login — Simples</strong>
		</td>
	</tr>
</table>
<br>
**Favicon / Ícone da aplicação Flutter e Web da Cliente**
<br>
As duas versões do ícone são apresentadas abaixo: à esquerda a pré-visualização derivada do `app_icon.ico` (Windows / Flutter), à direita o favicon usado pela build Web/Android.
<br>
<table>
	<tr>
		<td align="center">
			<img src="complementares/system/app_icon_preview.png" alt="Original (app_icon.ico)" width="96" />
			<br>
			<strong>Original (Flutter / Windows .ico preview)</strong>
			<br>
			<code>windows/runner/resources/app_icon.ico</code>
		</td>
		<td align="center">
			<img src="complementares/system/Logo_favIcon.png" alt="Web/Android favicon" width="96" />
			<br>
			<strong>Web / Android (favicon)</strong>
			<br>
			<code>docs/complementares/system/Logo_favIcon.png</code>
		</td>
	</tr>
</table>
<br>
**Fonte:** Autores. A entrevistada autorizou expressamente o uso dos logos e do ícone como material ilustrativo na documentação e como ícone/favico do sistema, mediante consentimento explícito e registrado.
<br>
---

**Consentimento**
<br>A entrevistada autorizou expressamente o uso dos dados coletados, dos requisitos extraídos e dos recursos visuais (logos, ícones, telas) como material ilustrativo na documentação do projeto e como base para a implementação do sistema, mediante consentimento explícito e registrado. O uso desses materiais deve respeitar a privacidade e os direitos de imagem da profissional, garantindo que qualquer menção ou representação seja feita de forma ética e alinhada com as expectativas acordadas durante as entrevistas. O consentimento inclui a utilização dos templates de mensagens automáticas para comunicação com clientes, desde que seja mantida a conformidade com as normas de proteção de dados e comunicação consentida.
<br>
<br>
**Mensagens-padrão (templates)**
<br>O sistema suporta envio de mensagens automáticas e templates via integração com WhatsApp (gatilhos: reserva solicitada, confirmação, lembrete, cancelamento). A seguir, exemplos de templates padronizados sugeridos e aprovados pela profissional:
- Mensagem recebida do cliente (entrada no histórico, não enviada pelo sistema):
> "Olá, gostaria de agendar uma sessão de massagem relaxante — qual melhor horário para esta semana?"
- Mensagem automática enviada pelo sistema para confirmação (cliente ← sistema → WhatsApp):
> "Olá {primeiro_nome}, sua solicitação de agendamento para {data} às {hora} foi registrada como *PENDENTE*. Você será notificada quando for aprovada. Obrigada! — {nome_clinica}"
- Mensagem automática enviada pelo sistema como lembrete (24h antes):
> "Lembrete: sua sessão de {procedimento} está agendada para {data} às {hora}. Caso precise reagendar, responda a esta mensagem ou acesse o app."
- Mensagem enviada pela profissional via sistema (quando a profissional precisa comunicar algo pelo WhatsApp): 
> "Olá {primeiro_nome}, aqui é a {nome_profissional}. Confirmei seu horário para {data} às {hora}. Trazer documento e chegar 10 minutos antes. Obrigada."
<br>
Os templates acima são exemplos recomendados. Todos os envios via WhatsApp devem respeitar o consentimento de comunicação do cliente e as regras da LGPD, mantendo opt-in explícito para mensagens promocionais.
<br>
Quando o sistema enviar mensagens automáticas, ele deve substituir as chaves `{primeiro_nome}`, `{data}`, `{hora}`, `{procedimento}` e `{nome_clinica}` pelos valores correspondentes do cliente e do agendamento. As mensagens devem ser claras, profissionais e alinhadas com a identidade visual da clínica, reforçando a marca e a confiança do cliente.
<br>
**Fonte:** Autores. A entrevistada autorizou expressamente o uso dos templates de mensagens como material ilustrativo na documentação e como base para os envios automáticos do sistema, mediante consentimento explícito e registrado.
<br>
---

## 6. Referências e exemplos

**Telas iniciais utilizadas como referência**
<br>
As três primeiras telas usadas para validar fluxos com a profissional foram incluídas como evidência visual:

- Tela de Onboarding (Boas-vindas): `docs/complementares/client_ui/Tela_Onboarding_Bem_Vindo_Principal.png`
- Tela de Login do Cliente: `docs/complementares/client_ui/Tela_Login_Cliente_Completo_Principal.png`
- Tela de Resumo / Dashboard: `docs/complementares/infra/Tela_DevTools_DB_Manager_Logs_Sistema_Tempo_Real.png`
<br>
Estas telas foram fornecidas e aprovadas pela profissional e documentam a orientação visual inicial do cliente ao utilizar o aplicativo.

**Privacidade entre clientes**
<br>
A entrevistada confirmou explicitamente durante as entrevistas que "uma cliente não vê a outra" — ou seja, não há visualização de terceiros na interface do cliente. Complementando esse ponto: o sistema deve garantir que cada cliente só tenha acesso aos seus próprios agendamentos, histórico e dados pessoais (visibilidade de agenda restrita por UID). Qualquer listagem ou relatório que possua informações de terceiros deverá ser acessível apenas por perfis administrativos com autenticação reforçada. Essa separação também implica que notificações e mensagens exibidas ao cliente não devem conter nomes, contatos ou detalhes de outras clientes.

**Horário de descanso (bloqueio de grade)**
<br>
A profissional relatou possuir um período de descanso diário que deve ser automaticamente bloqueado pela grade da agenda. Exemplo configurável: `12:30–13:30` (valor parametrizável no painel administrativo). O requisito funcional resultante é que o sistema permita definir janelas fixas de indisponibilidade por dia/semana que impeçam a reserva de horários no intervalo configurado.

**Mensagens-padrão (templates) — fluxo WhatsApp**
<br>
O sistema suporta envio de mensagens automáticas e templates via integração com WhatsApp (gatilhos: reserva solicitada, confirmação, lembrete, cancelamento). Abaixo exemplos de templates padronizados sugeridos e aprovados pela profissional:

- Mensagem recebida do cliente (entrada no histórico, não enviada pelo sistema):

> "Olá, gostaria de agendar uma sessão de massagem relaxante — qual melhor horário para esta semana?"

- Mensagem automática enviada pelo sistema para confirmação (cliente ← sistema → WhatsApp):

> "Olá {primeiro_nome}, sua solicitação de agendamento para {data} às {hora} foi registrada como *PENDENTE*. Você será notificada quando for aprovada. Obrigada! — {nome_clinica}"

- Mensagem automática enviada pelo sistema como lembrete (24h antes):

> "Lembrete: sua sessão de {procedimento} está agendada para {data} às {hora}. Caso precise reagendar, responda a esta mensagem ou acesse o app."

- Mensagem enviada pela profissional via sistema (quando a profissional precisa comunicar algo pelo WhatsApp):

> "Olá {primeiro_nome}, aqui é a {nome_profissional}. Confirmei seu horário para {data} às {hora}. Trazer documento e chegar 10 minutos antes. Obrigada."

Os templates acima são exemplos recomendados. Todos os envios via WhatsApp devem respeitar o consentimento de comunicação do cliente e as regras da LGPD, mantendo opt-in explícito para mensagens promocionais.

---

## 7. Encaminhamento para documentação do projeto

Este dossiê pode ser usado como base para o capítulo de levantamento de requisitos e para a seção de metodologia no relatório final. Para continuidade da documentação técnica do projeto, ele deve ser associado aos diagramas consolidados em [DIAGRAMAS.md](../DIAGRAMAS.md).
