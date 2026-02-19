-- CASE 027 - Tentar inserir chave_requisicao duplicada (deve falhar por UNIQUE)
USE db_doc_hub;

INSERT INTO requisicao_documento (chave_requisicao, id_correlacao, topico_origem, tenant, tipo_documento, canal_envio, status)
VALUES ('proposta:9999|doc:FATURA|ref:2026-01|canal:EMAIL', 'corr-dup-1', 'topico.fatura.solicitada', 'cartao-consignado', 'FATURA', 'EMAIL', 'CONCLUIDA');

-- Segunda inserção com a mesma chave (esperado: erro de UNIQUE)
INSERT INTO requisicao_documento (chave_requisicao, id_correlacao, topico_origem, tenant, tipo_documento, canal_envio, status)
VALUES ('proposta:9999|doc:FATURA|ref:2026-01|canal:EMAIL', 'corr-dup-2', 'topico.fatura.solicitada', 'cartao-consignado', 'FATURA', 'EMAIL', 'CONCLUIDA');
