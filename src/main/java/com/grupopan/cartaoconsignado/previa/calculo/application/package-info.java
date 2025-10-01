/**
 * Camada de aplicação responsável pela orquestração dos casos de uso.
 *
 * <p>Esta camada atua como coordenadora entre os adaptadores de entrada e o domínio,
 * implementando as portas de entrada definidas pelo domínio. Não contém lógica de negócio,
 * apenas coordena a execução de operações.
 *
 * <p>A camada de aplicação é responsável por:
 * <ul>
 *   <li>Orquestrar chamadas a serviços de domínio e repositórios</li>
 *   <li>Gerenciar transações e aspectos transversais</li>
 *   <li>Coordenar eventos de domínio</li>
 *   <li>Implementar casos de uso de ponta a ponta</li>
 * </ul>
 *
 * <p>Diferentemente do domínio, esta camada pode depender de abstrações do Spring Framework
 * para gerenciamento de transações e eventos.
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Aplicação"
)
package com.grupopan.cartaoconsignado.previa.calculo.application;