# Geração da documentação

A documentação final deve ser gerada em **Markdown (`.md`)**, dentro do diretório:

`docs/`

O arquivo `docs/README.md` deve ser o ponto de entrada, contendo a visão geral e links para as demais seções.

A documentação pode ser dividida em múltiplos arquivos quando isso melhorar a organização e a leitura, especialmente para:

- arquitetura;
- fluxos;
- regras de negócio;
- APIs;
- mensageria;
- persistência;
- integrações;
- configurações e operação.

Não crie arquivos desnecessários. Priorize uma estrutura simples, coesa e fácil de navegar.

Utilize **diagramas Mermaid** quando ajudarem a explicar arquitetura, sequência de processamento, estados ou fluxos.

A documentação deve ser escrita em **português do Brasil**, preservando nomes técnicos, classes, métodos, endpoints, eventos e demais elementos do código em sua nomenclatura original.

## Compatibilidade com Confluence

Estruture o conteúdo para que possa ser facilmente migrado ou publicado no **Confluence**.

Organize os documentos de forma que cada arquivo Markdown possa representar, quando apropriado, uma página independente no Confluence.

Mantenha uma hierarquia clara de páginas, seções, títulos e subtítulos.

Evite recursos específicos do GitHub que dificultem a migração para o Confluence.

Quando houver vários documentos, `docs/README.md` deve representar a página raiz da documentação e os demais arquivos devem formar uma hierarquia lógica de páginas filhas.

Ao finalizar, apresente:

- a árvore dos arquivos criados;
- a hierarquia de páginas recomendada para publicação no Confluence.