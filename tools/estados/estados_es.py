"""Condiciones, enfermedades y venenos del SRD 3.5 en español.

Como con las dotes, aquí se traduce TODO: una condición son dos o tres frases
y es de lo que más se consulta en mitad de un combate. El texto es fiel en los
números y más directo que el original.
"""

# nombre en inglés -> (nombre, texto)
CONDICIONES = {
'Ability Damaged': ('Característica dañada',
  'Has perdido puntos de una característica de forma temporal: se recuperan solos a razón de 1 punto por noche de descanso (2 si descansas el día entero). Aplica el nuevo modificador a todo lo que dependa de ella. Si la Fuerza llega a 0 no puedes moverte; si es la Destreza, quedas paralizado; si es la Constitución, mueres. Inteligencia, Sabiduría o Carisma a 0 te dejan inconsciente.'),

'Ability Drained': ('Característica succionada',
  'Como el daño a una característica, pero la pérdida es PERMANENTE: no se cura descansando, solo con magia. Se aplica igual a todo lo que dependa de esa característica.'),

'Blinded': ('Cegado',
  'No ves nada. −2 a la CA, pierdes tu bonificador de Destreza a la CA, te mueves a la mitad de velocidad y sufres −4 a Buscar y a casi toda prueba de habilidad basada en Fuerza o Destreza. Todo lo que dependa de la vista falla automáticamente. Para ti, todos tus enemigos tienen ocultación total: 50% de fallo.'),

'Blown Away': ('Arrastrado por el viento',
  'El vendaval te tira y te hace rodar por el suelo 1d4×10 pies, con 1d4 de daño no letal por cada 10 pies. Si vuelas, te lleva 2d6×10 pies hacia atrás y sufres 2d6 de daño no letal.'),

'Checked': ('Frenado',
  'El viento te impide avanzar contra él. A pie no puedes moverte hacia el viento; volando, retrocedes 1d6×5 pies.'),

'Confused': ('Confundido',
  'No decides tú: cada asalto tira 1d100. 01-25 actúa con normalidad; 26-50 no hace nada y balbucea; 51-75 se hiere a sí mismo con lo que lleve en la mano; 76-100 ataca a la criatura más cercana. Si alguien te ataca, atacas a quien te atacó hasta que deje de hacerlo.'),

'Cowering': ('Acobardado',
  'El miedo te tiene clavado: no haces nada, y encima quedas indefenso (−2 a la CA y sin bonificador de Destreza).'),

'Dazed': ('Aturullado',
  'No puedes hacer nada durante un asalto, pero te defiendes con normalidad: conservas tu CA y tu bonificador de Destreza. Normalmente dura un solo asalto.'),

'Dazzled': ('Deslumbrado',
  'La luz te ha dado de lleno: −1 a las tiradas de ataque, a Buscar y a Avistar.'),

'Dead': ('Muerto',
  'Tus puntos de golpe han bajado de −10, o has muerto de golpe por un efecto que mata. No puedes hacer nada. El alma se marcha del cuerpo y hace falta magia para traerla de vuelta.'),

'Deafened': ('Ensordecido',
  'No oyes: −4 a la iniciativa, fallas automáticamente las pruebas de Escuchar y tienes un 20% de probabilidad de fallar al lanzar un conjuro con componente verbal.'),

'Disabled': ('Incapacitado',
  'Estás exactamente a 0 puntos de golpe. Puedes hacer una acción de movimiento o una estándar por asalto, pero si haces algo agotador (atacar, correr, lanzar un conjuro) pierdes 1 punto de golpe al terminarla y pasas a moribundo.'),

'Dying': ('Moribundo',
  'Entre −1 y −9 puntos de golpe, inconsciente y sin poder hacer nada. Cada asalto pierdes 1 punto de golpe hasta morir, salvo que te estabilices: tira d% cada asalto, con un 10% de estabilizarte solo. Otro puede estabilizarte con una prueba de Sanar CD 15.'),

'Energy Drained': ('Con energía succionada',
  'Tienes uno o más niveles negativos. Cada uno da −1 a las tiradas de ataque, de salvación, de habilidad y de característica, −5 puntos de golpe y −1 al nivel efectivo. Un lanzador pierde además un conjuro del nivel más alto que pueda lanzar. Si acumulas tantos niveles negativos como tu nivel, mueres. A las 24 horas hay que salvar por Fortaleza: si superas, el nivel negativo se va; si fallas, se vuelve permanente.'),

'Entangled': ('Enredado',
  'Te mueves a la mitad de velocidad, no puedes correr ni cargar, sufres −2 al ataque y −4 a la Destreza efectiva. Si estás enredado a algo fijo, no puedes moverte. Lanzar un conjuro exige una prueba de Concentración CD 15 + nivel del conjuro.'),

'Exhausted': ('Exhausto',
  'Te mueves a la mitad de velocidad y sufres −6 a Fuerza y Destreza. Tras una hora de descanso completo pasas a fatigado.'),

'Fascinated': ('Fascinado',
  'Algo te tiene absorto: te quedas quieto mirándolo, con −4 a las pruebas de reacción (Avistar, Escuchar). Cualquier amenaza obvia rompe el efecto, y una sacudida amistosa también, gastando una acción estándar.'),

'Fatigued': ('Fatigado',
  'No puedes correr ni cargar, y sufres −2 a Fuerza y Destreza. Descansar ocho horas lo quita. Si te fatigas estando ya fatigado, pasas a exhausto.'),

'Flat-Footed': ('Desprevenido',
  'Antes de tu primer turno del combate, o cuando te pillan de improviso: pierdes tu bonificador de Destreza a la CA y no puedes hacer ataques de oportunidad.'),

'Frightened': ('Asustado',
  'Huyes de lo que te asusta lo mejor que puedas. Si no puedes huir, peleas con −2 a los ataques, las salvaciones, las pruebas de habilidad y las de característica. Es peor que estremecido y mejor que aterrado.'),

'Grappling': ('En presa',
  'Estás agarrado cuerpo a cuerpo. Pierdes tu bonificador de Destreza contra todo el que no esté en la presa, no puedes usar armas de dos manos ni la mayoría de los conjuros, y solo atacas con armas ligeras o sin armas.'),

'Helpless': ('Indefenso',
  'Paralizado, dormido, inconsciente, atado o a merced de otro. Cuentas con Destreza efectiva 0 (−5 al modificador), y quien te ataque cuerpo a cuerpo gana +4. Además te pueden dar el golpe de gracia.'),

'Incorporeal': ('Incorpóreo',
  'No tienes cuerpo físico. Solo te dañan otras criaturas incorpóreas, las armas mágicas, los conjuros y los efectos sobrenaturales, y aun así hay un 50% de ignorar el daño de un conjuro que no sea de fuerza. Atraviesas objetos sólidos a voluntad.'),

'Invisible': ('Invisible',
  'No se te ve: +2 a las tiradas de ataque contra enemigos videntes y les niegas su bonificador de Destreza a la CA.'),

'Knocked Down': ('Tumbado por el viento',
  'El vendaval te derriba. Quedas en el suelo, y sufres 1d3 de daño no letal si además te arrastra.'),

'Nauseated': ('Nauseado',
  'Estás a punto de vomitar: lo único que puedes hacer es una acción de movimiento al asalto. No puedes atacar, ni lanzar conjuros, ni concentrarte, ni nada que exija atención.'),

'Panicked': ('Aterrado',
  'Sueltas lo que llevas y huyes a toda velocidad de lo que te aterra, con −2 a las salvaciones, las pruebas de habilidad y las de característica. Si te acorralan, te acobardas. Puedes usar conjuros y aptitudes que te ayuden a huir.'),

'Paralyzed': ('Paralizado',
  'Estás congelado en el sitio: Fuerza y Destreza efectivas 0, indefenso, no puedes hacer nada. Aún puedes actuar mentalmente. Un aliado puede levantarte y moverte, pero pesas como un peso muerto.'),

'Petrified': ('Petrificado',
  'Te has convertido en piedra: inconsciente e indefenso. Si la estatua se rompe y luego te devuelven a la carne, quedas mutilado o muerto.'),

'Pinned': ('Inmovilizado',
  'Sujeto en el suelo dentro de una presa. Estás tumbado, no puedes moverte, pierdes tu bonificador de Destreza y solo puedes intentar zafarte o hablar. No estás indefenso del todo, pero casi.'),

'Prone': ('En el suelo',
  'Estás tirado. −4 al ataque cuerpo a cuerpo y no puedes usar la mayoría de las armas a distancia. Contra ataques cuerpo a cuerpo tienes −4 a la CA; contra los de distancia, +4. Levantarte es una acción de movimiento que provoca ataques de oportunidad.'),

'Shaken': ('Estremecido',
  '−2 a las tiradas de ataque, a las salvaciones, a las pruebas de habilidad y a las de característica. Es el escalón más suave del miedo.'),

'Sickened': ('Mareado',
  '−2 a las tiradas de ataque, de daño, de salvación, de habilidad y de característica.'),

'Stable': ('Estabilizado',
  'Estabas moribundo y has dejado de perder puntos de golpe. Sigues inconsciente. Tienes un 10% por hora de recuperar el conocimiento; si no, sigues estable hasta que alguien te cure.'),

'Staggered': ('Tambaleante',
  'Tu daño no letal iguala a tus puntos de golpe actuales. Solo puedes hacer una acción estándar o una de movimiento por asalto, no las dos. Si el daño no letal los supera, caes inconsciente.'),

'Stunned': ('Aturdido',
  'Sueltas lo que llevas en la mano, no puedes actuar, pierdes tu bonificador de Destreza a la CA y sufres −2 a la CA.'),

'Turned': ('Expulsado',
  'Un clérigo te ha expulsado: huyes de él tan lejos y tan rápido como puedas durante 10 asaltos. Si no puedes huir, te acobardas.'),

'Unconscious': ('Inconsciente',
  'Estás fuera de combate y no puedes hacer nada, indefenso. Puede ser por daño, por daño no letal o por un conjuro.'),
}


