-- =========================================================
-- consultas_operacionais.sql
-- Schema: db_doc_hub
--
-- Objetivo:
-- Consultas operacionais completas para:
-- - Painel (status / tipo / canal / volumes)
-- - Acompanhamento (timeline por requisicao)
-- - Troubleshooting (falhas, tentativas, payloads parciais)
-- - SLA (tempo total e por etapa)
-- - Assíncrono IGB (pendências, eventos)
-- - Reconciliação (S3 / GED / BRM / IGB via JSON)
-- - Outbox (pendências e falhas)
-- - Qualidade (anomalias, consistência)
--
-- Compatibilidade:
-- - MySQL 8 (inclui ONLY_FULL_GROUP_BY)
-- - JSON: JSON_EXTRACT / JSON_UNQUOTE
--
-- Convenções:
-- - Ajuste os parametros na seção "PARAMETROS"
-- - Este arquivo contém apenas SELECTs (sem DDL/DML)
-- =========================================================

USE db_doc_hub;

-- =========================================================
-- PARAMETROS
-- =========================================================
SET @dias := 30;                      -- janela padrão
SET @limite_horas_igb := 24;          -- pendências IGB
SET @chave_requisicao := 'proposta:1001|doc:FATURA|ref:2026-01|canal:EMAIL';

-- parâmetros de recon (edite quando precisar)
SET @s3_key := 'fatura/2026/01/1001.pdf';
SET @ged_id := 'GED-2001';
SET @brm_id := 'BRM-EMAIL-1001';
SET @igb_protocolo := 'IGB-2002';

-- =========================================================
-- 0) HEALTHCHECK - Contagens rápidas por tabela (útil após rodar cases)
-- =========================================================
SELECT 'requisicao_documento' AS tabela, COUNT(*) AS total FROM requisicao_documento
UNION ALL
SELECT 'execucao_etapa_documento', COUNT(*) FROM execucao_etapa_documento
UNION ALL
SELECT 'saida_etapa_documento', COUNT(*) FROM saida_etapa_documento
UNION ALL
SELECT 'envio_documento', COUNT(*) FROM envio_documento
UNION ALL
SELECT 'evento_envio_documento', COUNT(*) FROM evento_envio_documento
UNION ALL
SELECT 'outbox_requisicao_documento', COUNT(*) FROM outbox_requisicao_documento;

-- =========================================================
-- 1) PAINEL - Requisições por status (últimos N dias)
-- =========================================================
SELECT
    r.status,
    COUNT(*) AS total
FROM requisicao_documento r
WHERE r.data_criacao >= (NOW(3) - INTERVAL @dias DAY)
GROUP BY r.status
ORDER BY total DESC;

-- =========================================================
-- 2) PAINEL - Requisições por tipo_documento x canal_envio x status
-- =========================================================
SELECT
    r.tipo_documento,
    r.canal_envio,
    r.status,
    COUNT(*) AS total
FROM requisicao_documento r
WHERE r.data_criacao >= (NOW(3) - INTERVAL @dias DAY)
GROUP BY r.tipo_documento, r.canal_envio, r.status
ORDER BY r.tipo_documento, r.canal_envio, total DESC;

-- =========================================================
-- 3) PAINEL - Volumetria diária por tipo/canal (últimos N dias)
-- =========================================================
SELECT
    DATE(r.data_criacao) AS dia,
    r.tipo_documento,
    r.canal_envio,
    COUNT(*) AS total
FROM requisicao_documento r
WHERE r.data_criacao >= (NOW(3) - INTERVAL @dias DAY)
GROUP BY DATE(r.data_criacao), r.tipo_documento, r.canal_envio
ORDER BY dia DESC, r.tipo_documento, r.canal_envio;

-- =========================================================
-- 4) PAINEL - Em aberto (PROCESSANDO / AGUARDANDO_ASYNC)
-- =========================================================
SELECT
    r.id,
    r.chave_requisicao,
    r.tenant,
    r.tipo_documento,
    r.canal_envio,
    r.status,
    r.etapa_atual,
    r.data_criacao,
    r.data_atualizacao
