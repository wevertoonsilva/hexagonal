/**
 * Implementações concretas dos casos de uso do módulo de cálculo.
 *
 * <p>Este pacote contém as classes que implementam as portas de entrada definidas pelo domínio,
 * orquestrando a execução completa de cada caso de uso. Cada implementação coordena chamadas
 * a serviços de domínio, repositórios e outras portas de saída.
 *
 * <p>Os casos de uso são o ponto de entrada para a lógica de negócio, recebendo comandos
 * dos adaptadores de entrada, executando as operações necessárias e retornando os resultados
 * apropriados.
 *
 * <p><strong>Responsabilidades dos casos de uso:</strong>
 * <ul>
 *   <li>Validação inicial de entrada (estrutural, não de negócio)</li>
 *   <li>Coordenação de chamadas a serviços de domínio</li>
 *   <li>Gerenciamento de transações</li>
 *   <li>Publicação de eventos de domínio</li>
 *   <li>Tratamento e tradução de exceções</li>
 * </ul>
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Casos de Uso"
)
package com.grupopan.cartaoconsignado.previa.calculo.application.usecase;