# --- enfermedades: (nombre, forma de contagio, incubación, daño) ---
ENFERMEDADES = {
'Blinding sickness': ('Mal de la ceguera', 'Ingerida', '1d3 días', '1d4 Fue'),
'Cackle fever': ('Fiebre de la risa', 'Inhalada', '1 día', '1d6 Sab'),
'Demon fever': ('Fiebre demoníaca', 'Herida', '1 día', '1d6 Con'),
'Devil chills': ('Escalofríos del diablo', 'Herida', '1d4 días', '1d4 Fue'),
'Filth fever': ('Fiebre de la inmundicia', 'Herida', '1d3 días', '1d3 Des y 1d3 Con'),
'Mindfire': ('Fuego mental', 'Inhalada', '1 día', '1d4 Int'),
'Mummy rot': ('Podredumbre de momia', 'Contacto', '1 día', '1d6 Con'),
'Red ache': ('Dolor rojo', 'Herida', '1d3 días', '1d6 Fue'),
'Shakes': ('Temblores', 'Contacto', '1 día', '1d8 Des'),
'Slimy doom': ('Perdición viscosa', 'Contacto', '1 día', '1d4 Con'),
}

# aclaraciones que el SRD pone al pie de la tabla
NOTAS_ENFERMEDAD = {
'Blinding sickness': 'Si el daño a la Fuerza es de 2 o más, hay que salvar otra vez por Fortaleza (CD 16) o quedarse ciego para siempre.',
'Demon fever': 'Cada punto de daño a la Constitución exige otra salvación de Fortaleza (CD 18) o ese punto se pierde para siempre.',
'Devil chills': 'Hacen falta tres salvaciones seguidas para librarse, no dos.',
'Mummy rot': 'No se cura sola: hay que quitarla con magia (curar enfermedad) antes de poder recuperar los puntos perdidos.',
}