FROM requisicao_documento r
WHERE r.status IN ('PROCESSANDO', 'AGUARDANDO_ASYNC')
ORDER BY r.data_criacao ASC;

-- =========================================================
-- 5) TIMELINE - Execuções de etapas de uma requisição (por chave_requisicao)
-- =========================================================
SELECT
    r.chave_requisicao,
    e.id AS id_execucao_etapa,
    e.nome_etapa,
    e.status AS status_etapa,
    e.tentativa,
    e.data_inicio,
    e.data_fim,
    e.duracao_ms,
    e.codigo_erro,
    e.mensagem_erro
FROM requisicao_documento r
         JOIN execucao_etapa_documento e
              ON e.id_requisicao = r.id
WHERE r.chave_requisicao = @chave_requisicao
ORDER BY e.data_inicio ASC, e.nome_etapa ASC, e.tentativa ASC;

-- =========================================================
-- 6) TIMELINE - Saídas (JSON parcial) por etapa de uma requisição
-- =========================================================
SELECT
    r.chave_requisicao,
    e.nome_etapa,
    e.status AS status_etapa,
    e.tentativa,
    s.id AS id_saida,
    s.chave_saida,
    s.data_criacao,
    s.dados
FROM requisicao_documento r
         JOIN execucao_etapa_documento e
              ON e.id_requisicao = r.id
         LEFT JOIN saida_etapa_documento s
                   ON s.id_execucao_etapa = e.id
WHERE r.chave_requisicao = @chave_requisicao
ORDER BY e.data_inicio ASC, s.data_criacao ASC;

-- =========================================================
-- 7) SLA - Tempo total por requisição (últimos N dias)
-- Inclui P95 sem PERCENTILE_CONT (compatível MySQL 8/9)
-- Observação: usa data_conclusao quando disponível; senão data_atualizacao
-- =========================================================
WITH base AS (
    SELECT
        r.tipo_documento,
        r.canal_envio,
        r.status,
        (TIMESTAMPDIFF(MICROSECOND, r.data_criacao, COALESCE(r.data_conclusao, r.data_atualizacao)) / 1000) AS tempo_ms
    FROM requisicao_documento r
    WHERE r.data_criacao >= (NOW(3) - INTERVAL 30 DAY)
),
     ranked AS (
         SELECT
             b.*,
             ROW_NUMBER() OVER (
                 PARTITION BY b.tipo_documento, b.canal_envio, b.status
                 ORDER BY b.tempo_ms
                 ) AS rn,
             COUNT(*) OVER (
                 PARTITION BY b.tipo_documento, b.canal_envio, b.status
                 ) AS cnt
         FROM base b
     )
SELECT
    tipo_documento,
    canal_envio,
    status,
    COUNT(*) AS total,
    ROUND(AVG(tempo_ms), 2) AS media_ms,
    ROUND(MAX(tempo_ms), 2) AS max_ms,
    ROUND(
            MAX(CASE WHEN rn = CEIL(0.95 * cnt) THEN tempo_ms END),
            2
    ) AS p95_ms
FROM ranked
GROUP BY tipo_documento, canal_envio, status
ORDER BY tipo_documento, canal_envio, status;


-- =========================================================
-- 8) SLA - Tempo médio por etapa (últimos N dias)
-- =========================================================
SELECT
    e.nome_etapa,
    e.status,
    COUNT(*) AS total,
    ROUND(AVG(e.duracao_ms), 2) AS media_ms,
    MAX(e.duracao_ms) AS max_ms
FROM execucao_etapa_documento e
         JOIN requisicao_documento r
              ON r.id = e.id_requisicao
WHERE r.data_criacao >= (NOW(3) - INTERVAL @dias DAY)
  AND e.duracao_ms IS NOT NULL
GROUP BY e.nome_etapa, e.status
ORDER BY e.nome_etapa, e.status;

-- =========================================================
-- 9) FALHAS - Top falhas por etapa e codigo_erro (últimos N dias)
-- =========================================================
SELECT
    e.nome_etapa,
    e.codigo_erro,
    COUNT(*) AS total
