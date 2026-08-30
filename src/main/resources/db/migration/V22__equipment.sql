-- =====================================================================
-- Equipo del SRD 3.5 (contenido abierto OGL), de d20srd.org y traducido:
-- 78 armas, 21 armaduras y escudos, 154 objetos y 16 servicios.
--
-- Se amplía `items` en vez de crear tablas nuevas: la tienda (shop_offers) y
-- la bolsa (inventory) ya apuntan a items(code), así que todo sigue igual y
-- los objetos nuevos se pueden comprar y vender desde el primer momento.
--
-- Precios en piezas de COBRE, como el resto de la app (1 po = 100 pc).
-- =====================================================================

-- ---- columnas nuevas -------------------------------------------------
-- El grupo del SRD ("Arma marcial (una mano)", "Armadura pesada"), para
-- poder ordenar el catálogo por familias en la tienda.
alter table items add column if not exists equipment_group text not null default '';
alter table items add column if not exists name_en         text not null default '';
alter table items add column if not exists source          text not null default '';

-- armas
alter table items add column if not exists damage_small    text not null default '';
alter table items add column if not exists damage_medium   text not null default '';
alter table items add column if not exists critical        text not null default '';
alter table items add column if not exists range_increment text not null default '';
alter table items add column if not exists damage_type     text not null default '';
alter table items add column if not exists proficiency     text not null default '';
alter table items add column if not exists handling        text not null default '';

-- armaduras y escudos
alter table items add column if not exists ac_bonus        text not null default '';
alter table items add column if not exists max_dex         text not null default '';
alter table items add column if not exists armor_check     text not null default '';
alter table items add column if not exists spell_failure   text not null default '';
alter table items add column if not exists speed_30        text not null default '';
alter table items add column if not exists speed_20        text not null default '';

create index if not exists idx_items_group    on items(equipment_group);
create index if not exists idx_items_category on items(category);

