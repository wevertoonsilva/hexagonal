-- CASE 015 - Falha GED (CARTA_SUMARIO)
USE db_doc_hub;

INSERT INTO requisicao_documento (chave_requisicao, id_correlacao, topico_origem, tenant, tipo_documento, canal_envio, status, etapa_atual, data_conclusao)
VALUES ('proposta:2015|doc:CARTA_SUMARIO|ref:2026-01|canal:WHATSAPP', 'corr-015', 'topico.carta.sumario.solicitada', 'cartao-consignado',
        'CARTA_SUMARIO', 'WHATSAPP', 'FALHA', 'ARMAZENAR_PDF_GED', NOW(3));

SET @id_requisicao := LAST_INSERT_ID();

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'GERAR_DOCUMENTO_PAPERCLIP', 'SUCESSO', 1, NOW(3), NOW(3));

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'APLICAR_RODAPE_PDF', 'SUCESSO', 1, NOW(3), NOW(3));

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim)
VALUES (@id_requisicao, 'ARMAZENAR_PDF_S3', 'SUCESSO', 1, NOW(3), NOW(3));

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim, codigo_erro, mensagem_erro)
VALUES (@id_requisicao, 'ARMAZENAR_PDF_GED', 'FALHA', 1, NOW(3), NOW(3), 'GED_503', 'GED indisponivel');
SET @id_execucao := LAST_INSERT_ID();

INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 'erro', JSON_OBJECT('resultado','FALHA','codigo','GED_503','mensagem','Falha ao salvar no GED','http',JSON_OBJECT('status',503)));