FROM execucao_etapa_documento e
         JOIN requisicao_documento r
              ON r.id = e.id_requisicao
WHERE r.data_criacao >= (NOW(3) - INTERVAL @dias DAY)
  AND e.status = 'FALHA'
GROUP BY e.nome_etapa, e.codigo_erro
ORDER BY total DESC, e.nome_etapa ASC;

-- =========================================================
-- 10) FALHAS - Últimas falhas detalhadas (troubleshooting)
-- =========================================================
SELECT
    e.data_inicio,
    r.chave_requisicao,
    r.tipo_documento,
    r.canal_envio,
    e.nome_etapa,
    e.tentativa,
    e.codigo_erro,
    e.mensagem_erro
FROM execucao_etapa_documento e
         JOIN requisicao_documento r
              ON r.id = e.id_requisicao
WHERE e.status = 'FALHA'
ORDER BY e.data_inicio DESC
LIMIT 100;

-- =========================================================
-- 11) RETRY - Etapas com múltiplas tentativas (últimos N dias)
-- =========================================================
SELECT
    r.chave_requisicao,
    e.nome_etapa,
    MAX(e.tentativa) AS maior_tentativa,
    SUM(CASE WHEN e.status='FALHA' THEN 1 ELSE 0 END) AS qtde_falhas,
    SUM(CASE WHEN e.status='SUCESSO' THEN 1 ELSE 0 END) AS qtde_sucessos,
    MAX(e.data_fim) AS ultima_execucao
FROM execucao_etapa_documento e
         JOIN requisicao_documento r
              ON r.id = e.id_requisicao
WHERE r.data_criacao >= (NOW(3) - INTERVAL @dias DAY)
GROUP BY r.chave_requisicao, e.nome_etapa
HAVING MAX(e.tentativa) > 1
ORDER BY maior_tentativa DESC, ultima_execucao DESC;

-- =========================================================
-- 12) IGB - Pendências (AGUARDANDO_ASYNC) há mais de X horas
-- =========================================================
SELECT
    r.chave_requisicao,
    r.tipo_documento,
    r.canal_envio,
    r.status,
    ed.id AS id_envio,
    ed.status AS status_envio,
    ed.data_envio,
    TIMESTAMPDIFF(HOUR, ed.data_envio, NOW(3)) AS horas_pendente
FROM requisicao_documento r
         JOIN envio_documento ed
              ON ed.id_requisicao = r.id
WHERE r.status = 'AGUARDANDO_ASYNC'
  AND ed.provedor_envio = 'IGB'
  AND ed.data_envio IS NOT NULL
  AND ed.data_envio < (NOW(3) - INTERVAL @limite_horas_igb HOUR)
ORDER BY ed.data_envio ASC;

-- =========================================================
-- 13) IGB - Envios com eventos recebidos (últimos N dias)
-- =========================================================
SELECT
    ev.data_evento,
    r.chave_requisicao,
    r.tipo_documento,
    ed.id AS id_envio,
    ed.status AS status_envio,
    ev.tipo_evento,
    ev.id_evento_externo
FROM evento_envio_documento ev
         JOIN envio_documento ed
              ON ed.id = ev.id_envio_documento
         JOIN requisicao_documento r
              ON r.id = ed.id_requisicao
WHERE ev.data_evento >= (NOW(3) - INTERVAL @dias DAY)
ORDER BY ev.data_evento DESC;

-- =========================================================
-- 14) IGB - Eventos duplicados por id_evento_externo (deve ser zero)
-- =========================================================
SELECT
    ev.id_evento_externo,
    COUNT(*) AS total
FROM evento_envio_documento ev
GROUP BY ev.id_evento_externo
HAVING COUNT(*) > 1
ORDER BY total DESC;

-- =========================================================
-- 15) OUTBOX - Pendentes e falhas
-- =========================================================
SELECT
    o.id,
    r.chave_requisicao,
    o.tipo_evento,
    o.status,
    o.tentativas,
    o.data_criacao,
    o.data_publicacao
FROM outbox_requisicao_documento o
         JOIN requisicao_documento r
              ON r.id = o.id_requisicao
