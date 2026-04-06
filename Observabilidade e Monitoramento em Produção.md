Aqui está o guia completo e consolidado, unindo os aspectos técnicos de infraestrutura, as novidades do Java 25 e as competências de liderança necessárias para o seu cenário.
📑 Guia de Entrevista: Engenheiro de Software Sênior (Java/Fintech)
Este documento reúne 13 tópicos estratégicos para avaliar candidatos sêniores em um contexto de migração crítica, uso de tecnologias modernas e mentoria de times jovens.
1. Sincronização de Dados e Migração "Viva"
Cenário: Precisamos manter o RDS Postgres atualizado em tempo real a partir do Oracle (legado), mas as tabelas e estruturas são diferentes. O sistema legado não pode sofrer impacto de performance.
 * Pergunta: Como você desenharia essa sincronização para garantir que o RDS reflita as mudanças do Oracle quase instantaneamente, lidando com a diferença de esquemas?
 * O que esperar: Menção a CDC (Change Data Capture) com ferramentas como Debezium; uso de Kafka como buffer; uma camada de transformação (Consumer ou ETL) que trate o mapeamento; e preocupação com a idempotência na escrita.
2. Resiliência e Integridade de Dados
Cenário: Durante a sincronização, o Kafka ou o consumidor do RDS cai por 15 minutos. O Oracle continua recebendo milhares de transações.
 * Pergunta: Como você garante que, ao voltar, o RDS não terá "buracos" de dados e que nenhuma transação seja processada em duplicidade ou fora de ordem?
 * O que esperar: Uso de offsets do Kafka para retomada; estratégia de Dead Letter Queues (DLQ); e o uso de uma Chave de Idempotência ou UPSERT no Postgres para evitar duplicidade.
3. Java 25 e Concorrência (Virtual Threads)
Cenário: Temos serviços que consultam simultaneamente o Oracle, o MongoDB e uma API externa da nova processadora.
 * Pergunta: Com o Java 25, como você utilizaria Virtual Threads para otimizar esse serviço? Existe algum risco ao usar Virtual Threads com drivers de banco ou bibliotecas legadas?
 * O que esperar: Entendimento de que Virtual Threads brilham em tarefas I/O-bound; menção a Structured Concurrency; e o alerta sobre pinning (quando uma thread fica presa por blocos synchronized em drivers antigos), preferindo ReentrantLock.
4. Arquitetura: Isolamento do Legado
Cenário: O time precisa implementar uma regra nova, mas parte dos dados está no Oracle e parte no Postgres.
 * Pergunta: Como você estruturaria o código para que o domínio da aplicação não fique "sujo" com lógica de dois bancos diferentes ao mesmo tempo?
 * O que esperar: Uso do padrão Anti-Corruption Layer (ACL); aplicação de Hexagonal Architecture (Ports and Adapters) para que a lógica de negócio dependa de interfaces e não da implementação específica de cada banco.
5. Messaging: Kafka vs. SQS
Cenário: Temos fluxos de processamento de cartões e fluxos de notificações simples (e-mail/push).
 * Pergunta: Em quais cenários você escolheria o Kafka e em quais usaria o SQS? Como você decide qual ferramenta se encaixa melhor em cada caso?
 * O que esperar: Kafka para fluxos que exigem ordenação estrita, replay de mensagens ou alto throughput; SQS para tarefas desacopladas e simples que não exigem persistência de log.
6. Mentoria e Liderança Técnica
Cenário: O time é composto majoritariamente por Juniors e Plenos. Um desenvolvedor subiu um código que pode travar o Oracle via lock de tabela.
 * Pergunta: Como você aborda esse desenvolvedor no Code Review? Como você ensina o time a monitorar métricas para evitar que isso chegue em produção?
 * O que esperar: Abordagem pedagógica; sugestão de Pair Programming em tarefas críticas; menção a monitoramento de conexões ativas e tempo de transação no Grafana/Dynatrace.
7. Persistência: JPA vs. JDBC Puro
Cenário: O JPA pode gerar queries lentas ao lidar com mapeamentos complexos entre bancos diferentes durante a migração.
 * Pergunta: Em um cenário de migração de alta performance, você manteria 100% em JPA? Quando optaria por usar SQL puro ou JdbcClient?
 * O que esperar: Maturidade para admitir que o JPA pode ser um gargalo em migrações massivas; sugestão de Batch Inserts via JDBC para performance de carga pesada.
8. Consistência Transacional (Outbox Pattern)
Cenário: Uma transação de cartão é aprovada. Precisamos salvar no Postgres e disparar um evento no Kafka. Se o banco salvar mas o Kafka falhar, temos um problema.
 * Pergunta: Como você garante que a escrita no banco e o envio da mensagem sejam atômicos ou garantidos?
 * O que esperar: Menção ao Transactional Outbox Pattern (salvar o evento em uma tabela interna e um worker ler/postar no Kafka) para garantir consistência eventual segura.
9. Estratégia de "Shadow Testing"
Cenário: O novo sistema no Postgres está pronto, mas o risco de desligar o Oracle é alto.
 * Pergunta: Como você validaria se o novo sistema processa tudo exatamente como o legado antes do "switch" definitivo?
 * O que esperar: Sugestão de Shadow Writes (escrever nos dois, mas o novo resultado é apenas comparado) e scripts de Reconciliação de Dados para bater os saldos.
10. Performance e Escala no RDS Postgres
Cenário: O volume de dados no Postgres cresce rápido e as consultas de extrato começaram a degradar.
 * Pergunta: Além de índices básicos, quais estratégias de banco você usaria para manter a performance em tabelas com milhões de registros?
 * O que esperar: Menção a Partitioning de Tabelas (por data); análise de planos de execução (EXPLAIN ANALYZE); e estratégias de Vacuum/Autovacuum.
11. Segurança (PCI-DSS)
Cenário: Estamos lidando com dados de cartões. Há risco de logar números de cartões ou CVV acidentalmente.
 * Pergunta: Quais travas técnicas você implementaria no código ou no pipeline para garantir que dados sensíveis não sejam expostos?
 * O que esperar: Uso de bibliotecas de masking em logs; criptografia em repouso; uso de Value Objects para evitar serialização indevida; e ferramentas de SAST (Static Analysis).
12. Gestão de Débito Técnico
Cenário: A diretoria quer acelerar a migração para cortar custos, mas o código de sincronização ainda precisa de refatoração para ser resiliente.
 * Pergunta: Como você negocia a necessidade de qualidade técnica versus a pressa do negócio? O que é inegociável para você?
 * O que esperar: Capacidade de priorização por risco. O candidato deve ser inegociável com integridade de dados e observabilidade, mas pode aceitar adiar refatorações estéticas.
13. Observabilidade Nativa (Spring Boot 3+)
Cenário: Precisamos monitorar a latência da sincronização entre os bancos em tempo real.
 * Pergunta: Como você aproveitaria o Spring Boot Actuator e o Micrometer para expor métricas de negócio (ex: "atraso na sincronização")?
 * O que esperar: Criação de Custom Metrics (Gauges/Counters); integração com Prometheus; e uso de tracing distribuído para ligar métricas a traces lentos.
Dica de Ouro: Observe se o candidato demonstra preocupação com o "dia seguinte" da migração. Um sênior real não quer apenas que o código funcione, ele quer que o sistema seja operável e fácil de dar manutenção pelo time que ele está ajudando a formar.
