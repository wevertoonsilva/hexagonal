Formato e organização dos arquivos de documentação

A documentação final deve ser gerada em Markdown (.md) e armazenada dentro do próprio projeto.

Crie uma estrutura de documentação organizada, navegável e fácil de manter.

Diretório principal

Crie a documentação dentro do diretório:

docs/

O ponto de entrada obrigatório da documentação deve ser:

docs/README.md

Esse arquivo deve funcionar como a página inicial da documentação e conter:

* nome da aplicação;
* descrição e objetivo;
* visão geral do sistema;
* resumo da arquitetura;
* principais módulos/componentes;
* links para as demais documentações;
* índice navegável.

Organização da documentação

Não é obrigatório colocar toda a documentação em um único arquivo.

Para aplicações pequenas, um único docs/README.md pode ser suficiente.

Para aplicações médias ou grandes, prefira dividir a documentação em múltiplos arquivos Markdown, agrupando assuntos relacionados.

Exemplo de estrutura:

docs/
├── README.md
├── architecture/
│   ├── overview.md
│   ├── modules.md
│   └── dependencies.md
├── domain/
│   ├── overview.md
│   ├── entities.md
│   └── business-rules.md
├── flows/
│   ├── README.md
│   ├── fluxo-a.md
│   ├── fluxo-b.md
│   └── fluxo-c.md
├── api/
│   └── endpoints.md
├── messaging/
│   ├── overview.md
│   ├── consumers.md
│   └── producers.md
├── persistence/
│   ├── overview.md
│   └── data-model.md
├── integrations/
│   └── external-services.md
├── operations/
│   ├── configuration.md
│   ├── observability.md
│   └── error-handling.md
└── glossary.md

Essa estrutura é apenas uma referência. Adapte-a à arquitetura e às características reais da aplicação.

Não crie arquivos vazios, redundantes ou artificiais apenas para seguir essa estrutura.

Critério para divisão dos arquivos

Crie um arquivo separado quando um assunto:

* possuir conteúdo suficientemente relevante;
* representar um fluxo funcional importante;
* representar um módulo significativo;
* possuir muitas regras de negócio;
* precisar de diagramas próprios;
* tiver potencial de evoluir independentemente;
* tornar o arquivo principal excessivamente grande.

Agrupe assuntos pequenos e diretamente relacionados no mesmo arquivo.

Priorize coesão em vez de quantidade de arquivos.

Documentação dos fluxos

Fluxos de negócio importantes podem possuir arquivos próprios.

Exemplo:

docs/flows/processamento-documento.md

Cada fluxo deve explicar, quando aplicável:

1. objetivo;
2. trigger;
3. pré-condições;
4. entrada;
5. fluxo principal passo a passo;
6. decisões e bifurcações;
7. regras de negócio;
8. componentes/classes envolvidos;
9. persistência;
10. integrações;
11. mensageria;
12. tratamento de erros;
13. resultado;
14. estados envolvidos;
15. diagrama de sequência ou fluxo.

O objetivo é permitir que um desenvolvedor compreenda o processo ponta a ponta sem precisar descobrir sozinho a sequência navegando pelo código.

Diagramas

Inclua diagramas Mermaid diretamente nos arquivos Markdown sempre que ajudarem na compreensão.

Exemplo:

sequenceDiagram
    participant Controller
    participant UseCase
    participant Repository
    participant ExternalService
    Controller->>UseCase: executa operação
    UseCase->>Repository: consulta dados
    UseCase->>ExternalService: executa integração
    ExternalService-->>UseCase: resultado
    UseCase-->>Controller: resposta

Utilize o tipo de diagrama mais apropriado:

* flowchart para processos e arquitetura;
* sequenceDiagram para chamadas e fluxos ponta a ponta;
* classDiagram para estruturas importantes do domínio;
* stateDiagram-v2 para ciclos de vida e transições de estado.

Não crie diagramas meramente decorativos.

Navegação

Todos os arquivos devem ser facilmente acessíveis a partir de docs/README.md.

Utilize links relativos entre os documentos.

Exemplo:

## Documentação
- [Arquitetura](architecture/overview.md)
- [Domínio](domain/overview.md)
- [Regras de negócio](domain/business-rules.md)
- [Fluxos](flows/README.md)
- [APIs](api/endpoints.md)
- [Mensageria](messaging/overview.md)
- [Persistência](persistence/overview.md)
- [Integrações](integrations/external-services.md)
- [Configuração](operations/configuration.md)
- [Observabilidade](operations/observability.md)
- [Glossário](glossary.md)

