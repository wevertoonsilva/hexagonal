/**
 * Portas de entrada (driving ports) que definem os casos de uso oferecidos pelo módulo.
 *
 * <p>Este pacote contém interfaces que representam as funcionalidades que o módulo de cálculo
 * expõe para o mundo externo. São os pontos de entrada para a lógica de negócio, definindo
 * as operações que podem ser executadas no contexto de cálculo de prestações.
 *
 * <p>As portas de entrada devem ser expressas em termos do negócio, refletindo intenções
 * e casos de uso reais. São implementadas pela camada de aplicação e invocadas pelos
 * adaptadores de entrada (como controladores REST).
 *
 * <p><strong>Exemplos de portas de entrada:</strong>
 * <ul>
 *   <li>Comandos que executam operações de cálculo</li>
 *   <li>Consultas que retornam resultados de cálculos</li>
 *   <li>Operações de validação de parâmetros de cálculo</li>
 * </ul>
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Portas de Entrada"
)
package com.grupopan.cartaoconsignado.previa.calculo.domain.port.in;