/**
 * EL ELENCO DE VELMORRA — el dossier de la campaña, en datos.
 *
 * Este fichero es la fuente: las 44 fichas con lo que sabe el máster y, sobre
 * todo, con QUÉ PARTE DE ESO SABE LA MESA. Lo carga `cargar.mjs` contra la API.
 *
 * ------------------------------------------------------------------ sellos --
 *
 * Por defecto una ficha entra con esto a la vista: nombre, título, ubicación,
 * raza y descripción. O sea, lo que ves cuando conoces a alguien.
 *
 * Y con esto sellado: alineamiento, curiosidades y todos los tratos.
 *
 *   · El ALINEAMIENTO se sella siempre. Es una chuleta de comportamiento para
 *     el máster, no algo que se lea en la cara de nadie.
 *   · Las CURIOSIDADES se sellan siempre. En este dossier son los ganchos: el
 *     cuaderno de Marcial, los cuarenta y dos menús de Perlo, la placa de
 *     Críspulo. Son precisamente lo que la campaña va soltando.
 *   · Los TRATOS se sellan salvo los que se ven desde fuera (Ordo está de pie
 *     al lado de Sabela; Clementina está detrás de la caja de su tío).
 *
 * Cada ficha puede corregir ese reparto con `ve`.
 *
 * ------------------------------------------------------------------- razas --
 *
 * La raza se sella cuando ES el secreto. Que Casimira es humana se ve; que
 * Serafín es dhampir, que Rosalba se está volviendo ambarina o que el señor de
 * la puerta del Club es un engendro, no. Va marcado ficha a ficha con
 * `ve: { race: false }`, que en esta ciudad es medio argumento.
 *
 * ------------------------------------------------------------------ nombres --
 *
 * `alias` es cómo se le llama mientras el nombre siga sellado. Solo hace falta
 * en los pocos que no dan su nombre: la anciana del carromato, y poco más.
 *
 * ------------------------------------------------------------- sin salir aún --
 *
 * `ve: { listed: false }` deja la ficha en el cajón del máster: existe, se
 * puede preparar, y no sale en el elenco de los jugadores. Aquí son los cuatro
 * de la capa de abajo: Tobal, Nicasio, Fiacro y el Conde.
 */

/** Los tres personajes jugadores, tal como se crean en la mesa. */
export const PJS = [
  {
    name: 'Aster',
    clazz: 'Pícaro',
    race: 'Kalashtar',
    alignment: '',
    level: 1,
    city: 'Velmorra',
  },
  {
    name: 'Vhrael',
    clazz: 'Guerrero',
    race: 'Semielfo dhampir',
    alignment: '',
    level: 1,
    city: 'Velmorra',
  },
  {
    name: 'Zhaelor',
    clazz: 'Filo de guerra',
    race: 'Semidrow',
    alignment: '',
    level: 1,
    city: 'Velmorra',
  },
];

/**
 * El elenco.
 *
 * `tratos[].a` dice a quién apunta cada trato:
 *   'npc:<nombre exacto de otra ficha>'  → se enlaza con esa ficha
 *   'pj:<nombre del personaje jugador>'  → se enlaza con el personaje
 *   cualquier otra cosa                  → un nombre suelto (una institución,
 *                                          un gremio, alguien sin ficha)
 */
