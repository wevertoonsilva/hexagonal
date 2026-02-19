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
    CASE WHEN r.canal_envio = 'CARTA' THEN 'FISICO' ELSE 'DIGITAL' END,
    r.canal_envio
ORDER BY tipo_entrega, total DESC;


SELECT
    r.canal_envio,
    COUNT(*) AS total
FROM requisicao_documento r
WHERE r.data_criacao >= (NOW(3) - INTERVAL @dias DAY)
GROUP BY r.canal_envio
ORDER BY total DESC;

