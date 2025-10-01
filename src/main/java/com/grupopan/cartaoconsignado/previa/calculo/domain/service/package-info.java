/**
 * Serviços de domínio que implementam lógica de negócio complexa.
 *
 * <p>Este pacote contém serviços que coordenam operações envolvendo múltiplas entidades
 * ou que implementam regras de negócio que não pertencem naturalmente a uma única entidade
 * ou value object.
 *
 * <p>Os serviços de domínio são stateless e focam exclusivamente em lógica de negócio,
 * diferenciando-se dos serviços de aplicação por não lidarem com orquestração de casos
 * de uso ou coordenação de infraestrutura.
 *
 * <p><strong>Quando usar serviços de domínio:</strong>
 * <ul>
 *   <li>Lógica que envolve múltiplas entidades do domínio</li>
 *   <li>Algoritmos complexos de cálculo e transformação</li>
 *   <li>Regras de negócio que não se encaixam naturalmente em entidades</li>
 *   <li>Operações que requerem conhecimento especializado do domínio</li>
 * </ul>
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Serviços de Domínio"
)
package com.grupopan.cartaoconsignado.previa.calculo.domain.service;