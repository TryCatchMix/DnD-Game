"""Las dotes del SRD 3.5 en español (primera mitad, A–I).

A diferencia de los monstruos, una dote son dos o tres frases: se traducen
enteras, porque una dote en inglés no sirve de nada en la mesa. El texto es
fiel en los números pero más directo que el original, que repite mucho.

Cada entrada: (nombre, prerrequisito, beneficio, normal, especial).
"""

DOTES_A = {
'Acrobatic': ('Acrobático', '',
  '+2 a todas las pruebas de Saltar y de Piruetas.', '', ''),

'Agile': ('Ágil', '',
  '+2 a todas las pruebas de Equilibrio y de Escapismo.', '', ''),

'Alertness': ('Alerta', '',
  '+2 a todas las pruebas de Escuchar y de Avistar.', '',
  'El amo de un familiar disfruta de Alerta siempre que su familiar esté a un brazo de distancia.'),

'Animal Affinity': ('Afinidad animal', '',
  '+2 a todas las pruebas de Trato con animales y de Montar.', '', ''),

'Armor Proficiency (Heavy)': ('Competencia con armadura (pesada)',
  'Competencia con armadura (ligera), Competencia con armadura (media).',
  'Como Competencia con armadura (ligera), pero con las armaduras pesadas.',
  'Ver Competencia con armadura (ligera).',
  'Guerreros, paladines y clérigos la tienen de serie: no necesitan elegirla.'),

'Armor Proficiency (Light)': ('Competencia con armadura (ligera)', '',
  'Con una armadura con la que eres competente, su penalizador de armadura solo se aplica a las pruebas de Equilibrio, Trepar, Escapismo, Esconderse, Saltar, Moverse sigilosamente, Juego de manos y Piruetas.',
  'Quien lleva una armadura con la que no es competente aplica el penalizador de armadura a sus tiradas de ataque y a toda prueba de habilidad que implique moverse.',
  'Todos los personajes salvo magos, hechiceros y monjes la tienen de serie.'),

'Armor Proficiency (Medium)': ('Competencia con armadura (media)',
  'Competencia con armadura (ligera).',
  'Como Competencia con armadura (ligera), pero con las armaduras medias.',
  'Ver Competencia con armadura (ligera).',
  'Guerreros, bárbaros, paladines, clérigos, druidas y bardos la tienen de serie.'),

'Athletic': ('Atlético', '',
  '+2 a todas las pruebas de Trepar y de Nadar.', '', ''),

'Augment Summoning': ('Convocación potenciada', 'Conjuro focalizado (Conjuración).',
  'Toda criatura que convoques con un conjuro de convocación gana +4 de bonificador de mejora a Fuerza y Constitución mientras dure el conjuro.', '', ''),

'Blind-Fight': ('Combatir a ciegas', '',
  'En cuerpo a cuerpo, cada vez que falles por ocultación puedes repetir una vez la tirada porcentual para ver si en realidad aciertas. Un atacante invisible no gana ninguna ventaja contra ti: no pierdes tu bonificador de Destreza a la CA y él no gana su +2 habitual. Además, te mueves a velocidad normal a oscuras.',
  'Se aplican los modificadores normales de los atacantes invisibles y pierdes tu bonificador de Destreza a la CA.',
  'No sirve de nada contra alguien afectado por parpadeo. Un guerrero puede elegirla como dote adicional de guerrero.'),

'Brew Potion': ('Preparar pociones', 'Nivel de lanzador 3.º.',
  'Puedes crear una poción de cualquier conjuro de nivel 3 o menor que conozcas y que tenga por objetivo a una o más criaturas. Preparar una poción lleva un día. Su precio base es nivel del conjuro × nivel de lanzador × 50 po; cuesta 1/25 de ese precio en PX y la mitad en materiales.', '', ''),

'Cleave': ('Hendedura', 'Fue 13, Ataque poderoso.',
  'Si haces caer a una criatura de un golpe, ganas al instante un ataque cuerpo a cuerpo adicional contra otra criatura a tu alcance, con la misma arma y el mismo bonificador. No puedes dar un paso de 5 pies antes de ese ataque. Una vez por asalto.', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Combat Casting': ('Lanzamiento en combate', '',
  '+4 a las pruebas de Concentración para lanzar un conjuro o usar una aptitud sobrenatural mientras combates a la defensiva, o mientras estás en presa o inmovilizado.', '', ''),

'Combat Expertise': ('Pericia en combate', 'Int 13.',
  'Al atacar en cuerpo a cuerpo puedes restar hasta 5 a todas tus tiradas de ataque y sumar esa misma cifra como bonificador de esquiva a tu CA. La cifra no puede superar tu bonificador de ataque base. Dura hasta tu siguiente acción.',
  'Sin esta dote, combatir a la defensiva da −4 al ataque y +2 de esquiva a la CA.',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Combat Reflexes': ('Reflejos de combate', '',
  'Puedes hacer tantos ataques de oportunidad adicionales como tu bonificador de Destreza. Además puedes hacerlos estando desprevenido.',
  'Sin esta dote solo puedes hacer un ataque de oportunidad por asalto, y ninguno estando desprevenido.',
  'No permite a un pícaro usar su aptitud de oportunista más de una vez por asalto. Un guerrero puede elegirla como dote adicional.'),

'Craft Magic Arms And Armor': ('Crear armas y armaduras mágicas', 'Nivel de lanzador 5.º.',
  'Puedes crear cualquier arma, armadura o escudo mágico cuyos requisitos cumplas. Lleva un día por cada 1.000 po del precio de sus propiedades mágicas, cuesta 1/25 de ese precio en PX y la mitad en materiales. También puedes reparar objetos de este tipo que sepas fabricar.', '', ''),

'Craft Rod': ('Crear varas', 'Nivel de lanzador 9.º.',
  'Puedes crear cualquier vara cuyos requisitos cumplas. Lleva un día por cada 1.000 po de su precio base, cuesta 1/25 de ese precio en PX y la mitad en materiales.', '', ''),

'Craft Staff': ('Crear bastones', 'Nivel de lanzador 12.º.',
  'Puedes crear cualquier bastón cuyos requisitos cumplas. Lleva un día por cada 1.000 po de su precio base, cuesta 1/25 en PX y la mitad en materiales. Un bastón recién creado tiene 50 cargas.', '', ''),

'Craft Wand': ('Crear varitas', 'Nivel de lanzador 5.º.',
  'Puedes crear una varita de cualquier conjuro de nivel 4 o menor que conozcas. Su precio base es nivel de lanzador × nivel del conjuro × 750 po; lleva un día por cada 1.000 po, cuesta 1/25 en PX y la mitad en materiales. Nace con 50 cargas.', '', ''),

'Craft Wondrous Item': ('Crear objeto maravilloso', 'Nivel de lanzador 3.º.',
  'Puedes crear cualquier objeto maravilloso cuyos requisitos cumplas. Lleva un día por cada 1.000 po de su precio, cuesta 1/25 en PX y la mitad en materiales. También puedes reparar uno roto que supieras fabricar.', '', ''),

'Deceitful': ('Embustero', '',
  '+2 a todas las pruebas de Disfrazarse y de Falsificar.', '', ''),

'Deflect Arrows': ('Desviar flechas', 'Des 13, Ataque sin armas mejorado.',
  'Con al menos una mano libre, una vez por asalto puedes desviar un proyectil que fuera a alcanzarte y no recibir ningún daño. Debes ser consciente del ataque y no estar desprevenido. Desviar no cuenta como acción. No sirve contra proyectiles enormes (rocas de gigante, virotes de balista) ni contra efectos mágicos.', '',
  'Un monje puede tomarla como dote adicional a nivel 2 aunque no cumpla los requisitos. Un guerrero puede elegirla como dote adicional.'),

'Deft Hands': ('Manos hábiles', '',
  '+2 a todas las pruebas de Juego de manos y de Uso de cuerdas.', '', ''),

'Diehard': ('Duro de matar', 'Vigor.',
  'Al quedarte entre −1 y −9 puntos de golpe te estabilizas automáticamente: no tiras d% cada asalto. Además puedes elegir actuar como si estuvieras incapacitado en vez de moribundo; si lo haces, cada acción agotadora te cuesta 1 punto de golpe más.',
  'Sin esta dote, quien queda entre −1 y −9 puntos de golpe está inconsciente y moribundo.', ''),

'Diligent': ('Diligente', '',
  '+2 a todas las pruebas de Tasación y de Descifrar escritura.', '', ''),

'Dodge': ('Esquiva', 'Des 13.',
  'En tu acción designas a un enemigo y ganas +1 de esquiva a la CA contra sus ataques. Puedes cambiar de enemigo en cualquier acción. Los bonificadores de esquiva se acumulan entre sí, y se pierden cuando pierdes tu bonificador de Destreza a la CA.', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Empower Spell': ('Potenciar conjuro', '',
  'Todos los efectos numéricos variables del conjuro aumentan la mitad. No afecta a las salvaciones ni a las tiradas enfrentadas. Ocupa un espacio de conjuro dos niveles por encima del suyo.', '', ''),

'Endurance': ('Vigor', '',
  '+4 a: Nadar para resistir daño no letal; pruebas de Constitución para seguir corriendo, para evitar el daño de una marcha forzada, para aguantar la respiración y para resistir hambre o sed; Fortaleza para aguantar calor o frío y para resistir el daño de correr con armadura. Además puedes dormir con armadura media o pesada sin quedar fatigado.',
  'Quien duerme con armadura media o más pesada sin esta dote amanece fatigado.',
  'Un explorador la gana de serie a nivel 3.'),

'Enlarge Spell': ('Ampliar conjuro', '',
  'Un conjuro de alcance cercano, medio o largo duplica su alcance: cercano pasa a 50 pies + 5 pies/nivel, medio a 200 + 20/nivel y largo a 800 + 80/nivel. Ocupa un espacio un nivel por encima del suyo.', '', ''),

'Eschew Materials': ('Prescindir de materiales', '',
  'Puedes lanzar cualquier conjuro cuyo componente material cueste 1 po o menos sin necesidad de ese componente. Si cuesta más de 1 po, sigues necesitándolo.', '', ''),

'Exotic Weapon Proficiency': ('Competencia con armas exóticas',
  'Ataque base +1 (y Fue 13 para la espada bastarda o el hacha de guerra enana).',
  'Haces las tiradas de ataque con esa arma con normalidad.',
  'Quien usa un arma con la que no es competente sufre −4 al ataque.',
  'Puedes tomarla varias veces, cada una para un arma exótica distinta.'),

'Extend Spell': ('Extender conjuro', '',
  'El conjuro dura el doble. No afecta a los de duración concentración, instantánea o permanente. Ocupa un espacio un nivel por encima del suyo.', '', ''),

'Extra Turning': ('Expulsión adicional', 'Poder expulsar o reprender criaturas.',
  'Puedes usar tu aptitud de expulsar o reprender cuatro veces más al día de lo normal. Si puedes expulsar a más de un tipo de criatura, cada aptitud gana cuatro usos.',
  'Sin esta dote se expulsa 3 + modificador de Carisma veces al día.',
  'Puedes tomarla varias veces y sus efectos se acumulan.'),

'Far Shot': ('Disparo lejano', 'Disparo a bocajarro.',
  'Con un arma de proyectiles su incremento de distancia aumenta la mitad (×1½). Con un arma arrojadiza, se duplica.', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Forge Ring': ('Forjar anillos', 'Nivel de lanzador 12.º.',
  'Puedes crear cualquier anillo cuyos requisitos cumplas. Lleva un día por cada 1.000 po de su precio base, cuesta 1/25 en PX y la mitad en materiales. También puedes reparar uno roto que supieras fabricar.', '', ''),

'Great Cleave': ('Gran hendedura', 'Fue 13, Hendedura, Ataque poderoso, ataque base +4.',
  'Como Hendedura, pero sin límite de veces por asalto.', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Great Fortitude': ('Gran fortaleza', '',
  '+2 a todas las salvaciones de Fortaleza.', '', ''),

'Greater Spell Focus': ('Conjuro focalizado mayor', 'Conjuro focalizado en esa escuela.',
  '+1 más a la CD de las salvaciones contra tus conjuros de la escuela elegida. Se acumula con Conjuro focalizado.', '',
  'Puedes tomarla varias veces, cada una para otra escuela en la que ya tengas Conjuro focalizado.'),

'Greater Spell Penetration': ('Penetración de conjuros mayor', 'Penetración de conjuros.',
  '+2 más a las pruebas de nivel de lanzador (1d20 + nivel) para superar la resistencia a conjuros. Se acumula con Penetración de conjuros.', '', ''),

'Greater Two-Weapon Fighting': ('Combatir con dos armas mayor',
  'Des 19, Combatir con dos armas mejorado, Combatir con dos armas, ataque base +11.',
  'Ganas un tercer ataque con el arma secundaria, con −10 al ataque.', '',
  'Un guerrero puede elegirla como dote adicional. Un explorador de nivel 11 con el estilo de dos armas la tiene aunque no cumpla los requisitos.'),

'Greater Weapon Focus': ('Arma focalizada mayor',
  'Competencia con el arma, Arma focalizada con ella, nivel de guerrero 8.º.',
  '+1 más a las tiradas de ataque con el arma elegida. Se acumula con Arma focalizada.', '',
  'Puedes tomarla varias veces, cada una para un arma distinta.'),

'Greater Weapon Specialization': ('Especialización con un arma mayor',
  'Competencia con el arma, Arma focalizada mayor, Arma focalizada y Especialización con ella, nivel de guerrero 12.º.',
  '+2 más a las tiradas de daño con el arma elegida. Se acumula con Especialización con un arma.', '',
  'Puedes tomarla varias veces, cada una para un arma distinta.'),

'Heighten Spell': ('Elevar conjuro', '',
  'El conjuro pasa a ser de un nivel superior (hasta 9 como máximo). A diferencia de otras dotes metamágicas, sube de verdad su nivel efectivo: la CD de la salvación y todo lo que dependa del nivel se calculan con el nuevo.', '', ''),

'Improved Bull Rush': ('Arrollar mejorado', 'Fue 13, Ataque poderoso.',
  'Al arrollar no provocas ataque de oportunidad del defensor, y ganas +4 a la prueba enfrentada de Fuerza para empujarlo.', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Improved Counterspell': ('Contraconjuro mejorado', '',
  'Puedes contrarrestar un conjuro con otro de su misma escuela y de nivel igual o superior.',
  'Sin esta dote solo puedes contrarrestar un conjuro con ese mismo conjuro o con el que se indique.', ''),

'Improved Critical': ('Crítico mejorado', 'Competencia con el arma, ataque base +8.',
  'Con el arma elegida, tu margen de amenaza se duplica.', '',
  'Puedes tomarla varias veces, cada una para un arma distinta. No se acumula con otros efectos que amplíen el margen de amenaza.'),

'Improved Disarm': ('Desarmar mejorado', 'Int 13, Pericia en combate.',
  'Al desarmar no provocas ataque de oportunidad ni das al rival la ocasión de desarmarte a ti, y ganas +4 a la tirada de ataque enfrentada.',
  'Ver las reglas normales de desarmar.',
  'Un guerrero puede elegirla como dote adicional. Un monje puede tomarla a nivel 6 aunque no cumpla los requisitos.'),

'Improved Familiar': ('Familiar mejorado',
  'Poder conseguir un familiar nuevo, alineamiento compatible y nivel suficiente.',
  'Al elegir familiar puedes escoger también entre criaturas más poderosas de la lista, con un alineamiento que se aparte hasta un paso del tuyo en cada eje.', '', ''),

'Improved Feint': ('Finta mejorada', 'Int 13, Pericia en combate.',
  'Puedes hacer una prueba de Engañar para fintar en combate como acción de movimiento.',
  'Fintar en combate es una acción estándar.',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Improved Grapple': ('Presa mejorada', 'Des 13, Ataque sin armas mejorado.',
  'No provocas ataque de oportunidad al hacer el ataque de contacto para iniciar una presa, y ganas +4 a todas las pruebas de presa.',
  'Sin esta dote provocas un ataque de oportunidad al iniciar una presa.',
  'Un guerrero puede elegirla como dote adicional. Un monje puede tomarla a nivel 1 aunque no cumpla los requisitos.'),

'Improved Initiative': ('Iniciativa mejorada', '',
  '+4 a las pruebas de iniciativa.', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Improved Overrun': ('Atropellar mejorado', 'Fue 13, Ataque poderoso.',
  'Al atropellar, el objetivo no puede elegir apartarse, y ganas +4 a la prueba de Fuerza para derribarlo.',
  'Sin esta dote, el objetivo puede apartarse o bloquearte.',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Improved Precise Shot': ('Disparo certero mejorado',
  'Des 19, Disparo a bocajarro, Disparo certero, ataque base +11.',
  'Tus ataques a distancia ignoran el bonificador a la CA por cualquier cobertura que no sea total y la probabilidad de fallo por cualquier ocultación que no sea total. Además, al disparar a alguien trabado en una presa no hay riesgo de alcanzar a otro.',
  'Ver las reglas normales de cobertura y ocultación.',
  'Un guerrero puede elegirla como dote adicional. Un explorador de nivel 11 con el estilo de arquería la tiene aunque no cumpla los requisitos.'),

'Improved Shield Bash': ('Golpe de escudo mejorado', 'Competencia con escudos.',
  'Al golpear con el escudo conservas su bonificador a la CA.',
  'Sin esta dote pierdes el bonificador del escudo a la CA hasta tu siguiente turno.',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Improved Sunder': ('Romper mejorado', 'Fue 13, Ataque poderoso.',
  'Al golpear un objeto que lleve un rival no provocas ataque de oportunidad, y ganas +4 a esa tirada de ataque.',
  'Sin esta dote provocas un ataque de oportunidad al golpear un objeto que otro lleve encima.',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),
}
