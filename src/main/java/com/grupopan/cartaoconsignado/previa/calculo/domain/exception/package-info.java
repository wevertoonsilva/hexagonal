/**
 * Exceções de domínio que representam violações de regras de negócio.
 *
 * <p>Este pacote contém exceções específicas do domínio de cálculo, expressas na linguagem
 * ubíqua do negócio. Representam situações excepcionais relacionadas às regras e invariantes
 * do domínio, não erros técnicos de infraestrutura.
 *
 * <p>As exceções de domínio devem ser verificadas e tratadas de forma apropriada pelos
 * adaptadores de entrada, permitindo que o domínio comunique claramente violações de
 * regras de negócio.
 *
 * <p><strong>Características das exceções de domínio:</strong>
 * <ul>
 *   <li>Nomes expressivos refletindo conceitos do negócio</li>
 *   <li>Mensagens claras para usuários e desenvolvedores</li>
 *   <li>Independentes de frameworks e tecnologias</li>
 *   <li>Representam violações de invariantes e regras de negócio</li>
 * </ul>
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Exceções de Domínio"
)
package com.grupopan.cartaoconsignado.previa.calculo.domain.exception;