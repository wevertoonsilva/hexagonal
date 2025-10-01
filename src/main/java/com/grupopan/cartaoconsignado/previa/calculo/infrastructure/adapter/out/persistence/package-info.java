/**
 * Adaptadores de persistência que implementam o armazenamento de dados.
 *
 * <p>Este pacote contém adaptadores responsáveis por persistir e recuperar dados do módulo
 * de cálculo, implementando as interfaces de repositório definidas nas portas de saída do
 * domínio.
 *
 * <p>Os adaptadores de persistência realizam:
 * <ul>
 *   <li>Implementação de repositórios de domínio</li>
 *   <li>Mapeamento entre entidades de domínio e entidades de persistência (JPA, MongoDB, etc.)</li>
 *   <li>Execução de queries e comandos de banco de dados</li>
 *   <li>Gerenciamento de transações quando necessário</li>
 *   <li>Otimizações de performance (fetch strategies, batch operations)</li>
 * </ul>
 *
 * <p>Organizados por tecnologia de banco de dados para permitir uso simultâneo de
 * diferentes estratégias de persistência (polyglot persistence).
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Adaptadores de Persistência"
)
package com.grupopan.cartaoconsignado.previa.calculo.infrastructure.adapter.out.persistence;