/**
 * Adaptadores de notificação por email.
 *
 * <p>Este pacote contém implementações específicas para envio de notificações por email,
 * utilizando serviços de email como SendGrid, AWS SES ou SMTP.
 *
 * <p>Componentes típicos deste pacote:
 * <ul>
 *   <li>Implementações de envio de email com SDKs específicos (SendGrid, etc.)</li>
 *   <li>Gerenciamento de templates de email (HTML, texto plano)</li>
 *   <li>Personalização de conteúdo com dados dinâmicos</li>
 *   <li>Tratamento de anexos e imagens inline</li>
 *   <li>Configuração de remetentes, destinatários e metadados</li>
 *   <li>Tratamento de erros e retry strategies</li>
 *   <li>Rastreamento de entregas e eventos (opens, clicks)</li>
 * </ul>
 *
 * <p>Email é apropriado para notificações formais, relatórios detalhados e
 * comunicações que requerem registro permanente.
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Notificação Email"
)
package com.grupopan.cartaoconsignado.previa.calculo.infrastructure.adapter.out.notification.email;