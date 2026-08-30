-- =====================================================================
-- Condiciones, enfermedades y venenos del SRD 3.5 (contenido abierto OGL).
--
-- Las tres cosas se consultan a media pelea y hasta ahora no estaban en
-- ningún sitio: el bestiario dice "veneno" y "enfermedad" sin decir la CD, y
-- "aturdido" o "derribado" se discutían de memoria.
--
-- Como las dotes, están traducidas ENTERAS: son textos de dos o tres frases.
-- =====================================================================
create table if not exists conditions (
    id          uuid primary key default gen_random_uuid(),
    name        varchar(80)  not null unique,
    name_en     varchar(80)  not null default '',
    description text         not null default '',
    source      varchar(60)  not null default 'SRD 3.5'
);

create table if not exists diseases (
    id          uuid primary key default gen_random_uuid(),
    name        varchar(80)  not null unique,
    name_en     varchar(80)  not null default '',
    -- Ingerida | Inhalada | Herida | Contacto
    infection   varchar(40)  not null default '',
    dc          int          not null default 0,
    incubation  varchar(60)  not null default '',
    damage      varchar(120) not null default '',
    -- las aclaraciones que el SRD pone al pie de la tabla
    notes       text         not null default '',
    source      varchar(60)  not null default 'SRD 3.5'
);

create table if not exists poisons (
    id               uuid primary key default gen_random_uuid(),
    name             varchar(80)  not null unique,
    name_en          varchar(80)  not null default '',
    -- Contacto | Ingerido | Inhalado | Herida
    kind             varchar(40)  not null default '',
    dc               int          not null default 0,
    initial_damage   varchar(120) not null default '',
    secondary_damage varchar(120) not null default '',
    -- en piezas de cobre, como el resto de la app
    price_cp         bigint       not null default 0,
    source           varchar(60)  not null default 'SRD 3.5'
);

