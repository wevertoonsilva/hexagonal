/**
 * Adaptadores de mensageria utilizando Apache Kafka.
 *
 * <p>Este pacote contém implementações específicas para publicação e consumo de mensagens
 * através do Apache Kafka, um sistema distribuído de streaming de eventos.
 *
 * <p>Componentes típicos deste pacote:
 * <ul>
 *   <li>Producers para publicação de eventos em tópicos Kafka</li>
 *   <li>Consumers para processamento de mensagens de tópicos</li>
 *   <li>Configurações de serialização/deserialização (JSON, Avro, etc.)</li>
 *   <li>Tratamento de erros e dead letter queues</li>
 *   <li>Garantias de entrega e processamento idempotente</li>
 *   <li>Mappers entre eventos de domínio e mensagens Kafka</li>
 * </ul>
 *
 * <p>Kafka é apropriado para cenários de alta throughput, event sourcing e
 * comunicação assíncrona entre microsserviços.
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Mensageria Kafka"
)
package com.grupopan.cartaoconsignado.previa.calculo.infrastructure.adapter.out.messaging.kafka;