-- ---- catálogo del SRD ------------------------------------------------
insert into items (code, name, name_en, description, price_cp, weight_lb, category, equipment_group, damage_small, damage_medium, critical, range_increment, damage_type, proficiency, handling, ac_bonus, max_dex, armor_check, spell_failure, speed_30, speed_20, source) values
('guantelete', 'Guantelete', 'Gauntlet', '', 200, 1.0, 'arma', 'Arma sencilla (sin armas)', '1d2', '1d3', '×2', '', 'Contundente', 'Sencilla', 'Sin armas', '', '', '', '', '', '', 'SRD 3.5'),
('ataque_sin_armas', 'Ataque sin armas', 'Unarmed strike', '', 0, 0.0, 'arma', 'Arma sencilla (sin armas)', '1d2', '1d3', '×2', '', 'Contundente', 'Sencilla', 'Sin armas', '', '', '', '', '', '', 'SRD 3.5'),
('daga_de_puno', 'Daga de puño', 'Dagger, punching', '', 200, 1.0, 'arma', 'Arma sencilla (ligera)', '1d3', '1d4', '×3', '', 'Perforante', 'Sencilla', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('guantelete_con_puas', 'Guantelete con púas', 'Gauntlet, spiked', '', 500, 1.0, 'arma', 'Arma sencilla (ligera)', '1d3', '1d4', '×2', '', 'Perforante', 'Sencilla', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('maza_ligera', 'Maza ligera', 'Mace, light', '', 500, 4.0, 'arma', 'Arma sencilla (ligera)', '1d4', '1d6', '×2', '', 'Contundente', 'Sencilla', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('hoz', 'Hoz', 'Sickle', '', 600, 2.0, 'arma', 'Arma sencilla (ligera)', '1d4', '1d6', '×2', '', 'Cortante', 'Sencilla', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('garrote', 'Garrote', 'Club', '', 0, 3.0, 'arma', 'Arma sencilla (una mano)', '1d4', '1d6', '×2', '10 pies', 'Contundente', 'Sencilla', 'Una mano', '', '', '', '', '', '', 'SRD 3.5'),
('maza_pesada', 'Maza pesada', 'Mace, heavy', '', 1200, 8.0, 'arma', 'Arma sencilla (una mano)', '1d6', '1d8', '×2', '', 'Contundente', 'Sencilla', 'Una mano', '', '', '', '', '', '', 'SRD 3.5'),
('lucero_del_alba', 'Lucero del alba', 'Morningstar', '', 800, 6.0, 'arma', 'Arma sencilla (una mano)', '1d6', '1d8', '×2', '', 'Contundente y perforante', 'Sencilla', 'Una mano', '', '', '', '', '', '', 'SRD 3.5'),
('lanza_corta', 'Lanza corta', 'Shortspear', '', 100, 3.0, 'arma', 'Arma sencilla (una mano)', '1d4', '1d6', '×2', '20 pies', 'Perforante', 'Sencilla', 'Una mano', '', '', '', '', '', '', 'SRD 3.5'),
('lanza_larga', 'Lanza larga', 'Longspear', '', 500, 9.0, 'arma', 'Arma sencilla (dos manos)', '1d6', '1d8', '×3', '', 'Perforante', 'Sencilla', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('baston', 'Bastón', 'Quarterstaff', '', 0, 4.0, 'arma', 'Arma sencilla (dos manos)', '1d4/1d4', '1d6/1d6', '×2', '', 'Contundente', 'Sencilla', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('lanza', 'Lanza', 'Spear', '', 200, 6.0, 'arma', 'Arma sencilla (dos manos)', '1d6', '1d8', '×3', '20 pies', 'Perforante', 'Sencilla', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('ballesta_pesada', 'Ballesta pesada', 'Crossbow, heavy', '', 5000, 8.0, 'arma', 'Arma sencilla (a distancia)', '1d8', '1d10', '19-20/×2', '120 pies', 'Perforante', 'Sencilla', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('virotes_de_ballesta_10', 'Virotes de ballesta (10)', 'Bolts, crossbow (10)', '', 100, 1.0, 'arma', 'Arma sencilla (a distancia)', '', '', '', '', '', 'Sencilla', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('ballesta_ligera', 'Ballesta ligera', 'Crossbow, light', '', 3500, 4.0, 'arma', 'Arma sencilla (a distancia)', '1d6', '1d8', '19-20/×2', '80 pies', 'Perforante', 'Sencilla', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('dardo', 'Dardo', 'Dart', '', 50, 0.5, 'arma', 'Arma sencilla (a distancia)', '1d3', '1d4', '×2', '20 pies', 'Perforante', 'Sencilla', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('jabalina', 'Jabalina', 'Javelin', '', 100, 2.0, 'arma', 'Arma sencilla (a distancia)', '1d4', '1d6', '×2', '30 pies', 'Perforante', 'Sencilla', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('honda', 'Honda', 'Sling', '', 0, 0.0, 'arma', 'Arma sencilla (a distancia)', '1d3', '1d4', '×2', '50 pies', 'Contundente', 'Sencilla', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('balas_de_honda_10', 'Balas de honda (10)', 'Bullets, sling (10)', '', 10, 5.0, 'arma', 'Arma sencilla (a distancia)', '', '', '', '', '', 'Sencilla', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('hacha_arrojadiza', 'Hacha arrojadiza', 'Axe, throwing', '', 800, 2.0, 'arma', 'Arma marcial (ligera)', '1d4', '1d6', '×2', '10 pies', 'Cortante', 'Marcial', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('martillo_ligero', 'Martillo ligero', 'Hammer, light', '', 100, 2.0, 'arma', 'Arma marcial (ligera)', '1d3', '1d4', '×2', '20 pies', 'Contundente', 'Marcial', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('hacha_de_mano', 'Hacha de mano', 'Handaxe', '', 600, 3.0, 'arma', 'Arma marcial (ligera)', '1d4', '1d6', '×3', '', 'Cortante', 'Marcial', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('kukri', 'Kukri', 'Kukri', '', 800, 2.0, 'arma', 'Arma marcial (ligera)', '1d3', '1d4', '18-20/×2', '', 'Cortante', 'Marcial', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('pico_ligero', 'Pico ligero', 'Pick, light', '', 400, 3.0, 'arma', 'Arma marcial (ligera)', '1d3', '1d4', '×4', '', 'Perforante', 'Marcial', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('cachiporra', 'Cachiporra', 'Sap', '', 100, 2.0, 'arma', 'Arma marcial (ligera)', '1d4', '1d6', '×2', '', 'Contundente', 'Marcial', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('escudo_ligero_como_arma', 'Escudo ligero (como arma)', 'Shield, light', 'Cuesta lo mismo que el escudo o la armadura de los que forma parte', 0, 0.0, 'arma', 'Arma marcial (ligera)', '1d2', '1d3', '×2', '', 'Contundente', 'Marcial', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('armadura_con_puas_como_arma', 'Armadura con púas (como arma)', 'Spiked armor', 'Cuesta lo mismo que el escudo o la armadura de los que forma parte', 0, 0.0, 'arma', 'Arma marcial (ligera)', '1d4', '1d6', '×2', '', 'Perforante', 'Marcial', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('escudo_ligero_con_puas', 'Escudo ligero con púas', 'Spiked shield, light', 'Cuesta lo mismo que el escudo o la armadura de los que forma parte', 0, 0.0, 'arma', 'Arma marcial (ligera)', '1d3', '1d4', '×2', '', 'Perforante', 'Marcial', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('espada_corta', 'Espada corta', 'Sword, short', '', 1000, 2.0, 'arma', 'Arma marcial (ligera)', '1d4', '1d6', '19-20/×2', '', 'Perforante', 'Marcial', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('hacha_de_batalla', 'Hacha de batalla', 'Battleaxe', '', 1000, 6.0, 'arma', 'Arma marcial (una mano)', '1d6', '1d8', '×3', '', 'Cortante', 'Marcial', 'Una mano', '', '', '', '', '', '', 'SRD 3.5'),
('mayal', 'Mayal', 'Flail', '', 800, 5.0, 'arma', 'Arma marcial (una mano)', '1d6', '1d8', '×2', '', 'Contundente', 'Marcial', 'Una mano', '', '', '', '', '', '', 'SRD 3.5'),
('espada_larga', 'Espada larga', 'Longsword', '', 1500, 4.0, 'arma', 'Arma marcial (una mano)', '1d6', '1d8', '19-20/×2', '', 'Cortante', 'Marcial', 'Una mano', '', '', '', '', '', '', 'SRD 3.5'),
('pico_pesado', 'Pico pesado', 'Pick, heavy', '', 800, 6.0, 'arma', 'Arma marcial (una mano)', '1d4', '1d6', '×4', '', 'Perforante', 'Marcial', 'Una mano', '', '', '', '', '', '', 'SRD 3.5'),
('estoque', 'Estoque', 'Rapier', '', 2000, 2.0, 'arma', 'Arma marcial (una mano)', '1d4', '1d6', '18-20/×2', '', 'Perforante', 'Marcial', 'Una mano', '', '', '', '', '', '', 'SRD 3.5'),
('cimitarra', 'Cimitarra', 'Scimitar', '', 1500, 4.0, 'arma', 'Arma marcial (una mano)', '1d4', '1d6', '18-20/×2', '', 'Cortante', 'Marcial', 'Una mano', '', '', '', '', '', '', 'SRD 3.5'),
('escudo_pesado_como_arma', 'Escudo pesado (como arma)', 'Shield, heavy', 'Cuesta lo mismo que el escudo o la armadura de los que forma parte', 0, 0.0, 'arma', 'Arma marcial (una mano)', '1d3', '1d4', '×2', '', 'Contundente', 'Marcial', 'Una mano', '', '', '', '', '', '', 'SRD 3.5'),
('escudo_pesado_con_puas', 'Escudo pesado con púas', 'Spiked shield, heavy', 'Cuesta lo mismo que el escudo o la armadura de los que forma parte', 0, 0.0, 'arma', 'Arma marcial (una mano)', '1d4', '1d6', '×2', '', 'Perforante', 'Marcial', 'Una mano', '', '', '', '', '', '', 'SRD 3.5'),
('tridente', 'Tridente', 'Trident', '', 1500, 4.0, 'arma', 'Arma marcial (una mano)', '1d6', '1d8', '×2', '10 pies', 'Perforante', 'Marcial', 'Una mano', '', '', '', '', '', '', 'SRD 3.5'),
('martillo_de_guerra', 'Martillo de guerra', 'Warhammer', '', 1200, 5.0, 'arma', 'Arma marcial (una mano)', '1d6', '1d8', '×3', '', 'Contundente', 'Marcial', 'Una mano', '', '', '', '', '', '', 'SRD 3.5')
on conflict (code) do update set name_en = excluded.name_en, weight_lb = excluded.weight_lb, category = excluded.category, equipment_group = excluded.equipment_group, damage_small = excluded.damage_small, damage_medium = excluded.damage_medium, critical = excluded.critical, range_increment = excluded.range_increment, damage_type = excluded.damage_type, proficiency = excluded.proficiency, handling = excluded.handling, ac_bonus = excluded.ac_bonus, max_dex = excluded.max_dex, armor_check = excluded.armor_check, spell_failure = excluded.spell_failure, speed_30 = excluded.speed_30, speed_20 = excluded.speed_20, source = excluded.source;
insert into items (code, name, name_en, description, price_cp, weight_lb, category, equipment_group, damage_small, damage_medium, critical, range_increment, damage_type, proficiency, handling, ac_bonus, max_dex, armor_check, spell_failure, speed_30, speed_20, source) values
('alfanje', 'Alfanje', 'Falchion', '', 7500, 8.0, 'arma', 'Arma marcial (dos manos)', '1d6', '2d4', '18-20/×2', '', 'Cortante', 'Marcial', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('gujia', 'Gujía', 'Glaive', '', 800, 10.0, 'arma', 'Arma marcial (dos manos)', '1d8', '1d10', '×3', '', 'Cortante', 'Marcial', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('hacha_de_guerra', 'Hacha de guerra', 'Greataxe', '', 2000, 12.0, 'arma', 'Arma marcial (dos manos)', '1d10', '1d12', '×3', '', 'Cortante', 'Marcial', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('garrote_grande', 'Garrote grande', 'Greatclub', '', 500, 8.0, 'arma', 'Arma marcial (dos manos)', '1d8', '1d10', '×2', '', 'Contundente', 'Marcial', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('mayal_pesado', 'Mayal pesado', 'Flail, heavy', '', 1500, 10.0, 'arma', 'Arma marcial (dos manos)', '1d8', '1d10', '19-20/×2', '', 'Contundente', 'Marcial', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('espadon', 'Espadón', 'Greatsword', '', 5000, 8.0, 'arma', 'Arma marcial (dos manos)', '1d10', '2d6', '19-20/×2', '', 'Cortante', 'Marcial', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('guisarma', 'Guisarma', 'Guisarme', '', 900, 12.0, 'arma', 'Arma marcial (dos manos)', '1d6', '2d4', '×3', '', 'Cortante', 'Marcial', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('alabarda', 'Alabarda', 'Halberd', '', 1000, 12.0, 'arma', 'Arma marcial (dos manos)', '1d8', '1d10', '×3', '', 'Perforante o cortante', 'Marcial', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('lanza_de_caballeria', 'Lanza de caballería', 'Lance', '', 1000, 10.0, 'arma', 'Arma marcial (dos manos)', '1d6', '1d8', '×3', '', 'Perforante', 'Marcial', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('ranseur', 'Ranseur', 'Ranseur', '', 1000, 12.0, 'arma', 'Arma marcial (dos manos)', '1d6', '2d4', '×3', '', 'Perforante', 'Marcial', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('guadana', 'Guadaña', 'Scythe', '', 1800, 10.0, 'arma', 'Arma marcial (dos manos)', '1d6', '2d4', '×4', '', 'Perforante o cortante', 'Marcial', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('arco_largo', 'Arco largo', 'Longbow', '', 7500, 3.0, 'arma', 'Arma marcial (a distancia)', '1d6', '1d8', '×3', '100 pies', 'Perforante', 'Marcial', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('flechas_20', 'Flechas (20)', 'Arrows (20)', '', 100, 3.0, 'arma', 'Arma marcial (a distancia)', '', '', '', '', '', 'Marcial', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('arco_largo_compuesto', 'Arco largo compuesto', 'Longbow, composite', '', 10000, 3.0, 'arma', 'Arma marcial (a distancia)', '1d6', '1d8', '×3', '110 pies', 'Perforante', 'Marcial', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('arco_corto', 'Arco corto', 'Shortbow', '', 3000, 2.0, 'arma', 'Arma marcial (a distancia)', '1d4', '1d6', '×3', '60 pies', 'Perforante', 'Marcial', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('arco_corto_compuesto', 'Arco corto compuesto', 'Shortbow, composite', '', 7500, 2.0, 'arma', 'Arma marcial (a distancia)', '1d4', '1d6', '×3', '70 pies', 'Perforante', 'Marcial', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('kama', 'Kama', 'Kama', '', 200, 2.0, 'arma', 'Arma exótica (ligera)', '1d4', '1d6', '×2', '', 'Cortante', 'Exótica', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('nunchaku', 'Nunchaku', 'Nunchaku', '', 200, 2.0, 'arma', 'Arma exótica (ligera)', '1d4', '1d6', '×2', '', 'Contundente', 'Exótica', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('sai', 'Sai', 'Sai', '', 100, 1.0, 'arma', 'Arma exótica (ligera)', '1d3', '1d4', '×2', '10 pies', 'Contundente', 'Exótica', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('siangham', 'Siangham', 'Siangham', '', 300, 1.0, 'arma', 'Arma exótica (ligera)', '1d4', '1d6', '×2', '', 'Perforante', 'Exótica', 'Ligera', '', '', '', '', '', '', 'SRD 3.5'),
('espada_bastarda', 'Espada bastarda', 'Sword, bastard', '', 3500, 6.0, 'arma', 'Arma exótica (una mano)', '1d8', '1d10', '19-20/×2', '', 'Cortante', 'Exótica', 'Una mano', '', '', '', '', '', '', 'SRD 3.5'),
('hacha_de_guerra_enana', 'Hacha de guerra enana', 'Waraxe, dwarven', '', 3000, 8.0, 'arma', 'Arma exótica (una mano)', '1d8', '1d10', '×3', '', 'Cortante', 'Exótica', 'Una mano', '', '', '', '', '', '', 'SRD 3.5'),
('latigo', 'Látigo', 'Whip', '', 100, 2.0, 'arma', 'Arma exótica (una mano)', '1d2', '1d3', '×2', '', 'Cortante', 'Exótica', 'Una mano', '', '', '', '', '', '', 'SRD 3.5'),
('hacha_doble_orca', 'Hacha doble orca', 'Axe, orc double', '', 6000, 15.0, 'arma', 'Arma exótica (dos manos)', '1d6/1d6', '1d8/1d8', '×3', '', 'Cortante', 'Exótica', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('cadena_con_puas', 'Cadena con púas', 'Chain, spiked', '', 2500, 10.0, 'arma', 'Arma exótica (dos manos)', '1d6', '2d4', '×2', '', 'Perforante', 'Exótica', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('mayal_atroz', 'Mayal atroz', 'Flail, dire', '', 9000, 10.0, 'arma', 'Arma exótica (dos manos)', '1d6/1d6', '1d8/1d8', '×2', '', 'Contundente', 'Exótica', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('martillo_gancho_gnomo', 'Martillo gancho gnomo', 'Hammer, gnome hooked', '', 2000, 6.0, 'arma', 'Arma exótica (dos manos)', '1d6/1d4', '1d8/1d6', '×3/×4', '', 'Contundente o perforante', 'Exótica', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('espada_de_dos_hojas', 'Espada de dos hojas', 'Sword, two-bladed', '', 10000, 10.0, 'arma', 'Arma exótica (dos manos)', '1d6/1d6', '1d8/1d8', '19-20/×2', '', 'Cortante', 'Exótica', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('urgrosh_enano', 'Urgrosh enano', 'Urgrosh, dwarven', '', 5000, 12.0, 'arma', 'Arma exótica (dos manos)', '1d6/1d4', '1d8/1d6', '×3', '', 'Cortante o perforante', 'Exótica', 'Dos manos', '', '', '', '', '', '', 'SRD 3.5'),
('bolas', 'Bolas', 'Bolas', '', 500, 2.0, 'arma', 'Arma exótica (a distancia)', '1d3', '1d4', '×2', '10 pies', 'Contundente', 'Exótica', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('ballesta_de_mano', 'Ballesta de mano', 'Crossbow, hand', '', 10000, 2.0, 'arma', 'Arma exótica (a distancia)', '1d3', '1d4', '19-20/×2', '30 pies', 'Perforante', 'Exótica', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('virotes_10', 'Virotes (10)', 'Bolts (10)', '', 100, 1.0, 'arma', 'Arma exótica (a distancia)', '', '', '', '', '', 'Exótica', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('ballesta_de_repeticion_pesada', 'Ballesta de repetición pesada', 'Crossbow, repeating heavy', '', 40000, 12.0, 'arma', 'Arma exótica (a distancia)', '1d8', '1d10', '19-20/×2', '120 pies', 'Perforante', 'Exótica', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('virotes_5', 'Virotes (5)', 'Bolts (5)', '', 100, 1.0, 'arma', 'Arma exótica (a distancia)', '', '', '', '', '', 'Exótica', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('ballesta_de_repeticion_ligera', 'Ballesta de repetición ligera', 'Crossbow, repeating light', '', 25000, 6.0, 'arma', 'Arma exótica (a distancia)', '1d6', '1d8', '19-20/×2', '80 pies', 'Perforante', 'Exótica', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('red', 'Red', 'Net', '', 2000, 6.0, 'arma', 'Arma exótica (a distancia)', '', '', '', '10 pies', '', 'Exótica', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('shuriken_5', 'Shuriken (5)', 'Shuriken (5)', '', 100, 0.5, 'arma', 'Arma exótica (a distancia)', '1', '1d2', '×2', '10 pies', 'Perforante', 'Exótica', 'A distancia', '', '', '', '', '', '', 'SRD 3.5'),
('armadura_acolchada', 'Armadura acolchada', 'Padded', '', 500, 10.0, 'armadura', 'Armadura ligera', '', '', '', '', '', '', '', '1', '8', '0', '5%', '30 pies', '20 pies', 'SRD 3.5'),
('armadura_de_cuero', 'Armadura de cuero', 'Leather', '', 1000, 15.0, 'armadura', 'Armadura ligera', '', '', '', '', '', '', '', '2', '6', '0', '10%', '30 pies', '20 pies', 'SRD 3.5'),
('cuero_tachonado', 'Cuero tachonado', 'Studded leather', '', 2500, 20.0, 'armadura', 'Armadura ligera', '', '', '', '', '', '', '', '3', '5', '-1', '15%', '30 pies', '20 pies', 'SRD 3.5')
on conflict (code) do update set name_en = excluded.name_en, weight_lb = excluded.weight_lb, category = excluded.category, equipment_group = excluded.equipment_group, damage_small = excluded.damage_small, damage_medium = excluded.damage_medium, critical = excluded.critical, range_increment = excluded.range_increment, damage_type = excluded.damage_type, proficiency = excluded.proficiency, handling = excluded.handling, ac_bonus = excluded.ac_bonus, max_dex = excluded.max_dex, armor_check = excluded.armor_check, spell_failure = excluded.spell_failure, speed_30 = excluded.speed_30, speed_20 = excluded.speed_20, source = excluded.source;
insert into items (code, name, name_en, description, price_cp, weight_lb, category, equipment_group, damage_small, damage_medium, critical, range_increment, damage_type, proficiency, handling, ac_bonus, max_dex, armor_check, spell_failure, speed_30, speed_20, source) values
('camisote_de_mallas', 'Camisote de mallas', 'Chain shirt', '', 10000, 25.0, 'armadura', 'Armadura ligera', '', '', '', '', '', '', '', '4', '4', '-2', '20%', '30 pies', '20 pies', 'SRD 3.5'),
('armadura_de_pieles', 'Armadura de pieles', 'Hide', '', 1500, 25.0, 'armadura', 'Armadura media', '', '', '', '', '', '', '', '3', '4', '-3', '20%', '20 pies', '15 pies', 'SRD 3.5'),
('cota_de_escamas', 'Cota de escamas', 'Scale mail', '', 5000, 30.0, 'armadura', 'Armadura media', '', '', '', '', '', '', '', '4', '3', '-4', '25%', '20 pies', '15 pies', 'SRD 3.5'),
('cota_de_mallas', 'Cota de mallas', 'Chainmail', '', 15000, 40.0, 'armadura', 'Armadura media', '', '', '', '', '', '', '', '5', '2', '-5', '30%', '20 pies', '15 pies', 'SRD 3.5'),
('coraza', 'Coraza', 'Breastplate', '', 20000, 30.0, 'armadura', 'Armadura media', '', '', '', '', '', '', '', '5', '3', '-4', '25%', '20 pies', '15 pies', 'SRD 3.5'),
('cota_de_laminas', 'Cota de láminas', 'Splint mail', '', 20000, 45.0, 'armadura', 'Armadura pesada', '', '', '', '', '', '', '', '6', '0', '-7', '40%', '20 pies', '15 pies', 'SRD 3.5'),
('cota_de_bandas', 'Cota de bandas', 'Banded mail', '', 25000, 35.0, 'armadura', 'Armadura pesada', '', '', '', '', '', '', '', '6', '1', '-6', '35%', '20 pies', '15 pies', 'SRD 3.5'),
('media_placa', 'Media placa', 'Half-plate', '', 60000, 50.0, 'armadura', 'Armadura pesada', '', '', '', '', '', '', '', '7', '0', '-7', '40%', '20 pies', '15 pies', 'SRD 3.5'),
('placas_completas', 'Placas completas', 'Full plate', '', 150000, 50.0, 'armadura', 'Armadura pesada', '', '', '', '', '', '', '', '8', '1', '-6', '35%', '20 pies', '15 pies', 'SRD 3.5'),
('rodela', 'Rodela', 'Buckler', '', 1500, 5.0, 'armadura', 'Escudo', '', '', '', '', '', '', '', '1', '', '-1', '5%', '', '', 'SRD 3.5'),
('escudo_ligero_de_madera', 'Escudo ligero de madera', 'Shield, light wooden', '', 300, 5.0, 'armadura', 'Escudo', '', '', '', '', '', '', '', '1', '', '-1', '5%', '', '', 'SRD 3.5'),
('escudo_ligero_de_acero', 'Escudo ligero de acero', 'Shield, light steel', '', 900, 6.0, 'armadura', 'Escudo', '', '', '', '', '', '', '', '1', '', '-1', '5%', '', '', 'SRD 3.5'),
('escudo_pesado_de_madera', 'Escudo pesado de madera', 'Shield, heavy wooden', '', 700, 10.0, 'armadura', 'Escudo', '', '', '', '', '', '', '', '2', '', '-2', '15%', '', '', 'SRD 3.5'),
('escudo_pesado_de_acero', 'Escudo pesado de acero', 'Shield, heavy steel', '', 2000, 15.0, 'armadura', 'Escudo', '', '', '', '', '', '', '', '2', '', '-2', '15%', '', '', 'SRD 3.5'),
('escudo_de_torre', 'Escudo de torre', 'Shield, tower', '', 3000, 45.0, 'armadura', 'Escudo', '', '', '', '', '', '', '', '4', '2', '-10', '50%', '', '', 'SRD 3.5'),
('puas_de_armadura', 'Púas de armadura', 'Armor spikes', 'se suma al precio del objeto', 5000, 10.0, 'armadura', 'Complemento', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('guantelete_cerrado', 'Guantelete cerrado', 'Gauntlet, locked', '', 800, 5.0, 'armadura', 'Complemento', '', '', '', '', '', '', '', '', '', 'Special', '', '', '', 'SRD 3.5'),
('puas_de_escudo', 'Púas de escudo', 'Shield spikes', 'se suma al precio del objeto', 1000, 5.0, 'armadura', 'Complemento', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('mochila_vacia', 'Mochila (vacía)', 'Backpack (empty)', '', 200, 2.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('barril_vacio', 'Barril (vacío)', 'Barrel (empty)', '', 200, 30.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('cesta_vacia', 'Cesta (vacía)', 'Basket (empty)', '', 40, 1.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('petate', 'Petate', 'Bedroll', '', 10, 5.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('campanilla', 'Campanilla', 'Bell', '', 100, 0.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('manta_de_invierno', 'Manta de invierno', 'Blanket, winter', '', 50, 3.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('polea_con_aparejo', 'Polea con aparejo', 'Block and tackle', '', 500, 5.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('botella_de_vino_de_cristal', 'Botella de vino de cristal', 'Bottle, wine, glass', '', 200, 0.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('cubo_vacio', 'Cubo (vacío)', 'Bucket (empty)', '', 50, 2.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('abrojos', 'Abrojos', 'Caltrops', '', 100, 2.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('vela', 'Vela', 'Candle', '', 1, 0.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('lona_por_metro_cuadrado', 'Lona (por metro cuadrado)', 'Canvas (sq. yd.)', '', 10, 1.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('estuche_para_mapas_o_pergaminos', 'Estuche para mapas o pergaminos', 'Case, map or scroll', '', 100, 0.5, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('cadena_10_pies', 'Cadena (10 pies)', 'Chain (10 ft.)', '', 3000, 2.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('tiza_una_barra', 'Tiza (una barra)', 'Chalk, 1 piece', '', 1, 0.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('arcon_vacio', 'Arcón (vacío)', 'Chest (empty)', '', 200, 25.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('palanqueta', 'Palanqueta', 'Crowbar', '', 200, 5.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('lena_por_dia', 'Leña (por día)', 'Firewood (per day)', '', 1, 20.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('anzuelo', 'Anzuelo', 'Fishhook', '', 10, 0.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('red_de_pesca_25_pies_cuadrados', 'Red de pesca (25 pies cuadrados)', 'Fishing net, 25 sq. ft.', '', 400, 5.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('frasco_vacio', 'Frasco (vacío)', 'Flask (empty)', '', 3, 1.5, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('pedernal_y_acero', 'Pedernal y acero', 'Flint and steel', '', 100, 0.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5')
on conflict (code) do update set name_en = excluded.name_en, weight_lb = excluded.weight_lb, category = excluded.category, equipment_group = excluded.equipment_group, damage_small = excluded.damage_small, damage_medium = excluded.damage_medium, critical = excluded.critical, range_increment = excluded.range_increment, damage_type = excluded.damage_type, proficiency = excluded.proficiency, handling = excluded.handling, ac_bonus = excluded.ac_bonus, max_dex = excluded.max_dex, armor_check = excluded.armor_check, spell_failure = excluded.spell_failure, speed_30 = excluded.speed_30, speed_20 = excluded.speed_20, source = excluded.source;
insert into items (code, name, name_en, description, price_cp, weight_lb, category, equipment_group, damage_small, damage_medium, critical, range_increment, damage_type, proficiency, handling, ac_bonus, max_dex, armor_check, spell_failure, speed_30, speed_20, source) values
('garfio_de_escalada', 'Garfio de escalada', 'Grappling hook', '', 100, 4.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('martillo', 'Martillo', 'Hammer', '', 50, 2.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('tinta_frasco_de_1_onza', 'Tinta (frasco de 1 onza)', 'Ink (1 oz. vial)', '', 800, 0.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('pluma_de_escribir', 'Pluma de escribir', 'Inkpen', '', 10, 0.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('jarra_de_barro', 'Jarra de barro', 'Jug, clay', '', 3, 9.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('escalera_de_10_pies', 'Escalera de 10 pies', 'Ladder, 10-foot', '', 5, 20.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('candil_corriente', 'Candil corriente', 'Lamp, common', '', 10, 1.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('farol_de_ojo_de_buey', 'Farol de ojo de buey', 'Lantern, bullseye', '', 1200, 3.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('cerradura_muy_sencilla', 'Cerradura (muy sencilla)', 'Lock (very simple)', '', 2000, 1.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('cerradura_corriente', 'Cerradura (corriente)', 'Lock (average)', '', 4000, 1.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('cerradura_buena', 'Cerradura (buena)', 'Lock (good)', '', 8000, 1.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('cerradura_excepcional', 'Cerradura (excepcional)', 'Lock (amazing)', '', 15000, 1.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('grilletes', 'Grilletes', 'Manacles', '', 1500, 2.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('grilletes_de_calidad_superior', 'Grilletes de calidad superior', 'Manacles, masterwork', '', 5000, 2.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('espejo_pequeno_de_acero', 'Espejo pequeño de acero', 'Mirror, small steel', '', 1000, 0.5, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('jarra_de_barro_para_beber', 'Jarra de barro para beber', 'Mug/Tankard, clay', '', 2, 1.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('papel_una_hoja', 'Papel (una hoja)', 'Paper (sheet)', '', 40, 0.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('pergamino_una_hoja', 'Pergamino (una hoja)', 'Parchment (sheet)', '', 20, 0.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('cantaro_de_barro', 'Cántaro de barro', 'Pitcher, clay', '', 2, 5.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('clavija_de_escalada', 'Clavija de escalada', 'Piton', '', 10, 0.5, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('pertiga_de_10_pies', 'Pértiga de 10 pies', 'Pole, 10-foot', '', 20, 8.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('olla_de_hierro', 'Olla de hierro', 'Pot, iron', '', 50, 10.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('bolsa_de_cinturon_vacia', 'Bolsa de cinturón (vacía)', 'Pouch, belt (empty)', '', 100, 0.5, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('ariete_portatil', 'Ariete portátil', 'Ram, portable', '', 1000, 20.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('cuerda_de_seda_50_pies', 'Cuerda de seda (50 pies)', 'Rope, silk (50 ft.)', '', 1000, 5.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('saco_vacio', 'Saco (vacío)', 'Sack (empty)', '', 10, 0.5, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('lacre', 'Lacre', 'Sealing wax', '', 100, 1.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('aguja_de_coser', 'Aguja de coser', 'Sewing needle', '', 50, 0.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('silbato_de_senales', 'Silbato de señales', 'Signal whistle', '', 80, 0.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('anillo_de_sello', 'Anillo de sello', 'Signet ring', '', 500, 0.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('almadena', 'Almádena', 'Sledge', '', 100, 10.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('jabon_por_libra', 'Jabón (por libra)', 'Soap (per lb.)', '', 50, 1.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('pala_o_azada', 'Pala o azada', 'Spade or shovel', '', 200, 8.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('catalejo', 'Catalejo', 'Spyglass', '', 100000, 1.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('tienda_de_campana', 'Tienda de campaña', 'Tent', '', 1000, 20.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('vial_para_tinta_o_pocion', 'Vial para tinta o poción', 'Vial, ink or potion', '', 100, 0.1, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('odre', 'Odre', 'Waterskin', '', 100, 4.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('piedra_de_afilar', 'Piedra de afilar', 'Whetstone', '', 2, 1.0, 'equipo', 'Equipo de aventurero', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('acido_frasco', 'Ácido (frasco)', 'Acid (flask)', '', 1000, 1.0, 'sustancia', 'Sustancias y objetos especiales', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('fuego_del_alquimista_frasco', 'Fuego del alquimista (frasco)', 'Alchemist’s fire (flask)', '', 2000, 1.0, 'sustancia', 'Sustancias y objetos especiales', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5')
on conflict (code) do update set name_en = excluded.name_en, weight_lb = excluded.weight_lb, category = excluded.category, equipment_group = excluded.equipment_group, damage_small = excluded.damage_small, damage_medium = excluded.damage_medium, critical = excluded.critical, range_increment = excluded.range_increment, damage_type = excluded.damage_type, proficiency = excluded.proficiency, handling = excluded.handling, ac_bonus = excluded.ac_bonus, max_dex = excluded.max_dex, armor_check = excluded.armor_check, spell_failure = excluded.spell_failure, speed_30 = excluded.speed_30, speed_20 = excluded.speed_20, source = excluded.source;
insert into items (code, name, name_en, description, price_cp, weight_lb, category, equipment_group, damage_small, damage_medium, critical, range_increment, damage_type, proficiency, handling, ac_bonus, max_dex, armor_check, spell_failure, speed_30, speed_20, source) values
('antitoxina_vial', 'Antitoxina (vial)', 'Antitoxin (vial)', '', 5000, 0.0, 'sustancia', 'Sustancias y objetos especiales', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('antorcha_eterna', 'Antorcha eterna', 'Everburning torch', '', 11000, 1.0, 'sustancia', 'Sustancias y objetos especiales', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('agua_bendita_frasco', 'Agua bendita (frasco)', 'Holy water (flask)', '', 2500, 1.0, 'sustancia', 'Sustancias y objetos especiales', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('vara_de_humo', 'Vara de humo', 'Smokestick', '', 2000, 0.5, 'sustancia', 'Sustancias y objetos especiales', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('vara_solar', 'Vara solar', 'Sunrod', '', 200, 1.0, 'sustancia', 'Sustancias y objetos especiales', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('bolsa_trabapies', 'Bolsa trabapiés', 'Tanglefoot bag', '', 5000, 4.0, 'sustancia', 'Sustancias y objetos especiales', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('piedra_atronadora', 'Piedra atronadora', 'Thunderstone', '', 3000, 1.0, 'sustancia', 'Sustancias y objetos especiales', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('cerilla_de_yesca', 'Cerilla de yesca', 'Tindertwig', '', 100, 0.0, 'sustancia', 'Sustancias y objetos especiales', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('laboratorio_de_alquimista', 'Laboratorio de alquimista', 'Alchemist’s lab', '', 50000, 40.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('herramientas_de_artesano', 'Herramientas de artesano', 'Artisan’s tools', '', 500, 5.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('herramientas_de_artesano_de_calidad_superior', 'Herramientas de artesano de calidad superior', 'Artisan’s tools, masterwork', '', 5500, 5.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('estuche_de_escalador', 'Estuche de escalador', 'Climber’s kit', '', 8000, 5.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('estuche_de_disfraces', 'Estuche de disfraces', 'Disguise kit', '', 5000, 8.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('estuche_de_sanador', 'Estuche de sanador', 'Healer’s kit', '', 5000, 1.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('acebo_y_muerdago', 'Acebo y muérdago', 'Holly and mistletoe', '', 0, 0.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('simbolo_sagrado_de_madera', 'Símbolo sagrado de madera', 'Holy symbol, wooden', '', 100, 0.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('simbolo_sagrado_de_plata', 'Símbolo sagrado de plata', 'Holy symbol, silver', '', 2500, 1.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('reloj_de_arena', 'Reloj de arena', 'Hourglass', '', 2500, 1.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('lupa', 'Lupa', 'Magnifying glass', '', 10000, 0.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('instrumento_musical_corriente', 'Instrumento musical corriente', 'Musical instrument, common', '', 500, 3.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('instrumento_musical_de_calidad_superior', 'Instrumento musical de calidad superior', 'Musical instrument, masterwork', '', 10000, 3.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('balanza_de_mercader', 'Balanza de mercader', 'Scale, merchant’s', '', 200, 1.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('bolsa_de_componentes', 'Bolsa de componentes', 'Spell component pouch', '', 500, 2.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('libro_de_conjuros_de_mago_en_blanco', 'Libro de conjuros de mago (en blanco)', 'Spellbook, wizard’s (blank)', '', 1500, 3.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('herramientas_de_ladron', 'Herramientas de ladrón', 'Thieves’ tools', '', 3000, 1.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('herramientas_de_ladron_de_calidad_superior', 'Herramientas de ladrón de calidad superior', 'Thieves’ tools, masterwork', '', 10000, 2.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('herramienta_de_calidad_superior', 'Herramienta de calidad superior', 'Tool, masterwork', '', 5000, 1.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('reloj_de_agua', 'Reloj de agua', 'Water clock', '', 100000, 200.0, 'herramienta', 'Herramientas y estuches', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('ropa_de_artesano', 'Ropa de artesano', 'Artisan’s outfit', '', 100, 4.0, 'ropa', 'Ropa', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('vestiduras_de_clerigo', 'Vestiduras de clérigo', 'Cleric’s vestments', '', 500, 6.0, 'ropa', 'Ropa', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('ropa_de_abrigo', 'Ropa de abrigo', 'Cold weather outfit', '', 800, 7.0, 'ropa', 'Ropa', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('ropa_de_cortesano', 'Ropa de cortesano', 'Courtier’s outfit', '', 3000, 6.0, 'ropa', 'Ropa', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('ropa_de_artista', 'Ropa de artista', 'Entertainer’s outfit', '', 300, 4.0, 'ropa', 'Ropa', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('ropa_de_explorador', 'Ropa de explorador', 'Explorer’s outfit', '', 1000, 8.0, 'ropa', 'Ropa', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('ropa_de_monje', 'Ropa de monje', 'Monk’s outfit', '', 500, 2.0, 'ropa', 'Ropa', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('ropa_de_noble', 'Ropa de noble', 'Noble’s outfit', '', 7500, 10.0, 'ropa', 'Ropa', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('ropa_de_campesino', 'Ropa de campesino', 'Peasant’s outfit', '', 10, 2.0, 'ropa', 'Ropa', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('ropa_regia', 'Ropa regia', 'Royal outfit', '', 20000, 15.0, 'ropa', 'Ropa', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('ropa_de_erudito', 'Ropa de erudito', 'Scholar’s outfit', '', 500, 6.0, 'ropa', 'Ropa', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('ropa_de_viajero', 'Ropa de viajero', 'Traveler’s outfit', '', 100, 5.0, 'ropa', 'Ropa', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5')
on conflict (code) do update set name_en = excluded.name_en, weight_lb = excluded.weight_lb, category = excluded.category, equipment_group = excluded.equipment_group, damage_small = excluded.damage_small, damage_medium = excluded.damage_medium, critical = excluded.critical, range_increment = excluded.range_increment, damage_type = excluded.damage_type, proficiency = excluded.proficiency, handling = excluded.handling, ac_bonus = excluded.ac_bonus, max_dex = excluded.max_dex, armor_check = excluded.armor_check, spell_failure = excluded.spell_failure, speed_30 = excluded.speed_30, speed_20 = excluded.speed_20, source = excluded.source;
insert into items (code, name, name_en, description, price_cp, weight_lb, category, equipment_group, damage_small, damage_medium, critical, range_increment, damage_type, proficiency, handling, ac_bonus, max_dex, armor_check, spell_failure, speed_30, speed_20, source) values
('cerveza_galon', 'Cerveza (galón)', 'Ale, gallon', '', 20, 8.0, 'comida', 'Comida, bebida y alojamiento', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('cerveza_jarra', 'Cerveza (jarra)', 'Ale, mug', '', 4, 1.0, 'comida', 'Comida, bebida y alojamiento', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('banquete_por_persona', 'Banquete (por persona)', 'Banquet (per person)', '', 1000, 0.0, 'comida', 'Comida, bebida y alojamiento', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('pan_una_hogaza', 'Pan (una hogaza)', 'Bread, per loaf', '', 2, 0.5, 'comida', 'Comida, bebida y alojamiento', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('queso_un_pedazo', 'Queso (un pedazo)', 'Cheese, hunk of', '', 10, 0.5, 'comida', 'Comida, bebida y alojamiento', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('posada_buena_por_dia', 'Posada, buena (por día)', 'Inn stay (per day), good', '', 200, 0.0, 'comida', 'Comida, bebida y alojamiento', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('posada_corriente_por_dia', 'Posada, corriente (por día)', 'Inn stay (per day), common', '', 50, 0.0, 'comida', 'Comida, bebida y alojamiento', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('posada_mala_por_dia', 'Posada, mala (por día)', 'Inn stay (per day), poor', '', 20, 0.0, 'comida', 'Comida, bebida y alojamiento', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('comidas_buenas_por_dia', 'Comidas, buenas (por día)', 'Meals (per day), good', '', 50, 0.0, 'comida', 'Comida, bebida y alojamiento', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('comidas_corrientes_por_dia', 'Comidas, corrientes (por día)', 'Meals (per day), common', '', 30, 0.0, 'comida', 'Comida, bebida y alojamiento', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('comidas_malas_por_dia', 'Comidas, malas (por día)', 'Meals (per day), poor', '', 10, 0.0, 'comida', 'Comida, bebida y alojamiento', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('carne_un_pedazo', 'Carne (un pedazo)', 'Meat, chunk of', '', 30, 0.5, 'comida', 'Comida, bebida y alojamiento', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('vino_corriente_jarra', 'Vino corriente (jarra)', 'Wine, common (pitcher)', '', 20, 6.0, 'comida', 'Comida, bebida y alojamiento', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('vino_bueno_botella', 'Vino bueno (botella)', 'Wine, fine (bottle)', '', 1000, 1.5, 'comida', 'Comida, bebida y alojamiento', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('barda_para_criatura_mediana', 'Barda para criatura mediana', 'Barding, medium creature', 'Cuesta ×2 el precio de la armadura equivalente', 0, 0.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('barda_para_criatura_grande', 'Barda para criatura grande', 'Barding, large creature', 'Cuesta ×4 el precio de la armadura equivalente', 0, 0.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('bocado_y_brida', 'Bocado y brida', 'Bit and bridle', '', 200, 1.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('perro_guardian', 'Perro guardián', 'Dog, guard', '', 2500, 0.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('perro_de_monta', 'Perro de monta', 'Dog, riding', '', 15000, 0.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('burro_o_mula', 'Burro o mula', 'Donkey or mule', '', 800, 0.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('pienso_por_dia', 'Pienso (por día)', 'Feed (per day)', '', 5, 10.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('caballo_pesado', 'Caballo pesado', 'Horse, heavy', '', 20000, 0.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('caballo_ligero', 'Caballo ligero', 'Horse, light', '', 7500, 0.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('poni', 'Poni', 'Pony', '', 3000, 0.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('caballo_de_guerra_pesado', 'Caballo de guerra pesado', 'Warhorse, heavy', '', 40000, 0.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('caballo_de_guerra_ligero', 'Caballo de guerra ligero', 'Warhorse, light', '', 15000, 0.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('poni_de_guerra', 'Poni de guerra', 'Warpony', '', 10000, 0.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('silla_de_montar_militar', 'Silla de montar militar', 'Saddle, military', '', 2000, 30.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('silla_de_montar_de_carga', 'Silla de montar de carga', 'Saddle, pack', '', 500, 15.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('silla_de_montar_de_paseo', 'Silla de montar de paseo', 'Saddle, riding', '', 1000, 25.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('silla_de_montar_exotica_militar', 'Silla de montar exótica militar', 'Saddle, Exotic, military', '', 6000, 40.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('silla_de_montar_exotica_de_carga', 'Silla de montar exótica de carga', 'Saddle, Exotic, pack', '', 1500, 20.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('silla_de_montar_exotica_de_paseo', 'Silla de montar exótica de paseo', 'Saddle, Exotic, riding', '', 3000, 30.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('alforjas', 'Alforjas', 'Saddlebags', '', 400, 8.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('establo_por_dia', 'Establo (por día)', 'Stabling (per day)', '', 50, 0.0, 'montura', 'Monturas y arreos', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('carruaje', 'Carruaje', 'Carriage', '', 10000, 600.0, 'transporte', 'Transporte', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('carro', 'Carro', 'Cart', '', 1500, 200.0, 'transporte', 'Transporte', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('galera', 'Galera', 'Galley', '', 3000000, 0.0, 'transporte', 'Transporte', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('barcaza_de_quilla', 'Barcaza de quilla', 'Keelboat', '', 300000, 0.0, 'transporte', 'Transporte', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('drakkar', 'Drakkar', 'Longship', '', 1000000, 0.0, 'transporte', 'Transporte', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5')
on conflict (code) do update set name_en = excluded.name_en, weight_lb = excluded.weight_lb, category = excluded.category, equipment_group = excluded.equipment_group, damage_small = excluded.damage_small, damage_medium = excluded.damage_medium, critical = excluded.critical, range_increment = excluded.range_increment, damage_type = excluded.damage_type, proficiency = excluded.proficiency, handling = excluded.handling, ac_bonus = excluded.ac_bonus, max_dex = excluded.max_dex, armor_check = excluded.armor_check, spell_failure = excluded.spell_failure, speed_30 = excluded.speed_30, speed_20 = excluded.speed_20, source = excluded.source;
insert into items (code, name, name_en, description, price_cp, weight_lb, category, equipment_group, damage_small, damage_medium, critical, range_increment, damage_type, proficiency, handling, ac_bonus, max_dex, armor_check, spell_failure, speed_30, speed_20, source) values
('bote_de_remos', 'Bote de remos', 'Rowboat', '', 5000, 100.0, 'transporte', 'Transporte', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('remo', 'Remo', 'Oar', '', 200, 10.0, 'transporte', 'Transporte', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('barco_de_vela', 'Barco de vela', 'Sailing ship', '', 1000000, 0.0, 'transporte', 'Transporte', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('trineo', 'Trineo', 'Sled', '', 2000, 300.0, 'transporte', 'Transporte', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('carreta', 'Carreta', 'Wagon', '', 3500, 400.0, 'transporte', 'Transporte', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('barco_de_guerra', 'Barco de guerra', 'Warship', '', 2500000, 0.0, 'transporte', 'Transporte', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('coche_de_caballos', 'Coche de caballos', 'Coach cab', 'por milla', 3, 0.0, 'servicio', 'Conjuros y servicios', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('asalariado_cualificado', 'Asalariado cualificado', 'Hireling, trained', 'por día', 30, 0.0, 'servicio', 'Conjuros y servicios', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('asalariado_sin_cualificar', 'Asalariado sin cualificar', 'Hireling, untrained', 'por día', 10, 0.0, 'servicio', 'Conjuros y servicios', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('mensajero', 'Mensajero', 'Messenger', 'por milla', 2, 0.0, 'servicio', 'Conjuros y servicios', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('peaje_de_camino_o_de_puerta', 'Peaje de camino o de puerta', 'Road or gate toll', '', 1, 0.0, 'servicio', 'Conjuros y servicios', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('pasaje_en_barco', 'Pasaje en barco', 'Ship’s passage', 'por milla', 10, 0.0, 'servicio', 'Conjuros y servicios', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('conjuro_de_nivel_0', 'Conjuro de nivel 0', 'Spell, 0-level', 'Nivel de lanzador × 5 po', 0, 0.0, 'servicio', 'Conjuros y servicios', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('conjuro_de_nivel_1', 'Conjuro de nivel 1', 'Spell, 1st-level', 'Nivel de lanzador × 10 po', 0, 0.0, 'servicio', 'Conjuros y servicios', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('conjuro_de_nivel_2', 'Conjuro de nivel 2', 'Spell, 2nd-level', 'Nivel de lanzador × 20 po', 0, 0.0, 'servicio', 'Conjuros y servicios', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('conjuro_de_nivel_3', 'Conjuro de nivel 3', 'Spell, 3rd-level', 'Nivel de lanzador × 30 po', 0, 0.0, 'servicio', 'Conjuros y servicios', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('conjuro_de_nivel_4', 'Conjuro de nivel 4', 'Spell, 4th-level', 'Nivel de lanzador × 40 po', 0, 0.0, 'servicio', 'Conjuros y servicios', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('conjuro_de_nivel_5', 'Conjuro de nivel 5', 'Spell, 5th-level', 'Nivel de lanzador × 50 po', 0, 0.0, 'servicio', 'Conjuros y servicios', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('conjuro_de_nivel_6', 'Conjuro de nivel 6', 'Spell, 6th-level', 'Nivel de lanzador × 60 po', 0, 0.0, 'servicio', 'Conjuros y servicios', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('conjuro_de_nivel_7', 'Conjuro de nivel 7', 'Spell, 7th-level', 'Nivel de lanzador × 70 po', 0, 0.0, 'servicio', 'Conjuros y servicios', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('conjuro_de_nivel_8', 'Conjuro de nivel 8', 'Spell, 8th-level', 'Nivel de lanzador × 80 po', 0, 0.0, 'servicio', 'Conjuros y servicios', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5'),
('conjuro_de_nivel_9', 'Conjuro de nivel 9', 'Spell, 9th-level', 'Nivel de lanzador × 90 po', 0, 0.0, 'servicio', 'Conjuros y servicios', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SRD 3.5')
on conflict (code) do update set name_en = excluded.name_en, weight_lb = excluded.weight_lb, category = excluded.category, equipment_group = excluded.equipment_group, damage_small = excluded.damage_small, damage_medium = excluded.damage_medium, critical = excluded.critical, range_increment = excluded.range_increment, damage_type = excluded.damage_type, proficiency = excluded.proficiency, handling = excluded.handling, ac_bonus = excluded.ac_bonus, max_dex = excluded.max_dex, armor_check = excluded.armor_check, spell_failure = excluded.spell_failure, speed_30 = excluded.speed_30, speed_20 = excluded.speed_20, source = excluded.source;

-- ---- los que ya estaban en Dorakan: solo se completan --------------
-- Conservan nombre, descripción y precio; se les añaden las
-- estadísticas del SRD que les faltaban.
update items set name_en = 'Dagger', equipment_group = 'Arma sencilla (ligera)', category = 'arma', source = 'SRD 3.5', damage_small = '1d3', damage_medium = '1d4', critical = '19-20/×2', range_increment = '10 pies', damage_type = 'Perforante o cortante', proficiency = 'Sencilla', handling = 'Ligera' where code = 'daga';
update items set name_en = 'Lantern, hooded', equipment_group = 'Equipo de aventurero', category = 'equipo', source = 'SRD 3.5' where code = 'farol';
update items set name_en = 'Oil (1-pint flask)', equipment_group = 'Equipo de aventurero', category = 'equipo', source = 'SRD 3.5' where code = 'aceite';
update items set name_en = 'Pick, miner’s', equipment_group = 'Equipo de aventurero', category = 'equipo', source = 'SRD 3.5' where code = 'piqueta';
update items set name_en = 'Rations, trail (per day)', equipment_group = 'Equipo de aventurero', category = 'equipo', source = 'SRD 3.5' where code = 'racion';
update items set name_en = 'Rope, hempen (50 ft.)', equipment_group = 'Equipo de aventurero', category = 'equipo', source = 'SRD 3.5' where code = 'cuerda_canamo';
update items set name_en = 'Torch', equipment_group = 'Equipo de aventurero', category = 'equipo', source = 'SRD 3.5' where code = 'antorcha';

-- ---- al mostrador ----------------------------------------------------
-- Todo lo que sea un objeto que se pueda llevar encima entra en la vitrina.
-- Quedan fuera los servicios y el transporte (un barco no se compra en un
-- mostrador) y lo que no tiene precio fijo (el ataque sin armas, la barda,
-- las púas), que se cobran según de qué formen parte.
insert into shop_offers (id, location, item_code, price_cp, stock)
select gen_random_uuid(), 'Dorakan', i.code, i.price_cp, -1
  from items i
 where i.source = 'SRD 3.5'
   and i.category not in ('servicio', 'transporte')
   and i.price_cp > 0
   and not exists (select 1 from shop_offers o where o.item_code = i.code);
