-- CASE 020 - Retry S3 (CARTA_SUMARIO) sucesso na 2a tentativa
USE db_doc_hub;

INSERT INTO requisicao_documento (chave_requisicao, id_correlacao, topico_origem, tenant, tipo_documento, canal_envio, status, etapa_atual)
VALUES ('proposta:2020|doc:CARTA_SUMARIO|ref:2026-01|canal:WHATSAPP', 'corr-020', 'topico.carta.sumario.solicitada', 'cartao-consignado',
        'CARTA_SUMARIO', 'WHATSAPP', 'PROCESSANDO', 'ARMAZENAR_PDF_S3');
SET @id_requisicao := LAST_INSERT_ID();

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'GERAR_DOCUMENTO_PAPERCLIP', 'SUCESSO', 1, NOW(3), NOW(3));
INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'APLICAR_RODAPE_PDF', 'SUCESSO', 1, NOW(3), NOW(3));

-- 1a tentativa falha
INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim, codigo_erro, mensagem_erro)
VALUES (@id_requisicao, 'ARMAZENAR_PDF_S3', 'FALHA', 1, NOW(3), NOW(3), 'S3_TIMEOUT', 'Timeout no upload');
SET @id_execucao := LAST_INSERT_ID();
INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 'erro', JSON_OBJECT('resultado','FALHA','codigo','S3_TIMEOUT','mensagem','Falha 1a tentativa'));

-- 2a tentativa sucesso
INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'ARMAZENAR_PDF_S3', 'SUCESSO', 2, NOW(3), NOW(3));
SET @id_execucao := LAST_INSERT_ID();
INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 's3', JSON_OBJECT('resultado','SUCESSO','referencias',JSON_OBJECT('bucket','consignado-doc-hub','key','carta-sumario/2026/01/2020.pdf')));

-- segue fluxo e conclui
UPDATE requisicao_documento SET status='CONCLUIDA', etapa_atual='ATUALIZAR_STATUS_FINAL', data_conclusao=NOW(3) WHERE id=@id_requisicao;
