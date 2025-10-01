/**
 * Adaptadores de notificação para comunicação com usuários e sistemas externos.
 *
 * <p>Este pacote contém adaptadores responsáveis por enviar notificações através de
 * diferentes canais de comunicação, implementando portas de saída para disseminação
 * de informações relevantes.
 *
 * <p>Os adaptadores de notificação realizam:
 * <ul>
 *   <li>Envio de notificações para usuários finais</li>
 *   <li>Transformação de eventos de domínio em mensagens de notificação</li>
 *   <li>Seleção de canais apropriados (email, SMS, push, etc.)</li>
 *   <li>Formatação de conteúdo segundo templates</li>
 *   <li>Tratamento de falhas e retry logic</li>
 *   <li>Rastreamento de entregas e confirmações</li>
 * </ul>
 *
 * <p>Organizados por canal de notificação utilizado.
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Adaptadores de Notificação"
)
package com.grupopan.cartaoconsignado.previa.calculo.infrastructure.adapter.out.notification;