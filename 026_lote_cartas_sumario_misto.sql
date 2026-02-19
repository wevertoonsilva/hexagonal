-- CASE 026 - Lote de CARTA_SUMARIO (WHATSAPP/BRM e CARTA/IGB)
USE db_doc_hub;

INSERT INTO requisicao_documento (chave_requisicao, id_correlacao, topico_origem, tenant, tipo_documento, canal_envio, status, data_criacao, data_conclusao)
VALUES
    ('proposta:4001|doc:CARTA_SUMARIO|ref:2026-01|canal:WHATSAPP','corr-026-01','topico.carta.sumario.solicitada','cartao-consignado','CARTA_SUMARIO','WHATSAPP','CONCLUIDA',NOW(3)-INTERVAL 10 DAY,NOW(3)-INTERVAL 10 DAY),
    ('proposta:4002|doc:CARTA_SUMARIO|ref:2026-01|canal:WHATSAPP','corr-026-02','topico.carta.sumario.solicitada','cartao-consignado','CARTA_SUMARIO','WHATSAPP','CONCLUIDA',NOW(3)-INTERVAL 9 DAY,NOW(3)-INTERVAL 9 DAY),
    ('proposta:4003|doc:CARTA_SUMARIO|ref:2026-01|canal:CARTA','corr-026-03','topico.carta.sumario.solicitada','cartao-consignado','CARTA_SUMARIO','CARTA','AGUARDANDO_ASYNC',NOW(3)-INTERVAL 8 DAY,NULL),
    ('proposta:4004|doc:CARTA_SUMARIO|ref:2026-02|canal:WHATSAPP','corr-026-04','topico.carta.sumario.solicitada','cartao-consignado','CARTA_SUMARIO','WHATSAPP','CONCLUIDA',NOW(3)-INTERVAL 7 DAY,NOW(3)-INTERVAL 7 DAY),
    ('proposta:4005|doc:CARTA_SUMARIO|ref:2026-02|canal:CARTA','corr-026-05','topico.carta.sumario.solicitada','cartao-consignado','CARTA_SUMARIO','CARTA','AGUARDANDO_ASYNC',NOW(3)-INTERVAL 6 DAY,NULL);
