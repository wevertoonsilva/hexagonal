/**
 * Adaptadores de cache utilizando Redis.
 *
 * <p>Este pacote contém implementações específicas de cache utilizando Redis, um armazenamento
 * de estrutura de dados em memória de alta performance.
 *
 * <p>Componentes típicos deste pacote:
 * <ul>
 *   <li>Implementações de cache com RedisTemplate ou Spring Cache</li>
 *   <li>Configurações de serialização (JSON, etc.)</li>
 *   <li>Definição de TTLs e políticas de expiração</li>
 *   <li>Estratégias de invalidação de cache</li>
 *   <li>Uso de estruturas avançadas do Redis (hashes, sets, sorted sets)</li>
 *   <li>Cache distribuído para ambientes clustered</li>
 * </ul>
 *
 * <p>Redis é apropriado para cache de sessão, resultados de cálculos, e dados de
 * acesso frequente que requerem baixa latência.
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Cache Redis"
)
package com.grupopan.cartaoconsignado.previa.calculo.infrastructure.adapter.out.cache.redis;