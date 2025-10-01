/**
 * Adaptadores de persistência para banco de dados MySQL.
 *
 * <p>Este pacote contém implementações específicas de repositórios utilizando MySQL como
 * banco de dados relacional, normalmente através do Spring Data JPA.
 *
 * <p>Componentes típicos deste pacote:
 * <ul>
 *   <li>Implementações de repositórios de domínio usando JPA</li>
 *   <li>Entidades JPA anotadas para mapeamento objeto-relacional</li>
 *   <li>Mappers para conversão entre modelos de domínio e entidades JPA</li>
 *   <li>Queries customizadas com JPQL ou Criteria API</li>
 *   <li>Especificações para queries dinâmicas</li>
 * </ul>
 *
 * <p>O uso do MySQL é apropriado para dados transacionais que exigem consistência
 * ACID e relacionamentos complexos.
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Persistência MySQL"
)
package com.grupopan.cartaoconsignado.previa.calculo.infrastructure.adapter.out.persistence.mysql;