WHERE o.status IN ('PENDENTE', 'FALHA')
ORDER BY o.data_criacao ASC;

-- =========================================================
-- 16) OUTBOX - Latência de publicação (últimos N dias)
-- =========================================================
SELECT
    o.tipo_evento,
    o.status,
    COUNT(*) AS total,
    ROUND(AVG(TIMESTAMPDIFF(MICROSECOND, o.data_criacao, o.data_publicacao) / 1000), 2) AS media_ms,
    ROUND(MAX(TIMESTAMPDIFF(MICROSECOND, o.data_criacao, o.data_publicacao) / 1000), 2) AS max_ms
FROM outbox_requisicao_documento o
WHERE o.data_criacao >= (NOW(3) - INTERVAL @dias DAY)
  AND o.data_publicacao IS NOT NULL
GROUP BY o.tipo_evento, o.status
ORDER BY o.tipo_evento, o.status;

-- =========================================================
-- 17) RECON - Localizar requisição por S3 key (JSON)
-- =========================================================
SELECT
    r.chave_requisicao,
    r.tipo_documento,
    r.canal_envio,
    r.status,
    MAX(r.data_criacao) AS data_criacao,
    s.dados AS dados_s3
FROM requisicao_documento r
         JOIN execucao_etapa_documento e
              ON e.id_requisicao = r.id
         JOIN saida_etapa_documento s
              ON s.id_execucao_etapa = e.id
WHERE s.chave_saida = 's3'
  AND JSON_UNQUOTE(JSON_EXTRACT(s.dados, '$.referencias.key')) = @s3_key
GROUP BY r.chave_requisicao, r.tipo_documento, r.canal_envio, r.status, s.dados
ORDER BY data_criacao DESC;

-- =========================================================
-- 18) RECON - Localizar por GED id_documento (JSON)
-- =========================================================
SELECT
    r.chave_requisicao,
    r.tipo_documento,
    r.canal_envio,
    r.status,
    MAX(r.data_criacao) AS data_criacao,
    s.dados AS dados_ged
FROM requisicao_documento r
         JOIN execucao_etapa_documento e
              ON e.id_requisicao = r.id
         JOIN saida_etapa_documento s
              ON s.id_execucao_etapa = e.id
WHERE s.chave_saida = 'ged'
  AND JSON_UNQUOTE(JSON_EXTRACT(s.dados, '$.referencias.id_documento')) = @ged_id
GROUP BY r.chave_requisicao, r.tipo_documento, r.canal_envio, r.status, s.dados
ORDER BY data_criacao DESC;

-- =========================================================
-- 19) RECON - Localizar por BRM id_mensagem (JSON)
-- =========================================================
SELECT
    r.chave_requisicao,
    r.tipo_documento,
    r.canal_envio,
    r.status,
    MAX(r.data_criacao) AS data_criacao,
    s.dados AS dados_brm
FROM requisicao_documento r
         JOIN execucao_etapa_documento e
              ON e.id_requisicao = r.id
         JOIN saida_etapa_documento s
              ON s.id_execucao_etapa = e.id
WHERE s.chave_saida = 'brm'
  AND JSON_UNQUOTE(JSON_EXTRACT(s.dados, '$.referencias.id_mensagem')) = @brm_id
GROUP BY r.chave_requisicao, r.tipo_documento, r.canal_envio, r.status, s.dados
ORDER BY data_criacao DESC;

-- =========================================================
-- 20) RECON - Localizar por IGB id_protocolo (JSON)
-- =========================================================
SELECT
    r.chave_requisicao,
    r.tipo_documento,
    r.canal_envio,
    r.status,
    MAX(r.data_criacao) AS data_criacao,
    s.dados AS dados_igb
FROM requisicao_documento r
         JOIN execucao_etapa_documento e
              ON e.id_requisicao = r.id
         JOIN saida_etapa_documento s
              ON s.id_execucao_etapa = e.id
WHERE s.chave_saida = 'igb'
  AND JSON_UNQUOTE(JSON_EXTRACT(s.dados, '$.referencias.id_protocolo')) = @igb_protocolo
