Sistema crítico degradando em produção

Situação:
“Você entra no trabalho pela manhã e percebe que um serviço crítico da empresa começou a apresentar aumento forte de latência e erro nas últimas horas. O impacto já chegou ao negócio. O time está pressionado e há várias pessoas sugerindo soluções diferentes ao mesmo tempo. Como você conduziria essa situação?”

O que esperar da resposta:
Você deve esperar uma resposta estruturada, não heroica. Um bom sênior fala sobre contenção primeiro, diagnóstico depois e correção definitiva em seguida. Deve mencionar priorização do impacto, comunicação clara com stakeholders, uso de observabilidade, definição de responsável por investigar cada hipótese e cuidado para não fazer mudanças aleatórias em produção. Também é um bom sinal se ele falar de rollback, feature flag, mitigação temporária e aprendizado pós-incidente.

Entrega importante com arquitetura ruim

Situação:
“Você assume uma frente importante perto da entrega e percebe que a solução foi construída de forma muito acoplada, difícil de testar e com alto risco de manutenção. O prazo está apertado e não dá para reescrever tudo. O que você faz?”

O que esperar da resposta:
A resposta boa mostra pragmatismo. O candidato precisa equilibrar risco técnico e prazo de negócio. Espere alguém falando em atacar pontos críticos, criar isolamento mínimo, reduzir risco operacional, refatorar apenas o que destrava evolução e deixar claro o débito técnico remanescente. Senioridade aqui aparece quando ele evita tanto o ‘deixa tudo como está’ quanto o ‘vamos refazer tudo’. Tem que demonstrar critério.

Time entregando, mas com baixa qualidade

Situação:
“Seu time está conseguindo entregar as demandas, mas a qualidade está baixa: bugs recorrentes, retrabalho, testes frágeis e PRs difíceis de revisar. A liderança quer velocidade. Como você atuaria?”

O que esperar da resposta:
Você deve esperar alguém que entenda que qualidade não é discurso, é sistema de trabalho. Uma resposta forte fala sobre identificar gargalos reais, ajustar critérios de pronto, melhorar review, reforçar testes nos pontos certos, criar padrões técnicos e atacar causa-raiz do retrabalho. Também é sinal de maturidade quando o candidato fala em melhorar o fluxo sem paralisar o time e em mostrar com dados que baixa qualidade reduz velocidade no médio prazo.

Divergência técnica forte dentro do time

Situação:
“Dois engenheiros fortes do time discordam fortemente sobre a direção técnica de uma solução. A discussão começa a afetar a execução e o clima. Como você conduz?”

O que esperar da resposta:
Espere postura de liderança técnica, não arbitrariedade. Um bom candidato deve falar em trazer a discussão para critérios objetivos, como custo de mudança, escalabilidade, prazo, risco, operação e aderência ao contexto. Deve saber conduzir decisão sem transformar isso em disputa de ego. Melhor ainda se ele falar em registrar decisão arquitetural e alinhar o time depois, evitando debate infinito.

Requisito mal definido vindo do produto

Situação:
“Produto traz uma demanda importante, mas o problema está mal definido e os critérios estão vagos. O time já quer começar a desenvolver para ganhar tempo. Como você age?”

O que esperar da resposta:
O que você quer ouvir é capacidade de reduzir ambiguidade. Um sênior forte não aceita virar fábrica de código. Ele busca entender problema, contexto, impacto, regra de negócio, exceções e critérios de aceite mínimos antes de sair implementando. Também é bom sinal se ele falar em quebrar a entrega em partes menores, validar premissas cedo e evitar overengineering antes de ter clareza.

Serviço com custo crescente e pouca previsibilidade

Situação:
“Um serviço começou a crescer bem e agora o custo de infraestrutura subiu bastante. Ainda não há indisponibilidade, mas a tendência preocupa. Como você avalia e conduz esse tipo de problema?”

O que esperar da resposta:
Espere alguém que pense em custo como atributo de arquitetura. A resposta forte fala em medir consumo real, identificar drivers de custo, separar desperdício de necessidade legítima, priorizar otimizações com maior retorno e evitar tuning cego. É bom quando o candidato fala de capacidade, observabilidade, uso de cache quando faz sentido, revisão de padrões de acesso, escalabilidade horizontal versus vertical e impacto no produto.

Falha causada por mudança do próprio time

Situação:
“Uma mudança feita pelo seu time gerou incidente em produção. O problema foi corrigido, mas agora há pressão para identificar culpados. Como você lida com isso?”

O que esperar da resposta:
Senioridade aparece quando o candidato fala em responsabilidade sem cultura de culpa. Você quer ouvir sobre transparência, correção do processo, análise do que falhou em validação, rollout, observabilidade ou revisão, e ações concretas para evitar repetição. Resposta ruim é defensiva ou política demais. Resposta boa trata incidente como problema sistêmico, sem infantilizar responsabilidade individual.

