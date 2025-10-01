/**
 * Camada de infraestrutura contendo adaptadores para tecnologias externas.
 *
 * <p>Esta camada representa o hexágono externo da arquitetura hexagonal, implementando
 * as portas de saída definidas pelo domínio e fornecendo adaptadores de entrada que
 * conectam o mundo exterior ao núcleo de negócio.
 *
 * <p>Aqui residem todos os detalhes técnicos e dependências de frameworks, bibliotecas
 * e tecnologias específicas como bancos de dados, sistemas de mensageria, APIs REST,
 * cache e serviços de notificação.
 *
 * <p><strong>Princípios da camada de infraestrutura:</strong>
 * <ul>
 *   <li>Implementa portas definidas pelo domínio</li>
 *   <li>Isolamento de detalhes técnicos</li>
 *   <li>Facilita substituição de tecnologias</li>
 *   <li>Contém configurações específicas de frameworks</li>
 * </ul>
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Infraestrutura"
)
package com.grupopan.cartaoconsignado.previa.calculo.infrastructure;