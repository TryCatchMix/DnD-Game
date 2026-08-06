-- =====================================================================
-- Inventario manual: peso en el catálogo y objetos añadidos a mano.
-- =====================================================================

-- ---- peso de los objetos del catálogo (en libras) ------------------
alter table items add column weight_lb double precision not null default 0;

update items set weight_lb = 1   where code = 'antorcha';
update items set weight_lb = 1   where code = 'aceite';
update items set weight_lb = 1   where code = 'racion';
update items set weight_lb = 10  where code = 'cuerda_canamo';
update items set weight_lb = 6   where code = 'piqueta';
update items set weight_lb = 1   where code = 'daga';
update items set weight_lb = 2   where code = 'farol';
update items set weight_lb = 0.5 where code = 'pocion_curacion';

-- ---- la bolsa admite objetos manuales (con nombre y peso propios) ---
alter table inventory add column name      text not null default '';
alter table inventory add column weight_lb double precision not null default 0;
alter table inventory alter column item_code drop not null;

-- objetos ya existentes (comprados/sembrados): copiar nombre y peso del catálogo
update inventory inv
   set name = i.name, weight_lb = i.weight_lb
  from items i
 where inv.item_code = i.code;
