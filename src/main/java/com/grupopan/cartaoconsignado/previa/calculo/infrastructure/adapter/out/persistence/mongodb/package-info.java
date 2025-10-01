/**
 * Adaptadores de persistência para banco de dados MongoDB.
 *
 * <p>Este pacote contém implementações específicas de repositórios utilizando MongoDB como
 * banco de dados NoSQL orientado a documentos.
 *
 * <p>Componentes típicos deste pacote:
 * <ul>
 *   <li>Implementações de repositórios usando Spring Data MongoDB</li>
 *   <li>Documentos MongoDB com anotações de mapeamento</li>
 *   <li>Mappers para conversão entre modelos de domínio e documentos</li>
 *   <li>Queries customizadas com MongoTemplate ou agregações</li>
 *   <li>Índices e configurações de performance</li>
 * </ul>
 *
 * <p>O uso do MongoDB é apropriado para dados flexíveis, semi-estruturados ou que
 * requerem alta performance em leitura e escalabilidade horizontal.
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Persistência MongoDB"
)
package com.grupopan.cartaoconsignado.previa.calculo.infrastructure.adapter.out.persistence.mongodb;