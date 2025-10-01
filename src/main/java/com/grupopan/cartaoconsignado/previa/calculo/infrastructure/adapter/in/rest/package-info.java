/**
 * Adaptadores REST que expõem endpoints HTTP para o módulo de cálculo.
 *
 * <p>Este pacote contém controladores REST que recebem requisições HTTP e as traduzem
 * para invocações de casos de uso. Implementam a camada de apresentação da API,
 * seguindo convenções RESTful e boas práticas de design de APIs.
 *
 * <p>Os controladores REST são responsáveis por:
 * <ul>
 *   <li>Definir endpoints e mapeamentos HTTP</li>
 *   <li>Validar payloads de entrada com Bean Validation</li>
 *   <li>Mapear DTOs de entrada para comandos de domínio</li>
 *   <li>Invocar casos de uso apropriados</li>
 *   <li>Mapear resultados de domínio para DTOs de resposta</li>
 *   <li>Definir códigos de status HTTP apropriados</li>
 *   <li>Tratar exceções e retornar mensagens de erro adequadas</li>
 *   <li>Documentar APIs com OpenAPI/Swagger</li>
 * </ul>
 */
@org.springframework.modulith.ApplicationModule(
        displayName = "Adaptadores REST"
)
package com.grupopan.cartaoconsignado.previa.calculo.infrastructure.adapter.in.rest;