-- ------------------------- condiciones ------------------------
insert into conditions (name, name_en, description) values
('Característica dañada', 'Ability Damaged', 'Has perdido puntos de una característica de forma temporal: se recuperan solos a razón de 1 punto por noche de descanso (2 si descansas el día entero). Aplica el nuevo modificador a todo lo que dependa de ella. Si la Fuerza llega a 0 no puedes moverte; si es la Destreza, quedas paralizado; si es la Constitución, mueres. Inteligencia, Sabiduría o Carisma a 0 te dejan inconsciente.'),
('Característica succionada', 'Ability Drained', 'Como el daño a una característica, pero la pérdida es PERMANENTE: no se cura descansando, solo con magia. Se aplica igual a todo lo que dependa de esa característica.'),
('Cegado', 'Blinded', 'No ves nada. −2 a la CA, pierdes tu bonificador de Destreza a la CA, te mueves a la mitad de velocidad y sufres −4 a Buscar y a casi toda prueba de habilidad basada en Fuerza o Destreza. Todo lo que dependa de la vista falla automáticamente. Para ti, todos tus enemigos tienen ocultación total: 50% de fallo.'),
('Arrastrado por el viento', 'Blown Away', 'El vendaval te tira y te hace rodar por el suelo 1d4×10 pies, con 1d4 de daño no letal por cada 10 pies. Si vuelas, te lleva 2d6×10 pies hacia atrás y sufres 2d6 de daño no letal.'),
('Frenado', 'Checked', 'El viento te impide avanzar contra él. A pie no puedes moverte hacia el viento; volando, retrocedes 1d6×5 pies.'),
('Confundido', 'Confused', 'No decides tú: cada asalto tira 1d100. 01-25 actúa con normalidad; 26-50 no hace nada y balbucea; 51-75 se hiere a sí mismo con lo que lleve en la mano; 76-100 ataca a la criatura más cercana. Si alguien te ataca, atacas a quien te atacó hasta que deje de hacerlo.'),
('Acobardado', 'Cowering', 'El miedo te tiene clavado: no haces nada, y encima quedas indefenso (−2 a la CA y sin bonificador de Destreza).'),
('Aturullado', 'Dazed', 'No puedes hacer nada durante un asalto, pero te defiendes con normalidad: conservas tu CA y tu bonificador de Destreza. Normalmente dura un solo asalto.'),
('Deslumbrado', 'Dazzled', 'La luz te ha dado de lleno: −1 a las tiradas de ataque, a Buscar y a Avistar.'),
('Muerto', 'Dead', 'Tus puntos de golpe han bajado de −10, o has muerto de golpe por un efecto que mata. No puedes hacer nada. El alma se marcha del cuerpo y hace falta magia para traerla de vuelta.'),
('Ensordecido', 'Deafened', 'No oyes: −4 a la iniciativa, fallas automáticamente las pruebas de Escuchar y tienes un 20% de probabilidad de fallar al lanzar un conjuro con componente verbal.'),
('Incapacitado', 'Disabled', 'Estás exactamente a 0 puntos de golpe. Puedes hacer una acción de movimiento o una estándar por asalto, pero si haces algo agotador (atacar, correr, lanzar un conjuro) pierdes 1 punto de golpe al terminarla y pasas a moribundo.'),
('Moribundo', 'Dying', 'Entre −1 y −9 puntos de golpe, inconsciente y sin poder hacer nada. Cada asalto pierdes 1 punto de golpe hasta morir, salvo que te estabilices: tira d% cada asalto, con un 10% de estabilizarte solo. Otro puede estabilizarte con una prueba de Sanar CD 15.'),
('Con energía succionada', 'Energy Drained', 'Tienes uno o más niveles negativos. Cada uno da −1 a las tiradas de ataque, de salvación, de habilidad y de característica, −5 puntos de golpe y −1 al nivel efectivo. Un lanzador pierde además un conjuro del nivel más alto que pueda lanzar. Si acumulas tantos niveles negativos como tu nivel, mueres. A las 24 horas hay que salvar por Fortaleza: si superas, el nivel negativo se va; si fallas, se vuelve permanente.'),
('Enredado', 'Entangled', 'Te mueves a la mitad de velocidad, no puedes correr ni cargar, sufres −2 al ataque y −4 a la Destreza efectiva. Si estás enredado a algo fijo, no puedes moverte. Lanzar un conjuro exige una prueba de Concentración CD 15 + nivel del conjuro.'),
('Exhausto', 'Exhausted', 'Te mueves a la mitad de velocidad y sufres −6 a Fuerza y Destreza. Tras una hora de descanso completo pasas a fatigado.'),
('Fascinado', 'Fascinated', 'Algo te tiene absorto: te quedas quieto mirándolo, con −4 a las pruebas de reacción (Avistar, Escuchar). Cualquier amenaza obvia rompe el efecto, y una sacudida amistosa también, gastando una acción estándar.'),
('Fatigado', 'Fatigued', 'No puedes correr ni cargar, y sufres −2 a Fuerza y Destreza. Descansar ocho horas lo quita. Si te fatigas estando ya fatigado, pasas a exhausto.'),
('Desprevenido', 'Flat-Footed', 'Antes de tu primer turno del combate, o cuando te pillan de improviso: pierdes tu bonificador de Destreza a la CA y no puedes hacer ataques de oportunidad.'),
('Asustado', 'Frightened', 'Huyes de lo que te asusta lo mejor que puedas. Si no puedes huir, peleas con −2 a los ataques, las salvaciones, las pruebas de habilidad y las de característica. Es peor que estremecido y mejor que aterrado.'),
('En presa', 'Grappling', 'Estás agarrado cuerpo a cuerpo. Pierdes tu bonificador de Destreza contra todo el que no esté en la presa, no puedes usar armas de dos manos ni la mayoría de los conjuros, y solo atacas con armas ligeras o sin armas.'),
('Indefenso', 'Helpless', 'Paralizado, dormido, inconsciente, atado o a merced de otro. Cuentas con Destreza efectiva 0 (−5 al modificador), y quien te ataque cuerpo a cuerpo gana +4. Además te pueden dar el golpe de gracia.'),
('Incorpóreo', 'Incorporeal', 'No tienes cuerpo físico. Solo te dañan otras criaturas incorpóreas, las armas mágicas, los conjuros y los efectos sobrenaturales, y aun así hay un 50% de ignorar el daño de un conjuro que no sea de fuerza. Atraviesas objetos sólidos a voluntad.'),
('Invisible', 'Invisible', 'No se te ve: +2 a las tiradas de ataque contra enemigos videntes y les niegas su bonificador de Destreza a la CA.'),
('Tumbado por el viento', 'Knocked Down', 'El vendaval te derriba. Quedas en el suelo, y sufres 1d3 de daño no letal si además te arrastra.'),
('Nauseado', 'Nauseated', 'Estás a punto de vomitar: lo único que puedes hacer es una acción de movimiento al asalto. No puedes atacar, ni lanzar conjuros, ni concentrarte, ni nada que exija atención.'),
('Aterrado', 'Panicked', 'Sueltas lo que llevas y huyes a toda velocidad de lo que te aterra, con −2 a las salvaciones, las pruebas de habilidad y las de característica. Si te acorralan, te acobardas. Puedes usar conjuros y aptitudes que te ayuden a huir.'),
('Paralizado', 'Paralyzed', 'Estás congelado en el sitio: Fuerza y Destreza efectivas 0, indefenso, no puedes hacer nada. Aún puedes actuar mentalmente. Un aliado puede levantarte y moverte, pero pesas como un peso muerto.'),
('Petrificado', 'Petrified', 'Te has convertido en piedra: inconsciente e indefenso. Si la estatua se rompe y luego te devuelven a la carne, quedas mutilado o muerto.'),
('Inmovilizado', 'Pinned', 'Sujeto en el suelo dentro de una presa. Estás tumbado, no puedes moverte, pierdes tu bonificador de Destreza y solo puedes intentar zafarte o hablar. No estás indefenso del todo, pero casi.'),
('En el suelo', 'Prone', 'Estás tirado. −4 al ataque cuerpo a cuerpo y no puedes usar la mayoría de las armas a distancia. Contra ataques cuerpo a cuerpo tienes −4 a la CA; contra los de distancia, +4. Levantarte es una acción de movimiento que provoca ataques de oportunidad.'),
('Estremecido', 'Shaken', '−2 a las tiradas de ataque, a las salvaciones, a las pruebas de habilidad y a las de característica. Es el escalón más suave del miedo.'),
('Mareado', 'Sickened', '−2 a las tiradas de ataque, de daño, de salvación, de habilidad y de característica.'),
('Estabilizado', 'Stable', 'Estabas moribundo y has dejado de perder puntos de golpe. Sigues inconsciente. Tienes un 10% por hora de recuperar el conocimiento; si no, sigues estable hasta que alguien te cure.'),
('Tambaleante', 'Staggered', 'Tu daño no letal iguala a tus puntos de golpe actuales. Solo puedes hacer una acción estándar o una de movimiento por asalto, no las dos. Si el daño no letal los supera, caes inconsciente.'),
('Aturdido', 'Stunned', 'Sueltas lo que llevas en la mano, no puedes actuar, pierdes tu bonificador de Destreza a la CA y sufres −2 a la CA.'),
('Expulsado', 'Turned', 'Un clérigo te ha expulsado: huyes de él tan lejos y tan rápido como puedas durante 10 asaltos. Si no puedes huir, te acobardas.'),
('Inconsciente', 'Unconscious', 'Estás fuera de combate y no puedes hacer nada, indefenso. Puede ser por daño, por daño no letal o por un conjuro.')
on conflict (name) do nothing;

