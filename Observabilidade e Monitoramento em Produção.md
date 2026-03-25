Você atuará como engenheiro sênior Java/Spring Boot no projeto service-consignado-doc-hub.

Objetivo:
Implementar o scheduler responsável por reconciliar tentativas de envio DIGITAL (BRM), lendo a tabela `tentativa_envio_documento` e consultando o status da mensagem via `LibBrm.consultar()`.

---

Contexto de domínio:

O sistema possui as seguintes tabelas:
- requisicao_documento
- execucao_etapa_documento
- saida_etapa_documento
- tentativa_envio_documento
- evento_envio_documento
- outbox_callback_requisicao

A tabela `tentativa_envio_documento` representa uma tentativa de envio por canal.

Agora existem dois níveis de abstração:

1. Tipo de envio (domínio):
- DIGITAL
- FISICO

2. Canal técnico:
- WHATSAPP
- SMS
- IGB

Regras:
- DIGITAL usa BRM (WHATSAPP ou SMS)
- FISICO usa IGB (fora do escopo do reconciliador)

---

Status interno da tentativa:

- CRIADO
- PENDENTE (inclui aceite técnico do provedor)
- SUCESSO
- FALHA
- TIMEOUT

Estados finais:
- SUCESSO
- FALHA
- TIMEOUT

---

Escopo do reconciliador:

O reconciliador deve processar APENAS tentativas com:

- tipo_envio = DIGITAL
- canal_envio = WHATSAPP ou SMS
- status = PENDENTE
- proxima_consulta_em <= agora

Não processar:
- tipo_envio = FISICO

---

Regras importantes:

- BRM não possui stream de status → usar polling
- consulta via: LibBrm.consultar()
- a API de consulta pode demorar até ~25 segundos
- aplicação roda com múltiplos pods
- não pode haver dupla reconciliação da mesma tentativa
- não executar fallback duas vezes
- não colocar regra de negócio no scheduler
- não persistir dentro do adapter BRM
- não usar Thread.sleep
- não assumir single instance

---

Fluxo do reconciliador:

Para cada tentativa elegível:

1. Verificar timeout:
   - se agora >= data_limite_confirmacao
   - marcar como TIMEOUT
   - se for WHATSAPP, avaliar fallback para SMS

2. Consultar BRM:
   - chamar LibBrm.consultar()

3. Atualizar:
   - data_ultima_consulta
   - quantidade_consultas
   - status_externo_bruto

4. Mapear retorno:
   - sucesso → SUCESSO
   - falha → FALHA
   - pendente → manter PENDENTE

5. Se ainda PENDENTE:
   - recalcular proxima_consulta_em com backoff

---

Fallback:

Executar fallback apenas se:

- tipo_envio = DIGITAL
- canal_envio = WHATSAPP
- fallback_executado = false
- falha elegível

Ações:
- marcar fallback_executado = true
- criar nova tentativa:
  - tipo_envio = DIGITAL
  - canal_envio = SMS
  - id_envio_origem = tentativa original

Nunca:
- fallback para SMS duas vezes
- fallback para SMS se já for SMS

---

Concorrência (múltiplos pods):

Obrigatório:

- implementar claim seguro no banco
- evitar processamento duplicado

Estratégia:
- buscar lote elegível
- fazer claim por update atômico OU lock
- somente registros “claimados” são processados

Não depender apenas do @Scheduled.

---

Scheduler:

- deve ser fino
- apenas chama use case

Configuração inicial:
- fixedDelay: 30 segundos

---

Processamento:

- batch configurável (inicial: 20–50)
- concorrência controlada (5–10 chamadas simultâneas)
- não processar em série
- usar pool controlado

---

Backoff:

Baseado em quantidade_consultas:

Sugestão:
- 1ª consulta: +30s
- 2ª: +1min
- 3ª: +2min
- 4ª: +5min

Configurar via properties.

---

Arquitetura esperada:

Seguir padrão hexagonal:

application:
- port.in
- port.out
- usecase

infrastructure:
- adapter.in.scheduler
- adapter.out.brm
- adapter.out.persistence

---

Componentes esperados:

- ReconciliarTentativasEnvioPendentesScheduler
- ReconciliarTentativasEnvioPendentesUseCase
- ReconciliarTentativasEnvioPendentesService
- TentativaEnvioDocumentoRepositoryPort
- BrmConsultaStatusPort
- Adapter BRM usando LibBrm.consultar()

---

Importante:

- Adapter BRM NÃO pode persistir dados
- Use case decide transições de estado
- Repository faz persistência
- Scheduler não contém regra de negócio

---

Entrega em fases:

Fase 1:
- arquitetura das classes
- estratégia de concorrência
- estratégia de claim

Fase 2:
- ports e modelos

Fase 3:
- scheduler + use case

Fase 4:
- repository com claim seguro (MySQL)

Fase 5:
- adapter BRM

Fase 6:
- mapeamento de status + fallback

Fase 7:
- testes:
  - sucesso
  - timeout
  - fallback
  - concorrência entre pods
  - idempotência

---

Restrições finais:

- não gerar código simplista
- não ignorar concorrência
- não misturar camadas
- não assumir comportamento síncrono do BRM

Antes de gerar código:
explique a arquitetura e os trade-offs.