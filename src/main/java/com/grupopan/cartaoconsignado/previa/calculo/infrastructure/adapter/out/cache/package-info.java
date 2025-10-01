/**
 * Adaptadores de cache para otimização de performance.
 *
 * <p>Este pacote contém adaptadores responsáveis por implementar estratégias de caching,
 * reduzindo latência e carga em sistemas de persistência através do armazenamento temporário
 * de dados frequentemente acessados.
 *
 * <p>Os adaptadores de cache realizam:
 * <ul>
 *   <li>Implementação de repositórios com estratégias de cache</li>
 *   <li>Armazenamento e recuperação de dados em cache</li>
 *   <li>Gestão de políticas de expiração e invalidação</li>
 *   <li>Cache de resultados de cálculos custosos</li>
 *   <li>Sincronização entre cache e fontes de dados primárias</li>
 * </ul>
 *
 * <p>Organizados por tecnologia de cache utilizada.
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Adaptadores de Cache"
)
package com.grupopan.cartaoconsignado.previa.calculo.infrastructure.adapter.out.cache;