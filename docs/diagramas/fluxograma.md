# Fluxogramas do Sistema

## 1. Visão Geral da Arquitetura e Fluxos de Usuário
Este diagrama ilustra a arquitetura macro do sistema SAGMA, detalhando as interações entre os perfis de Cliente e Administrador, os módulos de gestão, o banco de dados (Cloud Firestore) e serviços externos.

```mermaid
graph LR
    subgraph UI ["INTERFACE DO UTILIZADOR (Mobile & Web)"]
        A[App Flutter / Web]
    end

    UI --> B{AUTENTICAÇÃO}
    
    subgraph CLIENTE ["PERFIL CLIENTE"]
        B --> C1[Login & Aceite LGPD]
        C1 --> C2[Dashboard Cliente]
        C2 --> C3[Solicitar Agendamento]
    end

    subgraph ADMIN ["PERFIL ADMINISTRADOR"]
        B --> D1[Login & Dashboard Admin]
        
        subgraph GESTAO ["MÓDULO GESTÃO"]
            D1 --> G1[A - Gestão de Clientes]
            D1 --> G2[B - Gestão de Agendamentos]
            D1 --> G3[C - Gestão Financeira]
            D1 --> G4[D - Configurações]
        end
    end

    subgraph DB ["BANCO DE DADOS (Cloud Firestore)"]
        C3 --> DB1[(agendamentos)]
        G1 --> DB2[(usuarios)]
        G2 --> DB1
        G3 --> DB3[(transacoes / pacotes)]
        G4 --> DB4[(configuracoes_gerais)]
    end

    subgraph INTEGRACAO ["SERVIÇOS & INTEGRAÇÕES"]
        DB1 --> F[Cloud Functions]
        F --> I1[Google Agenda Sync]
        F --> I2[WhatsApp / Push]
    end

    %% Estilização
    style UI fill:#e3f2fd,stroke:#1976d2
    style B fill:#fff3e0,stroke:#f57c00
    style GESTAO fill:#e8f5e9,stroke:#388e3c
    style DB fill:#f3e5f5,stroke:#7b1fa2
    style INTEGRACAO fill:#fffde7,stroke:#fbc02d
```
As setas indicam o fluxo de dados e interações entre os componentes do sistema. O diagrama destaca os principais pontos de interação, como a autenticação, as ações dos usuários (clientes e administradores), as operações no banco de dados e as integrações com serviços externos.
Dessa forma, é possível entender como as diferentes partes do sistema se conectam e onde ocorrem as principais operações, como o processo de agendamento, a gestão de clientes e a sincronização com o Google Agenda.

## 2. Diagrama do Processo de Agendamento quando em desenvolvimento do aplicativo no Flutter
Este diagrama detalha o fluxo específico do processo de agendamento, desde a ação do usuário até a criação do documento no Firestore, incluindo as validações e possíveis falhas.

Link para o fluxo detalhado do procedimento de agendamento: [Fluxo detalhado do procedimento de agendamento](fluxo_agendamento_detalhado.md), que descreve o processo de forma minuciosa, com separação entre o fluxo do cliente e o fluxo da profissional.

Link para falha silenciosa no processo de agendamento: [Falha Silenciosa no Processo de Agendamento](falha_silenciosa_agendamento.md) que detalha um cenário específico de falha no fluxo de agendamento, onde as regras de segurança do Firestore bloqueiam a criação do documento sem fornecer feedback ao usuário.