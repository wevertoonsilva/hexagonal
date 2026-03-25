Você atuará como engenheiro sênior Java/Spring Boot no projeto service-consignado-doc-hub.

Objetivo:
Implementar o scheduler responsável por reconciliar tentativas de envio BRM, lendo a tabela `tentativa_envio_documento` e consultando o status da mensagem via `LibBrm.consultar()`.

Contexto de domínio:
- O projeto possui as tabelas:
  - `requisicao_documento`
  - `execucao_etapa_documento`
  - `saida_etapa_documento`
  - `tentativa_envio_documento`
  - `evento_envio_documento`
  - `outbox_callback_requisicao`
- A tabela `tentativa_envio_documento` representa a tentativa de envio por canal.
- Os canais BRM são:
  - `WHATSAPP`
  - `SMS`
- Existe também `CARTA_FISICA`, mas o reconciliador NÃO deve tratar IGB. IGB será tratada por eventos.
- O status interno adotado para `tentativa_envio_documento` é:
  - `CRIADO`
  - `PENDENTE`
  - `SUCESSO`
  - `FALHA`
  - `TIMEOUT`
- O status `PENDENTE` representa o estado após aceite técnico do provedor.
- O BRM não possui stream de mudança de estado hoje.
- A consulta de status deve ser feita via `LibBrm.consultar()`.
- A aplicação roda em múltiplos pods.
- O reconciliador deve ser seguro para múltiplas instâncias, sem processar a mesma tentativa simultaneamente em dois pods.
- O scheduler deve rodar dentro do próprio projeto Spring Boot.
- O scheduler deve ser fino: sem regra de negócio complexa dentro da classe anotada com `@Scheduled`.
- A lógica de negócio deve ficar em use case/service.
- O scheduler deve processar apenas tentativas BRM elegíveis.
- O reconciliador deve trabalhar com batch configurável.
- O reconciliador deve respeitar `proxima_consulta_em`, `data_ultima_consulta`, `data_limite_confirmacao`, `quantidade_consultas` e `fallback_executado`.
- O reconciliador não deve consultar registros que já estão em estado final.
- O reconciliador deve permitir fallback de WhatsApp para SMS quando elegível.
- O reconciliador não deve executar fallback duas vezes para a mesma tentativa.
- Ao atingir estado terminal da requisição, o processo maior depois gravará callback na `outbox_callback_requisicao`, mas o foco desta implementação é o reconciliador da tentativa.

Requisitos de arquitetura:
1. Não coloque lógica de negócio no scheduler.
2. Crie uma interface de use case, por exemplo:
   - `ReconciliarTentativasEnvioPendentesUseCase`
3. Crie uma implementação de serviço, por exemplo:
   - `ReconciliarTentativasEnvioPendentesService`
4. Crie um scheduler Spring fino, por exemplo:
   - `ReconciliarTentativasEnvioPendentesScheduler`
5. Crie/reuse ports para:
   - buscar tentativas elegíveis para reconciliação
   - salvar atualização da tentativa
   - consultar status no BRM via adapter
   - criar tentativa de fallback SMS quando aplicável
6. Separe claramente:
   - adapter BRM
   - repository de persistência
   - use case de reconciliação
7. Não usar `Thread.sleep`.
8. Não assumir single instance.
9. Não usar lógica ingênua que possa gerar dupla reconciliação em múltiplos pods.

Requisitos de concorrência / múltiplos pods:
- A busca de tentativas elegíveis deve ser segura em ambiente com múltiplos pods.
- Implementar estratégia de claim/lock por registro no banco.
- Preferir abordagem compatível com MySQL, segura para concorrência.
- Se necessário, usar status intermediário de processamento ou estratégia de claim por update atômico.
- Não depender apenas do `@Scheduled` para evitar concorrência.
- O repositório deve expor método de busca/claim de tentativas elegíveis.
- O Copilot deve propor uma abordagem concreta e segura, não apenas conceitual.

Regras do reconciliador:
1. Processar apenas tentativas com:
   - canal em `WHATSAPP` ou `SMS`
   - status `PENDENTE`
   - `proxima_consulta_em <= agora`
