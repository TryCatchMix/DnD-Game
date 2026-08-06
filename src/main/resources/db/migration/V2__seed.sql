-- =====================================================================
-- Datos de arranque. Cuadran con lo que comprueba probar.sh:
--   · usuario mix@trycatchmix.com / archivos (DM)
--   · Gorash con Trepar +7
--   · un encargo AVAILABLE y otro BLOCKED_BY_WORLD (falta el Puente Norte)
-- =====================================================================

-- ---- usuario (contraseña: archivos) ---------------------------------
insert into users (id, email, password_hash, display_name, role) values
('11111111-1111-1111-1111-111111111111',
 'mix@trycatchmix.com',
 '$2b$10$UbCIqdSjeXcPjed/mHmoPe4Sd1z9cjSQF0HP9I8KwYWlYJj8JAaPO',
 'Mix', 'DM');

-- ---- los cuatro del libro (todos bajo la cuenta de Mix) -------------
insert into characters (id, user_id, name, clazz, city, level, vigor, max_vigor, pg, ca, bolsa, carga) values
('22222222-2222-2222-2222-222222220001','11111111-1111-1111-1111-111111111111','Gorash','Bárbaro','Dorakan',3,6,8,34,15,'214 po · 6 pp · 2 pc','61 lb / 86 lb ligera'),
('22222222-2222-2222-2222-222222220002','11111111-1111-1111-1111-111111111111','Sivil','Pícara','Dorakan',3,7,7,22,14,'88 po · 2 pp','23 lb / 60 lb ligera'),
('22222222-2222-2222-2222-222222220003','11111111-1111-1111-1111-111111111111','Alcaeus','Clérigo','Dorakan',3,8,8,28,16,'130 po','40 lb / 75 lb ligera'),
('22222222-2222-2222-2222-222222220004','11111111-1111-1111-1111-111111111111','Néfte','Maga','Dorakan',3,5,6,18,12,'56 po · 4 pp','14 lb / 45 lb ligera');

-- ---- habilidades (Gorash: Trepar +7, como el mockup) ----------------
insert into character_skills (id, character_id, name, code, modifier) values
(gen_random_uuid(),'22222222-2222-2222-2222-222222220001','Trepar','trepar',7),
(gen_random_uuid(),'22222222-2222-2222-2222-222222220001','Atletismo','atletismo',6),
(gen_random_uuid(),'22222222-2222-2222-2222-222222220001','Intimidar','intimidar',5),
(gen_random_uuid(),'22222222-2222-2222-2222-222222220001','Percepción','percepcion',3),
(gen_random_uuid(),'22222222-2222-2222-2222-222222220002','Sigilo','sigilo',8),
(gen_random_uuid(),'22222222-2222-2222-2222-222222220002','Trepar','trepar',4),
(gen_random_uuid(),'22222222-2222-2222-2222-222222220003','Religión','religion',6),
(gen_random_uuid(),'22222222-2222-2222-2222-222222220003','Medicina','medicina',5),
(gen_random_uuid(),'22222222-2222-2222-2222-222222220004','Arcanos','arcanos',7),
(gen_random_uuid(),'22222222-2222-2222-2222-222222220004','Historia','historia',6);

-- ---- el estado del mundo -------------------------------------------
insert into world_flags (flag_key, state) values
('puente_norte_en_pie', false);

-- ---- encargos -------------------------------------------------------
insert into quests
 (id, code, title, hook, location, faction, vigor_cost, duration, scene_count,
  reward_note, min_level, published, required_flag, required_flag_state, requirement_label, skill_tags)
values
('33333333-3333-3333-3333-333333330001','silencio_minas','El silencio de las minas',
 'Hace once días que no sube nadie del pozo tercero.','Dorakan','Gremio de Mineros',
 2,'6 h',2,'120 po · favor del Gremio',1,true,null,null,null,'Trepar,Atletismo'),
('33333333-3333-3333-3333-333333330002','procesion_farolero','La procesión del Farolero',
 'El Farol quiere cruzar al arrabal en fila y con antorchas.','Dorakan','El Farol',
 3,'1 día',1,'Favor del Farol',1,true,'puente_norte_en_pie',true,'Requiere: Puente Norte en pie',null);

-- ---- escenas de El silencio de las minas ---------------------------
insert into scenes (id, quest_id, ordinal, title, body, final_scene) values
('44444444-4444-4444-4444-444444440001','33333333-3333-3333-3333-333333330001',1,
 'Hay una jaula de bajada y no funciona',
 'El cable de la jaula está cortado a mano, no gastado. Alguien no quería que bajara nadie. El pozo respira aire frío desde abajo.',false),
('44444444-4444-4444-4444-444444440002','33333333-3333-3333-3333-333333330001',2,
 'El fondo del pozo',
 'Abajo huele a lámpara apagada y a algo peor. Las vagonetas siguen cargadas. Del turno perdido no queda nadie de pie.',true);

