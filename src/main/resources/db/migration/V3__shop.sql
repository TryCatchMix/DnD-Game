-- =====================================================================
-- La tienda (pantalla 06): monedero, catálogo, ofertas e inventario.
-- =====================================================================

-- ---- monedero del personaje, en piezas de cobre --------------------
alter table characters add column purse_cp bigint not null default 0;

-- cuadran con las bolsas que se sembraron en V2:
--   214 po · 6 pp · 2 pc = 21462 cp, etc.
update characters set purse_cp = 21462 where id = '22222222-2222-2222-2222-222222220001'; -- Gorash
update characters set purse_cp = 8820  where id = '22222222-2222-2222-2222-222222220002'; -- Sivil
update characters set purse_cp = 13000 where id = '22222222-2222-2222-2222-222222220003'; -- Alcaeus
update characters set purse_cp = 5640  where id = '22222222-2222-2222-2222-222222220004'; -- Néfte

-- ---- catálogo de objetos -------------------------------------------
create table items (
    code        text primary key,
    name        text not null,
    description text not null default '',
    price_cp    bigint not null,
    category    text not null default 'útil'
);

insert into items (code, name, description, price_cp, category) values
('antorcha','Antorcha','Arde una hora y alumbra un buen trecho.',1,'útil'),
('aceite','Frasco de aceite','Para el farol, o para prenderlo bajo los pies de alguien.',10,'útil'),
('racion','Ración de viaje','Comida seca para un día en el camino.',50,'útil'),
('cuerda_canamo','Cuerda de cáñamo (15 m)','Aguanta a una persona. Muy socorrida en un pozo.',100,'útil'),
('piqueta','Piqueta de minero','Pesada, pero abre paso en la roca blanda.',200,'útil'),
('daga','Daga','Corta, se arroja y abre cartas selladas.',200,'arma'),
('farol','Farol con caperuza','Luz dirigible que no te delata tanto como una antorcha.',500,'útil'),
('pocion_curacion','Poción de curación menor','Cierra heridas y devuelve algo de Vigor.',5000,'consumible');

-- ---- ofertas de la tienda de Dorakan -------------------------------
create table shop_offers (
    id        uuid primary key,
    location  text not null,
    item_code text not null references items(code),
    price_cp  bigint not null,
    stock     int not null default -1
);
create index idx_offer_location on shop_offers(location);

insert into shop_offers (id, location, item_code, price_cp, stock) values
(gen_random_uuid(),'Dorakan','antorcha',1,-1),
(gen_random_uuid(),'Dorakan','aceite',10,-1),
(gen_random_uuid(),'Dorakan','racion',50,-1),
(gen_random_uuid(),'Dorakan','cuerda_canamo',100,-1),
(gen_random_uuid(),'Dorakan','piqueta',200,-1),
(gen_random_uuid(),'Dorakan','daga',220,-1),
(gen_random_uuid(),'Dorakan','farol',500,2),
(gen_random_uuid(),'Dorakan','pocion_curacion',5200,3);

-- ---- inventario del personaje --------------------------------------
create table inventory (
    id           uuid primary key,
    character_id uuid not null references characters(id),
    item_code    text not null references items(code),
    quantity     int not null
);
create index idx_inv_char on inventory(character_id);

-- Gorash empieza con algo en la bolsa
insert into inventory (id, character_id, item_code, quantity) values
(gen_random_uuid(),'22222222-2222-2222-2222-222222220001','cuerda_canamo',1),
(gen_random_uuid(),'22222222-2222-2222-2222-222222220001','antorcha',3),
(gen_random_uuid(),'22222222-2222-2222-2222-222222220001','racion',2);