-- ------------------------ enfermedades ------------------------
insert into diseases (name, name_en, infection, dc, incubation, damage, notes) values
('Mal de la ceguera', 'Blinding sickness', 'Ingerida', 16, '1d3 días', '1d4 Fue', 'Si el daño a la Fuerza es de 2 o más, hay que salvar otra vez por Fortaleza (CD 16) o quedarse ciego para siempre.'),
('Fiebre de la risa', 'Cackle fever', 'Inhalada', 16, '1 día', '1d6 Sab', ''),
('Fiebre demoníaca', 'Demon fever', 'Herida', 18, '1 día', '1d6 Con', 'Cada punto de daño a la Constitución exige otra salvación de Fortaleza (CD 18) o ese punto se pierde para siempre.'),
('Escalofríos del diablo', 'Devil chills', 'Herida', 14, '1d4 días', '1d4 Fue', 'Hacen falta tres salvaciones seguidas para librarse, no dos.'),
('Fiebre de la inmundicia', 'Filth fever', 'Herida', 12, '1d3 días', '1d3 Des y 1d3 Con', ''),
('Fuego mental', 'Mindfire', 'Inhalada', 12, '1 día', '1d4 Int', ''),
('Podredumbre de momia', 'Mummy rot', 'Contacto', 20, '1 día', '1d6 Con', 'No se cura sola: hay que quitarla con magia (curar enfermedad) antes de poder recuperar los puntos perdidos.'),
('Dolor rojo', 'Red ache', 'Herida', 15, '1d3 días', '1d6 Fue', ''),
('Temblores', 'Shakes', 'Contacto', 13, '1 día', '1d8 Des', ''),
('Perdición viscosa', 'Slimy doom', 'Contacto', 14, '1 día', '1d4 Con', '')
on conflict (name) do nothing;

