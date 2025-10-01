/**
 * Módulo responsável pelo cálculo de prestações mensais no contexto de cartão consignado.
 *
 * <p>Este módulo implementa a lógica de negócio para calcular o valor da Prestação Mensal Total (PMT)
 * e a PMT mínima, considerando diferentes cenários e regras específicas do domínio de crédito consignado.
 *
 * <p>Organizado seguindo os princípios da arquitetura hexagonal (Ports and Adapters), o módulo
 * mantém o domínio de negócio isolado das preocupações técnicas de infraestrutura, permitindo
 * alta testabilidade e manutenibilidade.
 *
 * <p><strong>Estrutura:</strong>
 * <ul>
 *   <li><strong>domain:</strong> Núcleo do negócio com regras e lógica de cálculo</li>
 *   <li><strong>application:</strong> Orquestração dos casos de uso</li>
 *   <li><strong>infrastructure:</strong> Adaptadores para tecnologias externas</li>
 * </ul>
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Cálculo de Prestações"
)
package com.grupopan.cartaoconsignado.previa.calculo;