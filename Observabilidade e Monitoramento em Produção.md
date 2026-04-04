Você é um especialista em SRE, Cloud (AWS), Segurança (OWASP/NIST) e arquitetura de microserviços. Sua tarefa é gerar um Production Readiness Review (PRR) completo, prático e acionável para colocar um sistema em produção.

Contexto do sistema:
- Nome: Doc Hub
- Stack: Java 21 + Spring Boot 3, Spring Modulith, arquitetura hexagonal
- Infra: AWS (EKS, S3, Secrets Manager, possivelmente SQS), Kafka (Confluent Cloud + Schema Registry)
- Banco: MySQL
- Integrações externas: BRM (envio), IGB (físico), PaperClip (geração de documentos), RHSSO (OAuth2)
- Observabilidade: logs estruturados, tracing distribuído (Micrometer + Dynatrace)
- Status atual: funcionando em homologação, indo para produção

Objetivo:
Gerar um documento PRR completo com checklist de tudo que precisa ser validado antes do go-live.

Instruções obrigatórias:
- Seja direto, técnico e orientado à execução (evite teoria)
- Estruture em seções claras
- Para cada item, inclua:
  - Descrição
  - Ação necessária
  - Responsável (ex: Dev, DevOps, Segurança)
  - Evidência esperada
  - Status (Pendente/OK)
- Inclua checklists detalhados (checkbox style)
- Considere cenários reais de falha em produção
- Foque em riscos e mitigação

Estrutura obrigatória do documento:

1. Resumo Executivo
2. Escopo do Release
3. Arquitetura e Dependências
4. Inventário de Recursos (infra, tópicos Kafka, buckets, banco, etc.)
5. Secrets e Gestão de Acessos
   - Lista de todos os secrets
   - IAM Roles e políticas (least privilege)
   - Fluxo de solicitação de acesso
6. Configuração por Ambiente
7. Observabilidade
   - Logs, métricas, tracing
   - Dashboards e alertas
   - SLO/SLA
8. Segurança
   - Autenticação/autorização
   - Proteção de dados sensíveis
   - Hardening
9. Operação e Runbooks
   - Procedimentos de erro
   - Reprocessamento
   - DLQ / retries
10. Kafka e Mensageria
   - Tópicos, ACLs, schema, retries, DLQ
11. Banco de Dados
   - Migrations, índices, rollback
12. Plano de Deploy
   - Estratégia (rolling, blue/green, etc.)
   - Ordem de execução
13. Plano de Rollback
14. Testes de Produção (Smoke Test)
15. Riscos e Mitigações
16. Aprovações

Requisitos adicionais:
- Incluir exemplos reais aplicados ao contexto (Doc Hub)
- Incluir riscos típicos (ex: falha em callback, inconsistência de status, problema em Kafka, falha em BRM)
- Não simplificar demais
- Saída deve ser um único documento em Markdown pronto para uso em Jira/Confluence

Gere o documento completo.