-- CASE 028 - Evento IGB apontando para id_envio_documento inexistente (deve falhar por FK)
USE db_doc_hub;

INSERT INTO evento_envio_documento (id_envio_documento, tipo_evento, id_evento_externo, data_evento)
VALUES (99999999, 'IGB_ENTREGUE', 'evt-invalido-1', NOW(3));
