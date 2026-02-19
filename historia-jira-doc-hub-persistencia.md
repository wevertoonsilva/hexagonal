# 🧾 História Jira --- Implementação da Persistência do Doc Hub (Spring Boot + Spring Data + MySQL)

------------------------------------------------------------------------

## 🎯 Objetivo

Implementar a camada completa de persistência do serviço **Doc Hub**,
alinhada ao DDL oficial do schema `db_doc_hub`, utilizando **Spring
Boot + Spring Data JPA + MySQL**, garantindo:

-   Escrita consistente em todas as tabelas do pipeline
-   Status implementados como **Enum persistido como STRING**
-   Idempotência baseada em constraints do banco
-   Implementação do padrão **Outbox**
-   Pipeline auditável ponta a ponta

------------------------------------------------------------------------

# 📌 Escopo da Implementação

## 1️⃣ Entidades e Repositórios

Mapear entidades JPA para:

-   `requisicao_documento`
-   `execucao_etapa_documento`
-   `saida_etapa_documento`
-   `envio_documento`
-   `evento_envio_documento`
-   `outbox_requisicao_documento`

### Regras obrigatórias

-   Todos os campos `status` devem ser mapeados com
    `@Enumerated(EnumType.STRING)`
-   Nunca utilizar `EnumType.ORDINAL`
-   UNIQUE constraints devem ser respeitadas para garantir idempotência
-   Atualizações críticas podem utilizar `@Query` com SQL nativo quando
    necessário

------------------------------------------------------------------------

# 📌 Definição Oficial dos Enums de Status

> Todos devem ser implementados como Enum persistido como STRING.

------------------------------------------------------------------------

## ✅ StatusRequisicaoDocumento

(Tabela: `requisicao_documento.status` --- varchar(40))

**Opções permitidas:**

-   RECEBIDA\
-   EM_PROCESSAMENTO\
-   AGUARDANDO_ENVIO\
-   ENVIADA\
-   CONCLUIDA\
-   FALHA_FINAL\
-   CANCELADA

------------------------------------------------------------------------

## ✅ StatusExecucaoEtapa

(Tabela: `execucao_etapa_documento.status` --- varchar(30))

**Opções permitidas:**

-   INICIADA\
-   SUCESSO\
-   FALHA\
-   IGNORADA

------------------------------------------------------------------------

## ✅ StatusEnvioDocumento

(Tabela: `envio_documento.status` --- varchar(30))

**Opções permitidas:**

-   SOLICITADO\
-   ENVIANDO\
-   ENVIADO\
-   ENTREGUE\
-   FALHA\
-   CANCELADO

------------------------------------------------------------------------

## ✅ StatusOutbox

(Tabela: `outbox_requisicao_documento.status` --- varchar(20))

**Opções permitidas:**

-   PENDENTE\
-   PROCESSANDO\
-   PUBLICADO\
-   ERRO

------------------------------------------------------------------------

# 📌 Serviços de Aplicação --- Assinaturas dos Métodos

## 🔹 Requisição

``` java
RequisicaoDocumento criarOuObter(...);
Optional<RequisicaoDocumento> buscarPorId(long idRequisicao);
Optional<RequisicaoDocumento> buscarPorChave(String chaveRequisicao);
RequisicaoDocumento atualizarStatus(...);
RequisicaoDocumento atualizarEtapaAtual(...);
RequisicaoDocumento concluir(...);
RequisicaoDocumento marcarFalhaFinal(...);
```

## 🔹 Execução de Etapa

``` java
ExecucaoEtapaDocumento iniciarEtapa(...);
Optional<ExecucaoEtapaDocumento> buscarPorId(long idExecucaoEtapa);
Optional<ExecucaoEtapaDocumento> buscarUltimaExecucao(...);
ExecucaoEtapaDocumento finalizarEtapaSucesso(...);
ExecucaoEtapaDocumento finalizarEtapaFalha(...);
```

## 🔹 Saída de Etapa

``` java
SaidaEtapaDocumento salvarSaida(...);
SaidaEtapaDocumento salvarOuAtualizarSaida(...);
List<SaidaEtapaDocumento> listarPorExecucao(...);
```

## 🔹 Envio

``` java
EnvioDocumento criarEnvio(...);
Optional<EnvioDocumento> buscarPorId(...);
List<EnvioDocumento> listarPorRequisicao(...);
EnvioDocumento atualizarStatus(...);
EnvioDocumento marcarEnviado(...);
EnvioDocumento marcarEntregue(...);
```

## 🔹 Evento de Envio

``` java
EventoEnvioDocumento registrarEvento(...);
boolean existePorEventoExterno(...);
List<EventoEnvioDocumento> listarPorEnvio(...);
```

## 🔹 Outbox

``` java
OutboxRequisicaoDocumento enfileirarEvento(...);
List<OutboxRequisicaoDocumento> buscarPendentesParaProcessamento(...);
OutboxRequisicaoDocumento marcarProcessando(...);
OutboxRequisicaoDocumento marcarPublicado(...);
OutboxRequisicaoDocumento reagendarComTentativa(...);
OutboxRequisicaoDocumento marcarErroFinal(...);
```
