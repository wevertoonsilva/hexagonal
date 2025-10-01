/**
 * Portas (interfaces) que definem os contratos de entrada e saída do domínio.
 *
 * <p>Este pacote contém as abstrações que desacoplam o núcleo de negócio dos adaptadores externos.
 * As portas representam os pontos de integração do hexágono, permitindo que o domínio permaneça
 * agnóstico em relação aos detalhes de implementação da infraestrutura.
 *
 * <p>Organizadas em dois subpacotes:
 * <ul>
 *   <li><strong>in:</strong> Portas de entrada (driving ports) - casos de uso oferecidos pelo módulo</li>
 *   <li><strong>out:</strong> Portas de saída (driven ports) - dependências que o domínio necessita</li>
 * </ul>
 *
 * <p>Seguindo o princípio da inversão de dependências, o domínio define as interfaces
 * e a infraestrutura fornece as implementações.
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Portas do Domínio"
)
package com.grupopan.cartaoconsignado.previa.calculo.domain.port;