-- escena del Farolero (nunca se juega mientras esté bloqueada)
insert into scenes (id, quest_id, ordinal, title, body, final_scene) values
('44444444-4444-4444-4444-4444444400f1','33333333-3333-3333-3333-333333330002',1,
 'La cabeza de la procesión',
 'Las antorchas esperan en la plaza a que alguien dé la orden de avanzar.',true);

-- ---- opciones de la escena 1 ---------------------------------------
insert into scene_options (id, scene_id, ordinal, label, skill, dc, vigor_cost, risk, note) values
('55555555-5555-5555-5555-555555550001','44444444-4444-4444-4444-444444440001',1,
 'Bajar a pulso por el cable','trepar',18,1,'HIGH','El cable está cortado a mano, no gastado.'),
('55555555-5555-5555-5555-555555550002','44444444-4444-4444-4444-444444440001',2,
 'Buscar otra vía de bajada','atletismo',14,1,'MEDIUM',null),
('55555555-5555-5555-5555-555555550003','44444444-4444-4444-4444-444444440001',3,
 'Volver arriba y avisar al capataz',null,null,0,null,'Sin tirada: cierras el encargo sin bajar.');

-- modificador del desglose de la opción 1
insert into option_modifiers (id, option_id, label, value) values
(gen_random_uuid(),'55555555-5555-5555-5555-555555550001','Cable resbaladizo',-2);

-- desenlaces de la opción 1 (los cinco grados)
insert into outcomes (id, option_id, grade, narrative, next_scene_id, ends_quest) values
(gen_random_uuid(),'55555555-5555-5555-5555-555555550001',1,'El cable cede a los diez metros y caes al fondo. Te sacan medio roto.',null,true),
(gen_random_uuid(),'55555555-5555-5555-5555-555555550001',2,'No pasas de los primeros metros. Hoy el pozo gana.',null,true),
(gen_random_uuid(),'55555555-5555-5555-5555-555555550001',3,'Aguantas treinta metros y llegas magullado pero entero.','44444444-4444-4444-4444-444444440002',false),
(gen_random_uuid(),'55555555-5555-5555-5555-555555550001',4,'Bajas limpio hasta el fondo.','44444444-4444-4444-4444-444444440002',false),
(gen_random_uuid(),'55555555-5555-5555-5555-555555550001',5,'Bajas como si fuera una escalera de tu casa.','44444444-4444-4444-4444-444444440002',false);

-- desenlaces de la opción 2
insert into outcomes (id, option_id, grade, narrative, next_scene_id, ends_quest) values
(gen_random_uuid(),'55555555-5555-5555-5555-555555550002',1,'Resbalas en la rampa y te tuerces un tobillo. Fuera del encargo.',null,true),
(gen_random_uuid(),'55555555-5555-5555-5555-555555550002',2,'La vía está peor de lo que parecía. No hay bajada por ahí.',null,true),
(gen_random_uuid(),'55555555-5555-5555-5555-555555550002',3,'Encuentras un paso estrecho y bajas con esfuerzo.','44444444-4444-4444-4444-444444440002',false),
(gen_random_uuid(),'55555555-5555-5555-5555-555555550002',4,'Das con una escalera de servicio olvidada.','44444444-4444-4444-4444-444444440002',false),
(gen_random_uuid(),'55555555-5555-5555-5555-555555550002',5,'Bajas rápido y sin un rasguño.','44444444-4444-4444-4444-444444440002',false);

-- desenlace de la opción 3 (sin tirada)
insert into outcomes (id, option_id, grade, narrative, next_scene_id, ends_quest) values
(gen_random_uuid(),'55555555-5555-5555-5555-555555550003',4,'Vuelves arriba y avisas al capataz. El encargo queda para otro día.',null,true);

-- ---- opción de la escena 2 (final) ---------------------------------
insert into scene_options (id, scene_id, ordinal, label, skill, dc, vigor_cost, risk, note) values
('55555555-5555-5555-5555-555555550021','44444444-4444-4444-4444-444444440002',1,
 'Recoger lo que quede y salir',null,null,0,null,null);
insert into outcomes (id, option_id, grade, narrative, next_scene_id, ends_quest) values
(gen_random_uuid(),'55555555-5555-5555-5555-555555550021',4,'Recoges lo del turno perdido y subes a la luz. Se acabó.',null,true);

-- ---- opción de la escena del Farolero ------------------------------
insert into scene_options (id, scene_id, ordinal, label, skill, dc, vigor_cost, risk, note) values
('55555555-5555-5555-5555-5555555500f1','44444444-4444-4444-4444-4444444400f1',1,
 'Dar la orden de avanzar',null,null,0,null,null);
insert into outcomes (id, option_id, grade, narrative, next_scene_id, ends_quest) values
(gen_random_uuid(),'55555555-5555-5555-5555-5555555500f1',4,'La procesión avanza hacia el arrabal.',null,true);
