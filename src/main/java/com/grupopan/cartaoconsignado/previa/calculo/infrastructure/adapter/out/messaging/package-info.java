/**
 * Adaptadores de mensageria para comunicação assíncrona.
 *
 * <p>Este pacote contém adaptadores responsáveis por publicar e consumir mensagens através
 * de sistemas de mensageria, implementando padrões de comunicação assíncrona e event-driven.
 *
 * <p>Os adaptadores de mensageria realizam:
 * <ul>
 *   <li>Publicação de eventos de domínio para outros módulos ou sistemas</li>
 *   <li>Consumo de eventos externos relevantes para o módulo</li>
 *   <li>Transformação entre eventos de domínio e mensagens de infraestrutura</li>
 *   <li>Tratamento de erros e retry logic</li>
 *   <li>Garantia de idempotência e ordenação quando necessário</li>
 * </ul>
 *
 * <p>Organizados por tecnologia de mensageria utilizada.
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Adaptadores de Mensageria"
)
package com.grupopan.cartaoconsignado.previa.calculo.infrastructure.adapter.out.messaging;