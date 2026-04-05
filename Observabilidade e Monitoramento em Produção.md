Você é um especialista em Cloud (AWS), Kubernetes (EKS), Kafka (Confluent) e produção de sistemas distribuídos.

Sua tarefa é gerar um CHECKLIST DE PROVISIONAMENTO DE PRODUÇÃO, focado exclusivamente em criar e validar todos os recursos necessários antes do deploy de uma aplicação.

Contexto do sistema:
- Nome: Doc Hub
- Stack: Java 21 + Spring Boot 3
- Infra: AWS (EKS, S3, Secrets Manager, IAM), Kafka (Confluent Cloud + Schema Registry)
- Banco: MySQL
- Integrações: BRM, IGB, PaperClip, RHSSO
- Ambiente atual: homologação OK, produção ainda não provisionada

Objetivo:
Gerar um checklist completo de TUDO que precisa ser criado, solicitado ou validado em produção antes do deploy.

Regras obrigatórias:
- NÃO incluir explicações
- NÃO incluir teoria
- Apenas checklist técnico acionável
- Cada item deve ser verificável
- Usar checkbox (- [ ])
- Incluir responsável quando fizer sentido (Dev / DevOps / Segurança / DBA)
- Incluir itens que dependem de abertura de chamado ou outro time

Foco principal:
- Provisionamento (criar recursos)
- Configuração (ajustar recursos)
- Acessos (solicitar permissões)
- Dependências externas

Estrutura obrigatória:

## 1. Kubernetes / EKS
- namespace
- service account
- configmaps
- deployment
- hpa
- ingress / virtual service
- resource limits

## 2. AWS / Infra
- S3 (buckets + policies)
- Secrets Manager (todos os secrets)
- IAM roles (least privilege)
- Security groups / network rules
- DNS / certificados

## 3. Banco de Dados (MySQL)
- criação de schema
- usuários e permissões
- migrations
- conectividade

## 4. Kafka / Mensageria
- criação de tópicos
- ACLs (producer/consumer)
- schema registry (schemas registrados)
- consumer groups definidos
- DLQ / retry topics

## 5. Secrets e Credenciais
- listar todos os secrets necessários
- garantir existência em produção
- validar permissões de acesso
- validar rotação (se aplicável)

## 6. Integrações Externas
- whitelists de IP
- credenciais (OAuth, API keys)
- endpoints de produção
- testes de conectividade

## 7. Observabilidade (mínimo necessário)
- logs habilitados
- tracing ativo
- métricas básicas
- alertas mínimos (erro e indisponibilidade)

## 8. Acessos e Permissões
- acesso ao cluster
- acesso ao banco
- acesso ao Kafka
- acesso aos secrets
- acesso aos dashboards

## 9. Validações pré-deploy
- variáveis de ambiente configuradas
- secrets injetados corretamente
- conectividade validada
- dependências disponíveis

Requisitos adicionais:
- Incluir itens específicos de Kafka (ACL, DLQ, schema)
- Incluir itens específicos de AWS (IAM, Secrets, S3)
- Incluir erros comuns de provisionamento (ex: falta de permissão, secret inexistente)
- Checklist deve ser completo o suficiente para evitar falha no deploy

Saída:
- Apenas checklist em Markdown
- Sem explicações

Gere o checklist completo.