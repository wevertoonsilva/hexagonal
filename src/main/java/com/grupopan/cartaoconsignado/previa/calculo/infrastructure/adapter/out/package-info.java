/**
 * Adaptadores de saída (secundários) que implementam integrações com sistemas externos.
 *
 * <p>Este pacote contém os adaptadores que funcionam como driven adapters na arquitetura
 * hexagonal, implementando as portas de saída definidas pelo domínio para interagir com
 * recursos externos como bancos de dados, sistemas de mensageria, cache e serviços externos.
 *
 * <p>Os adaptadores de saída realizam:
 * <ul>
 *   <li>Implementação de repositórios e interfaces de persistência</li>
 *   <li>Mapeamento entre modelos de domínio e modelos de persistência</li>
 *   <li>Integração com sistemas de mensageria</li>
 *   <li>Gerenciamento de cache e armazenamento temporário</li>
 *   <li>Comunicação com APIs e serviços externos</li>
 *   <li>Envio de notificações e mensagens</li>
 * </ul>
 *
 * <p>Organizados por tecnologia para facilitar manutenção e substituição.
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Adaptadores de Saída"
)
package com.grupopan.cartaoconsignado.previa.calculo.infrastructure.adapter.out;