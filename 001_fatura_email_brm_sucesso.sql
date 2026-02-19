-- CASE 001 - FATURA via EMAIL (BRM) - SUCESSO (sincrono)
USE db_doc_hub;

INSERT INTO requisicao_documento (
    chave_requisicao, id_correlacao, topico_origem, tenant,
    tipo_documento, canal_envio, status, etapa_atual, data_conclusao
) VALUES (
             'proposta:1001|doc:FATURA|ref:2026-01|canal:EMAIL',
             'corr-001', 'topico.fatura.solicitada', 'cartao-consignado',
             'FATURA', 'EMAIL', 'CONCLUIDA', 'ATUALIZAR_STATUS_FINAL', NOW(3)
         );

SET @id_requisicao := LAST_INSERT_ID();

-- GERAR_DOCUMENTO_PAPERCLIP
INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim, duracao_ms)
VALUES (@id_requisicao, 'GERAR_DOCUMENTO_PAPERCLIP', 'SUCESSO', 1, NOW(3), NOW(3), 320);
SET @id_execucao := LAST_INSERT_ID();

INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 'paperclip', JSON_OBJECT('resultado','SUCESSO','referencias',JSON_OBJECT('id_documento','PC-1001')));

-- ARMAZENAR_PDF_S3
INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim, duracao_ms)
VALUES (@id_requisicao, 'ARMAZENAR_PDF_S3', 'SUCESSO', 1, NOW(3), NOW(3), 180);
SET @id_execucao := LAST_INSERT_ID();

INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 's3', JSON_OBJECT('resultado','SUCESSO','referencias',JSON_OBJECT('bucket','consignado-doc-hub','key','fatura/2026/01/1001.pdf')));

-- ENVIAR_BRM (EMAIL)
INSERT INTO envio_documento (id_requisicao, provedor_envio, canal_envio, status, data_envio)
VALUES (@id_requisicao, 'BRM', 'EMAIL', 'ENVIADO', NOW(3));
SET @id_envio := LAST_INSERT_ID();

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim, duracao_ms)
VALUES (@id_requisicao, 'ENVIAR_BRM', 'SUCESSO', 1, NOW(3), NOW(3), 210);
SET @id_execucao := LAST_INSERT_ID();

INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 'brm', JSON_OBJECT('resultado','SUCESSO','referencias',JSON_OBJECT('id_mensagem','BRM-EMAIL-1001'),'http',JSON_OBJECT('status',200)));

-- OUTBOX (simulando publicação)
INSERT INTO outbox_requisicao_documento (id_requisicao, tipo_evento, status, tentativas, data_publicacao)
VALUES (@id_requisicao, 'DOCUMENTO_PROCESSADO_FINALIZADO', 'PUBLICADO', 0, NOW(3));