GROUP BY r.chave_requisicao, r.tipo_documento, r.canal_envio, r.status, s.dados
ORDER BY data_criacao DESC;

-- =========================================================
-- 21) QUALIDADE - Requisições CONCLUIDA sem S3 (anomalia)
-- Compatível com ONLY_FULL_GROUP_BY
-- =========================================================
SELECT
    r.chave_requisicao,
    r.tipo_documento,
    r.canal_envio,
    r.status,
    MAX(r.data_criacao) AS data_criacao
FROM requisicao_documento r
         LEFT JOIN execucao_etapa_documento e
                   ON e.id_requisicao = r.id
         LEFT JOIN saida_etapa_documento s
                   ON s.id_execucao_etapa = e.id
                       AND s.chave_saida = 's3'
WHERE r.status = 'CONCLUIDA'
GROUP BY r.chave_requisicao, r.tipo_documento, r.canal_envio, r.status
HAVING SUM(CASE WHEN s.id IS NULL THEN 0 ELSE 1 END) = 0
ORDER BY data_criacao DESC;

-- =========================================================
-- 22) QUALIDADE - BRM (EMAIL/WHATSAPP) sem saída 'brm' registrada (anomalia)
-- =========================================================
SELECT
    r.chave_requisicao,
    r.tipo_documento,
    r.canal_envio,
    ed.status AS status_envio,
    ed.data_envio
FROM envio_documento ed
         JOIN requisicao_documento r
              ON r.id = ed.id_requisicao
         LEFT JOIN execucao_etapa_documento e
                   ON e.id_requisicao = r.id
                       AND e.nome_etapa = 'ENVIAR_BRM'
         LEFT JOIN saida_etapa_documento s
                   ON s.id_execucao_etapa = e.id
                       AND s.chave_saida = 'brm'
WHERE ed.provedor_envio = 'BRM'
  AND s.id IS NULL
ORDER BY ed.data_envio DESC;

-- =========================================================
-- 23) QUALIDADE - IGB sem evento de retorno após X horas (anomalia operacional)
-- =========================================================
SELECT
    r.chave_requisicao,
    r.tipo_documento,
    ed.id AS id_envio,
    ed.data_envio,
    TIMESTAMPDIFF(HOUR, ed.data_envio, NOW(3)) AS horas_desde_envio
FROM envio_documento ed
         JOIN requisicao_documento r
              ON r.id = ed.id_requisicao
         LEFT JOIN evento_envio_documento ev
                   ON ev.id_envio_documento = ed.id
WHERE ed.provedor_envio = 'IGB'
  AND ed.data_envio < (NOW(3) - INTERVAL @limite_horas_igb HOUR)
GROUP BY r.chave_requisicao, r.tipo_documento, ed.id, ed.data_envio
HAVING COUNT(ev.id) = 0
ORDER BY ed.data_envio ASC;

-- =========================================================
-- 24) CONSISTÊNCIA - Etapa atual divergente da última etapa registrada (heurística)
-- =========================================================
SELECT
    r.chave_requisicao,
    r.status,
    r.etapa_atual,
    ultima.nome_etapa AS ultima_etapa_registrada,
    ultima.data_fim AS ultima_data_fim
FROM requisicao_documento r
         LEFT JOIN (
    SELECT
        e.id_requisicao,
        SUBSTRING_INDEX(
                GROUP_CONCAT(e.nome_etapa ORDER BY e.data_fim DESC SEPARATOR ','), ',', 1
        ) AS nome_etapa,
        MAX(e.data_fim) AS data_fim
    FROM execucao_etapa_documento e
    GROUP BY e.id_requisicao
) ultima
                   ON ultima.id_requisicao = r.id
WHERE r.data_criacao >= (NOW(3) - INTERVAL @dias DAY)
ORDER BY r.data_criacao DESC;

-- =========================================================
-- 25) EXTRA - Buscar texto dentro de mensagens de erro (últimos N dias)
-- Ex: procurar "AccessDenied", "timeout", etc.
-- =========================================================
SET @texto_erro := 'timeout';