# --- venenos: (nombre, tipo, daño inicial, daño secundario) ---
# el precio se deja tal cual, solo se cambia "gp" por "po"
VENENOS = {
'Nitharit': ('Nitharit', 'Contacto CD 13', '—', '3d6 Con'),
'Sassone leaf residue': ('Residuo de hoja de sassone', 'Contacto CD 16', '2d12 pg', '1d6 Con'),
'Malyss root paste': ('Pasta de raíz de malyss', 'Contacto CD 16', '1 Des', '2d4 Des'),
'Terinav root': ('Raíz de terinav', 'Contacto CD 16', '1d6 Des', '2d6 Des'),
'Black lotus extract': ('Extracto de loto negro', 'Contacto CD 20', '3d6 Con', '3d6 Con'),
'Dragon bile': ('Bilis de dragón', 'Contacto CD 26', '3d6 Fue', '—'),
'Striped toadstool': ('Seta rayada', 'Ingerido CD 11', '1 Sab', '2d6 Sab y 1d4 Int'),
'Arsenic': ('Arsénico', 'Ingerido CD 13', '1 Con', '1d8 Con'),
'Id moss': ('Musgo del ello', 'Ingerido CD 14', '1d4 Int', '2d6 Int'),
'Oil of taggit': ('Aceite de taggit', 'Ingerido CD 15', '—', 'Inconsciencia'),
'Lich dust': ('Polvo de liche', 'Ingerido CD 17', '2d6 Fue', '1d6 Fue'),
'Dark reaver powder': ('Polvo del segador oscuro', 'Ingerido CD 18', '2d6 Con', '1d6 Con y 1d6 Fue'),
'Ungol dust': ('Polvo de ungol', 'Inhalado CD 15', '1 Car', '1d6 Car y 1 Car permanente'),
'Insanity mist': ('Bruma de la locura', 'Inhalado CD 15', '1d4 Sab', '2d6 Sab'),
'Burnt othur fumes': ('Vapores de othur quemado', 'Inhalado CD 18', '1 Con permanente', '3d6 Con'),
'Black adder venom': ('Veneno de víbora negra', 'Herida CD 11', '1d6 Con', '1d6 Con'),
'Small centipede poison': ('Veneno de ciempiés pequeño', 'Herida CD 11', '1d2 Des', '1d2 Des'),
'Bloodroot': ('Raíz de sangre', 'Herida CD 12', '—', '1d4 Con y 1d3 Sab'),
'Drow poison': ('Veneno drow', 'Herida CD 13', 'Inconsciencia', 'Inconsciencia 2d4 horas'),
'Greenblood oil': ('Aceite de sangre verde', 'Herida CD 13', '1 Con', '1d2 Con'),
'Blue whinnis': ('Whinnis azul', 'Herida CD 14', '1 Con', 'Inconsciencia'),
'Medium spider venom': ('Veneno de araña mediana', 'Herida CD 14', '1d4 Fue', '1d4 Fue'),
'Shadow essence': ('Esencia de sombra', 'Herida CD 17', '1 Fue permanente', '2d6 Fue'),
'Wyvern poison': ('Veneno de guiverno', 'Herida CD 17', '2d6 Con', '2d6 Con'),
'Large scorpion venom': ('Veneno de escorpión grande', 'Herida CD 18', '1d6 Fue', '1d6 Fue'),
'Giant wasp poison': ('Veneno de avispa gigante', 'Herida CD 18', '1d6 Des', '1d6 Des'),
'Deathblade': ('Hoja de la muerte', 'Herida CD 20', '1d6 Con', '2d6 Con'),
'Purple worm poison': ('Veneno de gusano púrpura', 'Herida CD 24', '1d6 Fue', '2d6 Fue'),
}