Quando uma seção possuir vários documentos, crie um README.md para funcionar como índice local somente quando isso realmente melhorar a navegação.

Referências ao código

Sempre que possível, utilize referências relativas para arquivos importantes do código-fonte.

Exemplo:

A entrada deste fluxo ocorre através de
[`DocumentoController`](../src/main/java/.../DocumentoController.java).

Ao mencionar uma regra importante, informe a classe e, quando relevante, o método responsável pela implementação.

As referências devem facilitar a navegação entre documentação e implementação.

Não utilize números de linha como referência permanente, pois eles se tornam obsoletos rapidamente.

Fonte da verdade

O código-fonte da aplicação é a principal fonte da verdade.

Considere também:

* testes;
* migrations;
* configurações;
* schemas;
* contratos;
* arquivos de infraestrutura;
* documentação existente.

Caso exista divergência entre documentação existente e implementação, destaque a inconsistência e considere o comportamento implementado no código como referência, salvo quando houver evidência explícita em contrário.

Conteúdo não confirmado

Não apresente hipóteses como fatos.

Quando alguma informação não puder ser confirmada pelo código, utilize uma indicação explícita, por exemplo:

Não confirmado: não foi possível determinar pelo código analisado se este processamento possui garantia de idempotência.

Quando houver uma inferência razoável:

Inferência: este componente aparentemente funciona como mecanismo de idempotência, com base no uso de […].

Essas observações devem ser utilizadas apenas quando realmente necessárias.

Qualidade do Markdown

Os arquivos devem utilizar Markdown limpo e compatível com renderizadores comuns, especialmente GitHub.

Utilize corretamente:

* títulos e subtítulos;
* listas;
* tabelas;
* blocos de código;
* Mermaid;
* links relativos;
* citações e observações quando necessárias.

Mantenha uma hierarquia consistente de títulos.

Evite HTML dentro dos arquivos Markdown, salvo quando estritamente necessário.

Linguagem

A documentação deve ser escrita em português do Brasil, mantendo nomes técnicos, classes, métodos, endpoints, eventos, tópicos, campos e conceitos do código em sua nomenclatura original.

Não traduza nomes existentes no código.

Nível de detalhe

Não gere documentação apenas para aumentar volume.

Priorize informações que ajudem um engenheiro a:

* compreender o sistema;
* realizar onboarding;
* investigar problemas;
* alterar regras de negócio;
* implementar novas funcionalidades;
* compreender impactos de mudanças;
* identificar integrações e dependências;
* acompanhar um fluxo do início ao fim.

Evite documentar getters, setters, constructors, DTOs triviais ou classes autoexplicativas individualmente, salvo quando forem importantes para compreender algum contrato ou comportamento.

Consistência entre documentos

Antes de finalizar, revise toda a documentação gerada verificando:

* links quebrados;
* informações contraditórias;
* nomenclaturas inconsistentes;
* fluxos incompletos;
* regras mencionadas em um documento e contraditas em outro;
* diagramas incompatíveis com a descrição textual;
* arquivos que deveriam estar referenciados no índice;
* documentação duplicada desnecessariamente.

A documentação deve funcionar como um conjunto coeso, e não como vários textos independentes gerados isoladamente.

Atualização do README principal do projeto

Não substitua nem reescreva automaticamente o README.md existente na raiz do projeto.

A documentação técnica detalhada deve permanecer em docs/.

Caso seja apropriado, sugira adicionar ao README.md principal apenas um link para:

docs/README.md

Não altere outros arquivos do projeto que não sejam necessários para produzir a documentação.

Entrega final

Ao concluir a geração, apresente:

1. a árvore de arquivos Markdown criados;
2. um resumo do conteúdo de cada arquivo;
3. os principais fluxos documentados;
4. as principais regras de negócio identificadas;
5. os diagramas criados;
6. informações que não puderam ser determinadas com segurança;
7. inconsistências encontradas entre código, testes, configurações ou documentação existente;
8. possíveis lacunas que deveriam ser esclarecidas pela equipe.

Antes de considerar o trabalho concluído, valide que docs/README.md permite navegar para toda a documentação relevante criada.