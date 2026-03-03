**Título:** Observabilidade e Monitoramento de Sistemas em Produção
**Subtítulo:** Da visibilidade técnica ao controle operacional

---

## Por que o tema é importante?

> _"Antes de entrar no conteúdo técnico, quero trazer uma situação que aposto que todo mundo aqui já viveu."_

> _"É segunda-feira de manhã. Chega uma mensagem no canal de incidentes: 'Tá falhando em produção'. E começa aquela corrida — abre log aqui, abre métrica ali, chama o time de infra, chama o time de negócio... trinta minutos depois todo mundo ainda está tentando entender se o problema é no serviço A, no serviço B ou se é coisa do parceiro."_

> _"Esse cenário tem um custo. Tem o custo técnico — o sistema degradado, o usuário impactado. Mas tem também o custo humano: o engenheiro no sábado às 11 da noite tentando montar um quebra-cabeça no escuro, sem as peças certas."_

> _"A pergunta que guia essa apresentação é simples: quando algo falha em produção, quanto tempo leva até você entender o quê, onde e por quê aconteceu? Essa resposta define a maturidade operacional de um time."_

> _"Observabilidade e monitoramento não são sobre ter mais dashboards. São sobre ter as respostas certas, na hora certa, para tomar decisões com confiança."_

---

## Observabilidade e Monitoramento — Visão Geral

> _"Antes de mergulhar nos tópicos, quero alinhar o que a gente quer dizer quando fala de observabilidade — porque é um termo que todo mundo usa, mas nem sempre com o mesmo significado."_

> _"Monitoramento é quando você sabe de antemão o que pode dar errado e configura alertas para isso. É reativo por natureza — você define o threshold, espera o problema aparecer e reage."_

> _"Observabilidade vai um passo além. É a capacidade de entender o estado interno de um sistema a partir dos dados que ele emite — mesmo quando o problema é algo que você nunca previu. Não é só saber que algo quebrou, é conseguir rastrear exatamente o caminho que levou até aquela falha."_

> _"Na prática, isso se apoia em três pilares: métricas, logs e traces. Cada um responde a uma pergunta diferente. Métricas dizem 'o que está acontecendo'. Logs dizem 'o que aconteceu'. Traces dizem 'por que caminho isso aconteceu'. A mágica está quando esses três conversam entre si."_

> _"Ao longo dessa apresentação, a gente vai ver como isso funciona na prática — desde a anatomia de um trace até como isso se traduz em menos tempo resolvendo incidente e melhor experiência para o usuário final. E no meio do caminho, a gente vai trazer um caso real que vivemos aqui, que mostra muito bem o valor disso tudo quando está funcionando."_

> _"Então vamos lá."_

---

## Conexão com o que veio antes

> _"O Evandro mostrou pra gente como as métricas nos dão uma visão quantitativa do sistema — latência, throughput, taxa de erro. O José mostrou como os logs registram os eventos, o que aconteceu linha a linha."_

> _"Mas deixa eu trazer uma situação. Imagina que o Evandro vê no dashboard dele que a latência do serviço de simulação de saque subiu 300% às 14h. Ele chama o José, que abre os logs e encontra erros — mas os logs são de três serviços diferentes, sem nenhuma conexão entre eles. Você sabe que tem um problema, você tem evidências espalhadas, mas não consegue montar a história completa."_

> _"É exatamente aí que entra o Trace. Se métricas te dizem **o quê** e logs te dizem **o que aconteceu**, o trace te diz **por qual caminho** — e isso muda completamente a velocidade do diagnóstico."_

---

## O que é um Trace

> _"Um trace representa a jornada completa de uma requisição pelo sistema. Do momento que ela entra até o momento que ela retorna uma resposta — cada passo desse caminho é registrado."_

> _"Essa unidade mínima se chama span. Cada span tem um início, um fim, uma duração, um status — se foi OK ou se falhou — e um contexto que o conecta ao resto da cadeia. Um conjunto de spans conectados forma um trace."_

> _"Pensa assim: se o log é uma foto de um momento, o trace é o filme completo da requisição. Você não só sabe que algo aconteceu — você sabe exatamente onde, em que ordem, quanto tempo cada etapa levou e onde a coisa quebrou."_

> _"E tem um detalhe técnico importante aqui: cada trace carrega um trace ID — um identificador único que viaja junto com a requisição por todos os serviços. É esse ID que permite reconstruir a história inteira depois."_

---

## Tracing Distribuído — onde a complexidade vive

> _"Agora, num monolito, trace já ajuda muito. Mas no mundo de microsserviços — que é o mundo que a gente vive — ele se torna indispensável."_

