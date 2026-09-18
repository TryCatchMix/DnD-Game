-- =====================================================================
-- QUIÉN LE HA VISTO LA CARA.
--
-- `npcs.reveal_portrait` era todo o nada: o toda la mesa conoce la cara del
-- encapuchado, o no la conoce nadie. Pero en mesa no pasa así: la exploradora
-- se asoma al callejón y lo ve; el resto estaba en la taberna.
--
-- Esta tabla dice, jugador a jugador, quién ha visto el retrato aunque la
-- cara siga sellada para los demás. Las reglas (ver ElencoService):
--
--   · reveal_portrait = true  -> la ve TODA la mesa, esté o no aquí;
--   · reveal_portrait = false -> la ven solo los usuarios de esta tabla.
--
-- Va por USUARIO y no por personaje: lo que se oculta son unos bytes que baja
-- una cuenta, y es la cuenta la que abre la pantalla.
-- =====================================================================

create table npc_portrait_viewers (
    npc_id  uuid not null references npcs(id) on delete cascade,
    user_id uuid not null references users(id) on delete cascade,
    primary key (npc_id, user_id)
);

create index idx_npc_portrait_viewers_user on npc_portrait_viewers(user_id);
