-- CASE 022 - Retry IGB (FATURA CARTA) sucesso na 2a tentativa
USE db_doc_hub;

INSERT INTO requisicao_documento (chave_requisicao, id_correlacao, topico_origem, tenant, tipo_documento, canal_envio, status, etapa_atual)
VALUES ('proposta:1022|doc:FATURA|ref:2026-01|canal:CARTA', 'corr-022', 'topico.fatura.solicitada', 'cartao-consignado',
        'FATURA', 'CARTA', 'AGUARDANDO_ASYNC', 'AGUARDAR_RETORNO_IGB');
SET @id_requisicao := LAST_INSERT_ID();

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'GERAR_DOCUMENTO_PAPERCLIP', 'SUCESSO', 1, NOW(3), NOW(3));
INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'ARMAZENAR_PDF_S3', 'SUCESSO', 1, NOW(3), NOW(3));

-- IGB tentativa 1 falha
INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim, codigo_erro, mensagem_erro)
VALUES (@id_requisicao, 'ENVIAR_IGB', 'FALHA', 1, NOW(3), NOW(3), 'IGB_503', 'Indisponivel');
SET @id_execucao := LAST_INSERT_ID();
INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 'erro', JSON_OBJECT('resultado','FALHA','codigo','IGB_503','mensagem','Falha 1a tentativa'));

-- IGB tentativa 2 sucesso
INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'ENVIAR_IGB', 'SUCESSO', 2, NOW(3), NOW(3));
SET @id_execucao := LAST_INSERT_ID();
INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 'igb', JSON_OBJECT('resultado','SUCESSO','referencias',JSON_OBJECT('id_protocolo','IGB-1022')));

INSERT INTO envio_documento (id_requisicao, provedor_envio, canal_envio, status, data_envio)
VALUES (@id_requisicao, 'IGB', 'CARTA', 'AGUARDANDO_ASYNC', NOW(3));
