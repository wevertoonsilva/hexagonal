-- CASE 018 - Falha IGB (FATURA CARTA)
USE db_doc_hub;

INSERT INTO requisicao_documento (chave_requisicao, id_correlacao, topico_origem, tenant, tipo_documento, canal_envio, status, etapa_atual, data_conclusao)
VALUES ('proposta:1018|doc:FATURA|ref:2026-01|canal:CARTA', 'corr-018', 'topico.fatura.solicitada', 'cartao-consignado',
        'FATURA', 'CARTA', 'FALHA', 'ENVIAR_IGB', NOW(3));

SET @id_requisicao := LAST_INSERT_ID();

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'GERAR_DOCUMENTO_PAPERCLIP', 'SUCESSO', 1, NOW(3), NOW(3));

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'ARMAZENAR_PDF_S3', 'SUCESSO', 1, NOW(3), NOW(3));

INSERT INTO envio_documento (id_requisicao, provedor_envio, canal_envio, status, data_envio)
VALUES (@id_requisicao, 'IGB', 'CARTA', 'FALHA', NOW(3));

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim, codigo_erro, mensagem_erro)
VALUES (@id_requisicao, 'ENVIAR_IGB', 'FALHA', 1, NOW(3), NOW(3), 'IGB_401', 'Nao autorizado IGB');
SET @id_execucao := LAST_INSERT_ID();

INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 'erro', JSON_OBJECT('resultado','FALHA','codigo','IGB_401','mensagem','Falha ao enviar para IGB','http',JSON_OBJECT('status',401)));
