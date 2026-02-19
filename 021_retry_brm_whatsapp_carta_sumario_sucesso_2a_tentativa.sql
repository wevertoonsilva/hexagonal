-- CASE 021 - Retry BRM (CARTA_SUMARIO WHATSAPP) sucesso na 2a tentativa
USE db_doc_hub;

INSERT INTO requisicao_documento (chave_requisicao, id_correlacao, topico_origem, tenant, tipo_documento, canal_envio, status, etapa_atual)
VALUES ('proposta:2021|doc:CARTA_SUMARIO|ref:2026-01|canal:WHATSAPP', 'corr-021', 'topico.carta.sumario.solicitada', 'cartao-consignado',
        'CARTA_SUMARIO', 'WHATSAPP', 'PROCESSANDO', 'ENVIAR_BRM');
SET @id_requisicao := LAST_INSERT_ID();

-- Pré etapas ok
INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'GERAR_DOCUMENTO_PAPERCLIP', 'SUCESSO', 1, NOW(3), NOW(3));
INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'APLICAR_RODAPE_PDF', 'SUCESSO', 1, NOW(3), NOW(3));
INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'ARMAZENAR_PDF_S3', 'SUCESSO', 1, NOW(3), NOW(3));
INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'ARMAZENAR_PDF_GED', 'SUCESSO', 1, NOW(3), NOW(3));

-- tentativa 1 falha
INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim, codigo_erro, mensagem_erro)
VALUES (@id_requisicao, 'ENVIAR_BRM', 'FALHA', 1, NOW(3), NOW(3), 'BRM_500', 'Erro interno');
SET @id_execucao := LAST_INSERT_ID();
INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 'erro', JSON_OBJECT('resultado','FALHA','codigo','BRM_500','mensagem','Falha 1a tentativa','http',JSON_OBJECT('status',500)));

-- tentativa 2 sucesso
INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'ENVIAR_BRM', 'SUCESSO', 2, NOW(3), NOW(3));
SET @id_execucao := LAST_INSERT_ID();
INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 'brm', JSON_OBJECT('resultado','SUCESSO','referencias',JSON_OBJECT('id_mensagem','BRM-WPP-2021'),'http',JSON_OBJECT('status',200)));

INSERT INTO envio_documento (id_requisicao, provedor_envio, canal_envio, status, data_envio)
VALUES (@id_requisicao, 'BRM', 'WHATSAPP', 'ENVIADO', NOW(3));

UPDATE requisicao_documento SET status='CONCLUIDA', etapa_atual='ATUALIZAR_STATUS_FINAL', data_conclusao=NOW(3) WHERE id=@id_requisicao;
