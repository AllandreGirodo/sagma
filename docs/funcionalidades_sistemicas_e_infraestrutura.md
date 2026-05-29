# Funcionalidades Sistêmicas e Infraestrutura

## Visão Geral

Este documento organiza as capacidades nucleares do SAGMA e os elementos de infraestrutura citados no relatório final, oferecendo uma visão consolidada e de fácil consulta para a equipe de desenvolvimento, auditores e demais stakeholders.

```mermaid
flowchart TD
    %% Estilos
    classDef core fill:#e8f5e9,stroke:#2e7d32,color:#000;
    classDef infra fill:#f0f4c3,stroke:#827717,color:#000;
    classDef future fill:#f3e5f5,stroke:#6a1b9a,color:#000;

    subgraph SAGMA[Plataforma SAGMA]
        direction LR
        subgraph CORE[Funcionalidades nucleares]
            direction TB
            C1[Gestão de clientes]
            C2[Agendamento reativo]
            C3[Controle de pacotes]
            C4[Relatórios gerenciais]
            C5[Comunicação e notificações]
        end

        subgraph INFRA[Infraestrutura]
            direction TB
            I1[Flutter]
            I2[Firebase Auth]
            I3[Firestore]
            I4[Firebase Hosting]
            I5[Regras de segurança]
            I6[App responsivo web/mobile]
        end

        subgraph FUT[Evoluções futuras]
            direction TB
            E1[Mensageria automatizada]
            E2[Dashboards gráficos]
            E3[Sincronização com Google Calendar]
            E4[Fluxos via n8n]
            E5[Geração automatizada de relatórios]
            E6[Orquestração de campanhas e promoções]
            E7[Processamento de pagamentos (webhooks)]
            E8[Enriquecimento e triagem de leads]

            subgraph N8N[Fluxos orquestrados via n8n]
                direction TB
                N1[Lembretes escalonados (WhatsApp → fallback SMS/Email)]
                N2[Confirmação e atualização de agendamento via webhook]
                N3[Processamento de pagamentos pendentes]
                N4[Sincronização bidirecional com Google Calendar]
                N5[Agregação periódica de relatórios e envio por email]
                N6[Importação e higienização de listas de clientes]
            end
        end
    end

    %% Relações
    C2 --> C3
    C5 --> I2
    I3 --> C4

    %% Classes
    class C1,C2,C3,C4,C5 core
    class I1,I2,I3,I4,I5,I6 infra
    class E1,E2,E3,E4,E5,E6,E7,E8 future
```

## 1. Funcionalidades Nucleares

### 1.1 Gestao de clientes
A aplicação centraliza inclusão, edição, consulta e histórico de atendimentos, reduzindo retrabalho administrativo.

### 1.2 Agendamento reativo
O fluxo de agendamento utiliza estados de aprovação para evitar conflitos de horários e garantir controle manual pela profissional. Icone de aprovação e recusa. O sistema bloqueia automaticamente tentativas de agendamento em horários já ocupados.

### 1.3 Controle de pacotes
As sessões dos pacotes são debitadas automaticamente após o atendimento realizado, preservando a rastreabilidade do saldo.

### 1.4 Relatorios gerenciais
O sistema oferece listagens e filtros temporais para apoio ao acompanhamento financeiro e de produtividade.

### 1.5 Comunicacao e notificacoes
As mensagens ao cliente são apoiadas por hyperlinks e templates, com potencial de evolução para notificações automatizadas.

## 2. Infraestrutura

### 2.1 Flutter
Base de desenvolvimento multiplataforma para ambiente mobile e web.

### 2.2 Firebase Auth
Gerencia autenticação e controle de acesso por perfil.

### 2.3 Firestore
Camada de persistência em tempo real para clientes, agendamentos, pacotes e estoque.

### 2.4 Firebase Hosting
Infraestrutura de publicação web utilizada para a entrega do MVP em ambiente produtivo.

### 2.5 Regras de seguranca
As regras declarativas do Firestore sustentam o isolamento de dados e a proteção de operações sensíveis.

## 3. Evolucoes Futuras

### 3.1 Mensageria automatizada
Evoluir de hyperlinks manuais para integração oficial de mensageria e lembretes automáticos.

### 3.2 Dashboards graficos
Incluir painéis visuais para leitura sintética do faturamento e da operação.

### 3.3 Sincronizacao com Google Calendar
Integrar com calendários externos para ampliar a visibilidade dos horários.

### 3.4 Fluxos automatizados via n8n
Acoplar orquestração de automações para notificações e atendimento assistido.
n8n é uma plataforma de automação low-code (open-source) que permite orquestrar triggers, webhooks e integrações com serviços externos (APIs de mensagens, gateways de pagamento, Google Calendar, SMTP, planilhas etc.). Pode ser self‑hosted ou em nuvem, oferece retries, filas e tratamento de erros, e é útil para processos assíncronos e integrações de borda.

Exemplos de fluxos recomendados:

- Lembretes escalonados: enviar confirmação via WhatsApp; se não entregue, tentar SMS ou email; escalonar lembretes (48h, 24h, 2h antes) e registrar entregas.
- Confirmação ativa: processar respostas de clientes por webhook e atualizar o status do agendamento no Firestore.
- Pagamentos e webhooks: consumir notificações de pagamento, atualizar pacotes e liberar bloqueios de agendamento.
- Sincronização de agenda: manter Firestore e Google Calendar sincronizados, com resolução de conflitos baseada em prioridade manual.
- Relatórios agendados: gerar e exportar CSV/XLSX com consumo de insumos, anexar e enviar automaticamente por email.
- Importação e higienização: processar CSVs, normalizar telefones, deduplicar e inserir clientes via API.

Boas práticas: começar com fluxos pequenos e idempotentes, proteger webhooks com autenticação, usar filas para cargas em lote e documentar cada fluxo (trigger, passos, falhas e recuperação).

### 3.5 Geracao automatizada de relatorios
Automatizar a geração de relatórios periódicos (diários, semanais, mensais) com métricas-chave e enviá-los por email para acompanhamento contínuo.
### 3.6 Orquestracao de campanhas e promocoes
Implementar um módulo de marketing para criar campanhas promocionais, segmentar clientes e orquestrar
envios de mensagens personalizadas com ofertas e lembretes de renovação de pacotes.
### 3.7 Processamento de pagamentos (webhooks)
Integrar com gateways de pagamento para processar transações, atualizar pacotes e liberar bloqueios de agendamento automaticamente via webhooks.
### 3.8 Enriquecimento e triagem de leads
Implementar rotinas de enriquecimento de dados (ex.: validação de telefone, geolocalização) e triagem de leads para priorizar contatos com maior potencial de conversão.


## Encaminhamento

Consulte também o [Dossiê de Entrevistas e Elicitação de Requisitos](dossie_entrevistas_elicitacao_requisitos.md) e o arquivo de [Requisitos Funcionais e Não Funcionais](requisitos_funcionais_e_nao_funcionais.md).