-- -------------------------- venenos ---------------------------
insert into poisons (name, name_en, kind, dc, initial_damage, secondary_damage, price_cp) values
('Nitharit', 'Nitharit', 'Contacto', 13, '—', '3d6 Con', 65000),
('Residuo de hoja de sassone', 'Sassone leaf residue', 'Contacto', 16, '2d12 pg', '1d6 Con', 30000),
('Pasta de raíz de malyss', 'Malyss root paste', 'Contacto', 16, '1 Des', '2d4 Des', 50000),
('Raíz de terinav', 'Terinav root', 'Contacto', 16, '1d6 Des', '2d6 Des', 75000),
('Extracto de loto negro', 'Black lotus extract', 'Contacto', 20, '3d6 Con', '3d6 Con', 450000),
('Bilis de dragón', 'Dragon bile', 'Contacto', 26, '3d6 Fue', '—', 150000),
('Seta rayada', 'Striped toadstool', 'Ingerido', 11, '1 Sab', '2d6 Sab y 1d4 Int', 18000),
('Arsénico', 'Arsenic', 'Ingerido', 13, '1 Con', '1d8 Con', 12000),
('Musgo del ello', 'Id moss', 'Ingerido', 14, '1d4 Int', '2d6 Int', 12500),
('Aceite de taggit', 'Oil of taggit', 'Ingerido', 15, '—', 'Inconsciencia', 9000),
('Polvo de liche', 'Lich dust', 'Ingerido', 17, '2d6 Fue', '1d6 Fue', 25000),
('Polvo del segador oscuro', 'Dark reaver powder', 'Ingerido', 18, '2d6 Con', '1d6 Con y 1d6 Fue', 30000),
('Polvo de ungol', 'Ungol dust', 'Inhalado', 15, '1 Car', '1d6 Car y 1 Car permanente', 100000),
('Bruma de la locura', 'Insanity mist', 'Inhalado', 15, '1d4 Sab', '2d6 Sab', 150000),
('Vapores de othur quemado', 'Burnt othur fumes', 'Inhalado', 18, '1 Con permanente', '3d6 Con', 210000),
('Veneno de víbora negra', 'Black adder venom', 'Herida', 11, '1d6 Con', '1d6 Con', 12000),
('Veneno de ciempiés pequeño', 'Small centipede poison', 'Herida', 11, '1d2 Des', '1d2 Des', 9000),
('Raíz de sangre', 'Bloodroot', 'Herida', 12, '—', '1d4 Con y 1d3 Sab', 10000),
('Veneno drow', 'Drow poison', 'Herida', 13, 'Inconsciencia', 'Inconsciencia 2d4 horas', 7500),
('Aceite de sangre verde', 'Greenblood oil', 'Herida', 13, '1 Con', '1d2 Con', 10000),
('Whinnis azul', 'Blue whinnis', 'Herida', 14, '1 Con', 'Inconsciencia', 12000),
('Veneno de araña mediana', 'Medium spider venom', 'Herida', 14, '1d4 Fue', '1d4 Fue', 15000),
('Esencia de sombra', 'Shadow essence', 'Herida', 17, '1 Fue permanente', '2d6 Fue', 25000),
('Veneno de guiverno', 'Wyvern poison', 'Herida', 17, '2d6 Con', '2d6 Con', 300000),
('Veneno de escorpión grande', 'Large scorpion venom', 'Herida', 18, '1d6 Fue', '1d6 Fue', 20000),
('Veneno de avispa gigante', 'Giant wasp poison', 'Herida', 18, '1d6 Des', '1d6 Des', 21000),
('Hoja de la muerte', 'Deathblade', 'Herida', 20, '1d6 Con', '2d6 Con', 180000),
('Veneno de gusano púrpura', 'Purple worm poison', 'Herida', 24, '1d6 Fue', '2d6 Fue', 70000)
on conflict (name) do nothing;
