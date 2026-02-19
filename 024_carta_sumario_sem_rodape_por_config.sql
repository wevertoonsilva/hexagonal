-- CASE 024 - CARTA_SUMARIO com rodape desabilitado por config
USE db_doc_hub;

INSERT INTO requisicao_documento (chave_requisicao, id_correlacao, topico_origem, tenant, tipo_documento, canal_envio, status, etapa_atual, data_conclusao)
VALUES ('proposta:2024|doc:CARTA_SUMARIO|ref:2026-01|canal:CARTA', 'corr-024', 'topico.carta.sumario.solicitada', 'cartao-consignado',
        'CARTA_SUMARIO', 'CARTA', 'AGUARDANDO_ASYNC', 'AGUARDAR_RETORNO_IGB', NULL);
SET @id_requisicao := LAST_INSERT_ID();

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'GERAR_DOCUMENTO_PAPERCLIP', 'SUCESSO', 1, NOW(3), NOW(3));

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'APLICAR_RODAPE_PDF', 'IGNORADA', 1, NOW(3), NOW(3));
SET @id_execucao := LAST_INSERT_ID();
INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 'regra', JSON_OBJECT('resultado','SUCESSO','retorno',JSON_OBJECT('motivo','desabilitado_por_config','regra','rodape_desabilitado')));

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'ARMAZENAR_PDF_S3', 'SUCESSO', 1, NOW(3), NOW(3));

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'ARMAZENAR_PDF_GED', 'SUCESSO', 1, NOW(3), NOW(3));

INSERT INTO envio_documento (id_requisicao, provedor_envio, canal_envio, status, data_envio)
VALUES (@id_requisicao, 'IGB', 'CARTA', 'AGUARDANDO_ASYNC', NOW(3));
