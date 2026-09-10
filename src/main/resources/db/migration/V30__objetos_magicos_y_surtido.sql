-- =====================================================================
-- LO QUE FALTABA EN EL MOSTRADOR: pociones, pergaminos, varitas, objetos
-- maravillosos y las variantes de armas y armaduras (calidad superior,
-- hierro frío, plata alquímica, mitral, adamantina y +1).
--
-- V22 trajo el equipo mundano del SRD 3.5 (armas, armaduras, aperos) y lo
-- puso todo a la venta. Pero la vitrina se quedaba en lo mundano: no había
-- una sola poción más allá de la de curación que sembró V3, ni un pergamino,
-- ni nada que un aventurero de nivel 3 quisiera comprar.
--
-- Y HAY UN SEGUNDO AGUJERO QUE SE TAPA AQUÍ. V28 se llevó todas las ofertas
-- de V22 a la campaña heredada y dejó como SURTIDO BASE —el que se copia a
-- cada campaña nueva— solo los ocho objetos de V3. Es decir: la mesa vieja
-- tenía tienda entera y las nuevas nacían con ocho cosas. Al final del
-- fichero el surtido se reparte por igual entre TODOS los mostradores: el de
-- cada campaña que ya exista y el base del que beberán las que vengan.
--
-- Precios en piezas de COBRE (1 po = 100 pc) y son los del manual:
--   · poción      = nivel del conjuro × nivel de lanzador × 50 po (nivel 0: 25 po)
--   · pergamino   = nivel del conjuro × nivel de lanzador × 25 po (nivel 0: 12,5 po)
--   · varita      = nivel del conjuro × nivel de lanzador × 750 po (nivel 0: 375 po)
--   · calidad superior: +300 po un arma, +150 po una armadura o escudo
--   · hierro frío: el doble del arma · plata alquímica: +2/+10/+20 po
--   · +1 mágico: +2.000 po un arma, +1.000 po una armadura (calidad superior aparte)
--
-- La columna `source` dice de dónde sale cada cosa: 'SRD 3.5' lo del manual,
-- 'Dorakan' lo propio de esta ambientación (el Ámbar), y vacío lo que escribe
-- un máster a mano desde la tienda. Eso último NO se reparte a nadie: el
-- homebrew de una mesa no tiene por qué aparecer en la de al lado.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. POCIONES
-- ---------------------------------------------------------------------
-- La de V3 pasa a llamarse por su nombre del manual: es curar heridas leves
-- y ya costaba sus 50 po. Se renombra para que no se confunda con la de
-- heridas MENORES (25 po, 1 punto) que entra justo debajo.
update items set
    name = 'Poción de curar heridas leves',
    name_en = 'Potion of cure light wounds',
    description = 'Cierra la herida y devuelve 1d8+1 puntos de Vigor. La que lleva todo el mundo en el cinto.',
    weight_lb = 0.1,
    category = 'consumible',
    equipment_group = 'Pociones y aceites',
    source = 'SRD 3.5'
where code = 'pocion_curacion';

