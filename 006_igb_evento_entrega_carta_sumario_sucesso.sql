-- CASE 006 - Evento IGB ENTREGUE para CARTA_SUMARIO (fecha o case 004)
USE db_doc_hub;

SET @chave := 'proposta:2002|doc:CARTA_SUMARIO|ref:2026-01|canal:CARTA';

INSERT INTO requisicao_documento (chave_requisicao, id_correlacao, topico_origem, tenant, tipo_documento, canal_envio, status, etapa_atual)
VALUES (@chave, 'corr-004', 'topico.carta.sumario.solicitada', 'cartao-consignado', 'CARTA_SUMARIO', 'CARTA', 'AGUARDANDO_ASYNC', 'AGUARDAR_RETORNO_IGB')
ON DUPLICATE KEY UPDATE id = id;

SET @id_requisicao := (SELECT id FROM requisicao_documento WHERE chave_requisicao = @chave);

INSERT INTO envio_documento (id_requisicao, provedor_envio, canal_envio, status, data_envio)
SELECT @id_requisicao, 'IGB', 'CARTA', 'AGUARDANDO_ASYNC', NOW(3)
WHERE NOT EXISTS (
    SELECT 1 FROM envio_documento WHERE id_requisicao=@id_requisicao AND provedor_envio='IGB'
);

SET @id_envio := (SELECT id FROM envio_documento WHERE id_requisicao=@id_requisicao AND provedor_envio='IGB' ORDER BY id DESC LIMIT 1);

INSERT INTO evento_envio_documento (id_envio_documento, tipo_evento, id_evento_externo, data_evento)
VALUES (@id_envio, 'IGB_ENTREGUE', 'evt-igb-2002-1', NOW(3));

UPDATE envio_documento SET status='ENTREGUE', data_entrega=NOW(3) WHERE id=@id_envio;
UPDATE requisicao_documento SET status='CONCLUIDA', etapa_atual='ATUALIZAR_STATUS_FINAL', data_conclusao=NOW(3) WHERE id=@id_requisicao;
