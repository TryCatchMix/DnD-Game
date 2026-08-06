-- =====================================================================
-- Aptitudes de clase de las clases marciales (no lanzan conjuros).
-- Datos del SRD 3.5 (contenido abierto OGL), traducidos.
-- Van en la pestaña "Habilidades" como su propia categoría.
-- =====================================================================
create table class_features (
    id          uuid primary key default gen_random_uuid(),
    clazz       varchar(40)  not null,
    name        varchar(80)  not null,
    level       int          not null,
    kind        varchar(40)  not null default '',
    description varchar(2000) not null default '',
    source      varchar(60)  not null default 'SRD 3.5'
);

create index idx_class_features_clazz on class_features(clazz);

-- ---------------------------- BÁRBARO --------------------------------
insert into class_features (id, clazz, name, level, kind, description) values
(gen_random_uuid(),'Bárbaro','Furia',1,'Extraordinaria','Al entrar en furia gana +4 a Fuerza, +4 a Constitución, +2 a las salvaciones de Voluntad y −2 a la CA. Dura 3 asaltos + su modificador (ya mejorado) de Constitución. Usos por día: 1 a nivel 1, y uno más a niveles 4, 8, 12, 16 y 20.'),
(gen_random_uuid(),'Bárbaro','Movimiento rápido',1,'Extraordinaria','+10 pies a la velocidad base, siempre que lleve armadura ligera o media (o ninguna) y no vaya sobrecargado.'),
(gen_random_uuid(),'Bárbaro','Esquiva asombrosa',2,'Extraordinaria','Conserva su bonificador de Destreza a la CA aunque le pillen desprevenido o le ataque un enemigo invisible.'),
(gen_random_uuid(),'Bárbaro','Sentido de las trampas',3,'Extraordinaria','+1 a Reflejos para evitar trampas y +1 de esquiva a la CA contra sus ataques. Mejora en +1 a niveles 6, 9, 12, 15 y 18.'),
(gen_random_uuid(),'Bárbaro','Esquiva asombrosa mejorada',5,'Extraordinaria','Ya no puede ser flanqueado, salvo por un pícaro con al menos cuatro niveles más que él.'),
(gen_random_uuid(),'Bárbaro','Reducción de daño',7,'Extraordinaria','Reducción de daño 1/—. Aumenta a 2/— a nivel 10, 3/— a 13, 4/— a 16 y 5/— a 19.'),
(gen_random_uuid(),'Bárbaro','Furia mayor',11,'Extraordinaria','Su furia pasa a dar +6 a Fuerza, +6 a Constitución y +3 a las salvaciones de Voluntad.'),
(gen_random_uuid(),'Bárbaro','Voluntad indómita',14,'Extraordinaria','Mientras está en furia gana +4 a las salvaciones de Voluntad contra conjuros y efectos de encantamiento.'),
(gen_random_uuid(),'Bárbaro','Furia incansable',17,'Extraordinaria','Ya no queda fatigado al terminar la furia.'),
(gen_random_uuid(),'Bárbaro','Furia poderosa',20,'Extraordinaria','Su furia pasa a dar +8 a Fuerza, +8 a Constitución y +4 a las salvaciones de Voluntad.');

-- ---------------------------- GUERRERO -------------------------------
insert into class_features (id, clazz, name, level, kind, description) values
(gen_random_uuid(),'Guerrero','Competencia con armas y armaduras',1,'Competencia','Competente con todas las armas sencillas y marciales, con todas las armaduras (ligera, media y pesada) y con todos los escudos, incluido el escudo de torre.'),
(gen_random_uuid(),'Guerrero','Dote adicional de guerrero',1,'Dote','Gana una dote adicional de combate (de la lista de dotes de guerrero) a nivel 1 y otra cada dos niveles: 2, 4, 6, 8, 10, 12, 14, 16, 18 y 20. Es lo que le permite especializarse mucho más que otras clases.');