> _"Quando uma requisição passa por vários serviços, cada um rodando de forma independente, em containers diferentes, talvez em regiões diferentes — como você rastreia o caminho completo? Como você sabe se o problema está no seu serviço ou no serviço que você está chamando?"_

> _"Isso é tracing distribuído. A ideia central é a propagação de contexto — o trace ID viaja junto com cada chamada, seja HTTP, gRPC, ou mensageria como Kafka e SQS. Cada serviço que recebe a requisição lê esse contexto, registra seu próprio span e passa o contexto adiante."_

> _"O padrão que a gente usa pra isso é o W3C TraceContext — um header chamado traceparent que carrega o trace ID e o span ID pai. Qualquer serviço que respeite esse padrão consegue participar do trace automaticamente."_

> _"Quando funciona bem, você abre uma ferramenta como o Dynatrace e vê o caminho completo — API Gateway, nosso serviço, serviço do parceiro — tudo num único trace, com o tempo de cada etapa e onde exatamente a falha aconteceu."_

---

## Como ajuda no dia a dia — visão técnica

> _"Na prática, isso muda o fluxo de investigação completamente."_

> _"Sem trace, um incidente funciona assim: alerta dispara, todo mundo abre o próprio sistema, começa o jogo de 'não é aqui' — e você perde tempo valioso tentando correlacionar evidências manualmente."_

> _"Com trace, você pega o trace ID daquela requisição problemática, abre no Dynatrace e vê exatamente onde a latência explodiu, qual serviço retornou erro, qual era o payload naquele momento. Em minutos, não em horas."_

> _"Isso impacta diretamente o MTTR — o tempo médio de resolução de incidente. E o MTTR é uma das métricas mais importantes de maturidade operacional de um time de engenharia."_

---

## Como ajuda no dia a dia — visão de negócio

> _"Mas quero ir além do técnico por um momento, porque trace tem valor de negócio direto também."_

> _"Primeiro: **responsabilidade entre sistemas**. Quando você integra com parceiros — e a gente integra com vários — inevitavelmente vai ter um momento em que o problema está do lado deles, mas eles vão questionar. Com trace, você não precisa de achismo. Você tem o registro completo da requisição, com timestamps, payload, status code. É uma evidência técnica irrefutável."_

> _"Segundo: **diagnóstico em fronteiras externas**. Quando você aciona um parceiro reportando um bug, a primeira coisa que eles pedem é justamente o trace — porque é a forma mais rápida de eles reproduzirem e entenderem o que aconteceu do lado deles. Se você não tem trace, você não tem essa evidência."_

> _"E terceiro: **confiança com o negócio**. Quando um incidente acontece e você consegue em 10 minutos dizer exatamente o que falhou, por quê e o que está sendo feito — isso constrói credibilidade. Times que têm boa observabilidade respondem com dados, não com suposições."_

---

## Case real — PanCred, ConsigCard e Pismo

> _"E pra fechar minha parte com algo concreto, deixa eu trazer um caso que a gente viveu aqui."_

> _"O PanCred chamou nossa API no ConsigCard para simular um saque. Nossa API chamou a API de simulação da Pismo. Os cálculos que voltaram estavam incorretos — e o usuário final estava recebendo valores errados."_

> _"Acionamos a Pismo. A primeira coisa que eles pediram foi: 'me manda o trace da requisição'. E aqui está o ponto — porque o ConsigCard sempre propaga contexto de trace em todas as chamadas, a gente entrou no Dynatrace, filtrou pelos logs do nosso serviço e em segundos tinha o trace ID completo daquela requisição específica."_

> _"Passamos o trace pra Pismo. Com isso em mãos, eles conseguiram ver o request exato que chegou nos servidores deles, identificaram o bug interno e liberaram a correção."_

> _"Sem trace, essa investigação seria um ciclo longo de e-mails, prints de tela e suposições. Com trace, foi uma conversa técnica precisa que resolveu o problema no mesmo dia."_

> _"Esse caso resume bem o que o Evandro, o José e eu estamos falando ao longo dessa apresentação — métricas te avisam, logs te contam, trace te mostra o caminho. Os três juntos é que formam a base de uma operação que funciona de verdade."_

**Algumas dicas de apresentação:**

A transição entre as partes é o momento mais importante. Sair do "por que é importante" e entrar na "visão geral" sem parecer uma aula requer que você mantenha o tom de conversa — fale como se estivesse explicando para um colega, não definindo um conceito de livro. A definição de monitoramento vs. observabilidade pode gerar debate na plateia de engenheiros, então deixa espaço para isso acontecer — é sinal de que engajou.

