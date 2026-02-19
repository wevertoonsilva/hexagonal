-- CASE 008 - FATURA via IGB sem retorno (pendente)
USE db_doc_hub;

INSERT INTO requisicao_documento (chave_requisicao, id_correlacao, topico_origem, tenant, tipo_documento, canal_envio, status, etapa_atual)
VALUES ('proposta:1008|doc:FATURA|ref:2026-01|canal:CARTA', 'corr-008', 'topico.fatura.solicitada', 'cartao-consignado',
        'FATURA', 'CARTA', 'AGUARDANDO_ASYNC', 'AGUARDAR_RETORNO_IGB');

SET @id_requisicao := LAST_INSERT_ID();

INSERT INTO envio_documento (id_requisicao, provedor_envio, canal_envio, status, data_envio)
VALUES (@id_requisicao, 'IGB', 'CARTA', 'AGUARDANDO_ASYNC', NOW(3) - INTERVAL 48 HOUR);
