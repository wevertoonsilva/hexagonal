-- CASE 003 - CARTA_SUMARIO via WHATSAPP (BRM) - SUCESSO
-- Com rodape + GED
USE db_doc_hub;

INSERT INTO requisicao_documento (
    chave_requisicao, id_correlacao, topico_origem, tenant,
    tipo_documento, canal_envio, status, etapa_atual, data_conclusao
) VALUES (
             'proposta:2001|doc:CARTA_SUMARIO|ref:2026-01|canal:WHATSAPP',
             'corr-003', 'topico.carta.sumario.solicitada', 'cartao-consignado',
             'CARTA_SUMARIO', 'WHATSAPP', 'CONCLUIDA', 'ATUALIZAR_STATUS_FINAL', NOW(3)
         );

SET @id_requisicao := LAST_INSERT_ID();

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'GERAR_DOCUMENTO_PAPERCLIP', 'SUCESSO', 1, NOW(3), NOW(3));
SET @id_execucao := LAST_INSERT_ID();
INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 'paperclip', JSON_OBJECT('resultado','SUCESSO','referencias',JSON_OBJECT('id_documento','PC-2001')));

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'APLICAR_RODAPE_PDF', 'SUCESSO', 1, NOW(3), NOW(3));
SET @id_execucao := LAST_INSERT_ID();
INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 'pdf', JSON_OBJECT('resultado','SUCESSO','retorno',JSON_OBJECT('rodape_aplicado',true)));

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'ARMAZENAR_PDF_S3', 'SUCESSO', 1, NOW(3), NOW(3));
SET @id_execucao := LAST_INSERT_ID();
INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 's3', JSON_OBJECT('resultado','SUCESSO','referencias',JSON_OBJECT('bucket','consignado-doc-hub','key','carta-sumario/2026/01/2001.pdf')));

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'ARMAZENAR_PDF_GED', 'SUCESSO', 1, NOW(3), NOW(3));
SET @id_execucao := LAST_INSERT_ID();
INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 'ged', JSON_OBJECT('resultado','SUCESSO','referencias',JSON_OBJECT('id_documento','GED-2001')));

-- BRM WHATSAPP
INSERT INTO envio_documento (id_requisicao, provedor_envio, canal_envio, status, data_envio)
VALUES (@id_requisicao, 'BRM', 'WHATSAPP', 'ENVIADO', NOW(3));

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'ENVIAR_BRM', 'SUCESSO', 1, NOW(3), NOW(3));
SET @id_execucao := LAST_INSERT_ID();
INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 'brm', JSON_OBJECT('resultado','SUCESSO','referencias',JSON_OBJECT('id_mensagem','BRM-WPP-2001'),'http',JSON_OBJECT('status',200)));

INSERT INTO outbox_requisicao_documento (id_requisicao, tipo_evento, status, tentativas, data_publicacao)
VALUES (@id_requisicao, 'DOCUMENTO_PROCESSADO_FINALIZADO', 'PUBLICADO', 0, NOW(3));