2. Antes de consultar o BRM, verificar timeout:
   - se `agora >= data_limite_confirmacao`
   - marcar `TIMEOUT`
   - se a tentativa for de `WHATSAPP` e a política permitir, avaliar criação de fallback SMS
3. Ao consultar o BRM via `LibBrm.consultar()`, atualizar:
   - `data_ultima_consulta`
   - `quantidade_consultas`
   - `status_externo_bruto`
4. Mapear o retorno do BRM para status interno:
   - status final de sucesso -> `SUCESSO`
   - status final de falha -> `FALHA`
   - status ainda em processamento -> mantém `PENDENTE`
5. Quando mantiver `PENDENTE`, recalcular `proxima_consulta_em` usando backoff configurável.
6. Se a falha do WhatsApp for elegível a fallback:
   - marcar `fallback_executado = true` na tentativa original
   - criar nova `tentativa_envio_documento` para canal `SMS`
   - associar `id_envio_origem`
   - deixar a tentativa SMS pronta para fluxo posterior
7. Não criar fallback SMS se já existir fallback executado.
8. Não criar fallback para tentativa `SMS`.
9. Não reconciliar `CARTA_FISICA`.

Backoff e agendamento:
- O scheduler deve usar `fixedDelay` configurável.
- Sugestão inicial:
  - scheduler a cada 30 segundos
- O backoff por tentativa deve usar `proxima_consulta_em`.
- O Copilot deve implementar de forma parametrizável via properties.
- Não hardcode valores mágicos.
- Sugestão inicial de configuração:
  - primeira próxima consulta: 30 segundos
  - depois 1 minuto
  - depois 2 minutos
  - depois 5 minutos
- O algoritmo pode ser simples e baseado em `quantidade_consultas`.

Estrutura esperada:
Seguir arquitetura hexagonal/modular do projeto. Exemplo:
- application/port/in
- application/port/out
- application/usecase
- infrastructure/adapter/in/scheduler
- infrastructure/adapter/out/brm
- infrastructure/adapter/out/persistence

Quero que você entregue em fases, nesta ordem:

Fase 1:
- proponha a arquitetura das classes
- liste classes/interfaces que serão criadas ou alteradas
- descreva a estratégia de concorrência entre pods
- descreva a estratégia de claim dos registros no banco

Fase 2:
- gere os ports, DTOs e enums necessários
- reaproveite os enums e modelos existentes quando fizer sentido

Fase 3:
- gere o scheduler fino
- gere a interface do use case
- gere a implementação do use case com a lógica principal

Fase 4:
- gere o adapter/repository de persistência para buscar/claimar tentativas elegíveis de forma segura
- gere pseudo-SQL ou implementação concreta compatível com MySQL

Fase 5:
- gere o adapter BRM que encapsula `LibBrm.consultar()`
- o adapter deve devolver um objeto de resultado já traduzido para a aplicação, sem persistir nada

Fase 6:
- gere a política de mapeamento do retorno do BRM para status interno e decisão de fallback

Fase 7:
- gere testes unitários e de integração para:
  - tentativa pendente consultada com sucesso
  - tentativa com timeout
  - falha elegível a fallback
  - falha não elegível a fallback
  - prevenção de fallback duplicado
  - prevenção de dupla reconciliação em múltiplos pods

Restrições importantes:
- Não gerar uma implementação simplista só para compilar.
- Não colocar regras de negócio dentro do adapter BRM.
- Não colocar regras de negócio dentro do scheduler.
- Não gravar diretamente `tentativa_envio_documento` dentro do adapter BRM.
- Não assumir que resposta técnica do BRM significa sucesso final.
- Não ignorar múltiplos pods.
- Não deixar código com setters espalhados e sem encapsulamento se o modelo atual permitir métodos de domínio.
- Não usar nomes genéricos demais.
- Não criar uma solução que dependa de single thread.

Quero código e estrutura com qualidade de produção, não apenas exemplo didático.
Antes de gerar código, explique a abordagem escolhida e os trade-offs.