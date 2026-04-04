Você é um especialista em SRE, DevOps e Cloud (AWS/Kubernetes/Kafka). Sua tarefa é gerar um CHECKLIST DE PRODUÇÃO (GO-LIVE CHECKLIST) extremamente prático, detalhado e acionável para um sistema.

Contexto do sistema:
- Nome: Doc Hub
- Stack: Java 21 + Spring Boot 3, Spring Modulith, arquitetura hexagonal
- Infra: AWS (EKS, S3, Secrets Manager, possivelmente SQS), Kafka (Confluent Cloud + Schema Registry)
- Banco: MySQL
- Integrações externas: BRM, IGB, PaperClip, RHSSO
- Observabilidade: logs estruturados + tracing (Micrometer + Dynatrace)
- Status: funcionando em homologação, indo para produção

Objetivo:
Gerar um checklist completo de tudo que precisa ser feito, validado ou solicitado antes e durante o go-live em produção.

Regras obrigatórias:
- NÃO gerar explicações longas
- NÃO gerar texto descritivo
- FOCO TOTAL em checklist operacional
- Cada item deve ser direto e verificável
- Usar checkbox ( - [ ] )
- Agrupar por categorias
- Incluir itens que normalmente são esquecidos em produção

Para cada item, incluir:
- Ação clara (verbo no início)
- Se aplicável, indicar responsável (Dev / DevOps / Segurança / DBA)
- Se relevante, indicar dependência externa (ex: abrir chamado, criar role, etc.)

Estrutura obrigatória:

## 1. Infraestrutura (EKS / Rede / DNS)
## 2. Configuração da Aplicação
## 3. Secrets e Credenciais
## 4. IAM / Roles / Permissões
## 5. Banco de Dados
## 6. Kafka / Mensageria
## 7. Integrações Externas
## 8. Observabilidade (Logs / Métricas / Tracing)
## 9. Segurança
## 10. Deploy e Release
## 11. Rollback e Contingência
## 12. Operação (Runbook / Suporte)
## 13. Smoke Test em Produção
## 14. Pós-Go-Live (Primeiras 24h)

Requisitos adicionais:
- Incluir itens específicos do contexto (Kafka, Schema Registry, callbacks, DLQ, retries)
- Incluir itens de acesso (solicitar permissões, liberar firewall, whitelists, etc.)
- Incluir validações críticas (ex: secrets carregados, consumer ativo, tópico correto)
- Incluir riscos comuns (ex: duplicidade, perda de mensagem, timeout externo)
- Incluir verificações de produção reais (não genéricas)

Saída:
- Um único checklist em Markdown
- Sem explicações, apenas itens acionáveis

Gere o checklist completo.