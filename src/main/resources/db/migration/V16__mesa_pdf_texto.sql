-- =====================================================================
-- Buscar DENTRO de los PDF, no solo por el título.
--
-- Al subir un PDF, el backend le saca el texto con PDFBox y lo guarda aquí.
-- Así la biblioteca puede responder a "¿en qué PDF sale 'los seres de la
-- muerte'?" sin volver a abrir cada fichero. Las imágenes dejan la columna
-- vacía; los PDF viejos (subidos antes de esto) se rellenan con /reindexar.
-- =====================================================================

alter table mesa_archivos
    add column text_content text not null default '';
