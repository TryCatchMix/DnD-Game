-- =====================================================================
-- Qué lleva PUESTO el personaje, no solo qué lleva encima.
--
-- Hasta ahora la bolsa solo sabía cantidades y pesos, así que la CA, el
-- penalizador de armadura y el fallo de conjuros había que escribirlos a mano
-- en la ficha. Con esta marca, y con las estadísticas que V22 metió en `items`,
-- la hoja puede calcular todo eso sola.
--
-- Es una marca por LÍNEA de inventario: si llevas dos espadas largas, la línea
-- entera cuenta como equipada (basta para lo que se calcula).
-- =====================================================================
alter table inventory add column if not exists equipped boolean not null default false;

create index if not exists idx_inventory_equipped on inventory(character_id, equipped);
