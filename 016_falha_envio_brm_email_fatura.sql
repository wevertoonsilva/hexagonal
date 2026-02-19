-- CASE 016 - Falha BRM (FATURA EMAIL)
USE db_doc_hub;

INSERT INTO requisicao_documento (chave_requisicao, id_correlacao, topico_origem, tenant, tipo_documento, canal_envio, status, etapa_atual, data_conclusao)
VALUES ('proposta:1016|doc:FATURA|ref:2026-01|canal:EMAIL', 'corr-016', 'topico.fatura.solicitada', 'cartao-consignado',
        'FATURA', 'EMAIL', 'FALHA', 'ENVIAR_BRM', NOW(3));

SET @id_requisicao := LAST_INSERT_ID();

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'GERAR_DOCUMENTO_PAPERCLIP', 'SUCESSO', 1, NOW(3), NOW(3));

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'ARMAZENAR_PDF_S3', 'SUCESSO', 1, NOW(3), NOW(3));

INSERT INTO envio_documento (id_requisicao, provedor_envio, canal_envio, status, data_envio)
VALUES (@id_requisicao, 'BRM', 'EMAIL', 'FALHA', NOW(3));

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim, codigo_erro, mensagem_erro)
VALUES (@id_requisicao, 'ENVIAR_BRM', 'FALHA', 1, NOW(3), NOW(3), 'BRM_400', 'Payload invalido');
SET @id_execucao := LAST_INSERT_ID();

INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 'erro', JSON_OBJECT('resultado','FALHA','codigo','BRM_400','mensagem','BRM rejeitou envio','http',JSON_OBJECT('status',400)));
