-- CASE 011 - Falha PaperClip (CARTA_SUMARIO)
USE db_doc_hub;

INSERT INTO requisicao_documento (chave_requisicao, id_correlacao, topico_origem, tenant, tipo_documento, canal_envio, status, etapa_atual, data_conclusao)
VALUES ('proposta:2011|doc:CARTA_SUMARIO|ref:2026-01|canal:WHATSAPP', 'corr-011', 'topico.carta.sumario.solicitada', 'cartao-consignado',
        'CARTA_SUMARIO', 'WHATSAPP', 'FALHA', 'GERAR_DOCUMENTO_PAPERCLIP', NOW(3));

SET @id_requisicao := LAST_INSERT_ID();

INSERT INTO execucao_etapa_documento (id_requisicao, nome_etapa, status, tentativa, data_inicio, data_fim, codigo_erro, mensagem_erro)
VALUES (@id_requisicao, 'GERAR_DOCUMENTO_PAPERCLIP', 'FALHA', 1, NOW(3), NOW(3), 'PAPERCLIP_TIMEOUT', 'Timeout PaperClip');
SET @id_execucao := LAST_INSERT_ID();

INSERT INTO saida_etapa_documento (id_execucao_etapa, chave_saida, dados)
VALUES (@id_execucao, 'erro', JSON_OBJECT('resultado','FALHA','codigo','PAPERCLIP_TIMEOUT','mensagem','Timeout ao gerar documento'));
