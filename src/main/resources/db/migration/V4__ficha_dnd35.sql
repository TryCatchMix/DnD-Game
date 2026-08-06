-- =====================================================================
-- Hoja de personaje D&D 3.5: características, combate, salvaciones, etc.
-- + habilidades con rangos + Alisander (el de la foto).
-- =====================================================================

-- ---- nuevos campos de la ficha -------------------------------------
alter table characters
  add column player           text not null default '',
  add column race             text not null default '',
  add column alignment        text not null default '',
  add column deity            text not null default '',
  add column size             text not null default 'Mediano',
  add column age              text not null default '',
  add column sex              text not null default '',
  add column height           text not null default '',
  add column weight           text not null default '',
  add column campaign         text not null default '',
  add column str_score        int  not null default 10,
  add column dex_score        int  not null default 10,
  add column con_score        int  not null default 10,
  add column int_score        int  not null default 10,
  add column wis_score        int  not null default 10,
  add column cha_score        int  not null default 10,
  add column hp_current       int  not null default 0,
  add column ac_touch         int  not null default 10,
  add column ac_flat_footed   int  not null default 10,
  add column initiative_misc  int  not null default 0,
  add column speed            int  not null default 30,
  add column bab              int  not null default 0,
  add column grapple_misc     int  not null default 0,
  add column spell_resistance int  not null default 0,
  add column save_fort        int  not null default 0,
  add column save_ref         int  not null default 0,
  add column save_will        int  not null default 0,
  add column damage_reduction text not null default '';

-- ---- valores comunes de los cuatro ya existentes -------------------
update characters set hp_current = pg, player = 'Mix', campaign = 'Ciudades Libres';

-- Gorash (Bárbaro)
update characters set
  str_score=16, dex_score=13, con_score=15, int_score=8, wis_score=12, cha_score=10,
  ac_touch=11, ac_flat_footed=14, bab=3, save_fort=5, save_ref=2, save_will=2, speed=30,
  race='Semiorco', alignment='Caótico Neutral', deity='Ninguno',
  age='24', sex='Macho', height='1,90 m', weight='95 kg'
where id = '22222222-2222-2222-2222-222222220001';

-- Sivil (Pícara)
update characters set
  str_score=10, dex_score=17, con_score=12, int_score=13, wis_score=11, cha_score=14,
  ac_touch=13, ac_flat_footed=12, bab=2, save_fort=1, save_ref=6, save_will=1, speed=30,
  race='Media elfa', alignment='Neutral', deity='Olidammara',
  age='27', sex='Hembra', height='1,68 m', weight='58 kg'
where id = '22222222-2222-2222-2222-222222220002';

-- Alcaeus (Clérigo)
update characters set
  str_score=12, dex_score=10, con_score=13, int_score=11, wis_score=16, cha_score=13,
  ac_touch=10, ac_flat_footed=16, bab=2, save_fort=5, save_ref=1, save_will=6, speed=20,
  race='Humano', alignment='Legal Bueno', deity='Heironeous',
  age='35', sex='Macho', height='1,80 m', weight='82 kg'
where id = '22222222-2222-2222-2222-222222220003';

-- Néfte (Maga)
update characters set
  str_score=8, dex_score=14, con_score=12, int_score=17, wis_score=12, cha_score=10,
  ac_touch=12, ac_flat_footed=10, bab=1, save_fort=1, save_ref=2, save_will=3, speed=30,
  race='Humana', alignment='Neutral', deity='Boccob',
  age='22', sex='Hembra', height='1,65 m', weight='54 kg'
where id = '22222222-2222-2222-2222-222222220004';

-- ---- habilidades: pasar de un modificador plano a rangos -----------
alter table character_skills
  add column key_ability text not null default '',
  add column ranks       int  not null default 0,
  add column misc_mod    int  not null default 0;

update character_skills set ranks = modifier;
alter table character_skills drop column modifier;

-- ---- Alisander (el de la foto): Clérigo de Pelor -------------------
insert into characters
 (id, user_id, name, clazz, city, level, vigor, max_vigor, pg, ca, bolsa, carga, purse_cp,
  player, race, alignment, deity, size, age, sex, height, weight, campaign,
  str_score, dex_score, con_score, int_score, wis_score, cha_score,
  hp_current, ac_touch, ac_flat_footed, initiative_misc, speed, bab, grapple_misc,
  spell_resistance, save_fort, save_ref, save_will, damage_reduction)
values
 ('22222222-2222-2222-2222-222222220005','11111111-1111-1111-1111-111111111111',
  'Alisander','Clérigo','Dorakan',1,8,8,70,20,'','61 lb / 86 lb ligera',5000,
  'Mix','Humano','Neutral Bueno','Pelor','Mediano','Adulto','Macho','1,85 m','150 kg','Ciudades Libres',
  14,12,15,11,20,11,
  70,13,19,0,20,0,0,
  0,4,1,7,'1/—');

insert into character_skills (id, character_id, name, code, key_ability, ranks, misc_mod) values
(gen_random_uuid(),'22222222-2222-2222-2222-222222220005','Diplomacia','diplomacia','CAR',1,0),
(gen_random_uuid(),'22222222-2222-2222-2222-222222220005','Saber (Historia)','saber_historia','INT',3,0),
(gen_random_uuid(),'22222222-2222-2222-2222-222222220005','Saber (Religión)','saber_religion','INT',4,0),
(gen_random_uuid(),'22222222-2222-2222-2222-222222220005','Concentración','concentracion','CON',4,0),
(gen_random_uuid(),'22222222-2222-2222-2222-222222220005','Sanar','sanar','SAB',4,0),
(gen_random_uuid(),'22222222-2222-2222-2222-222222220005','Percepción','percepcion','SAB',5,0),
(gen_random_uuid(),'22222222-2222-2222-2222-222222220005','Avistar','avistar','SAB',0,0);
