/**
 * Modelos de domínio que representam os conceitos fundamentais do negócio de cálculo de prestações.
 *
 * <p>Este pacote contém as entidades, agregados e objetos de valor (value objects) que expressam
 * os conceitos centrais do domínio. Os modelos aqui definidos encapsulam tanto dados quanto
 * comportamentos relacionados ao cálculo de PMT.
 *
 * <p>Devem residir aqui representações de conceitos como: valores monetários, taxas de juros,
 * parâmetros de cálculo, resultados de cálculo e suas respectivas invariantes de negócio.
 *
 * <p><strong>Características dos modelos:</strong>
 * <ul>
 *   <li>Expressos na linguagem ubíqua do domínio</li>
 *   <li>Imutáveis quando possível (value objects)</li>
 *   <li>Contêm validações e invariantes de negócio</li>
 *   <li>Livres de anotações de frameworks de persistência</li>
 * </ul>
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Modelos de Domínio"
)
package com.grupopan.cartaoconsignado.previa.calculo.domain.model;