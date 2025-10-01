/**
 * Adaptadores de entrada (primários) que recebem requisições de clientes externos.
 *
 * <p>Este pacote contém os adaptadores que funcionam como driving adapters na arquitetura
 * hexagonal, responsáveis por receber requisições do mundo externo e direcioná-las para
 * os casos de uso apropriados.
 *
 * <p>Os adaptadores de entrada fazem a tradução entre os protocolos de comunicação
 * (REST, messaging, gRPC, etc.) e as portas de entrada do domínio, realizando:
 * <ul>
 *   <li>Deserialização de payloads de entrada</li>
 *   <li>Validação estrutural de requisições</li>
 *   <li>Mapeamento para objetos de domínio</li>
 *   <li>Invocação de casos de uso</li>
 *   <li>Serialização de respostas</li>
 *   <li>Tratamento de exceções e códigos HTTP/status apropriados</li>
 * </ul>
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Adaptadores de Entrada"
)
package com.grupopan.cartaoconsignado.previa.calculo.infrastructure.adapter.in;