SELECT
    e.data_inicio,
    r.chave_requisicao,
    e.nome_etapa,
    e.codigo_erro,
    e.mensagem_erro
FROM execucao_etapa_documento e
         JOIN requisicao_documento r
              ON r.id = e.id_requisicao
WHERE r.data_criacao >= (NOW(3) - INTERVAL @dias DAY)
  AND e.status = 'FALHA'
  AND (e.mensagem_erro LIKE CONCAT('%', @texto_erro, '%')
    OR e.codigo_erro LIKE CONCAT('%', @texto_erro, '%'))
ORDER BY e.data_inicio DESC;

-- =========================================================
-- 26) SUMÁRIO - Quantidade TOTAL por canal de envio
-- (CARTA / WHATSAPP / EMAIL)
-- =========================================================
SELECT
    r.canal_envio,
    COUNT(*) AS total
FROM requisicao_documento r
WHERE r.data_criacao >= (NOW(3) - INTERVAL @dias DAY)
GROUP BY r.canal_envio
ORDER BY total DESC;


-- =========================================================
-- 27) SUMÁRIO - Quantidade TOTAL por tipo_documento x canal
-- =========================================================
SELECT
    r.tipo_documento,
    r.canal_envio,
    COUNT(*) AS total
FROM requisicao_documento r
WHERE r.data_criacao >= (NOW(3) - INTERVAL @dias DAY)
GROUP BY r.tipo_documento, r.canal_envio
ORDER BY r.tipo_documento, total DESC;


-- =========================================================
-- 28) SUMÁRIO - FÍSICO vs DIGITAL (com detalhamento de canal)
--
-- Regras:
-- - CARTA  -> FISICO
-- - EMAIL / WHATSAPP -> DIGITAL
-- =========================================================
SELECT
    CASE
        WHEN r.canal_envio = 'CARTA' THEN 'FISICO'
        ELSE 'DIGITAL'
        END AS tipo_entrega,
    r.canal_envio,
    COUNT(*) AS total
FROM requisicao_documento r
WHERE r.data_criacao >= (NOW(3) - INTERVAL @dias DAY)
GROUP BY
    CASE
        WHEN r.canal_envio = 'CARTA' THEN 'FISICO'
        ELSE 'DIGITAL'
        END,
    r.canal_envio
ORDER BY tipo_entrega, total DESC;


-- =========================================================
-- 29) SUMÁRIO EXECUTIVO - TOTAL GERAL + QUEBRA POR CANAL
-- (uma linha por canal, útil para KPI rápido)
-- =========================================================
SELECT
    r.canal_envio,
    COUNT(*) AS total_requisicoes,
    SUM(CASE WHEN r.status = 'CONCLUIDA' THEN 1 ELSE 0 END) AS total_concluidas,
    SUM(CASE WHEN r.status = 'FALHA' THEN 1 ELSE 0 END) AS total_falhas,
    SUM(CASE WHEN r.status IN ('PROCESSANDO','AGUARDANDO_ASYNC') THEN 1 ELSE 0 END) AS total_em_aberto
FROM requisicao_documento r
WHERE r.data_criacao >= (NOW(3) - INTERVAL @dias DAY)
GROUP BY r.canal_envio
ORDER BY total_requisicoes DESC;


-- =========================================================
-- 30) SUMÁRIO EXECUTIVO - TOTAL POR DOCUMENTO (FATURA x CARTA_SUMARIO)
-- =========================================================
SELECT
    r.tipo_documento,
    COUNT(*) AS total_requisicoes,
    SUM(CASE WHEN r.canal_envio = 'CARTA' THEN 1 ELSE 0 END) AS total_carta_fisica,
    SUM(CASE WHEN r.canal_envio = 'EMAIL' THEN 1 ELSE 0 END) AS total_email,
    SUM(CASE WHEN r.canal_envio = 'WHATSAPP' THEN 1 ELSE 0 END) AS total_whatsapp
FROM requisicao_documento r
WHERE r.data_criacao >= (NOW(3) - INTERVAL @dias DAY)
GROUP BY r.tipo_documento
ORDER BY total_requisicoes DESC;

