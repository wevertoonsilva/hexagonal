-- CASE 005 - Evento IGB ENTREGUE para FATURA (fecha o case 002)
USE db_doc_hub;

SET @chave := 'proposta:1002|doc:FATURA|ref:2026-01|canal:CARTA';

-- Garante existência da requisicao (idempotente)
INSERT INTO requisicao_documento (chave_requisicao, id_correlacao, topico_origem, tenant, tipo_documento, canal_envio, status, etapa_atual)
VALUES (@chave, 'corr-002', 'topico.fatura.solicitada', 'cartao-consignado', 'FATURA', 'CARTA', 'AGUARDANDO_ASYNC', 'AGUARDAR_RETORNO_IGB')
ON DUPLICATE KEY UPDATE id = id;

SET @id_requisicao := (SELECT id FROM requisicao_documento WHERE chave_requisicao = @chave);

-- Cria um envio IGB se não existir nenhum
INSERT INTO envio_documento (id_requisicao, provedor_envio, canal_envio, status, data_envio)
SELECT @id_requisicao, 'IGB', 'CARTA', 'AGUARDANDO_ASYNC', NOW(3)
WHERE NOT EXISTS (
    SELECT 1 FROM envio_documento WHERE id_requisicao=@id_requisicao AND provedor_envio='IGB'
);

SET @id_envio := (SELECT id FROM envio_documento WHERE id_requisicao=@id_requisicao AND provedor_envio='IGB' ORDER BY id DESC LIMIT 1);

-- Evento externo
INSERT INTO evento_envio_documento (id_envio_documento, tipo_evento, id_evento_externo, data_evento)
VALUES (@id_envio, 'IGB_ENTREGUE', 'evt-igb-1002-1', NOW(3));

-- Atualiza estado
UPDATE envio_documento SET status='ENTREGUE', data_entrega=NOW(3) WHERE id=@id_envio;
UPDATE requisicao_documento SET status='CONCLUIDA', etapa_atual='ATUALIZAR_STATUS_FINAL', data_conclusao=NOW(3) WHERE id=@id_requisicao;