-- ------------------------------ MONJE --------------------------------
insert into class_features (id, clazz, name, level, kind, description) values
(gen_random_uuid(),'Monje','Ráfaga de golpes',1,'Extraordinaria','Con una acción de asalto completo puede realizar un ataque sin armas adicional, a cambio de una penalización a todos sus ataques del asalto (−2 al principio; mejora al subir de nivel). Requiere armadura ligera o ninguna.'),
(gen_random_uuid(),'Monje','Golpe sin armas',1,'Extraordinaria','Sus golpes sin armas son letales y no provocan ataques de oportunidad. Daño: 1d6 a nivel 1, 1d8 a 4, 1d10 a 8, 2d6 a 12, 2d8 a 16 y 2d10 a 20 (tamaño Mediano).'),
(gen_random_uuid(),'Monje','Bonificador a la CA',1,'Extraordinaria','Sin armadura y sin carga, suma su modificador de Sabiduría (si es positivo) a la CA y a la CA de contacto. Además gana +1 de esquiva a la CA a niveles 5, 10, 15 y 20.'),
(gen_random_uuid(),'Monje','Golpe aturdidor',1,'Dote','Ataque sin armas que obliga a una salvación de Fortaleza (CD 10 + ½ nivel de monje + mod. de Sabiduría) o el objetivo queda aturdido 1 asalto. Usos por día: 1 cada 4 niveles de monje.'),
(gen_random_uuid(),'Monje','Evasión',2,'Extraordinaria','Si supera una salvación de Reflejos contra un efecto que haría la mitad de daño, no recibe ningún daño. Solo con armadura ligera o sin armadura.'),
(gen_random_uuid(),'Monje','Movimiento rápido',3,'Sobrenatural','+10 pies a la velocidad sin armadura, y aumenta con el nivel: +20 a 6, +30 a 9, +40 a 12, +50 a 15 y +60 a 18.'),
(gen_random_uuid(),'Monje','Mente inmóvil',3,'Extraordinaria','+2 a las salvaciones contra conjuros y efectos de la escuela de Encantamiento.'),
(gen_random_uuid(),'Monje','Golpe ki',4,'Sobrenatural','Sus golpes sin armas cuentan como mágicos para superar la reducción de daño. A nivel 10 cuentan además como legales y a nivel 16 como de adamantina.'),
(gen_random_uuid(),'Monje','Caída lenta',4,'Extraordinaria','Junto a una pared, trata las caídas como si fueran 20 pies más cortas. La distancia mejora con el nivel hasta anular por completo cualquier caída a nivel 20.'),
(gen_random_uuid(),'Monje','Pureza de cuerpo',5,'Extraordinaria','Inmune a todas las enfermedades, salvo las de origen mágico o sobrenatural.'),
(gen_random_uuid(),'Monje','Integridad de cuerpo',7,'Sobrenatural','Puede curarse a sí mismo hasta el doble de su nivel de monje en puntos de golpe al día, repartidos como quiera.'),
(gen_random_uuid(),'Monje','Evasión mejorada',9,'Extraordinaria','Como Evasión, pero además recibe solo la mitad del daño aunque falle la salvación de Reflejos.'),
(gen_random_uuid(),'Monje','Cuerpo de diamante',11,'Sobrenatural','Inmune a todos los venenos de cualquier tipo.'),
(gen_random_uuid(),'Monje','Ráfaga de golpes mayor',11,'Extraordinaria','Al usar ráfaga de golpes gana un ataque adicional al máximo bonificador de ataque base.'),
(gen_random_uuid(),'Monje','Paso abundante',12,'Sobrenatural','Puede teletransportarse una vez al día como el conjuro puerta dimensional (nivel de lanzador igual a la mitad de su nivel de monje).'),
(gen_random_uuid(),'Monje','Alma de diamante',13,'Extraordinaria','Gana resistencia a los conjuros igual a su nivel de monje + 10.'),
(gen_random_uuid(),'Monje','Palma temblorosa',15,'Sobrenatural','Una vez a la semana puede canalizar un golpe mortal: si acierta y el objetivo falla una salvación de Fortaleza (CD 10 + ½ nivel + mod. de Sabiduría), muere. Debe declararse antes de atacar.'),
(gen_random_uuid(),'Monje','Cuerpo eterno',17,'Extraordinaria','Ya no sufre penalizaciones de característica por envejecer ni puede ser envejecido mágicamente. Sigue muriendo de viejo al llegar su hora.'),
(gen_random_uuid(),'Monje','Lengua del sol y la luna',17,'Extraordinaria','Puede hablar con cualquier criatura viva que tenga un idioma.'),
(gen_random_uuid(),'Monje','Cuerpo vacío',19,'Sobrenatural','Puede volverse etéreo durante un número de asaltos al día igual a su nivel de monje, como el conjuro forma etérea.'),
(gen_random_uuid(),'Monje','Yo perfecto',20,'Sobrenatural','Pasa a ser un exterior (nativo): las curaciones y demás efectos lo tratan como tal, y gana reducción de daño 10/mágico.');
