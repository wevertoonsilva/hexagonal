/**
 * Portas de saída (driven ports) que definem as dependências externas necessárias ao domínio.
 *
 * <p>Este pacote contém interfaces que abstraem as necessidades do domínio em relação a
 * recursos externos, como persistência de dados, envio de mensagens, cache, notificações,
 * e integrações com outros sistemas.
 *
 * <p>O domínio define "o que" precisa, mas não "como" será implementado. As implementações
 * concretas residem na camada de infraestrutura, permitindo fácil substituição e testabilidade
 * através de mocks e stubs.
 *
 * <p><strong>Exemplos de portas de saída:</strong>
 * <ul>
 *   <li>Interfaces de repositórios para persistência de dados</li>
 *   <li>Contratos para publicação de eventos de domínio</li>
 *   <li>Abstrações para acesso a cache e armazenamento temporário</li>
 *   <li>Interfaces para envio de notificações</li>
 *   <li>Contratos para consultas a sistemas externos</li>
 * </ul>
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Portas de Saída"
)
package com.grupopan.cartaoconsignado.previa.calculo.domain.port.out;