---

## Disponibilidade

> _"Vou começar a parte técnica da apresentação falando sobre disponibilidade — que parece um conceito simples, mas tem muito mais profundidade do que aparece à primeira vista."_

> _"Quando a gente fala de disponibilidade, o instinto é pensar: 'o serviço tá up ou down?' Mas disponibilidade em sistemas modernos é uma pergunta muito mais sutil do que essa."_

> _"Um serviço pode estar respondendo 200 OK e ainda assim estar destruindo a experiência do usuário. Pode estar 'vivo' para o orquestrador e completamente degradado para quem está do outro lado da tela. Isso é o que a gente chama de disponibilidade sintática versus disponibilidade semântica — e a diferença entre as duas é exatamente onde mora o problema."_

---

> _"No Kubernetes — que é o ambiente onde a maioria dos nossos serviços roda — temos dois mecanismos principais para monitorar disponibilidade: o Liveness Probe e o Readiness Probe."_

> _"O Liveness responde à pergunta: o processo está vivo? Se falhar, o orquestrador reinicia o container. Parece simples, mas tem uma armadilha séria aqui: se o seu liveness probe for sensível demais — por exemplo, se ele falhar quando o serviço está sob alta carga — você entra num loop de reinicializações em cascata que piora o incidente em vez de resolver."_

> _"O Readiness responde a uma pergunta diferente: o serviço está pronto para receber tráfego? Ele pode estar vivo mas ainda inicializando, ou temporariamente sobrecarregado. Quando o readiness falha, o pod sai do balanceador — o processo é preservado, mas ele para de receber novas requisições até se recuperar."_

> _"A distinção importa muito na prática. Liveness cuida da sobrevivência do processo. Readiness cuida da qualidade do tráfego que ele recebe."_

---

> _"Mas tem um ponto que eu quero deixar bem marcado: liveness e readiness verdes não significam que tudo está bem. Eles são checks de infraestrutura — eles não sabem nada sobre o que está acontecendo dentro da sua lógica de negócio."_

> _"É exatamente por isso que a gente precisa ir além dos health checks básicos e conectar disponibilidade com SLOs — Service Level Objectives. Um SLO define de forma mensurável a promessa de qualidade que o serviço entrega. E quando você monitora disponibilidade através de SLOs, você começa a enxergar degradações silenciosas que os probes nunca capturariam."_

> _"E essa ponte entre disponibilidade de infraestrutura e experiência real do usuário é justamente o que o Evandro vai aprofundar agora, falando sobre performance."_

---

## Transição para o Evandro — Performance

> _"Evandro, pode vir. A gente acabou de ver que um sistema pode estar 'disponível' e ainda assim entregar uma experiência ruim. Você vai mostrar como a performance é a lente que revela esse gap, certo?"_

---

**Dicas para sua apresentação:**

O ponto mais importante da sua fala é o contraste entre disponibilidade sintática e semântica — é contra-intuitivo o suficiente para prender a atenção logo no início. Vale abrir com uma pergunta direta para a plateia: _"Alguém já teve um incidente onde todos os health checks estavam verdes?"_ — quase todo engenheiro já viveu isso, e isso cria conexão imediata antes de você explicar o conceito.

Evite entrar em detalhes de configuração de probe no roteiro — isso vira aula de Kubernetes. O foco é no raciocínio por trás de cada um, não na sintaxe YAML.

---

**Estrutura dos 17 slides:**

|#|Título|Seção|
|---|---|---|
|01|Capa|—|
|02|Por que o tema importa?|Introdução|
|03|Observabilidade vs Monitoramento|Visão Geral|
|04|Os 3 Pilares|Visão Geral|
|05|Métricas e Logs não bastam|Transição → Trace|
|06|O que é um Trace?|Sua fala 1|
|07|Trace Distribuído|Sua fala 1|
|08|Como o contexto se propaga|Sua fala 1|
|09|Trace no dia a dia|Sua fala 1|
|10|Valor de negócio do Trace|Sua fala 1|
|11|**Case real: PanCred/ConsigCard/Pismo**|Sua fala 1|
|12|O que é Disponibilidade?|Sua fala 2|
|13|SLA · SLO · SLI + os noves|Sua fala 2|
|14|Liveness vs Readiness Probe|Sua fala 2|
|15|Probes verdes não significam tudo bem|Sua fala 2|
|16|Trace e Disponibilidade: a ligação|Conexão|
|17|Conclusão|—|

