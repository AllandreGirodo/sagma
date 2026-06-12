# Anteprojeto de Trabalho de Conclusão de Curso

**Título:** Sistema de Agendamento e Gestão para Profissionais de Massoterapia utilizando Flutter e Dart

**Discente:** [Removido para avaliação cega]
**Orientador:** [Removido para avaliação cega]
**Instituição:** Faculdade de Tecnologia de Ribeirão Preto (FATEC)
**Data:** Fevereiro de 2026

## 1. Resumo

Este projeto apresenta o desenvolvimento de uma aplicação multiplataforma (Mobile e Web) voltada para a gestão de clínicas de massoterapia e profissionais autônomos. A solução foca na otimização de agendamentos itinerantes e fixos, controle de pacotes de sessões e baixa automática de insumos. Utiliza o framework Flutter com linguagem Dart e o ecossistema Firebase para persistência de dados em tempo real.

## 2. Introdução e Problema

A gestão de pequenos negócios de estética corporal frequentemente carece de ferramentas digitais acessíveis, resultando em erros de agendamento e falta de controle financeiro. O problema central é a dificuldade de conciliar a agenda da profissional com a demanda das clientes, garantindo que materiais (cremes) e pacotes de sessões sejam geridos sem perdas.

## 3. Justificativa

A digitalização de processos para profissionais autônomos permite maior escalabilidade e profissionalismo. Este trabalho se justifica pela aplicação de conceitos de Pesquisa Operacional (similar ao Problema do Torneio Itinerante - TTP) no contexto de serviços de saúde e bem-estar, buscando minimizar conflitos de horários e otimizar o uso de recursos.

## 4. Objetivos

**Geral:** Desenvolver um MVP funcional para gestão de massoterapia até Abril de 2026.

**Específicos:**

* Implementar internacionalização (PT, EN, ES, JA).
* Criar lógica de agendamento com aprovação administrativa.
* Gerenciar estoque de materiais com baixa automática por sessão.

## 5. Cronograma de Execução (Sprint Final)

| Semana | Atividade |
| :--- | :--- |
| 01-02 | Setup do Ambiente, Modelagem Firestore e Auth. |
| 03-04 | Desenvolvimento do Módulo de Agendamento e Interface de Calendário. |
| 05-06 | Gestão de Pacotes, Finanças e Controle de Estoque. |
| 07-08 | Testes com usuário real, Correções e Redação Final do Relatório. |

## 6. Status de Entrega (Junho/2026)

O MVP foi concluído e superou o escopo original planejado. Resumo do que foi entregue:

| Funcionalidade | Planejado | Status |
| :--- | :--- | :--- |
| Autenticação e cadastro de clientes | Sim | ✅ Entregue |
| Agendamento com aprovação administrativa | Sim | ✅ Entregue |
| Dashboard administrativo com métricas | Sim | ✅ Entregue |
| Controle de estoque com baixa automática | Sim | ✅ Entregue |
| Internacionalização (PT, EN, ES) | Sim | ✅ Entregue |
| Conformidade LGPD (anonimização + logs) | Sim | ✅ Entregue |
| Descarte automático de logs (Cloud Function) | Trabalho futuro | ✅ Entregue |
| Notificações push (FCM + triggers) | Trabalho futuro | ✅ Entregue |
| Lembretes automáticos 24h antes | Trabalho futuro | ✅ Entregue |
| Exportação de relatório financeiro em PDF | Trabalho futuro | ✅ Entregue |
| Botão WhatsApp de aprovação rápida (admin) | Trabalho futuro | ✅ Entregue |
| Regras Firestore completas (todas as coleções) | Parcial | ✅ Entregue |
| Pagamento online integrado | Trabalho futuro | ⏳ Não entregue |
| Sincronização com Google Calendar | Trabalho futuro | ⏳ Não entregue |

**Plataformas validadas:** Web (Firebase Hosting), Android (APK)  
**Projeto Firebase:** `horario-agenda` (showase/demonstração)  
**Próxima etapa:** Migração para conta Firebase dedicada à Andréia Girodo (produção real)

## 7. Referências Bibliográficas

* PRESSMAN, R. S. Engenharia de Software. McGraw-Hill, 2016.
* SADALAGE, P. J.; FOWLER, M. NoSQL Essencial. Novatec, 2013.
* FLUTTER. Documentação oficial. Disponível em: https://docs.flutter.dev.