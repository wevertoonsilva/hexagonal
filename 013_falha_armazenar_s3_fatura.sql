-- CASE 013 - Falha S3 (FATURA)
USE db_doc_hub;

INSERT INTO requisicao_documento (chave_requisicao, id_correlacao, topico_origem, tenant, tipo_documento, canal_envio, status, etapa_atual, data_conclusao)
VALUES ('proposta:1013|doc:FATURA|ref:2026-01|canal:EMAIL', 'corr-013', 'topico.fatura.solicitada', 'cartao-consignado',
        'FATURA', 'EMAIL', 'FALHA', 'ARMAZENAR_PDF_S3', NOW(3));

SET @id_requisicao := LAST_INSERT_ID();

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'GERAR_DOCUMENTO_PAPERCLIP', 'SUCESSO', 1, NOW(3), NOW(3));

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim, codigo_erro, mensagem_erro)
VALUES (@id_requisicao, 'ARMAZENAR_PDF_S3', 'FALHA', 1, NOW(3), NOW(3), 'S3_ACCESS_DENIED', 'AccessDenied no S3');
SET @id_execucao := LAST_INSERT_ID();

INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 'erro', JSON_OBJECT('resultado','FALHA','codigo','S3_ACCESS_DENIED','mensagem','Falha upload S3'));
