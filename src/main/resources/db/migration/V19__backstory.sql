-- =====================================================================
-- Trasfondo: la historia del personaje, escrita como un documento con
-- formato (negritas, colores, listas…). Es una hoja rica por personaje.
--
-- Se guarda como HTML en la propia ficha (tabla characters), no en una tabla
-- aparte: cada personaje tiene UN solo trasfondo, así que es un campo más de
-- la hoja, como la biografía en cualquier ficha de rol.
-- =====================================================================

alter table characters
    add column backstory text not null default '';

-- Cuándo se guardó por última vez, para el "Guardado a las…" de la pantalla.
alter table characters
    add column backstory_updated_at timestamptz;
