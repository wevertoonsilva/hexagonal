-- CASE 025 - Lote de FATURAS (EMAIL/BRM e CARTA/IGB)
USE db_doc_hub;

INSERT INTO requisicao_documento (chave_requisicao, id_correlacao, topico_origem, tenant, tipo_documento, canal_envio, status, data_criacao, data_conclusao)
VALUES
    ('proposta:3001|doc:FATURA|ref:2026-01|canal:EMAIL','corr-025-01','topico.fatura.solicitada','cartao-consignado','FATURA','EMAIL','CONCLUIDA',NOW(3)-INTERVAL 10 DAY,NOW(3)-INTERVAL 10 DAY),
    ('proposta:3002|doc:FATURA|ref:2026-01|canal:EMAIL','corr-025-02','topico.fatura.solicitada','cartao-consignado','FATURA','EMAIL','CONCLUIDA',NOW(3)-INTERVAL 9 DAY,NOW(3)-INTERVAL 9 DAY),
    ('proposta:3003|doc:FATURA|ref:2026-01|canal:CARTA','corr-025-03','topico.fatura.solicitada','cartao-consignado','FATURA','CARTA','AGUARDANDO_ASYNC',NOW(3)-INTERVAL 8 DAY,NULL),
    ('proposta:3004|doc:FATURA|ref:2026-02|canal:EMAIL','corr-025-04','topico.fatura.solicitada','cartao-consignado','FATURA','EMAIL','CONCLUIDA',NOW(3)-INTERVAL 7 DAY,NOW(3)-INTERVAL 7 DAY),
    ('proposta:3005|doc:FATURA|ref:2026-02|canal:CARTA','corr-025-05','topico.fatura.solicitada','cartao-consignado','FATURA','CARTA','AGUARDANDO_ASYNC',NOW(3)-INTERVAL 6 DAY,NULL);
