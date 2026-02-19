-- CASE 007 - Evento IGB duplicado (mesmo id_evento_externo)
-- Esperado: segundo INSERT falha por UNIQUE (ou você trata via INSERT IGNORE)
USE db_doc_hub;

-- Ajuste este id para um que já exista (ex: evt-igb-2002-1 do case 006)
SET @id_evento := 'evt-igb-2002-1';

-- Este insert deve falhar por UNIQUE (teste de idempotencia)
-- Se preferir não quebrar execução, troque por INSERT IGNORE.
INSERT INTO evento_envio_documento (id_envio_documento, tipo_evento, id_evento_externo, data_evento)
VALUES (1, 'IGB_ENTREGUE', @id_evento, NOW(3));