insert into items (code, name, name_en, description, price_cp, weight_lb, category, equipment_group, source) values
-- conjuros de nivel 0 — 25 po
('pocion_curar_heridas_menores','Poción de curar heridas menores','Potion of cure minor wounds','Un punto de Vigor. Poca cosa, salvo cuando ese punto es el que te queda.',2500,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_resistencia','Poción de resistencia','Potion of resistance','+1 de resistencia a todas las salvaciones durante un minuto.',2500,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_guia','Poción de guía','Potion of guidance','+1 a la siguiente tirada de ataque, salvación o prueba de habilidad.',2500,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_virtud','Poción de virtud','Potion of virtue','Un punto de Vigor temporal durante un minuto.',2500,0.1,'consumible','Pociones y aceites','SRD 3.5'),
-- conjuros de nivel 1 — 50 po
('pocion_aguante','Poción de aguante','Potion of endure elements','Aguantas el frío o el calor extremos durante 24 horas.',5000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_escudo_de_fe','Poción de escudo de fe','Potion of shield of faith','+2 de deflexión a la CA durante un minuto.',5000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_escudo_entropico','Poción de escudo entrópico','Potion of entropic shield','Los proyectiles que te apuntan fallan un 20% de las veces, un minuto.',5000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_santuario','Poción de santuario','Potion of sanctuary','Quien quiera atacarte debe superar una salvación o buscarse otro blanco.',5000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_agrandar_persona','Poción de agrandar persona','Potion of enlarge person','Doblas tu tamaño: +2 de Fuerza, -2 de Destreza y un arma mayor.',5000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_reducir_persona','Poción de reducir persona','Potion of reduce person','Menguas a la mitad: +2 de Destreza, -2 de Fuerza y +1 al ataque.',5000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_salto','Poción de salto','Potion of jump','+10 a las pruebas de Saltar durante un minuto.',5000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_retirada_expeditiva','Poción de retirada expeditiva','Potion of expeditious retreat','+30 pies de velocidad. Para llegar, o para no estar.',5000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('aceite_de_arma_magica','Aceite de arma mágica','Oil of magic weapon','Se unta en el arma: +1 al ataque y al daño durante un minuto.',5000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
-- conjuros de nivel 2 — 300 po
('pocion_curar_heridas_moderadas','Poción de curar heridas moderadas','Potion of cure moderate wounds','Devuelve 2d8+3 puntos de Vigor.',30000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_fuerza_de_toro','Poción de fuerza de toro','Potion of bull''s strength','+4 de Fuerza durante tres minutos.',30000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_gracia_felina','Poción de gracia felina','Potion of cat''s grace','+4 de Destreza durante tres minutos.',30000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_resistencia_del_oso','Poción de resistencia del oso','Potion of bear''s endurance','+4 de Constitución durante tres minutos.',30000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_astucia_del_zorro','Poción de astucia del zorro','Potion of fox''s cunning','+4 de Inteligencia durante tres minutos.',30000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_sabiduria_del_buho','Poción de sabiduría del búho','Potion of owl''s wisdom','+4 de Sabiduría durante tres minutos.',30000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_esplendor_del_aguila','Poción de esplendor del águila','Potion of eagle''s splendor','+4 de Carisma durante tres minutos.',30000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_piel_de_corteza','Poción de piel de corteza','Potion of barkskin','+2 de armadura natural a la CA durante media hora.',30000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_invisibilidad','Poción de invisibilidad','Potion of invisibility','Desapareces tres minutos, o hasta que ataques a alguien.',30000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_escalar_aranas','Poción de escalar arañas','Potion of spider climb','Trepas por muros y techos a 20 pies durante media hora.',30000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_retardar_veneno','Poción de retardar veneno','Potion of delay poison','El veneno no te hace nada durante horas. Luego sí, así que corre.',30000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_restablecimiento_menor','Poción de restablecimiento menor','Potion of lesser restoration','Repara 1d4 puntos de daño temporal a una característica.',30000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_resistir_energia','Poción de resistir energía','Potion of resist energy','Ignoras 10 puntos de daño de fuego, frío, ácido, electricidad o sónico.',30000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_ayuda','Poción de ayuda','Potion of aid','+1 al ataque, inmune al miedo y 1d8+3 puntos de Vigor temporales.',30000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_ver_lo_invisible','Poción de ver lo invisible','Potion of see invisibility','Ves lo que no está: invisibles, etéreos y lo que se esconde en ambos.',30000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_levitar','Poción de levitar','Potion of levitate','Subes y bajas a voluntad, 20 pies por asalto, durante tres minutos.',30000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
-- conjuros de nivel 3 — 750 po
('pocion_curar_heridas_graves','Poción de curar heridas graves','Potion of cure serious wounds','Devuelve 3d8+5 puntos de Vigor. La que se guarda para el final.',75000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_volar','Poción de volar','Potion of fly','Vuelas a 60 pies durante cinco minutos. Cuenta los asaltos.',75000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_prisa','Poción de prisa','Potion of haste','Un ataque más al asalto, +30 pies de velocidad, +1 al ataque y a la CA.',75000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_heroismo','Poción de heroísmo','Potion of heroism','+2 de moral al ataque, a las salvaciones y a las habilidades, media hora.',75000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_desplazamiento','Poción de desplazamiento','Potion of displacement','No estás donde te ven: los ataques fallan un 50% durante cinco asaltos.',75000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_forma_gaseosa','Poción de forma gaseosa','Potion of gaseous form','Te vuelves niebla: pasas por una rendija y solo te hiere lo mágico.',75000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_neutralizar_veneno','Poción de neutralizar veneno','Potion of neutralize poison','Corta el veneno de raíz y te protege del siguiente durante horas.',75000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('pocion_eliminar_enfermedad','Poción de eliminar enfermedad','Potion of remove disease','Cura cualquier enfermedad, también las que trae un monstruo encima.',75000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
-- aceites y elixires (objetos maravillosos de un solo uso)
('aceite_de_deslizamiento','Aceite de deslizamiento','Oil of slipperiness','Nada te agarra: ni cuerdas, ni redes, ni las manos de nadie.',100000,0.5,'consumible','Pociones y aceites','SRD 3.5'),
('disolvente_universal','Disolvente universal','Universal solvent','Deshace cualquier pegamento, incluida la baba de un cubo gelatinoso.',5000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('elixir_de_esconderse','Elixir de esconderse','Elixir of hiding','+10 a Esconderse durante una hora.',25000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('elixir_de_sigilo','Elixir de sigilo','Elixir of sneaking','+10 a Moverse Sigilosamente durante una hora.',25000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('elixir_de_nadar','Elixir de nadar','Elixir of swimming','+10 a Nadar durante una hora.',25000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('elixir_de_vision','Elixir de visión','Elixir of vision','+10 a Buscar durante una hora.',25000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('elixir_de_amor','Elixir de amor','Elixir of love','Quien lo bebe se encapricha del primero que ve. Una hora de problemas.',15000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('elixir_de_verdad','Elixir de verdad','Elixir of truth','Diez minutos sin poder mentir. Se usa más en los interrogatorios que en las tabernas.',50000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('elixir_de_aliento_de_fuego','Elixir de aliento de fuego','Elixir of fire breath','Escupes fuego hasta tres veces: 4d6 puntos de daño a 25 pies.',110000,0.1,'consumible','Pociones y aceites','SRD 3.5'),
('polvo_de_aparicion','Polvo de aparición','Dust of appearance','Un puñado al aire y todo lo invisible del claro deja de serlo.',180000,0.0,'consumible','Pociones y aceites','SRD 3.5'),
('unguento_de_keoghtom','Ungüento de Keoghtom','Keoghtom''s ointment','Cinco aplicaciones. Cada una cura 1d8+5 y limpia veneno o enfermedad.',400000,0.5,'consumible','Pociones y aceites','SRD 3.5'),
-- lo de la casa
('ambar','Ámbar','Amber','Resina líquida del color de la miel, espesa y tibia al tacto. Cierra las heridas —cura 1d8 puntos de Vigor más uno por nivel de quien la bebe— y le espesa la sangre: +2 de Constitución durante una hora.',2500,0.1,'consumible','Pociones y aceites','Dorakan')
on conflict (code) do nothing;


-- ---------------------------------------------------------------------
-- 2. PERGAMINOS
-- ---------------------------------------------------------------------
-- Un pergamino lo lanza quien tenga el conjuro en su lista (o se juegue una
-- prueba de Usar Objeto Mágico). Precio = nivel × nivel de lanzador × 25 po;
-- si el conjuro pide componentes caros, se suman: identificar lleva sus
-- 100 po de polvo de perlas y por eso vale 125 y no 25.
insert into items (code, name, name_en, description, price_cp, weight_lb, category, equipment_group, source) values
('pergamino_detectar_magia','Pergamino de detectar magia','Scroll of detect magic','Tres asaltos mirando: qué hay encantado y con qué fuerza.',1250,0.0,'consumible','Pergaminos','SRD 3.5'),
('pergamino_leer_magia','Pergamino de leer magia','Scroll of read magic','Para leer los otros pergaminos. El primero de todos.',1250,0.0,'consumible','Pergaminos','SRD 3.5'),
('pergamino_luz','Pergamino de luz','Scroll of light','Un objeto alumbra como una antorcha durante una hora.',1250,0.0,'consumible','Pergaminos','SRD 3.5'),
('pergamino_proyectil_magico','Pergamino de proyectil mágico','Scroll of magic missile','1d4+1 puntos de daño que no fallan nunca.',2500,0.0,'consumible','Pergaminos','SRD 3.5'),
('pergamino_armadura_de_mago','Pergamino de armadura de mago','Scroll of mage armor','+4 de armadura a la CA durante una hora.',2500,0.0,'consumible','Pergaminos','SRD 3.5'),
('pergamino_escudo','Pergamino de escudo','Scroll of shield','+4 de escudo a la CA y ni un proyectil mágico te toca.',2500,0.0,'consumible','Pergaminos','SRD 3.5'),
('pergamino_dormir','Pergamino de dormir','Scroll of sleep','Cuatro dados de golpe de criaturas caen dormidas. Con los goblins funciona.',2500,0.0,'consumible','Pergaminos','SRD 3.5'),
('pergamino_manos_ardientes','Pergamino de manos ardientes','Scroll of burning hands','Un abanico de fuego de 15 pies: 1d4 puntos de daño por nivel.',2500,0.0,'consumible','Pergaminos','SRD 3.5'),
('pergamino_curar_heridas_leves','Pergamino de curar heridas leves','Scroll of cure light wounds','1d8+1 puntos de Vigor para quien lo necesite.',2500,0.0,'consumible','Pergaminos','SRD 3.5'),
('pergamino_identificar','Pergamino de identificar','Scroll of identify','Dice qué hace ese objeto mágico. Lleva 100 po de polvo de perlas dentro.',12500,0.0,'consumible','Pergaminos','SRD 3.5'),
('pergamino_invisibilidad','Pergamino de invisibilidad','Scroll of invisibility','Uno de los presentes deja de verse durante tres minutos.',15000,0.0,'consumible','Pergaminos','SRD 3.5'),
('pergamino_imagen_multiple','Pergamino de imagen múltiple','Scroll of mirror image','1d4+1 copias tuyas que se mueven contigo y se llevan los golpes.',15000,0.0,'consumible','Pergaminos','SRD 3.5'),
('pergamino_tela_de_arana','Pergamino de tela de araña','Scroll of web','Llena 20 pies de telaraña pegajosa. Bien puesta, gana el combate.',15000,0.0,'consumible','Pergaminos','SRD 3.5'),
('pergamino_curar_heridas_moderadas','Pergamino de curar heridas moderadas','Scroll of cure moderate wounds','2d8+3 puntos de Vigor.',15000,0.0,'consumible','Pergaminos','SRD 3.5'),
('pergamino_bola_de_fuego','Pergamino de bola de fuego','Scroll of fireball','5d6 puntos de daño de fuego en 20 pies a la redonda. Mira dónde apuntas.',37500,0.0,'consumible','Pergaminos','SRD 3.5'),
('pergamino_relampago','Pergamino de relámpago','Scroll of lightning bolt','5d6 puntos de daño en una línea de 120 pies.',37500,0.0,'consumible','Pergaminos','SRD 3.5'),
('pergamino_disipar_magia','Pergamino de disipar magia','Scroll of dispel magic','Apaga el conjuro del otro. O el tuyo, si te has metido en un lío.',37500,0.0,'consumible','Pergaminos','SRD 3.5'),
('pergamino_volar','Pergamino de volar','Scroll of fly','Cinco minutos de vuelo a 60 pies.',37500,0.0,'consumible','Pergaminos','SRD 3.5')
on conflict (code) do nothing;


-- ---------------------------------------------------------------------
-- 3. VARITAS
-- ---------------------------------------------------------------------
-- 50 cargas, una por uso. Precio = nivel × nivel de lanzador × 750 po.
insert into items (code, name, name_en, description, price_cp, weight_lb, category, equipment_group, source) values
('varita_detectar_magia','Varita de detectar magia','Wand of detect magic','50 cargas. La varita del tasador y del que abre cofres ajenos.',37500,0.1,'magico','Varitas','SRD 3.5'),
('varita_luz','Varita de luz','Wand of light','50 cargas de luz de antorcha sin humo ni chispas.',37500,0.1,'magico','Varitas','SRD 3.5'),
('varita_curar_heridas_leves','Varita de curar heridas leves','Wand of cure light wounds','50 cargas de 1d8+1. Lo que mantiene viva a una partida entera.',75000,0.1,'magico','Varitas','SRD 3.5'),
('varita_proyectil_magico','Varita de proyectil mágico','Wand of magic missile','50 cargas de 1d4+1 que no fallan.',75000,0.1,'magico','Varitas','SRD 3.5'),
('varita_armadura_de_mago','Varita de armadura de mago','Wand of mage armor','50 cargas de +4 a la CA durante una hora.',75000,0.1,'magico','Varitas','SRD 3.5'),
('varita_curar_heridas_moderadas','Varita de curar heridas moderadas','Wand of cure moderate wounds','50 cargas de 2d8+3. Cara, y aun así se vende sola.',450000,0.1,'magico','Varitas','SRD 3.5')
on conflict (code) do nothing;


-- ---------------------------------------------------------------------
-- 4. OBJETOS MARAVILLOSOS Y ANILLOS
-- ---------------------------------------------------------------------
insert into items (code, name, name_en, description, price_cp, weight_lb, category, equipment_group, source) values
('capa_de_resistencia_1','Capa de resistencia +1','Cloak of resistance +1','+1 de resistencia a las tres salvaciones. La primera compra de todo aventurero sensato.',100000,1.0,'magico','Objetos maravillosos','SRD 3.5'),
('amuleto_de_armadura_natural_1','Amuleto de armadura natural +1','Amulet of natural armor +1','+1 de armadura natural a la CA. Se lleva al cuello y no estorba a nada.',200000,0.0,'magico','Objetos maravillosos','SRD 3.5'),
('broche_de_proteccion','Broche de protección','Brooch of shielding','Absorbe 101 puntos de proyectil mágico y se apaga.',150000,0.0,'magico','Objetos maravillosos','SRD 3.5'),
('bolsa_de_contencion_i','Bolsa de contención I','Bag of holding I','Traga 250 libras y pesa siempre 15. No la metas dentro de otra.',250000,15.0,'magico','Objetos maravillosos','SRD 3.5'),
('zurron_practico','Zurrón práctico','Handy haversack','Lo que buscas está siempre arriba: sacarlo es una acción de movimiento.',200000,5.0,'magico','Objetos maravillosos','SRD 3.5'),
('cuerda_de_escalar','Cuerda de escalar','Rope of climbing','60 pies de cuerda que se ata, se suelta y trepa sola cuando se lo mandas.',300000,3.0,'magico','Objetos maravillosos','SRD 3.5'),
('botas_elficas','Botas élficas','Boots of elvenkind','+5 a Moverse Sigilosamente. Ni la hojarasca te oye.',250000,1.0,'magico','Objetos maravillosos','SRD 3.5'),
('capa_elfica','Capa élfica','Cloak of elvenkind','+5 a Esconderse. Cambia de color con lo que tienes detrás.',250000,1.0,'magico','Objetos maravillosos','SRD 3.5'),
('sombrero_de_disfraz','Sombrero de disfraz','Hat of disguise','Cambia tu cara y tu ropa a voluntad. No cambia lo que se toca.',180000,0.5,'magico','Objetos maravillosos','SRD 3.5'),
('lentes_de_aguila','Lentes de águila','Eyes of the eagle','+5 a Avistar. Molesta un poco al principio.',250000,0.0,'magico','Objetos maravillosos','SRD 3.5'),
('cuerno_de_niebla','Cuerno de niebla','Horn of fog','Sopla y sale una niebla espesa. Para huir, o para que no te sigan.',200000,1.0,'magico','Objetos maravillosos','SRD 3.5'),
('botas_de_brincar_y_trepar','Botas de brincar y trepar','Boots of striding and springing','Andas más rápido y saltas como si tuvieras +5 en Saltar.',550000,1.0,'magico','Objetos maravillosos','SRD 3.5'),
('guantes_de_destreza_2','Guantes de destreza +2','Gloves of Dexterity +2','+2 de Destreza mientras los lleves puestos.',400000,0.5,'magico','Objetos maravillosos','SRD 3.5'),
('cinturon_de_fuerza_de_gigante_2','Cinturón de fuerza de gigante +2','Belt of giant strength +2','+2 de Fuerza mientras lo lleves ceñido.',400000,1.0,'magico','Objetos maravillosos','SRD 3.5'),
('perla_de_poder_nivel_1','Perla de poder (nivel 1)','Pearl of power (1st level)','Una vez al día devuelve al lanzador un conjuro de nivel 1 ya usado.',100000,0.0,'magico','Objetos maravillosos','SRD 3.5'),
('anillo_de_proteccion_1','Anillo de protección +1','Ring of protection +1','+1 de deflexión a la CA. Un aro sencillo, sin marcas.',200000,0.0,'magico','Anillos','SRD 3.5'),
('anillo_de_nadar','Anillo de nadar','Ring of swimming','+5 a Nadar, siempre, aunque no sepas nadar.',250000,0.0,'magico','Anillos','SRD 3.5'),
('anillo_de_sustento','Anillo de sustento','Ring of sustenance','Ni comes ni bebes, y duermes en dos horas. Tarda una semana en hacerse a ti.',250000,0.0,'magico','Anillos','SRD 3.5')
on conflict (code) do nothing;


-- ---------------------------------------------------------------------
-- 5. ARMAS Y ARMADURAS: CALIDAD SUPERIOR, MATERIALES Y +1
-- ---------------------------------------------------------------------
-- Van con su grupo del SRD ("Arma marcial (una mano)", "Escudo"), no con uno
-- inventado: de ese grupo sale si la ficha las trata como arma, armadura o
-- escudo al equiparlas (ver Gear.kind).
--
-- Calidad superior: +1 al ataque en un arma; una armadura pesa igual pero
-- penaliza un punto menos. El mitral quita 3 al penalizador, sube 2 la Des
-- máxima, baja 10% el fallo de conjuros y pesa la mitad. La plata alquímica
-- resta 1 al daño; el hierro frío y la adamantina, no.
insert into items (code, name, name_en, description, price_cp, weight_lb, category, equipment_group, damage_small, damage_medium, critical, range_increment, damage_type, proficiency, handling, ac_bonus, max_dex, armor_check, spell_failure, speed_30, speed_20, source) values
-- calidad superior
('daga_de_calidad_superior','Daga de calidad superior','Dagger, masterwork','+1 al ataque por lo bien hecha que está.',30200,1.0,'arma','Arma sencilla (ligera)','1d3','1d4','19-20/×2','10 pies','Perforante o cortante','Sencilla','Ligera','','','','','','','SRD 3.5'),
('espada_larga_de_calidad_superior','Espada larga de calidad superior','Longsword, masterwork','+1 al ataque. El paso previo a encantarla.',31500,4.0,'arma','Arma marcial (una mano)','1d6','1d8','19-20/×2','','Cortante','Marcial','Una mano','','','','','','','SRD 3.5'),
('arco_corto_compuesto_de_calidad_superior','Arco corto compuesto de calidad superior','Shortbow, composite, masterwork','+1 al ataque.',37500,2.0,'arma','Arma marcial (a distancia)','1d4','1d6','×3','70 pies','Perforante','Marcial','A distancia','','','','','','','SRD 3.5'),
('cota_de_mallas_de_calidad_superior','Cota de mallas de calidad superior','Chainmail, masterwork','Penaliza un punto menos a las habilidades.',30000,40.0,'armadura','Armadura media','','','','','','','','5','2','-4','30%','20 pies','15 pies','SRD 3.5'),
('escudo_pesado_de_acero_de_calidad_superior','Escudo pesado de acero de calidad superior','Shield, heavy steel, masterwork','Penaliza un punto menos a las habilidades.',17000,15.0,'armadura','Escudo','','','','','','','','2','','-1','15%','','','SRD 3.5'),
-- materiales especiales
('daga_de_plata_alquimica','Daga de plata alquímica','Dagger, alchemical silver','Muerde a los licántropos y a los diablos. Un punto menos de daño.',400,1.0,'arma','Arma sencilla (ligera)','1d3','1d4','19-20/×2','10 pies','Perforante o cortante','Sencilla','Ligera','','','','','','','SRD 3.5'),
('espada_larga_de_plata_alquimica','Espada larga de plata alquímica','Longsword, alchemical silver','Plateada del filo a la punta. Un punto menos de daño.',2500,4.0,'arma','Arma marcial (una mano)','1d6','1d8','19-20/×2','','Cortante','Marcial','Una mano','','','','','','','SRD 3.5'),
('daga_de_hierro_frio','Daga de hierro frío','Dagger, cold iron','Hierro forjado en frío: lo que los feéricos no soportan.',400,1.0,'arma','Arma sencilla (ligera)','1d3','1d4','19-20/×2','10 pies','Perforante o cortante','Sencilla','Ligera','','','','','','','SRD 3.5'),
('espada_larga_de_hierro_frio','Espada larga de hierro frío','Longsword, cold iron','Contra demonios y feéricos, la que hay que llevar.',3000,4.0,'arma','Arma marcial (una mano)','1d6','1d8','19-20/×2','','Cortante','Marcial','Una mano','','','','','','','SRD 3.5'),
('espada_larga_de_adamantina','Espada larga de adamantina','Longsword, adamantine','Atraviesa la piedra y el hierro: ignora 20 puntos de reducción de daño.',301500,4.0,'arma','Arma marcial (una mano)','1d6','1d8','19-20/×2','','Cortante','Marcial','Una mano','','','','','','','SRD 3.5'),
('camisote_de_mallas_de_mitral','Camisote de mallas de mitral','Mithral shirt','Ligerísimo: se lleva bajo la ropa y casi no estorba a nada.',110000,12.5,'armadura','Armadura ligera','','','','','','','','4','6','0','10%','30 pies','20 pies','SRD 3.5'),
-- lo encantado
('daga_1','Daga +1','Dagger +1','+1 al ataque y al daño. Y cuenta como arma mágica.',230200,1.0,'arma','Arma sencilla (ligera)','1d3','1d4','19-20/×2','10 pies','Perforante o cortante','Sencilla','Ligera','','','','','','','SRD 3.5'),
('espada_larga_1','Espada larga +1','Longsword +1','+1 al ataque y al daño. Y cuenta como arma mágica.',231500,4.0,'arma','Arma marcial (una mano)','1d6','1d8','19-20/×2','','Cortante','Marcial','Una mano','','','','','','','SRD 3.5'),
('arco_corto_compuesto_1','Arco corto compuesto +1','Shortbow, composite +1','+1 al ataque y al daño con cada flecha.',237500,2.0,'arma','Arma marcial (a distancia)','1d4','1d6','×3','70 pies','Perforante','Marcial','A distancia','','','','','','','SRD 3.5'),
('cuero_tachonado_1','Cuero tachonado +1','Studded leather +1','+4 a la CA y ni pesa ni penaliza.',117500,20.0,'armadura','Armadura ligera','','','','','','','','4','5','0','15%','30 pies','20 pies','SRD 3.5'),
('cota_de_mallas_1','Cota de mallas +1','Chainmail +1','+6 a la CA. Lo que lleva un guerrero que ya ha cobrado un par de encargos.',130000,40.0,'armadura','Armadura media','','','','','','','','6','2','-4','30%','20 pies','15 pies','SRD 3.5'),
('escudo_pesado_de_acero_1','Escudo pesado de acero +1','Shield, heavy steel +1','+3 a la CA.',117000,15.0,'armadura','Escudo','','','','','','','','3','','-1','15%','','','SRD 3.5')
on conflict (code) do nothing;


-- ---------------------------------------------------------------------
-- 6. AL MOSTRADOR, Y AL DE TODAS LAS MESAS
-- ---------------------------------------------------------------------
-- Un mostrador por campaña más el BASE (campaign_id nulo), que es la
-- plantilla de la que copia CampaignService al crear una mesa nueva.
--
-- La ciudad se hereda de lo que ya hubiera en ese mostrador. `location` no se
-- filtra desde V28 (lo explica ShopService), pero la columna es NOT NULL y
-- conviene que no aparezcan dos ciudades distintas en la misma vitrina.
--
-- Fuera quedan los servicios y el transporte —un barco no se compra en un
-- mostrador—, lo que no tiene precio propio (el ataque sin armas, las púas) y
-- el homebrew de cada máster (source vacío), que es suyo y de nadie más.
--
-- El `not exists` deja intactas las ofertas que ya estuvieran puestas: si un
-- máster subió el precio de la daga o dejó dos faroles en stock, sigue así.
with mostradores as (
    select c.id as campaign_id,
           coalesce((select o.location from shop_offers o where o.campaign_id = c.id limit 1),
                    'Dorakan') as location
      from campaigns c
    union all
    select null::uuid,
           coalesce((select o.location from shop_offers o where o.campaign_id is null limit 1),
                    'base')
),
-- Lo caro y lo mágico no se apila en la trastienda: unas pocas unidades y a
-- reponer cuando el máster quiera. El resto, sin límite.
existencias (code, stock) as (values
    ('daga_1', 1), ('espada_larga_1', 1), ('arco_corto_compuesto_1', 1),
    ('cuero_tachonado_1', 1), ('cota_de_mallas_1', 1), ('escudo_pesado_de_acero_1', 1),
    ('espada_larga_de_adamantina', 1), ('camisote_de_mallas_de_mitral', 1),
    ('ambar', 3)
),
surtido as (
    select i.code,
           i.price_cp,
           coalesce(e.stock,
               case
                   when i.equipment_group in ('Varitas', 'Objetos maravillosos', 'Anillos') then 1
                   when i.equipment_group in ('Pociones y aceites', 'Pergaminos') then 3
                   else -1
               end) as stock
      from items i
      left join existencias e on e.code = i.code
     where i.source in ('SRD 3.5', 'Dorakan')
       and i.category not in ('servicio', 'transporte')
       and i.price_cp > 0
)
insert into shop_offers (id, location, item_code, price_cp, stock, campaign_id)
select gen_random_uuid(), m.location, s.code, s.price_cp, s.stock, m.campaign_id
  from mostradores m
 cross join surtido s
 where not exists (
           select 1 from shop_offers o
            where o.item_code = s.code
              and o.campaign_id is not distinct from m.campaign_id);
