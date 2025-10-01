/**
 * Adaptadores que conectam o domínio com tecnologias e sistemas externos.
 *
 * <p>Este pacote contém os adaptadores concretos que implementam as portas definidas pelo
 * domínio, tanto de entrada quanto de saída, aplicando o padrão Adapter da arquitetura
 * hexagonal.
 *
 * <p>Organizado em dois subpacotes principais:
 * <ul>
 *   <li><strong>in:</strong> Adaptadores primários que recebem requisições externas</li>
 *   <li><strong>out:</strong> Adaptadores secundários que implementam portas de saída</li>
 * </ul>
 *
 * <p>Os adaptadores são responsáveis por traduzir entre o modelo do domínio e os
 * formatos específicos das tecnologias utilizadas.
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Adaptadores"
)
package com.grupopan.cartaoconsignado.previa.calculo.infrastructure.adapter;