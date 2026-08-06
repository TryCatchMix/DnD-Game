-- =====================================================================
-- El grimorio: hechizos y qué clase los aprende (y a qué nivel).
-- =====================================================================

create table spells (
    id          uuid primary key,
    name        text not null unique,
    school      text not null,
    description text not null
);

create table spell_classes (
    id       uuid primary key,
    spell_id uuid not null references spells(id),
    clazz    text not null,
    level    int  not null
);
create index idx_spellclass_spell on spell_classes(spell_id);

insert into spells (id, name, school, description) values
(gen_random_uuid(),'Curar heridas leves','Conjuración','Con un toque cierras heridas y devuelves 1d8 puntos de golpe (más 1 por nivel).'),
(gen_random_uuid(),'Curar heridas graves','Conjuración','Un toque que restaura 3d8 puntos de golpe (más 1 por nivel).'),
(gen_random_uuid(),'Bendición','Encantamiento','Tus aliados cercanos ganan +1 al ataque y a los tiros de salvación contra el miedo.'),
(gen_random_uuid(),'Escudo de la fe','Abjuración','Un halo de fe concede al objetivo un bono de +2 a la Clase de Armadura.'),
(gen_random_uuid(),'Detectar el mal','Adivinación','Percibes auras malignas en un cono y calibras su intensidad.'),
(gen_random_uuid(),'Silencio','Ilusión','Una esfera queda muda: dentro no hay ruido ni conjuros con componente verbal.'),
(gen_random_uuid(),'Restablecimiento menor','Conjuración','Cura fatiga y penalizadores temporales a características.'),
(gen_random_uuid(),'Disipar magia','Abjuración','Cancela conjuros y efectos mágicos sobre un objetivo o en un área.'),
(gen_random_uuid(),'Columna de fuego','Evocación','Una columna de llamas divinas cae del cielo e inflige 1d6 por nivel.'),
(gen_random_uuid(),'Resurrección','Conjuración','Devuelves a la vida a un muerto aunque solo quede un resto de su cuerpo.'),
(gen_random_uuid(),'Proyectil mágico','Evocación','Dardos de fuerza que golpean sin fallar: 1d4+1 de daño cada uno.'),
(gen_random_uuid(),'Armadura de mago','Conjuración','Una armadura invisible de fuerza otorga un bono de +4 a la Clase de Armadura.'),
(gen_random_uuid(),'Manos ardientes','Evocación','Un abanico de llamas surge de tus dedos e inflige 1d4 por nivel.'),
(gen_random_uuid(),'Sueño','Encantamiento','Sume en un sueño mágico a varios enemigos de pocos dados de golpe.'),
(gen_random_uuid(),'Detectar magia','Adivinación','Ves auras mágicas y su escuela en aquello que observas.'),
(gen_random_uuid(),'Invisibilidad','Ilusión','El objetivo desaparece de la vista hasta que ataca o el conjuro acaba.'),
(gen_random_uuid(),'Bola de fuego','Evocación','Una explosión ardiente a distancia inflige 1d6 por nivel en un área.'),
(gen_random_uuid(),'Relámpago','Evocación','Un rayo recto abrasa todo lo que cruza su línea: 1d6 por nivel.'),
(gen_random_uuid(),'Vuelo','Transmutación','El objetivo vuela con soltura durante un minuto por nivel.'),
(gen_random_uuid(),'Puerta dimensional','Conjuración','Te transportas al instante a un punto cercano que puedas señalar.'),
(gen_random_uuid(),'Teleportar','Conjuración','Viajas al instante a un lugar lejano que hayas visto antes.'),
(gen_random_uuid(),'Enmarañar','Transmutación','Hierbas y plantas cobran vida y atrapan a quienes pisan la zona.'),
(gen_random_uuid(),'Piel robliza','Transmutación','La piel del objetivo se endurece como corteza: +2 (o más) a la Clase de Armadura.'),
(gen_random_uuid(),'Llamar al rayo','Evocación','Desde una tormenta descargas rayos que infligen 3d6 cada uno.'),
(gen_random_uuid(),'Fascinar','Encantamiento','Cautivas con tu arte a quienes te escuchan, que quedan absortos y quietos.'),
(gen_random_uuid(),'Sugestión','Encantamiento','Deslizas una idea razonable en la mente de alguien, que la cumple como propia.');

-- ---- qué clase aprende cada hechizo, y a qué nivel -----------------
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Clérigo',1),('Druida',1),('Bardo',1)) as c(clazz,level) where name='Curar heridas leves';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Clérigo',3),('Druida',3),('Bardo',3)) as c(clazz,level) where name='Curar heridas graves';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Clérigo',1),('Paladín',1)) as c(clazz,level) where name='Bendición';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, 'Clérigo', 1 from spells where name='Escudo de la fe';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, 'Clérigo', 1 from spells where name='Detectar el mal';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Clérigo',2),('Bardo',2)) as c(clazz,level) where name='Silencio';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Clérigo',2),('Druida',2),('Paladín',1)) as c(clazz,level) where name='Restablecimiento menor';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Clérigo',3),('Mago',3),('Hechicero',3),('Druida',4),('Bardo',3)) as c(clazz,level) where name='Disipar magia';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Clérigo',5),('Druida',5)) as c(clazz,level) where name='Columna de fuego';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, 'Clérigo', 7 from spells where name='Resurrección';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Mago',1),('Hechicero',1)) as c(clazz,level) where name='Proyectil mágico';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Mago',1),('Hechicero',1)) as c(clazz,level) where name='Armadura de mago';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Mago',1),('Hechicero',1)) as c(clazz,level) where name='Manos ardientes';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Mago',1),('Hechicero',1),('Bardo',1)) as c(clazz,level) where name='Sueño';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Mago',0),('Hechicero',0),('Bardo',0)) as c(clazz,level) where name='Detectar magia';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Mago',2),('Hechicero',2),('Bardo',2)) as c(clazz,level) where name='Invisibilidad';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Mago',3),('Hechicero',3)) as c(clazz,level) where name='Bola de fuego';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Mago',3),('Hechicero',3)) as c(clazz,level) where name='Relámpago';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Mago',3),('Hechicero',3)) as c(clazz,level) where name='Vuelo';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Mago',4),('Hechicero',4),('Bardo',4)) as c(clazz,level) where name='Puerta dimensional';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Mago',5),('Hechicero',5)) as c(clazz,level) where name='Teleportar';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, 'Druida', 1 from spells where name='Enmarañar';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Druida',2),('Explorador',2)) as c(clazz,level) where name='Piel robliza';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, 'Druida', 3 from spells where name='Llamar al rayo';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, 'Bardo', 1 from spells where name='Fascinar';
insert into spell_classes (id, spell_id, clazz, level)
select gen_random_uuid(), id, c.clazz, c.level from spells, (values
  ('Bardo',2),('Mago',3),('Hechicero',3)) as c(clazz,level) where name='Sugestión';