export const ELENCO = [

  // ======================================================= los jugadores ====

  {
    name: 'Aster',
    alias: 'El que sueña',
    title: '',
    location: 'Con el grupo',
    race: 'Kalashtar',
    alignment: '',
    description:
      'Sueña con lugares que no existen y los sueña con demasiado detalle. ' +
      'Lleva una máscara blanca de madera colgada del cinto. Pícaro 1. ' +
      'En los papeles del Ministerio es «el que sueña».',
    trivia: [
      'Cuenta campanarios sin darse cuenta. Al llegar a Velmorra le salieron siete, y en la ciudad hay siete. Todavía.',
      'Su valor en oro: 10.000 po vivo. El único de los tres que vale más que su peso.',
      'Los kalashtar vienen de Eberron: humanos ligados a un espíritu quori que viven soñando. Que la trama vaya de sueños robados no es casualidad.',
    ],
    tratos: [
      { kind: 'amistoso', a: 'pj:Vhrael', note: 'Su compañero', visto: true },
      { kind: 'amistoso', a: 'pj:Zhaelor', note: 'Su compañero', visto: true },
      { kind: 'neutral', a: 'npc:Perlo', note: 'Le interesa: responde con números' },
      { kind: 'neutral', a: 'npc:Madame Lisandra Voss', note: 'Le olió «una lluvia que no ha caído»' },
      { kind: 'neutral', a: 'npc:El Cantor sin Nombre', note: 'Canta su sueño como si fuera folclore' },
    ],
  },

  {
    name: 'Vhrael',
    alias: '',
    title: '',
    location: 'Con el grupo',
    race: 'Semielfo dhampir (templado)',
    alignment: '',
    description:
      'Carga el duelo de su hermana Alyne. Necesita sangre y la sacia con ámbar: ' +
      'un frasco le dura tres días, o un día con el menú de la casa de Casimira. ' +
      'Lleva una media máscara de cuero al cuello y un anillo-sello de su casta. Guerrero 1.',
    trivia: [
      'Su anillo es una llave social enorme y él no lo sabe. Serafín Nácar lo reconocerá a la primera, y creía que ya no quedaba nadie que lo llevara.',
      'Es lo que otros quieren desangrar: toda la subtrama «Sangre al Alba» le apunta a él.',
    ],
    tratos: [
      { kind: 'amistoso', a: 'pj:Aster', note: 'Su compañero', visto: true },
      { kind: 'amistoso', a: 'pj:Zhaelor', note: 'Su compañero', visto: true },
      { kind: 'neutral', a: 'npc:Casimira', note: 'Su cena barata: el menú de la casa lleva ámbar' },
      { kind: 'neutral', a: 'npc:Serafín Nácar', note: 'Los Templados: primero él' },
      { kind: 'neutral', a: 'npc:Tancredo Lis', note: 'Los Templados: después él' },
    ],
  },

  {
    name: 'Zhaelor',
    alias: '',
    title: '',
    location: 'Con el grupo',
    race: 'Semidrow',
    alignment: '',
    description:
      'De Fenwick, una aldea de marisma. Vio algo que no debía en Cantera Gris, ' +
      'y por eso lo compraron en vez de dejar que lo ahorcaran. ' +
      'Lleva un colgante drow sin identificar. Filo de guerra 1.',
    trivia: [
      'El colgante es plata drow auténtica, pero el número grabado por dentro es reciente y torpe, hecho con punzón de taller. Es un número de lote: lo marcaron como a una vaca.',
    ],
    tratos: [
      { kind: 'amistoso', a: 'pj:Aster', note: 'Su compañero', visto: true },
      { kind: 'amistoso', a: 'pj:Vhrael', note: 'Su compañero', visto: true },
      { kind: 'neutral', a: 'npc:Teodo Rell', note: 'Reconoce el barro de marisma de sus botas: misma región' },
      { kind: 'amistoso', a: 'npc:Brígida «Plata» Olmedo', note: 'Conectan bien: los dos son de bares' },
    ],
  },

  // ==================================================== el camino y la ley ==

  {
    name: 'Ilda Vero',
    alias: 'La Tijera',
    title: '',
    location: 'Itinerante; aparece donde le conviene',
    race: 'Humana',
    alignment: 'Legal neutral',
    description:
      'Anciana de luto, encaje negro, manos quietas sobre el regazo. ' +
      'Los liberó del carromato envenenando a los guardias con una petaca untada por fuera.',
    // No dio su nombre: para la mesa es la anciana del carromato.
    ve: { name: false },
    trivia: [
      'Asesina veterana, de nivel muy alto. No pelea con los PJs y no va a matar a Aster: su encargo es que los tres lleguen a Velmorra vivos.',
      'Habla de todo el mundo como si fuera familia suya («mi sobrino el de la horca»).',
      'Nunca hace una pregunta personal, y esa es la forma más fácil de saber que ya lo sabe todo.',
      'En su fase amable es una abuela entrañable; cuando se le cae la careta, la voz se le queda plana y las frases cortas. Averiguar intenciones +13.',
      'Reloj C: les regala una segunda pista, cobra la tercera con un favor sucio, y luego se descubre para quién trabaja de verdad. No es para ellos.',
    ],
    tratos: [
      { kind: 'neutral', a: 'Quien le paga', note: 'Los PJs no saben quién es' },
      { kind: 'neutral', a: 'npc:Emeric Corvane', note: 'Sabe de su existencia, pero no le ha puesto cara' },
    ],
  },

  {
    name: 'Emeric Corvane',
    alias: '',
    title: 'Alguacil',
    location: 'Toda la ciudad; despacho en la comandancia',
    race: 'Humano',
    alignment: 'Legal neutral',
    description:
      'La ley de Velmorra. Cuarentón, abrigo oscuro, cuaderno bajo el brazo. ' +
      'Investiga la muerte de los guardias del carromato. No es corrupto ni tonto.',
    trivia: [
      'Tiene razón: los PJs lo hicieron. Que no sea corrupto ni tonto es justo el problema.',
      'Cuanto más furioso está, más bajito habla. Si empieza a susurrar, corred.',
      'Regla de oro: funciona mejor si tiene razón. No lo conviertas en corrupto; un policía honesto persiguiendo a tres culpables reales es mucho más incómodo.',
    ],
    tratos: [
      { kind: 'neutral', a: 'Los fielatos y las garitas', note: 'Tiene copias de las descripciones de los tres' },
      { kind: 'enemigo', a: 'npc:Doña Perpetua Ruíz-Mor', note: 'A regañadientes: ella protege a sus cadáveres de él' },
      { kind: 'neutral', a: 'npc:Teodo Rell', note: 'Le da los partes del puerto' },
      { kind: 'neutral', a: 'El Ministerio del Cáliz', note: 'Le marca hasta dónde puede investigar' },
    ],
  },

  {
    name: 'Marcial Hoyos',
    alias: '',
    title: 'Mozo de cuadra',
    location: 'Establos del Vado, a las afueras',
    race: 'Humano',
    alignment: 'Neutral',
    description:
      'Sesenta años, cojo, habla más con los animales que con la gente. ' +
      'Les compró el caballo por 15 po, 20 si regatearon bien. ' +
      'No pregunta por el pasajero ni por el destino, solo por el animal.',
    trivia: [
      'Su cuaderno de resguardos es un registro físico de cuántos carromatos con el sello del cáliz han pasado por ahí este año: muchos más que los diez años anteriores juntos.',
      'Lo dijo en voz alta una vez y no piensa repetirlo.',
    ],
    tratos: [
      { kind: 'neutral', a: 'Medio puerto', note: 'Pasa por sus cuadras' },
      { kind: 'amistoso', a: 'El grupo', note: 'Le caen bien desde el trato justo del caballo, y eso es un favor cobrable' },
    ],
  },

  // ========================================================= el Farol Sordo ==

  {
    name: 'Casimira',
    alias: 'La Sorda',
    title: 'Dueña del Farol Sordo',
    location: 'El Farol Sordo, Ribera Baja',
    race: 'Humana',
    alignment: 'Neutral',
    description:
      'Cuarenta y ocho o cincuenta años, brazos de cargar barriles, delantal quemado en dos sitios. ' +
      'Te mira a la boca, no a los ojos. Experta 5.',
    trivia: [
      'No está sorda: finge sordera para que la gente hable delante de ella con libertad, y lee los labios como tapadera.',
      'Nunca repite lo que oye borracho a nadie, y de ahí el mote público.',
      'El menú de la casa lleva trazas de ámbar y en la pizarra hay un frasquito dorado dibujado al lado. Se sirven 42 al día.',
      'En la taberna no huele a ajo.',
      'Averiguar intenciones +11: los cala mucho antes de que ellos la calen a ella, y el dinero por delante es la peor forma posible de sonsacarle.',
      'Sabe perfectamente que «la gente del cáliz» trae y lleva personas al muelle.',
    ],
    tratos: [
      { kind: 'neutral', a: 'Los estibadores de la cocina', note: 'Su músculo' },
      { kind: 'amistoso', a: 'npc:Perlo', note: 'Mobiliario de la casa', visto: true },
      { kind: 'amistoso', a: 'npc:El Cantor sin Nombre', note: 'Le deja el rincón gratis', visto: true },
      { kind: 'neutral', a: 'npc:Teodo Rell', note: 'Sabe lo de la habitación pagada y no usada' },
    ],
  },

  {
    name: 'Perlo',
    alias: 'El Contador',
    title: '',
    location: 'El salón del Farol Sordo',
    race: 'Humano',
    alignment: 'Neutral bueno',
    description:
      'Plebeyo 1. Cuenta en voz alta a todo el que entra y no puede evitarlo; le da vergüenza. ' +
      'No miente nunca, pero solo contesta a preguntas con número.',
    trivia: [
      'Es una máquina de filtrar información sin saberlo. Cuarenta y dos menús al día contra doscientos donantes registrados: si los PJs atan esos dos números, se les cae la venda de golpe.',
    ],
    tratos: [
      { kind: 'amistoso', a: 'npc:Casimira', note: 'Vive en la taberna y todos lo toleran con cariño', visto: true },
    ],
  },

  {
    name: 'El Cantor sin Nombre',
    alias: 'El Cantor',
    title: '',
    location: 'La esquina del fondo del Farol Sordo',
    race: 'Humano, aparentemente',
    alignment: 'Caótico neutral',
    description: 'Viejo, ciego de un ojo, salterio pequeño. Canta romances que ya no recuerda nadie más.',
    // Lo de «aparentemente» no lo sabe la mesa.
    ve: { race: false },
    trivia: [
      'Una de sus canciones habla de una ciudad con siete lunas y una novia que espera en un balcón, y la canta como folclore de toda la vida sin que a nadie le extrañe.',
      'Es tu vehículo para soltar pistas del arco sin que ningún PNJ tenga que «saber» nada.',
      'Perla, la perra tuerta de la casa, duerme siempre bajo su mesa, y nunca se acerca a la puerta cuando llueve fuerte.',
      'Nadie sabe dónde vive.',
    ],
    tratos: [
      { kind: 'amistoso', a: 'npc:Casimira', note: 'Le deja el sitio gratis', visto: true },
    ],
  },

  {
    name: 'Belisario Quintanilla',
    alias: '',
    title: 'Funcionario del catastro',
    location: 'La barra del Farol Sordo, de las siete en adelante',
    race: 'Humano',
    alignment: 'Legal neutral',
    description:
      'Del registro municipal de calles y solares. Sobrio es intachable; ' +
      'borracho se queja de su trabajo con una honestidad peligrosa.',
    trivia: [
      'Cada año hay más calle y menos mapa, y a él le pagan igual por dibujar lo que no existía el mes pasado.',
      'Confirma lo de las calles nuevas desde dentro de la institución, que es muy distinto de que lo diga un farolero excéntrico.',
    ],
    tratos: [
      { kind: 'neutral', a: 'El Archivo Catastral', note: 'Su casa' },
      { kind: 'neutral', a: 'npc:Tobías Gill', note: 'Se cruzan y se evitan: cada uno sabe la mitad de lo mismo' },
    ],
  },

  {
    name: 'Los hermanos Pardo',
    alias: '',
    title: 'Pescadores',
    location: 'Remendando redes en la puerta del Farol Sordo',
    race: 'Humanos, gemelos',
    alignment: 'Neutral',
    description:
      'Dejaron de salir al mar hace un año «por lo que se ve entre la niebla cerca de la isla». ' +
      'Hablan poco y solo entre ellos.',
    trivia: [
      'Si les preguntas directamente por la isla, cambian de tema con una educación exagerada, y eso inquieta más que si se negaran.',
    ],
    tratos: [
      { kind: 'neutral', a: 'El gremio de pescadores', note: 'También evita esa zona y no lo admite' },
    ],
  },

  {
    name: 'Doña Sabela Corvino',
    alias: '',
    title: '',
    location: 'El reservado del fondo del Farol Sordo, tres noches seguidas',
    race: 'Humana',
    alignment: 'Legal neutral',
    description:
      'Aristócrata 4, treinta y pocos. Vive en la ciudad alta y viene a pie o en silla de manos. ' +
      'Paga en plata nueva. Curiosa por naturaleza, nunca empieza hostil.',
    trivia: [
      'Perlo contó cuatro personas entrando con ella. Solo se ven dos. Los otros dos están arriba.',
    ],
    tratos: [
      { kind: 'neutral', a: 'npc:Ordo', note: 'Su guardaespaldas', visto: true },
      { kind: 'neutral', a: 'Dos más que no enseña', note: 'Están arriba' },
    ],
  },

  {
    name: 'Ordo',
    alias: '',
    title: 'Guardaespaldas',
    location: 'De pie junto a Doña Sabela, en el Farol Sordo',
    race: 'Semiorco',
    alignment: 'Legal neutral',
    description: 'Profesional, callado, no busca pelea pero la termina.',
    trivia: [],
    tratos: [
      { kind: 'amistoso', a: 'npc:Doña Sabela Corvino', note: 'La protege, y nadie más mientras trabaja', visto: true },
    ],
  },

  {
    name: 'Don Ismael de Bedmar',
    alias: '',
    title: '',
    location: 'El Farol Sordo; acaba de llegar de Vesperanza',
    race: 'Humano',
    alignment: 'Legal bueno',
    description:
      'Treinta y ocho años. El caballo de guerra reventado del aparcadero es suyo: ha cabalgado ' +
      'dos días casi sin parar y ha venido solo, sin escolta. Busca a su hermano pequeño Tobal, ' +
      'desaparecido en Velmorra. Ofrece hasta 1.000 po.',
    trivia: [
      'Venir sin escolta por estos caminos es un suicidio que él conoce de sobra.',
      'Es la alternativa honrada de dinero grande frente a los 10.000 po de vender a Aster. Ponlos a elegir y verás qué campaña tienes.',
      'Si conoce a Vhrael y se entera de lo que es, se le abren los ojos: su hermano es como él.',
    ],
    tratos: [
      { kind: 'familiar', a: 'npc:Tobal de Bedmar', note: 'Su hermano pequeño; ha venido a buscarlo', visto: true },
      { kind: 'neutral', a: 'Su casa en Vesperanza', note: 'No sabe que está aquí' },
    ],
  },

  {
    name: 'Tobal de Bedmar',
    alias: '',
    title: '',
    location: 'Desaparecido en Velmorra',
    race: 'Humano dhampir (templado)',
    alignment: 'Neutral bueno',
    description:
      'El hermano pequeño de Ismael. Se marchó de Vesperanza porque lo que es allí no se puede ser.',
    ve: { listed: false, race: false },
    trivia: [
      'Uso recomendado: que sea uno de los templados sin familia que Tancredo entregó.',
      'Ata la trama de Ismael con la subtrama de «Sangre al Alba» y le da a Vhrael la cara de una víctima concreta en vez de una lista de nombres.',
    ],
    tratos: [
      { kind: 'familiar', a: 'npc:Don Ismael de Bedmar', note: 'Su hermano mayor, que lo busca' },
      { kind: 'neutral', a: 'La comunidad templada de Velmorra', note: 'Lo acogió y luego lo perdió' },
      { kind: 'enemigo', a: 'npc:Tancredo Lis', note: 'Lo apuntó en el libro como pérdida asumible' },
    ],
  },

  // ============================================================ Muelle Bajo ==

  {
    name: 'Teodo Rell',
    alias: '',
    title: 'Capataz de la Lonja de Estibadores',
    location: 'Muelle Bajo; fuma solo en el pasillo trasero del Farol Sordo',
    race: 'Humano',
    alignment: 'Legal neutral',
    description:
      'Capataz del muelle: reparte el trabajo, y en este puerto eso es tener poder de verdad.',
    trivia: [
      'Es quien los estuvo mirando dormir y quien se llevó los cadáveres de los guardias.',
      'Lo delata el barro de marisma de las botas: Zhaelor lo reconoce con Percepción CD 15, con bonificador de circunstancia por venir de una región parecida.',
      'No lo hizo por maldad. Limpiar lo que aparece en el camino de Velmorra forma parte de su trabajo, y lleva años haciéndolo sin preguntar.',
    ],
    tratos: [
      { kind: 'neutral', a: 'El Ministerio del Cáliz', note: 'Le encargan los trabajos sucios y le pagan' },
      { kind: 'neutral', a: 'npc:Emeric Corvane', note: 'Le da los partes que le dejan dar' },
      { kind: 'amistoso', a: 'npc:Nune', note: 'Su cuadrilla' },
      { kind: 'neutral', a: 'npc:Casimira', note: 'Ella sabe lo de la habitación pagada y no usada' },
    ],
  },

  {
    name: 'Nune',
    alias: '',
    title: 'Estibador',
    location: 'El muelle de noche',
    race: 'Humano, joven',
    alignment: 'Neutral bueno',
    description: 'Estibador nuevo. Todavía no ha aprendido a mirar para otro lado.',
    trivia: [
      'Existe para enseñarle al grupo lo que cuesta el muelle de noche sin tener que matar a un PJ para demostrarlo.',
    ],
    tratos: [
      { kind: 'amistoso', a: 'npc:Teodo Rell', note: 'Su capataz' },
      { kind: 'amistoso', a: 'Los forasteros', note: 'Le caen bien porque todavía no ha aprendido a mirar para otro lado' },
    ],
  },

  // ============================================================= El Relicario ==

  {
    name: 'Serafín Nácar',
    alias: '',
    title: 'Joyero',
    location: 'Joyería Nácar & Luto, El Relicario',
    race: 'Dhampir (templado)',
    alignment: 'Neutral bueno',
    description:
      'Aparenta cincuenta. Lupa de joyero encajada en el ojo derecho, que no se quita jamás: dice que ' +
      'la última vez que lo hizo «vio la ciudad tal como es, y no le gustó». Habla de las piedras como ' +
      'si fueran vecinas cotillas. Tasa gratis la primera vez, «para conocerle a usted, no a la joya». Tasación +16.',
    ve: { race: false },
    trivia: [
      'Tiene más de ciento cuarenta años.',
      'Tesorero de los Templados. Guarda un libro con los sellos de todas las familias dhampir que conoce, vivas o extintas, y tiene la lista de los cuatro templados desaparecidos este mes.',
      'Le engastó al Conde Vantarre un reloj de sol de bolsillo «para un hombre que no sale de día».',
      'Si le mencionan un frasco de sangre plateada, cambia de tema demasiado deprisa.',
      'Es socio «de segunda» del Club de los Insomnes y puede colar allí a los PJs.',
      'Es la puerta de entrada a toda la subtrama. En cuanto vea el anillo de Vhrael, se le cae la lupa por primera vez en ochenta años.',
    ],
    tratos: [
      { kind: 'familiar', a: 'npc:Clementina Nácar', note: 'Su sobrina-bisnieta; le lleva las cuentas', visto: true },
      { kind: 'neutral', a: 'npc:Tancredo Lis', note: 'Su portavoz, del que empieza a desconfiar' },
      { kind: 'amistoso', a: 'La comunidad templada', note: 'Es su tesorero' },
      { kind: 'amistoso', a: 'npc:Críspulo Fenn', note: 'Vecinos de barrio' },
      { kind: 'neutral', a: 'Los ricos de Alto Velo', note: 'Clientes' },
      { kind: 'neutral', a: 'pj:Vhrael', note: 'Reconocerá su anillo-sello a la primera' },
    ],
  },

  {
    name: 'Clementina Nácar',
    alias: '',
    title: '',
    location: 'Detrás de la caja de Nácar & Luto',
    race: 'Humana',
    alignment: 'Neutral bueno',
    description:
      'Veintitantos. Sobrina-bisnieta de Serafín, lleva las cuentas. ' +
      'Tercera generación de la familia que envejece delante de él.',
    trivia: [
      'Lo llevan con humor negro: «Tío, cuando me muera, hazme un broche bonito».',
    ],
    tratos: [
      { kind: 'familiar', a: 'npc:Serafín Nácar', note: 'Su tío-bisabuelo', visto: true },
      { kind: 'neutral', a: 'Los proveedores', note: 'Lleva ella el trato' },
      { kind: 'amistoso', a: 'La mitad de las criadas de Alto Velo', note: 'Se entera de todo' },
    ],
  },

  {
    name: 'Críspulo Fenn',
    alias: '',
    title: 'Daguerrotipista',
    location: 'Estudio Lumen, El Relicario',
    race: 'Humano',
    alignment: 'Neutral',
    description:
      'Retratos post mortem: sienta al difunto, le pinta los ojos sobre los párpados y lo rodea de su ' +
      'familia. Prefiere retratar muertos «porque los vivos se mueven». 10 po el retrato.',
    trivia: [
      'La placa es plata pulida como un espejo, así que los vampiros clásicos no salen y los templados sí.',
      'Hace un mes el Club de los Insomnes le encargó un retrato de grupo: doce sillas, siete personas, y un guante flotando sobre una de las vacías.',
      'No duerme desde entonces y vendería la placa por 50 po solo por quitársela de encima.',
    ],
    tratos: [
      { kind: 'neutral', a: 'npc:Doña Perpetua Ruíz-Mor', note: 'Le llegan los muertos por ahí' },
      { kind: 'neutral', a: 'Las familias de luto de medio Velmorra', note: 'Su clientela' },
      { kind: 'amistoso', a: 'npc:Serafín Nácar', note: 'Vecinos de barrio' },
      { kind: 'enemigo', a: 'El Club de los Insomnes', note: 'Le encargaron el retrato; desde entonces no duerme' },
    ],
  },

  // ========================================================= Calle del Yunque ==

  {
    name: 'Gaspar Tornaferro',
    alias: '',
    title: 'Herrero y armero',
    location: 'Su forja, Calle del Yunque',
    race: 'Humano',
    alignment: 'Neutral bueno',
    description:
      'Enorme, brazos negros de hollín, voz suave, paciencia infinita. Teje mientras espera a que el ' +
      'metal se caliente: agujas de acero, lana roja. «El acero y la lana son lo mismo, chaval: todo es ' +
      'saber cuándo tensar».',
    trivia: [
      'Regala bufandas a los clientes que le caen bien, y a quien recibe una le hace siempre un 10% de descuento.',
      'Cumple el Registro de Plata del Ministerio al pie de la letra, porque es un hombre legal, y no se le ha ocurrido pensar quién lee ese registro.',
    ],
    tratos: [
      { kind: 'amistoso', a: 'npc:Brígida «Plata» Olmedo', note: 'Su socia, en el banco del fondo', visto: true },
      { kind: 'neutral', a: 'El gremio de herreros', note: 'Cumplidor' },
      { kind: 'neutral', a: 'La guardia', note: 'Les arregla el equipo' },
      { kind: 'neutral', a: 'El Ministerio del Cáliz', note: 'Un funcionario viene a sellarle el registro cada mes' },
    ],
  },

  {
    name: 'Brígida «Plata» Olmedo',
    alias: 'Plata',
    title: 'Plateadora y grabadora',
    location: 'El banco del fondo de la forja, Calle del Yunque',
    race: 'Mediana',
    alignment: 'Caótico neutral',
    description:
      'Platea, graba y es la única de la calle que entiende de pólvora. Habla a toda velocidad y ' +
      'apuesta por cualquier cosa. Platea por la puerta de atrás con un 50% de recargo y sin apuntar ' +
      'nada en el registro.',
    trivia: [
      'Colecciona balas de plata usadas «con historia».',
      'Tiene colgadas en la pared de segunda mano las dos dagas de Aster, las que se llevó clavadas el tercer perro de niebla.',
      'Se las compró hace dos días a un cochero con librea sin escudo, y dice que «olían a niebla, y la niebla no huele».',
      'Se las devuelve a 4 po «porque una daga que vuelve con su dueño trae suerte, y yo apuesto siempre a la suerte».',
      'Decide antes de la próxima sesión de quién era esa librea: de ahí sale el dueño de los perros de niebla.',
    ],
    tratos: [
      { kind: 'amistoso', a: 'npc:Gaspar Tornaferro', note: 'Su socio', visto: true },
      { kind: 'neutral', a: 'npc:Ambrosio Cuajo', note: 'Le compra plateado y le vende reactivos' },
      { kind: 'neutral', a: 'Media Sentina', note: 'Trato y apuestas' },
      { kind: 'neutral', a: 'El dueño de los perros de niebla', note: 'Le compró las dagas a su cochero sin saber a quién servía' },
      { kind: 'neutral', a: 'pj:Aster', note: 'Tiene sus dos dagas colgadas de segunda mano' },
    ],
  },

  // ==================================================== El Ministerio del Cáliz ==

  {
    name: 'Ulpiano Grajal',
    alias: '',
    title: 'Licenciado, dispensador jefe',
    location: 'Dispensario nº 7, Plaza del Cáliz',
    race: 'Humano',
    alignment: 'Legal neutral',
    description:
      'Flaco, meticuloso, lo sella todo: recetas, recibos, servilletas y una vez la mano de un cliente. ' +
      'Para él nada existe hasta que tiene sello. No es malo: es un engranaje orgulloso de serlo.',
    trivia: [
      'Dice ser alérgico al ajo.',
      'Si un PJ le miente y él lo nota (Averiguar intenciones +8), no dice nada: cambia de sello.',
      'En la cartilla de donante hay tres preguntas que no pegan con las demás y todas van de sueños. Si Aster contesta con sinceridad, alguien recibe una copia por triplicado.',
    ],
    tratos: [
      { kind: 'neutral', a: 'El Ministerio del Cáliz', note: 'Manda las copias hacia arriba' },
      { kind: 'neutral', a: 'npc:Hermano Sabas', note: 'Recoge aquí sus cajas' },
      { kind: 'neutral', a: 'npc:Rosalba Mies', note: 'Su dependienta', visto: true },
      { kind: 'neutral', a: 'Todo barrio que necesite una poción', note: 'Su clientela' },
    ],
  },

  {
    name: 'Rosalba Mies',
    alias: '',
    title: 'Dependienta',
    location: 'El mostrador del Dispensario nº 7',
    race: 'Humana ambarina',
    alignment: 'Neutral bueno',
    description:
      'Simpatiquísima, con unos ojos color miel preciosos que no tenía hace un año y unos anteojos ' +
      'ahumados para cuando entra el sol por el escaparate.',
    ve: { race: false },
    trivia: [
      'Es una ambarina en fase temprana y ni ella lo sabe.',
      'Es la primera «semi» que verán los PJs, y su encanto es justo ese: es majísima y se está convirtiendo en otra cosa delante de todos.',
    ],
    tratos: [
      { kind: 'neutral', a: 'npc:Ulpiano Grajal', note: 'Su jefe', visto: true },
      { kind: 'amistoso', a: 'Los clientes fijos', note: 'Se los sabe por el nombre' },
      { kind: 'familiar', a: 'Su familia', note: 'Le dice que está estupenda' },
    ],
  },

  {
    name: 'Hermano Sabas',
    alias: '',
    title: 'Ministro de barrio',
    location: 'Los barrios pobres, con su carro de cajas',
    race: 'Humano',
    alignment: 'Legal bueno',
    description:
      'Reparte sangre a los pobres y cree de verdad que hace el bien. ' +
      'Y en cierto modo lo hace, que es lo incómodo del personaje.',
    trivia: [
      'Cuenta las gotas en voz alta al servir.',
      'Lo único que teme es que le corten el suministro.',
    ],
    tratos: [
      { kind: 'neutral', a: 'npc:Ulpiano Grajal', note: 'Su proveedor' },
      { kind: 'amistoso', a: 'Las familias pobres de tres barrios', note: 'Su gente' },
      { kind: 'amistoso', a: 'npc:Padre Rufino Ceballos', note: 'Rivalidad amable sobre quién consuela mejor' },
    ],
  },

  // ==================================================== alquimia clandestina ==

  {
    name: 'Ambrosio Cuajo',
    alias: '',
    title: 'Alquimista',
    location: 'La Barcaza Ahogada, un canal muerto de la Sentina',
    race: 'Gnomo',
    alignment: 'Caótico neutral',
    description:
      'Gemelo de Anacleto. Compiten por todo, empezando por quién es el mayor: nadie lo sabe porque la ' +
      'madre murió sin decirlo, por venganza. Cada uno prueba las mezclas del otro, así que casi siempre ' +
      'uno de los dos brilla un poco en la oscuridad o tiene la voz muy aguda. ' +
      'Venden química del manual al 80% y ámbar cortado a 10 po.',
    trivia: [
      'Se fían de cualquiera que le dé la razón a uno contra el otro, y esa es la forma barata de sacarles información.',
      'Venden cánulas y frascos esterilizados en cantidad a la perfumería Aguas de Medianoche, y no han preguntado para qué.',
    ],
    tratos: [
      { kind: 'familiar', a: 'npc:Anacleto Cuajo', note: 'Su gemelo; compiten por todo', visto: true },
      { kind: 'neutral', a: 'npc:Muérdago', note: 'Le lleva y le trae clientes' },
      { kind: 'neutral', a: 'npc:Brígida «Plata» Olmedo', note: 'Trato de plateado y reactivos' },
      { kind: 'neutral', a: 'npc:Madame Lisandra Voss', note: 'Su mejor cliente' },
    ],
  },

  {
    name: 'Anacleto Cuajo',
    alias: '',
    title: 'Alquimista',
    location: 'La Barcaza Ahogada, un canal muerto de la Sentina',
    race: 'Gnomo',
    alignment: 'Caótico neutral',
    description:
      'Gemelo de Ambrosio. Compiten por todo, empezando por quién es el mayor: nadie lo sabe porque la ' +
      'madre murió sin decirlo, por venganza. Cada uno prueba las mezclas del otro, así que casi siempre ' +
      'uno de los dos brilla un poco en la oscuridad o tiene la voz muy aguda. ' +
      'Venden química del manual al 80% y ámbar cortado a 10 po.',
    trivia: [
      'Se fían de cualquiera que le dé la razón a uno contra el otro, y esa es la forma barata de sacarles información.',
      'Venden cánulas y frascos esterilizados en cantidad a la perfumería Aguas de Medianoche, y no han preguntado para qué.',
    ],
    tratos: [
      { kind: 'familiar', a: 'npc:Ambrosio Cuajo', note: 'Su gemelo; compiten por todo', visto: true },
      { kind: 'neutral', a: 'npc:Muérdago', note: 'Le lleva y le trae clientes' },
      { kind: 'neutral', a: 'Media Sentina', note: 'Clientela' },
      { kind: 'neutral', a: 'npc:Madame Lisandra Voss', note: 'Su mejor cliente' },
    ],
  },

  {
    name: 'Vesna Halloc',
    alias: '',
    title: 'Cirujana',
    location: 'El sótano de la pastelería La Rosquilla Feliz, Muelle Bajo',
    race: 'Humana',
    alignment: 'Caótico neutral',
    description:
      'Cirujana expulsada del Ministerio. Quiere volver a entrar, o quemarlo. Intenta demostrar de dónde ' +
      'sale el ámbar y paga 40 po por cada frasco auténtico, más de lo que cuestan en la botica. ' +
      'Cama en su sótano: 2 po la noche. Con Sanar +14 es la forma más barata de curarse en Velmorra ' +
      'sin pasar por el Cáliz.',
    trivia: [
      'Se disculpa antes de hacer daño: «Perdón, perdón, esto va a doler».',
      'Odia al Ministerio y tiene contactos dentro.',
    ],
    tratos: [
      { kind: 'familiar', a: 'npc:Doña Pura', note: 'Su tía; le deja el sótano', visto: true },
      { kind: 'neutral', a: 'npc:Ambrosio Cuajo', note: 'Le compra material' },
      { kind: 'neutral', a: 'Contrabandistas del muelle', note: 'Le traen frascos' },
      { kind: 'enemigo', a: 'El Ministerio del Cáliz', note: 'La expulsó; quiere volver a entrar o quemarlo' },
    ],
  },

  {
    name: 'Doña Pura',
    alias: '',
    title: 'Pastelera',
    location: 'La Rosquilla Feliz, planta de arriba, Muelle Bajo',
    race: 'Humana',
    alignment: 'Neutral',
    description:
      'Hace el mejor bizcocho de la ciudad y no pregunta qué pasa en su sótano. ' +
      '«Si baja alguien sangrando, que no me manche los merengues».',
    trivia: [],
    tratos: [
      { kind: 'familiar', a: 'npc:Vesna Halloc', note: 'Su sobrina, la del sótano', visto: true },
      { kind: 'amistoso', a: 'Medio barrio', note: 'Viene por el bizcocho' },
    ],
  },

  {
    name: 'Madame Lisandra Voss',
    alias: '',
    title: 'Perfumista',
    location: 'Perfumería Aguas de Medianoche',
    race: 'Semielfa',
    alignment: 'Neutral malvado',
    description:
      'Elegante, encantadora y completamente amoral. Describe a la gente por su olor y no recuerda ' +
      'caras, solo aromas. No odia a nadie: simplemente le da igual de dónde salgan sus ingredientes. ' +
      'Oficio (alquimia) +15, Averiguar intenciones +12.',
    trivia: [
      'Es quien fabrica el Ungüento de Aurora (5.000 po el tarro), el bálsamo que permite a un vampiro clásico aguantar una hora de sol.',
      'El ingrediente principal es sangre de dhampir, mucha, y la extrae ella misma en la trastienda con las cánulas de los Cuajo. Los cuerpos acaban en los canales.',
      'Olió a los PJs nada más entrar: «jaula» para los tres, «pantano» para Zhaelor y «una lluvia que todavía no ha caído» para Aster.',
      'Vhrael, dentro de la tienda, huele sangre de los suyos bajo los perfumes: Sabiduría CD 12, automático en la trastienda.',
    ],
    tratos: [
      { kind: 'neutral', a: 'npc:Conde Aurelio Vantarre', note: 'Su cliente' },
      { kind: 'neutral', a: 'npc:Mayordomo Fiacro', note: 'Recoge los paquetes cada viernes' },
      { kind: 'neutral', a: 'npc:Tancredo Lis', note: 'Le entrega la materia prima' },
      { kind: 'neutral', a: 'npc:Ambrosio Cuajo', note: 'Proveedor de cánulas y frascos' },
      { kind: 'neutral', a: 'La mitad de Alto Velo', note: 'Le compra perfume y no sabe nada' },
    ],
  },

  {
    name: 'Don Lino',
    alias: '',
    title: 'Barbero-sangrador',
    location: 'Su barbería, en la Sentina',
    race: 'Humano',
    alignment: 'Neutral',
    description:
      '«Afeita y sangra». Te sangra por salud, como se ha hecho toda la vida, ' +
      'y luego vende tu sangre al Cáliz. 1 pp el afeitado.',
    trivia: [
      'Es perfectamente legal y perfectamente asqueroso, y en Velmorra nadie ve la diferencia.',
    ],
    tratos: [
      { kind: 'neutral', a: 'El dispensario', note: 'Le compra la sangre' },
      { kind: 'neutral', a: 'Los clientes pobres', note: 'Se dejan sangrar por un afeitado gratis' },
    ],
  },

  // ================================================= la Sentina y las calles ==

  {
    name: 'Muérdago',
    alias: '',
    title: 'Informadora',
    location: 'Los canales de la Sentina',
    race: 'Humana, cría de la calle',
    alignment: 'Caótico neutral',
    description:
      'Sobrevive y colecciona. Es quien te lleva a la Barcaza Ahogada: dos dientes por cabeza.',
    trivia: [
      'Cobra en dientes. No en oro, en dientes. De quién sean es asunto suyo y no piensa explicarlo.',
      'Ha visto un carro de la perfumería en la Sentina de madrugada, y ese dato lo vende barato porque no sabe lo que vale.',
    ],
    tratos: [
      { kind: 'neutral', a: 'npc:Ambrosio Cuajo', note: 'Les lleva clientes' },
      { kind: 'neutral', a: 'npc:Vesna Halloc', note: 'Le lleva desesperados' },
      { kind: 'amistoso', a: 'Las cuadrillas de crías de los canales', note: 'Los suyos' },
      { kind: 'neutral', a: 'Cualquiera que pague', note: 'En dientes' },
    ],
  },

  {
    name: 'Doña Perpetua Ruíz-Mor',
    alias: '',
    title: 'Forense',
    location: 'Depósito municipal de cadáveres',
    race: 'Humana',
    alignment: 'Neutral bueno',
    description: 'Forense municipal. Quiere que nadie le toque sus cadáveres.',
    trivia: [
      'Les pone nombre y les habla: «No le hagas caso a Anselmo, hoy está de morros».',
      'Puede falsificar un certificado de defunción, que es la salida más rápida al problema legal de los PJs, y es un favor que se cobra.',
      'Cuando llegue el templado desangrado del Reloj D lo llamará Nicasio y dirá que lo vaciaron «con cánula, con cuidado, como en una botica».',
    ],
    tratos: [
      { kind: 'enemigo', a: 'npc:Emeric Corvane', note: 'Tensión constante: ella protege a sus cadáveres de él' },
      { kind: 'neutral', a: 'npc:Críspulo Fenn', note: 'Le manda los muertos' },
      { kind: 'neutral', a: 'Los enterradores', note: 'Trato diario' },
      { kind: 'enemigo', a: 'El Ministerio del Cáliz', note: 'Le reclama cuerpos que ella retrasa todo lo que puede' },
    ],
  },

  {
    name: 'Tobías Gill',
    alias: '',
    title: 'Farolero jefe',
    location: 'Las Siete Agujas y todas las farolas de la ciudad',
    race: 'Humano',
    alignment: 'Legal neutral',
    description:
      'Farolero jefe del gremio. Quiere que sus faroles se enciendan en orden, ' +
      'y ese orden le importa más que casi nada.',
    trivia: [
      'Sabe qué calles no existían la semana pasada, porque él las enciende.',
      'Lleva las etiquetas alfabetizadas en un cuaderno y habla solo.',
    ],
    tratos: [
      { kind: 'amistoso', a: 'Su gremio', note: 'Los faroleros' },
      { kind: 'amistoso', a: 'npc:Padre Rufino Ceballos', note: 'Los faroleros mantienen Santa Candela' },
      { kind: 'neutral', a: 'npc:Belisario Quintanilla', note: 'Cada uno tiene la mitad de la misma verdad' },
      { kind: 'neutral', a: 'npc:Elvira Sandoval', note: 'Vive en una de esas calles' },
    ],
  },

  {
    name: 'Elvira Sandoval',
    alias: '',
    title: '',
    location: 'Una calle nueva, impecable y vacía',
    race: '',
    alignment: '',
    description:
      'Una señora mayor, agradable, en el umbral de su puerta con un cestillo, sonriendo. ' +
      'Completamente normal y acogedora, en mitad de una calle que no estaba ahí hace un mes.',
    trivia: [
      'Su inquietud es de contexto puro, no de aspecto. No le pasa nada raro. Lo raro es dónde está.',
      'Raza y alineamiento: decídelos tú.',
    ],
    tratos: [
      { kind: 'neutral', a: 'Sus vecinos', note: 'También son nuevos' },
      { kind: 'neutral', a: 'npc:Tobías Gill', note: 'Él enciende su calle' },
    ],
  },

  // =========================================================== Las Siete Agujas ==

  {
    name: 'Padre Rufino Ceballos',
    alias: '',
    title: 'Clérigo de Santa Candela',
    location: 'Santuario de Santa Candela, Las Siete Agujas',
    race: 'Humano',
    alignment: 'Neutral bueno',
    description:
      'Clérigo 5, viejísimo y bondadoso. Se duerme en mitad de las frases y se despierta terminándolas ' +
      'como si nada. Vende conjuros (curación, quitar enfermedad, quitar maldición) y «regala» agua ' +
      'bendita a cambio de un donativo voluntario de 25 po, que casualmente es su precio de catálogo.',
    trivia: [
      'Si le preguntan con qué sueña, dice que con «unas lunas muy bonitas, siete o así», y se vuelve a dormir.',
      'Si el Ministerio busca soñadores, ¿por qué nadie se ha llevado a Rufino? Guárdate la respuesta.',
    ],
    tratos: [
      { kind: 'amistoso', a: 'npc:Tobías Gill', note: 'El gremio de faroleros es prácticamente su feligresía entera' },
      { kind: 'amistoso', a: 'npc:Hermano Sabas', note: 'Rivalidad amable sobre quién consuela mejor' },
      { kind: 'amistoso', a: 'Los pobres del barrio', note: 'Su gente' },
    ],
  },

  {
    name: 'Doña Resu',
    alias: '',
    title: 'Puesto de copas',
    location: 'Mercado de las Horas',
    race: 'Humana',
    alignment: 'Neutral',
    description:
      'Sirve sangre por copas, legal y a la vista: de cerdo, de cordero y «de donante». ' +
      'Trata igual a un vivo, a un templado y a un vampiro, porque todos pagan igual.',
    trivia: [],
    tratos: [
      { kind: 'neutral', a: 'Los mataderos', note: 'Sus proveedores' },
      { kind: 'neutral', a: 'La clientela nocturna de Velmorra', note: 'Toda' },
    ],
  },

  {
    name: 'El Ajero',
    alias: '',
    title: 'Estraperlista de ajo',
    location: 'Mercado de las Horas, con un ojo en la calle',
    race: 'Mediano',
    alignment: 'Caótico neutral',
    description:
      'Vende ajo de estraperlo: 1 pp la cabeza, o 5 po si hay guardias mirando. El ajo no es ilegal ' +
      'exactamente, pero el Arancel del Ajo del puerto lo grava como si fuera coñac, y él lo pasa en ' +
      'barriles de sardinas.',
    trivia: [
      'Vive de un producto que en cualquier otra ciudad del mundo vale nada. Eso te dice todo sobre Velmorra sin explicar nada.',
    ],
    tratos: [
      { kind: 'neutral', a: 'Contrabandistas del Muelle Bajo', note: 'Le pasan los barriles' },
      { kind: 'neutral', a: 'Las cocineras', note: 'Clientela honrada' },
      { kind: 'neutral', a: 'Clientes con una prisa que no es culinaria', note: 'La otra clientela' },
    ],
  },

  {
    name: 'El notario sin notaría',
    alias: '',
    title: '',
    location: 'Mercado de las Horas',
    race: 'Humano',
    alignment: 'Neutral malvado',
    description:
      'Vende cartas de invitación firmadas por propietarios endeudados: entre 50 y 500 po según la casa. ' +
      'Sirven para que un vampiro pueda entrar donde no debería.',
    trivia: [
      'Es ilegal y todo el mundo sabe exactamente dónde está su puesto. Eso es Velmorra en una frase.',
    ],
    tratos: [
      { kind: 'neutral', a: 'La Sangre Vieja', note: 'Sus mejores clientes' },
      { kind: 'neutral', a: 'Propietarios arruinados de Alto Velo', note: 'Sus proveedores de firmas' },
      { kind: 'neutral', a: 'npc:Mayordomo Fiacro', note: 'Le compra y le desprecia a partes iguales' },
    ],
  },

  {
    name: 'Bonifacio',
    alias: '',
    title: 'Titiritero',
    location: 'Su teatrillo de marionetas, Mercado de las Horas',
    race: 'Humano',
    alignment: 'Caótico neutral',
    description:
      'Cada noche representa «una tragedia de verdad, con final gracioso». Y son de verdad: ' +
      'coge desgracias que han pasado y las convierte en comedia.',
    trivia: [
      'Una noche representa La caída de la Casa de los Templados, la historia de la familia dhampir que se negó al trato y acabó mal.',
      'Si esa es la casta de Vhrael, verá su tragedia contada con voces graciosas delante de un público que se ríe. Úsalo solo si crees que su jugador va a disfrutar el golpe.',
      'Alguien le cuenta las historias. Piensa quién.',
    ],
    tratos: [
      { kind: 'amistoso', a: 'El público de las Siete Agujas', note: 'Todas las noches' },
      { kind: 'neutral', a: 'Quien le cuenta las historias', note: 'Decide quién' },
    ],
  },

  // =============================================== Alto Velo y la Sangre Vieja ==

  {
    name: 'Tancredo Lis',
    alias: '',
    title: 'Portavoz templado',
    location: 'Alto Velo; despacho de contable',
    race: 'Dhampir (templado)',
    alignment: 'Legal neutral',
    description:
      'Portavoz de la comunidad templada. Meticuloso, lleva libro de todo. Quiere de verdad a los suyos.',
    ve: { race: false },
    trivia: [
      'Y por eso los vende. La Sangre Vieja le dio a elegir: entregar «uno al mes, de los que nadie echa de menos», o que hicieran con los templados de Velmorra lo que se hizo con otra casta que se negó.',
      'Elige a los que no tienen familia y los apunta en su libro como «pérdidas asumibles».',
      'Si lo descubren, no huye ni pelea: saca el libro y enseña los números. «Uno al mes. Sesenta vivos. ¿Tienen ustedes una cuenta mejor? Díganmela, se lo ruego».',
      'Es el villano de la subtrama, y es el que más lástima debería dar.',
    ],
    tratos: [
      { kind: 'amistoso', a: 'Los sesenta templados de Velmorra', note: 'Su comunidad' },
      { kind: 'neutral', a: 'npc:Serafín Nácar', note: 'Su tesorero, que empieza a atar cabos' },
      { kind: 'neutral', a: 'npc:Mayordomo Fiacro', note: 'Le paga en el Mercado de las Horas, junto al teatrillo' },
      { kind: 'neutral', a: 'npc:Madame Lisandra Voss', note: 'Le entrega la materia prima' },
    ],
  },

  {
    name: 'Mayordomo Fiacro',
    alias: '',
    title: 'Mayordomo del Club de los Insomnes',
    location: 'La puerta del Club de los Insomnes',
    race: 'Engendro vampírico',
    alignment: 'Legal malvado',
    description:
      'Portero y mayordomo, VD 4. Cortesía absoluta, voz de terciopelo, no parpadea.',
    ve: { listed: false, race: false },
    trivia: [
      'Lleva doscientos años sin decir una palabrota y está muy orgulloso de ello.',
      'A nivel 1 no es un enemigo, es un muro. Guárdalo para cuando tengan nivel 3 o 4 y algo de plata.',
    ],
    tratos: [
      { kind: 'neutral', a: 'npc:Conde Aurelio Vantarre', note: 'Su amo' },
      { kind: 'neutral', a: 'Los socios del Club', note: 'Los atiende a todos' },
      { kind: 'neutral', a: 'npc:Madame Lisandra Voss', note: 'Le recoge los paquetes los viernes' },
      { kind: 'neutral', a: 'npc:Tancredo Lis', note: 'Le paga' },
      { kind: 'neutral', a: 'npc:El notario sin notaría', note: 'Le compra y le desprecia a partes iguales' },
    ],
  },

  {
    name: 'Conde Aurelio Vantarre',
    alias: '',
    title: 'Presidente del Club de los Insomnes',
    location: 'Su mansión de Alto Velo y el Club de los Insomnes',
    race: 'Vampiro (Sangre Vieja)',
    alignment: 'Legal malvado',
    description:
      'El más antiguo de la ciudad y el poder real de Velmorra, aunque no salga en ningún censo. ' +
      'Elegante, melancólico, con un humor muy seco. Lleva tres siglos sin ver el sol y está obsesionado ' +
      'con volver a verlo: colecciona relojes de sol en un salón sin ventanas.',
    ve: { listed: false, race: false },
    trivia: [
      'Se sabe de memoria a qué hora amanece cada día del año.',
      'No es un monstruo que ruge: es un hombre que quiere algo con tanta fuerza que ha dejado de ver lo que cuesta. «¿Sabe usted lo que es no recordar de qué color es el mediodía?»',
      'En el Reloj D acaba paseándose a mediodía por la Plaza del Cáliz, con sombrilla, delante de toda la ciudad.',
      'No le hagas ficha. A nivel 1, si pelean con él, mueren los tres.',
    ],
    tratos: [
      { kind: 'amistoso', a: 'La docena de vampiros de la Sangre Vieja', note: 'Los preside' },
      { kind: 'neutral', a: 'npc:Mayordomo Fiacro', note: 'Su mayordomo' },
      { kind: 'neutral', a: 'npc:Madame Lisandra Voss', note: 'Su proveedora del Ungüento de Aurora' },
      { kind: 'neutral', a: 'npc:Serafín Nácar', note: 'Le engastó el reloj de sol de bolsillo' },
      { kind: 'neutral', a: 'El Ministerio del Cáliz', note: 'Acuerdo de la Copa: el Cáliz le da sangre embotellada y discreción; él no caza por la calle y financia al Ministerio' },
    ],
  },

  {
    name: 'Nicasio',
    alias: '',
    title: '',
    location: 'Una mesa de piedra en el depósito de Perpetua',
    race: 'Dhampir',
    alignment: '',
    description:
      'El primer cadáver de la subtrama. Un templado desangrado que aparece en un canal de la Sentina, ' +
      'en el primer paso del Reloj D. Perpetua le puso ese nombre porque no tenía ninguno.',
    ve: { listed: false, race: false },
    trivia: [
      'Un dhampir sin sangre es algo que Velmorra no ha visto nunca, y Perpetua lo sabe.',
      'Es la primera vez que la subtrama toca la mesa.',
    ],
    tratos: [
      { kind: 'neutral', a: 'npc:Doña Perpetua Ruíz-Mor', note: 'Le puso el nombre' },
      { kind: 'enemigo', a: 'npc:Madame Lisandra Voss', note: 'Lo vaciaron «con cánula, con cuidado, como en una botica»' },
    ],
  },
];
