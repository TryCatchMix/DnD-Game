-- =====================================================================
-- EL ELENCO SOBREVIVE A SU CAMPAÑA.
--
-- Hasta aquí `npcs.campaign_id` era NOT NULL con ON DELETE CASCADE: cerrar
-- una mesa se llevaba por delante todo su elenco. Y el elenco es lo que más
-- cuesta escribir de una campaña —la ficha entera de cada cara, sus tratos,
-- el retrato— y lo que más se reutiliza: el tabernero que sabía demasiado
-- vale igual en la partida siguiente.
--
-- Así que los PNJs pasan a comportarse COMO LOS PERSONAJES (V28): al borrar
-- la campaña no se borran, se quedan SIN MESA. Siguen siendo de quien los
-- escribió (`user_id`) y desde cualquier campaña que dirija los puede traer
-- a su elenco.
--
-- campaign_id null deja de ser un error y pasa a significar «suelto, todavía
-- sin mesa» —el mismo sentido que ya tiene en `characters`—.
-- =====================================================================

-- El nombre de la restricción lo puso Postgres al crear la tabla en V31
-- (npcs_campaign_id_fkey), pero no me fío de un nombre que no escribí yo: se
-- busca la que cuelga de esa columna y se tira, se llame como se llame.
do $$
declare
    nombre text;
begin
    select con.conname into nombre
    from pg_constraint con
    join pg_class rel on rel.oid = con.conrelid
    where rel.relname = 'npcs'
      and con.contype = 'f'
      and con.conkey = array[(select att.attnum
                              from pg_attribute att
                              where att.attrelid = rel.oid
                                and att.attname = 'campaign_id')];
    if nombre is not null then
        execute format('alter table npcs drop constraint %I', nombre);
    end if;
end $$;

alter table npcs alter column campaign_id drop not null;

alter table npcs add constraint npcs_campaign_id_fkey
    foreign key (campaign_id) references campaigns(id) on delete set null;

-- De qué mesa viene, para que el cajón de sueltos no sea un montón anónimo.
-- Se guarda el NOMBRE, no el id: la campaña ya no existe: si guardara su id no
-- habría nada a lo que apuntar. Vacío en los que nunca perdieron mesa.
alter table npcs add column former_campaign_name text not null default '';

-- El elenco suelto de cada máster. Parcial porque solo se consulta para
-- listar lo que no tiene mesa, y esa lista es corta al lado de la tabla.
create index idx_npcs_sueltos on npcs(user_id, name) where campaign_id is null;

-- ---------------------------------------------------------------------
-- Y EL RETRATO SE VA CON ÉL.
--
-- El retrato no vive en `npcs`: es material de La Mesa (`mesa_archivos`), y
-- eso sí cae por cascada con la campaña. Un elenco que sobrevive sin caras
-- sobrevive a medias, así que al borrar la campaña el servicio desengancha de
-- ella los archivos que son retrato (`campaign_id` a null) en vez de dejar
-- que la cascada se los lleve, y no borra sus ficheros del disco. Cuando el
-- PNJ entra en una mesa nueva, su retrato entra con él en esa biblioteca.
--
-- La columna ya admitía null desde V28 (se añadió NULL-able); esto solo lo
-- deja dicho, y da un índice para encontrar lo desenganchado si algún día hay
-- que repasarlo a mano.
-- ---------------------------------------------------------------------
create index idx_mesa_archivos_sueltos on mesa_archivos(user_id)
    where campaign_id is null;
