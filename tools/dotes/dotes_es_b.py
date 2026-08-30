"""Las dotes del SRD 3.5 en español (segunda mitad, I–W). Ver dotes_es_a.py."""

DOTES_B = {
'Improved Trip': ('Derribo mejorado', 'Int 13, Pericia en combate.',
  'No provocas ataque de oportunidad al intentar derribar a un rival estando desarmado, y ganas +4 a la prueba de Fuerza para derribarlo. Si lo derribas, ganas al instante un ataque cuerpo a cuerpo contra él, como si no hubieras usado tu ataque.',
  'Sin esta dote provocas un ataque de oportunidad al intentar derribar desarmado.',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Improved Turning': ('Expulsión mejorada', 'Poder expulsar o reprender criaturas.',
  'Expulsas o reprendes como si tuvieras un nivel más en la clase que te da esa aptitud.', '', ''),

'Improved Two-Weapon Fighting': ('Combatir con dos armas mejorado',
  'Des 17, Combatir con dos armas, ataque base +6.',
  'Además del ataque adicional normal con el arma secundaria, ganas un segundo ataque con ella, con −5 al ataque.',
  'Sin esta dote solo consigues un ataque adicional con el arma secundaria.',
  'Un guerrero puede elegirla como dote adicional. Un explorador de nivel 6 con el estilo de dos armas la tiene aunque no cumpla los requisitos.'),

'Improved Unarmed Strike': ('Ataque sin armas mejorado', '',
  'Se te considera armado aun estando desarmado: no provocas ataques de oportunidad al atacar sin armas, pero sí los provocas tú contra quien te ataque desarmado. Además, tus golpes sin armas pueden hacer daño letal o no letal, a tu elección.',
  'Sin esta dote se te considera desarmado y solo puedes hacer daño no letal.',
  'Un monje la gana de serie a nivel 1. Un guerrero puede elegirla como dote adicional.'),

'Investigator': ('Investigador', '',
  '+2 a todas las pruebas de Reunir información y de Buscar.', '', ''),

'Iron Will': ('Voluntad de hierro', '',
  '+2 a todas las salvaciones de Voluntad.', '', ''),

'Leadership': ('Liderazgo', 'Nivel de personaje 6.º.',
  'Atraes a un lugarteniente y a un grupo de seguidores leales. Tu puntuación de liderazgo es tu nivel de personaje más tu modificador de Carisma, ajustada por tu reputación, tu fortaleza y cómo trates a los tuyos. Esa puntuación decide el nivel del lugarteniente (siempre dos niveles por debajo del tuyo como máximo) y cuántos seguidores de cada nivel te siguen. Consulta la tabla de Liderazgo del manual para las cifras exactas.', '',
  'Un lugarteniente muerto o maltratado hace bajar tu puntuación de liderazgo.'),

'Lightning Reflexes': ('Reflejos felinos', '',
  '+2 a todas las salvaciones de Reflejos.', '', ''),

'Magical Aptitude': ('Aptitud mágica', '',
  '+2 a todas las pruebas de Conocimiento de conjuros y de Utilizar objeto mágico.', '', ''),

'Manyshot': ('Disparo múltiple', 'Des 17, Disparo a bocajarro, Disparo rápido, ataque base +6.',
  'Como acción estándar puedes disparar dos flechas a un mismo objetivo a 30 pies o menos. Ambas usan la misma tirada de ataque, con −4, y hacen daño normal. Por cada 5 puntos de ataque base por encima de +6 puedes añadir una flecha más (hasta cuatro con ataque base +16), con −2 más al ataque por cada una.', '',
  'Un guerrero puede elegirla como dote adicional. Un explorador de nivel 6 con el estilo de arquería la tiene aunque no cumpla los requisitos.'),

'Martial Weapon Proficiency': ('Competencia con armas marciales', '',
  'Haces las tiradas de ataque con el arma elegida con normalidad.',
  'Con un arma con la que no eres competente sufres −4 al ataque.',
  'Puedes tomarla varias veces, cada una para un arma marcial distinta. Bárbaros, guerreros, paladines y exploradores son competentes con todas de serie.'),

'Maximize Spell': ('Maximizar conjuro', '',
  'Todos los efectos numéricos variables del conjuro salen al máximo. No afecta a las salvaciones ni a las tiradas enfrentadas. Ocupa un espacio tres niveles por encima del suyo.', '', ''),

'Mobility': ('Movilidad', 'Des 13, Esquiva.',
  '+4 de esquiva a la CA contra los ataques de oportunidad que provoques al salir de un área amenazada o al moverte dentro de ella.', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Mounted Archery': ('Arquería montada', 'Montar 1 rango, Combate montado.',
  'El penalizador por usar un arma a distancia montado se reduce a la mitad: −2 en vez de −4 si tu montura hace un movimiento doble, y −4 en vez de −8 si corre.', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Mounted Combat': ('Combate montado', 'Montar 1 rango.',
  'Una vez por asalto, cuando alcancen a tu montura, puedes hacer una prueba de Montar como reacción para anular el impacto: se anula si tu resultado supera la tirada de ataque del rival.', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Natural Spell': ('Conjuro natural', 'Sab 13, aptitud de forma salvaje.',
  'Puedes completar los componentes verbales y somáticos de tus conjuros en forma salvaje, sustituyéndolos por ruidos y gestos. También puedes usar los componentes materiales y focos que lleves, aunque estén fundidos en tu forma actual.', '', ''),

'Negotiator': ('Negociador', '',
  '+2 a todas las pruebas de Diplomacia y de Averiguar intenciones.', '', ''),

'Nimble Fingers': ('Dedos ágiles', '',
  '+2 a todas las pruebas de Inutilizar mecanismo y de Abrir cerraduras.', '', ''),

'Persuasive': ('Persuasivo', '',
  '+2 a todas las pruebas de Engañar y de Intimidar.', '', ''),

'Point Blank Shot': ('Disparo a bocajarro', '',
  '+1 al ataque y al daño con armas a distancia contra blancos a 30 pies o menos.', '', ''),

'Power Attack': ('Ataque poderoso', 'Fue 13.',
  'Antes de tirar tus ataques del asalto puedes restar una cifra a todas tus tiradas de ataque cuerpo a cuerpo y sumar esa misma cifra a todas las de daño. No puede superar tu bonificador de ataque base y dura hasta tu siguiente turno.', '',
  'Con un arma a dos manos (o una a una mano usada a dos manos) sumas el DOBLE al daño. No sirve con armas ligeras. Un guerrero puede elegirla como dote adicional.'),

'Precise Shot': ('Disparo certero', 'Disparo a bocajarro.',
  'Puedes disparar o arrojar contra un enemigo trabado en cuerpo a cuerpo sin el −4 habitual.', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Quick Draw': ('Desenvainado rápido', 'Ataque base +1.',
  'Desenvainas como acción libre en vez de como acción de movimiento, y sacas un arma escondida como acción de movimiento. Además puedes arrojar armas a tu ritmo completo de ataques.',
  'Sin esta dote desenvainar es una acción de movimiento (o libre si tu ataque base es +1 o más, como parte de un movimiento).',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Quicken Spell': ('Acelerar conjuro', '',
  'Lanzar el conjuro es una acción inmediata: puedes hacer otra cosa, incluso lanzar otro conjuro, en el mismo asalto. Solo uno acelerado por asalto, y no vale con conjuros de más de un asalto completo. Ocupa un espacio cuatro niveles por encima del suyo.', '', ''),

'Rapid Reload': ('Recarga rápida', 'Competencia con la ballesta elegida.',
  'Recargar esa ballesta pasa a ser una acción libre (de mano o ligera) o de movimiento (pesada). Sigue provocando ataques de oportunidad. Con ballesta de mano o ligera puedes además disparar tantas veces por asalto como con un arco.',
  'Sin esta dote hace falta una acción de movimiento para la de mano o ligera, y una de asalto completo para la pesada.',
  'Puedes tomarla varias veces, cada una para otro tipo de ballesta.'),

'Rapid Shot': ('Disparo rápido', 'Des 13, Disparo a bocajarro.',
  'Ganas un ataque a distancia adicional por asalto, con tu mejor bonificador de ataque base, pero todos tus ataques del asalto sufren −2. Requiere la acción de ataque completo.', '',
  'Un guerrero puede elegirla como dote adicional. Un explorador de nivel 2 con el estilo de arquería la tiene aunque no cumpla los requisitos.'),

'Ride-By Attack': ('Ataque al paso', 'Montar 1 rango, Combate montado.',
  'Montado y cargando, puedes moverte, atacar y seguir moviéndote en la misma línea recta, sin superar el doble de la velocidad de tu montura. Ni tú ni ella provocáis ataque de oportunidad del enemigo al que atacas.', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Run': ('Correr', '',
  'Al correr te mueves cinco veces tu velocidad (con armadura ligera, media o ninguna y carga media o menor), o cuatro veces con armadura pesada o carga pesada. Ganas +4 a Saltar tras una carrerilla y conservas tu bonificador de Destreza a la CA mientras corres.',
  'Sin esta dote corres a cuatro veces tu velocidad (o tres con armadura pesada) y pierdes tu bonificador de Destreza a la CA.', ''),

'Scribe Scroll': ('Escribir pergamino', 'Nivel de lanzador 1.º.',
  'Puedes crear un pergamino de cualquier conjuro que conozcas. Su precio base es nivel del conjuro × nivel de lanzador × 25 po; lleva un día por cada 1.000 po, cuesta 1/25 en PX y la mitad en materiales.', '', ''),

'Self-Sufficient': ('Autosuficiente', '',
  '+2 a todas las pruebas de Sanar y de Supervivencia.', '', ''),

'Shield Proficiency': ('Competencia con escudos', '',
  'Puedes usar un escudo sufriendo solo los penalizadores normales.',
  'Con un escudo con el que no eres competente aplicas su penalizador de armadura a las tiradas de ataque y a las pruebas de habilidad que impliquen moverse.',
  'Todos salvo magos, hechiceros, druidas y monjes la tienen de serie.'),

'Shot On The Run': ('Disparar en movimiento',
  'Des 13, Esquiva, Movilidad, Disparo a bocajarro, ataque base +4.',
  'Con la acción de ataque y un arma a distancia, puedes moverte antes y después de disparar, siempre que el total no supere tu velocidad.', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Silent Spell': ('Conjuro silencioso', '',
  'El conjuro se lanza sin componentes verbales. Ocupa un espacio un nivel por encima del suyo.', '', ''),

'Simple Weapon Proficiency': ('Competencia con armas sencillas', '',
  'Haces las tiradas de ataque con las armas sencillas con normalidad.',
  'Con un arma con la que no eres competente sufres −4 al ataque.',
  'Todos salvo druidas, monjes, magos y algunas clases de PNJ la tienen de serie.'),

'Skill Focus': ('Habilidad focalizada', '',
  '+3 a todas las pruebas de la habilidad elegida.', '',
  'Puedes tomarla varias veces, cada una para otra habilidad.'),

'Snatch Arrows': ('Atrapar flechas', 'Des 15, Desviar flechas, Ataque sin armas mejorado.',
  'Al usar Desviar flechas puedes atrapar el proyectil en vez de solo desviarlo. Si es un arma arrojadiza puedes devolvérsela al instante a quien te la lanzó, aunque no sea tu turno, o guardarla. Necesitas al menos una mano libre.', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Spell Focus': ('Conjuro focalizado', '',
  '+1 a la CD de las salvaciones contra tus conjuros de la escuela elegida.', '',
  'Puedes tomarla varias veces, cada una para otra escuela.'),

'Spell Mastery': ('Maestría de conjuros', 'Nivel de mago 1.º.',
  'Cada vez que la tomas eliges tantos conjuros que ya conozcas como tu modificador de Inteligencia. A partir de ahí puedes prepararlos sin consultar el libro de conjuros.',
  'Sin esta dote necesitas el libro para preparar todos tus conjuros, salvo leer magia.', ''),

'Spell Penetration': ('Penetración de conjuros', '',
  '+2 a las pruebas de nivel de lanzador (1d20 + nivel) para superar la resistencia a conjuros de una criatura.', '', ''),

'Spirited Charge': ('Carga vigorosa', 'Montar 1 rango, Combate montado, Ataque al paso.',
  'Montado y cargando, haces el doble de daño con un arma cuerpo a cuerpo (o el triple con una lanza de caballería).', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Spring Attack': ('Ataque súbito', 'Des 13, Esquiva, Movilidad, ataque base +4.',
  'Con la acción de ataque y un arma cuerpo a cuerpo, puedes moverte antes y después de atacar sin superar tu velocidad. Moverte así no provoca ataque de oportunidad del enemigo al que atacas (sí de los demás).', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Stealthy': ('Sigiloso', '',
  '+2 a todas las pruebas de Esconderse y de Moverse sigilosamente.', '', ''),

'Still Spell': ('Conjuro inmóvil', '',
  'El conjuro se lanza sin componentes somáticos. Ocupa un espacio un nivel por encima del suyo.', '', ''),

'Stunning Fist': ('Golpe aturdidor',
  'Des 13, Sab 13, Ataque sin armas mejorado, ataque base +8.',
  'Debes declararla antes de tirar el ataque (si fallas, se pierde el intento). El enemigo dañado por tu ataque sin armas debe superar una salvación de Fortaleza (CD 10 + ½ tu nivel de personaje + tu modificador de Sabiduría) o queda aturdido hasta tu siguiente turno. Puedes usarla una vez al día por cada cuatro niveles de personaje.', '',
  'Un monje la gana de serie a nivel 1 y la usa una vez por cada cuatro niveles de monje. Un guerrero puede elegirla como dote adicional.'),

'Toughness': ('Dureza', '',
  'Ganas +3 puntos de golpe.', '',
  'Puedes tomarla varias veces y sus efectos se acumulan.'),

'Tower Shield Proficiency': ('Competencia con escudo de torre', 'Competencia con escudos.',
  'Puedes usar un escudo de torre sufriendo solo los penalizadores normales.',
  'Con un escudo con el que no eres competente aplicas su penalizador de armadura a las tiradas de ataque y a las pruebas de habilidad que impliquen moverse.',
  'Guerreros y paladines la tienen de serie.'),

'Track': ('Rastrear', '',
  'Con una prueba de Supervivencia puedes encontrar rastros y seguirlos durante una milla; hay que repetirla cada vez que el rastro se complica. Vas a la mitad de tu velocidad (o a velocidad normal con −5 a la prueba, o al doble con −20).',
  'Sin esta dote puedes usar Supervivencia para encontrar rastros, pero solo puedes seguirlos si la CD es 10 o menos.',
  'Un explorador la gana de serie a nivel 1.'),

'Trample': ('Arrollar montado', 'Montar 1 rango, Combate montado.',
  'Al atropellar montado, el objetivo no puede apartarse. Tu montura puede hacer un ataque de pezuña contra quien derribes, con el +4 habitual contra objetivos derribados.', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Two-Weapon Defense': ('Defensa con dos armas', 'Des 15, Combatir con dos armas.',
  'Con un arma doble o con dos armas (sin contar las naturales ni los golpes sin armas) ganas +1 de escudo a la CA. Si combates a la defensiva o usas la acción de defensa total, sube a +2.', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Two-Weapon Fighting': ('Combatir con dos armas', 'Des 15.',
  'Se reducen tus penalizadores por combatir con dos armas: 2 menos con la mano buena y 6 menos con la otra.',
  'Sin esta dote, combatir con dos armas da −6 con la mano buena y −10 con la secundaria.',
  'Un explorador de nivel 2 con el estilo de dos armas la tiene aunque no cumpla los requisitos. Un guerrero puede elegirla como dote adicional.'),

'Weapon Finesse': ('Soltura con un arma', 'Ataque base +1.',
  'Con un arma ligera, un estoque, un látigo o una cadena con púas de tu tamaño puedes usar tu modificador de Destreza en vez del de Fuerza en las tiradas de ataque. Si llevas escudo, su penalizador de armadura se aplica a esas tiradas.', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Weapon Focus': ('Arma focalizada', 'Competencia con el arma, ataque base +1.',
  '+1 a todas las tiradas de ataque con el arma elegida.', '',
  'Puedes tomarla varias veces, cada una para un arma distinta. Un guerrero puede elegirla como dote adicional.'),

'Weapon Specialization': ('Especialización con un arma',
  'Competencia con el arma, Arma focalizada con ella, nivel de guerrero 4.º.',
  '+2 a todas las tiradas de daño con el arma elegida.', '',
  'Puedes tomarla varias veces, cada una para un arma distinta.'),

'Whirlwind Attack': ('Ataque en torbellino',
  'Des 13, Int 13, Pericia en combate, Esquiva, Movilidad, Ataque súbito, ataque base +4.',
  'Con la acción de ataque completo puedes renunciar a tus ataques normales y hacer en su lugar un ataque cuerpo a cuerpo, con tu bonificador de ataque base completo, contra cada enemigo a tu alcance. Renuncias también a los ataques adicionales de otras dotes o conjuros.', '',
  'Un guerrero puede elegirla como dote adicional de guerrero.'),

'Widen Spell': ('Ensanchar conjuro', '',
  'Un conjuro con área de ráfaga, emanación, línea o extensión duplica todas las medidas de su área. Ocupa un espacio tres niveles por encima del suyo.', '', ''),
}
