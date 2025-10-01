/**
 * Camada de domínio contendo o núcleo da lógica de negócio do módulo de cálculo.
 *
 * <p>Esta camada representa o hexágono interno da arquitetura hexagonal e deve ser completamente
 * independente de frameworks, bibliotecas externas e detalhes de infraestrutura. Contém as regras
 * fundamentais de negócio relacionadas ao cálculo de prestações.
 *
 * <p>O domínio é expresso através de conceitos puros do negócio, utilizando linguagem ubíqua
 * estabelecida em conjunto com os especialistas do domínio de crédito consignado.
 *
 * <p><strong>Princípios:</strong>
 * <ul>
 *   <li>Independência de tecnologia e frameworks</li>
 *   <li>Foco exclusivo em regras de negócio</li>
 *   <li>Alta coesão e baixo acoplamento</li>
 *   <li>Facilidade para testes unitários</li>
 * </ul>
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Domínio de Cálculo"
)
package com.grupopan.cartaoconsignado.previa.calculo.domain;