Dependência externa instável

Situação:
“Seu sistema depende de uma integração externa importante que é instável, lenta e pouco confiável. O fornecedor demora para responder e o negócio não pode parar. Como você desenharia a estratégia?”

O que esperar da resposta:
A resposta forte traz resiliência arquitetural. Espere menções a timeout, retry com critério, circuit breaker, fallback, processamento assíncrono quando possível, idempotência, observabilidade e tratamento explícito de degradação. Melhor ainda se o candidato falar em desacoplar a experiência do usuário do tempo da integração e definir claramente o que acontece quando a dependência falha.

Engenheiro bom tecnicamente, ruim para o time

Situação:
“Você tem no time uma pessoa muito forte tecnicamente, mas que centraliza decisões, dificulta colaboração e gera dependência excessiva nela. Como você lida com esse cenário?”

O que esperar da resposta:
Você deve esperar maturidade de liderança. Um sênior ou tech lead forte fala sobre feedback direto, alinhamento de comportamento esperado, distribuição de contexto, revisão de forma de trabalho e redução de risco de concentração de conhecimento. Resposta boa não demoniza a pessoa nem normaliza o problema. Ela trata performance como técnica + colaboração.

Refatoração sem patrocínio explícito

Situação:
“Você identifica um problema estrutural importante no sistema, mas não existe demanda formal para corrigir isso e o roadmap já está cheio. Como você decide se vale ou não puxar essa discussão?”

O que esperar da resposta:
A resposta boa mostra visão de negócio. O candidato deve saber transformar problema técnico em risco concreto: tempo de entrega, incidentes, custo, insegurança para evoluir, impacto operacional. Deve falar em propor recortes menores, construir argumento com evidência e buscar janela correta de execução. Sênior que só fala ‘precisa refatorar porque está feio’ ainda está pensando como dev pleno.

Onboarding ruim e conhecimento espalhado

Situação:
“Cada pessoa do time entende um pedaço do sistema, quase não existe documentação útil e sempre que entra alguém novo o onboarding é lento. O que você faria?”

O que esperar da resposta:
Espere foco em escala organizacional. Um candidato forte fala em reduzir dependência de conhecimento tácito, melhorar documentação essencial, padronizar fluxos, registrar decisões importantes e criar mecanismos de compartilhamento contínuo. É um bom sinal se ele prioriza documentação viva e útil, não burocracia.

Pressão para cortar testes e review

Situação:
“Em uma entrega estratégica, alguém da liderança sugere reduzir testes e encurtar code review para ganhar velocidade. Como você responderia?”

O que esperar da resposta:
A resposta boa não é dogmática, mas também não é frouxa. O candidato deve avaliar risco, criticidade, reversibilidade e tipo de mudança. Pode até flexibilizar algo em contexto específico, mas com compensações claras. Você quer ouvir alguém que sabe negociar velocidade sem desmontar os controles básicos de segurança da entrega.

Mudança grande atravessando vários times

Situação:
“Você precisa liderar uma mudança técnica que depende de vários times, cada um com prioridades diferentes e pouco incentivo para colaborar. Como você destravaria isso?”

O que esperar da resposta:
Senioridade aqui é articulação. Espere alguém falando em alinhar objetivo comum, quebrar a iniciativa em partes, definir contratos claros entre times, reduzir dependências, negociar prioridade com base em impacto e manter comunicação frequente. Resposta boa mostra capacidade de influência sem autoridade formal.

Métricas bonitas, percepção ruim do usuário

Situação:
“As métricas técnicas principais parecem aceitáveis, mas usuários e áreas de negócio reclamam que o sistema está ruim. Como você investigaria?”

O que esperar da resposta:
Você deve esperar alguém que entenda que telemetria parcial engana. Resposta forte fala em revisar métricas de experiência real, jornada ponta a ponta, erros silenciosos, gargalos fora do serviço principal, comportamento por perfil de usuário e correlação com eventos de negócio. Muito candidato fica preso em CPU, memória e latência média. Sênior de verdade pensa em experiência e valor entregue.

Decisão entre solução rápida e solução sustentável

Situação:
“Você tem duas opções para resolver um problema importante: uma é mais rápida, resolve agora, mas gera limitação futura; a outra é mais sólida, mas custa mais tempo. Como você decide?”

O que esperar da resposta:
Essa é clássica para detectar maturidade. A resposta forte não escolhe uma opção por princípio. Ela considera contexto, urgência, reversibilidade, custo de mudança, impacto futuro e capacidade do time. Melhor ainda se o candidato falar em solução intermediária, rollout incremental ou desenho que preserve saída futura.

Se você quiser, eu posso transformar isso agora em um roteiro completo de entrevista com:
“pergunta situacional + sinais de resposta forte + sinais de alerta + nota de avaliação de 1 a 5”.
