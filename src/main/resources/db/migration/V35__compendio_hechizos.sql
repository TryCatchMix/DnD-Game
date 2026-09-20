-- =====================================================================
-- Compendio del Manual del Jugador 3.5 (español), volcado a la pestaña
-- Habilidades. Generado por tools/compendio/generar_migracion.py.
--
-- Para cada ficha: UPDATE si ya existe (match por nombre sin tildes) o
-- INSERT si no. No se borra nada. En UPDATE sólo se tocan los campos
-- con valor en el compendio (no se blanquea un dato bueno con '').
-- HECHIZOS: sólo se ENRIQUECEN los que ya existen (UPDATE por nombre sin
-- tildes). No se inserta ninguno: la BD ya tiene 514 en español (V13) y se
-- evitan duplicados por traducción divergente.
-- =====================================================================


-- ------------------- HECHIZOS (solo enriquecer) ----------------

update spells set school = $c$Transmutación$c$, descriptors = $c$tierra$c$, description = $c$Al lanzarse este conjuro, se ablandará toda la tierra y piedra natural del área que esté al descubierto. La tierra húmeda pasará a ser un barrizal; la tierra seca, arena; y la piedra se convertirá en arcilla blanda que podrá cortarse y moldearse con facilidad. Afectas a un área cuadrada de 10' de lado hasta una profundidad de entre 1 y 4', dependiendo de la dureza o resistencia del terreno en ese punto (a discreción del DM). La piedra mágica, encantada, trabajada o que no esté al descubierto, no será afectada, como tampoco lo serán las criaturas de piedra o tierra.

Las criaturas que estén en el barro deberán tener éxito en un TS de Reflejos o quedarán atrapadas durante 1d2 asaltos, sin poder moverse, atacar ni lanzar conjuros. Las criaturas que tengan éxito podrán moverse por el barro a la mitad de velocidad, aunque no podrán correr ni cargar.

La tierra suelta no resulta tan problemática como el barro, pero todas las criaturas que se encuentren en el área verán reducida a la mitad su velocidad normal y no podrán correr ni cargar sobre esa superficie.

La piedra convertida en arcilla no entorpecerá el movimiento, pero permitirá a los personajes cortar, modelar o excavar en zonas que antes no habrían resultado afectadas por esas acciones. Por ejemplo, un grupo de aventureros que quisiera salir de una caverna podría usar este conjuro para ablandar una pared. Aunque el sortilegio no afecta a la piedra trabajada o que no esté desnuda, los techos de caverna o las superficies verticales, como las caras de acantilados, sí podrán ser alteradas. Por lo general, esto último provocará un derrumbamiento o desprendimiento de tierras, pues el material ablandado se despegará de la pared o techo y caerá.

El conjuro puede producir un daño estructural moderado a las construcciones artificiales (como una pared o torre) ablandando el suelo debajo de ellas y haciendo que se asienten. Sin embargo, la mayoría de edificios bien construidos sólo serán dañados por este conjuro, no quedarán destruidos.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$un cuadrado de 10'/nivel; ver texto$c$, duration = $c$instantánea$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'ablandar tierra y piedra';
update spells set school = $c$Transmutación$c$, description = $c$Puedes abrir o cerrar (a tu elección) una puerta, cofre, caja, ventana, mochila, bolsa, botella o cualquier otro recipiente. Si hay cualquier cosa que se oponga a esta actividad (como una tranca en una puerta o una cerradura en un cofre), el conjuro fracasará. Además, el sortilegio sólo puede abrir y cerrar cosas que pesen 30 lb. o menos. Por lo tanto, las puertas, cofres y objetos similares del tamaño apropiado para criaturas enormes pueden estar más allá de los efectos de este conjuro. Foco: una llave de latón.$c$, components = $c$V, S, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$objeto que pese hasta 30 lb. o portal que pueda ser abierto o cerrado$c$, duration = $c$instantánea$c$, saving_throw = $c$Voluntad niega (objeto)$c$, spell_resistance = $c$sí (objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'abrir/cerrar';
update spells set school = $c$Transmutación$c$, description = $c$La criatura transmutada se mueve y actúa más rápido de lo normal. Esta velocidad adicional tiene varios efectos:

Cuando realice una acción de ataque completo, una criatura acelerada puede realizar un ataque adicional con cualquier arma que esté esgrimiendo. El ataque se realiza utilizando el ataque base

196

completo de la criatura, mas todos los modificadores apropiados a la situación (este efecto no es acumulativo con efectos similares, como el proporcionado por un arma veloz, ni permite una acción adicional real, por lo que no puedes utilizarla para lanzar un segundo conjuro o realizar cualquier otro tipo de acción adicional en el asalto).

Una criatura acelerada obtiene un bonificador +1 a las tiradas de ataque y un bonificador +1 de esquiva a la CA y las salvaciones de Reflejos. Cualquier situación que te prive de tu bonificador de Destreza a la CA (si lo tiene) también te hace perder estos bonificadores.

Todos los modos de movimiento de la criatura acelerada (incluyendo movimiento terrestre, excavar, trepar, volar v nada) aumentan en 30', hasta un máximo del doble de la velocidad normal del objetivo con esa forma de movimiento. Este aumento cuenta como un bonificador de mejora, y afecta a la distancia de salto de la criatura, como sucede normalmente con los aumentos en la velocidad.

Varios efectos de acelerar no se apilan. Acelerar disipa y contrarresta ralentizar.

Componente material: una viruta de raíz de regaliz.

| divinación | |
| |--|
| Adivinación | |
| Nivel: Clr 4, Saber 4 | |
| Componentes: V, S, M | |
| Tiempo de lanzamiento: 10 minutos | |
| Alcance: personal | |
| Objetivo: tú | |
| Duración: instantanea | |

El conjuro de adivinación (similar a augurio, pero más poderoso) puede darte un consejo útil en respuesta a una pregunta concreta sobre un objetivo, un acontecimiento o una actividad que vava a tener lugar antes de haber transcurrido una semana. El consejo puede ser tan simple como una frase corta o tan elaborado como una rima críptica o un presagio.

Por ejemplo, supón que la pregunta fuera: "¿Haremos bien aventurándonos en el templo en ruinas de Erythnul?" El DM sabe que acechando cerca de la entrada del mismo hay un terrible troll que vigila 10.000 po y un escudo +1, pero cree que el grupo tiene posibilidades de derrotarlo si lucha duramente. Por tanto, el conjuro de adivinación podría responder: "Aceite y llamas prestos, iluminarán el camino hacia vuestro enriquecimiento". Sea como fuere, el DM será quien controle la información que recibas. Si el grupo no actuara basándose en tal información, las condiciones podrían cambiar e invalidar el presagio (por ejemplo, el troll podría haberse marchado, llevándose el tesoro consigo).

Las posibilidades básicas de realizar una adivinación correcta son de 70% + 1% por nivel de lanzador, hasta un máximo de 90%. El DM ajustará las posibilidades si circunstancias inusuales lo requieren (si, por ejemplo, se han tomado precauciones especiales contra la adivinación).

Si la tirada falla, serás consciente de que el conjuro ha fracasado, a no ser que esté funcionando una magia concreta que se encargue de facilitarte respuestas falsas.

Al igual que sucede con augurio, todas las adivinaciones sobre una cuestión concreta que ejecute una misma persona utilizarán el mismo resultado de dado que la primera y darán la misma respuesta.

Componente material: incienso y una ofrenda en forma de sacrificio que resulte apropiada para tu religión (juntos, los materiales han de costar 25 po como mínimo).$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura/nivel; dos cualesquiera no pueden distar más de 30'$c$, duration = $c$1 asalto/nivel$c$, saving_throw = $c$Fortaleza niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'acelerar';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro hace que un arma se considere afilada mágicamente, mejorando su capacidad para asestar golpes. Esta transmutación duplica el rango de amenaza del arma. Un rango de amenaza normal pasará a ser de 19-20; uno de 19-20 pasará a ser de 17-20; y uno de 18-20 pasará a ser de 15-20. Este conjuro sólo puede lanzarse sobre armas perforantes o cortantes. Si es ejecutada sobre flechas o virotes de ballesta, la afiladura de cada proyectil individual finalizará en cuanto éste sea disparado, golpee o no el blanco deseado (a efectos de este conjuro considera a los shuriken como flechas, más que como armas arrojadizas). Varios efectos que aumenten el rango de amenaza de un arma (como un conjuro de afiladura v la dote de Crítico mejorado) no se apilan. No puedes lanzar este conjuro sobre un arma natural, como una garra.$c$, components = $c$V. S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$un arma o 50 proyectiles, todos los$c$, duration = $c$10 min/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo, objeto)$c$, spell_resistance = $c$sí (inofensivo, objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'afiladura';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro hace crecer instantáneamente a una criatura u objeto, doblando su altura y multiplicando su peso por 8. Este aumento cambia la categoría de tamaño de la criatura a la inmediatamente superior. El objetivo obtiene un bonificador +2 de tamaño a la Fuerza, un penalizador -2 de tamaño a la Destreza (hasta un mínimo de 1), y un penalizador-1 a las tiradas de ataque y la CA debido a su tamaño aumentado.

Una criatura humanoide que vea su tamaño aumentado a Grande tiene un espacio de 10' y un alcance natural de 10'. Este conjuro no cambia la velocidad del receptor. La securer - la

Si no hay espacio suficiente en el recinto para el tamaño deseado, la criatura alcanza el tamaño máximo posible y debe realizar una prueba de Fuerza (utilizando su puntuación aumentada) para hacer reventar el recinto durante el proceso. Si falla, queda encerrado sin dañar al material que le rodea (el conjuro no puede ser utilizado para aplastar a una criatura aumentando su tamaño).

Todo el equipo que la criatura transporte o lleve encima también será agrandado por el conjuro. Las armas de cuerpo a cuerpo y las armas de proyectil afectadas por este conjuro infligen más daño (consulta la Guía del Dungeon Master). Otras propiedades mágicas no se incrementan mediante este conjuro. Cualquier objeto agrandado que deje de estar en posesión de la criatura agrandada (incluyendo un arma de proyectil o arrojadiza) regresa instantáneamente a su tamafio normal. Esto implica que las armas arrojadizas causan daño normal, y que los proyectiles infligen daño acorde al tamaño del arma que los disparó. Las propiedades mágicas de los objetos agrandados no aumentan con este conjuro (una espada +1 agrandada sigue teniendo sólo un bonificador +1 de mejora, una varita del tamaño de un bastón tiene sólo sus funciones normales, una poción gigante simplemente requiere una mayor cantidad de fluido ingerido para que sus efectos mágicos operen, etc.

· Varios efectos mágicos que aumenten el tamaño no se apilan, lo cual quiere decir (entre otras cosas) que no puedes utilizar un segundo lanzamiento de este conjuro para aumentar más a una criatura que ya esté bajo los efectos de un primer lanzamiento.

Agrandar persona contrarresta y disipa el conjuro de reducir persona.

Agrandar persona puede ser hecho permanente con un conjuro de permanencia.

Componente material: una pizca de hierro pulverizado.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción$c$, spell_range = $c$corto (25' + 5'/2 niveles) = = =$c$, target = $c$una criatura humanoide = La cont$c$, duration = $c$1 min/nivel (D) . I$c$, saving_throw = $c$Fortaleza niega niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'agrandar persona';
update spells set school = $c$Evocacion$c$, subschool = $c$sonico$c$, description = $c$Emites un tremendo alarido que ensordece e inflige daño a las criaturas que se encuentren en su camino. Toda criatura que se encuentre en el área quedará ensordecida durante 2d6 asaltos y sufrirá 5d6 puntos de daño por sonido. Un TS con éxito niega la sordera y reduce el daño a la mitad. Las criaturas cristalinas u objetos quebradizos o de cristal que se vean expuestos al efecto sufrirán 1d6 puntos de daño por nivel de lanzador (máximo 15d6). Las criaturas afectadas tienen derecho a un TS de Fortaleza para reducir el daño a la mitad, y las que tengan asidos objetos frágiles podrán negar el daño sufrido por éstos si tienen éxito en un TS de Reflejos. Este sortilegio no puede penetrar dentro de

uno de silencio.$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$30'$c$, target = $c$explosión en forma de cono$c$, duration = $c$instantanea$c$, saving_throw = $c$Fortaleza parcial o Reflejos niega (objeto); ver texto$c$, spell_resistance = $c$si (objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'alarido';
update spells set school = $c$Evocación$c$, description = $c$Este conjuro funciona como alarido, salvo en que el cono inflige 10d6 puntos de daño por sonido (o 1d6 puntos de daño sónico por nivel de lanzador, máximo 20d6, contra las criaturas cristalinas u objetos quebradizos o de cristal que se vean expuestos al efecto). También hace que las criaturas queden aturdidas durante 1 asalto y sordas durante 4d6 asaltos. Una criatura en el área del cono puede negar el efecto de aturdimiento y reducir a la mitad tanto el daño como la duración de la sordera mediante una salvación de Fortaleza con éxito. Las que tengan asidos objetos frágiles podrán negar el daño sufrido por éstos si tienen éxito en un TS de Reflejos.

Foco arcano: un pequeño cuerno de metal o marfil.$c$, components = $c$V, S, F$c$, spell_range = $c$60'$c$, saving_throw = $c$Fortaleza parcial o Reflejos niega (objeto); ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'alarido mayor';
update spells set school = $c$Abjuracion$c$, description = $c$Este conjuro hace sonar una alarma mental o audible cada vez que una criatura Menuda o mayor entra en la zona custodiada o la toca. Una criatura que pronuncie la contraseña (elegida por ti en el momento del lanzamiento) no hará sonar la alarma. Al ejecutar el conjuro eliges también si la alarma será mental o audible.

Alarma mental: esta alarma te avisa (sólo a ti) siempre y cuando estés en un radio de una milla del área custodiada. Oirás dentro de tu mente un soniquete metálico que te despertará del sueño normal, pero, por lo demás, no perturbará tu concentración. Un conjuro de silencio no surte efecto alguno sobre una alarma mental.

Alarma audible: esta alarma emite el sonido de una campanilla, y podrá oírla claramente cualquiera en un radio de 60' del área custodiada. Esa distancia se reduce en 10' por cada puerta cerrada que se interponga y en 20' por cada pared sólida. Si hubiera un silencio absoluto, la campanilla podría oírse débilmente hasta a 180' de distancia. El sonido dura 1 asalto y no será oído por las criaturas que sean víctimas de un conjuro de silencio.

Las criaturas etéreas o astrales no harán saltar la alarma.

Una alarma puede ser hecha permanente mediante un conjuro de permanencia.

Foco arcano: una campanilla y un finísimo alambre de plata.$c$, components = $c$V, S, F/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$emanación de 20' de radio, centrada en un punto del espacio$c$, duration = $c$2 h/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'alarma';
update spells set school = $c$Abjuración$c$, description = $c$Que esté alineada puede superar la reducción del daño de ciertas criaturas, normalmente ajenos del alineamiento opuesto. Este conjuro no tiene efecto sobre un arma que ya tenga un alineamiento, como una espada sagrada.

No puedes lanzar este conjuro sobre un arma natural, ni sobre un impacto sin armas.

Cuando vuelves un arma buena, caótica, legal o maligna, alinear arma es un conjuro bueno, caótico, legal o maligno, respectivamente.

| Alterar el propio aspecto |
| |
| Transmutación |
| Nivel: Brd 2, Hcr/Mag 2 |
| Componentes: V, S |
| Tiempo de lanzamiento: 1 acción estándar |
| Alcance: personal |
| Objetivo: tú |
| Duración: 10 min/nivel (D) |
| |

Asumes la forma de una criatura del mismo tipo que tu forma normal (como humanoide o bestia mágica). La nueva forma no puede diferir en más de una categoría de tamaño de tu tamaño normal. Los DG máximos que puede tener la forma que asumas son iguales a tu nivel de lanzador (por ejemplo, un máximo de 5 DG a 5.º nivel). Puedes cambiar tu aspecto al de otro miembro de tu propia especie, o incluso al tuyo propio.

Conservas tus propias puntuaciones de características. Tu clase, nivel, puntos de golpe, alineamiento, ataque base y salvaciones base permanecen todos sin cambios. Conservas todas los ataques y cualidades especiales sobrenaturales y sortílegos de tu forma normal, salvo los que requieran una parte del cuerpo que la nueva forma no tenga (como una boca para un arma de aliento u ojos para un ataque de mirada). Conservas todos los ataques y cualidades especiales extraordinarios debidos a tus niveles de clase (como la aptitud de furia de un bárbaro), pero pierdes todos los de tu forma normal que no provengan de niveles de clase (como la aptitud presencia pavorosa de un dragón).

Si la nueva forma es capaz de hablar, puedes comunicarte de forma normal. Conservas cualquier aptitud para el lanzamiento de conjuros que tuvieras en tu forma original, pero la nueva forma debe ser capaz de hablar de forma inteligible (esto es, hablar un lenguaje) para utilizar

componentes verbales, y tener extremidades capaces de manipulación delicada para utilizar componentes somáticos o materiales.

Adquieres las cualidades físicas de la nueva forma, al mismo tiempo que conservas tu mente. Las cualidades físicas incluyen tamaño natural, capacidades de movimiento mundano (como andar, excavar, nadar, trepar y volar con alas, hasta una velocidad máxima de 120' para el vuelo y 60' para el movimiento no en vuelo), bonificador a la armadura natural, armas naturales (como garras, mordisco, etc.), bonificadores raciales a las habilidades, dotes raciales y cualquier cualidad física general (presencia o ausencia de alas, número de extremidades, etc.). Un cuerpo con extremidades adicionales no te permite realizar más ataques (o ataques más ventajosos con dos armas) de lo normal.

No obtienes ningún ataque ni cualidad especiales extraordinarios que no se indiquen como una cualidad física de la criatura, tales como visión en la oscuridad, visión en la penumbra, sentido ciego, vista ciega, curación rápida, regeneración, olfato, etc.

No obtienes ningún ataque o cualidad especial sobrenatural, ni tampoco las aptitudes sortílegas de la nueva forma. Tu tipo y subtipo de criatura (si lo hay) no cambian, independientemente de tu nueva forma. No puedes adoptar la forma de ninguna criatura con una plantilla, ni siquiera aunque la plantilla no cambie el tipo o subtipo de la criatura.

Puedes determinar libremente las cualidades físicas menores de la nueva forma (como color y textura del pelo o tono de la piel), dentro de los rangos normales para una criatura de ese tipo. Las cualidades físicas relevantes de la nueva forma (tales como peso, altura y sexo) también están controladas por ti, pero deben estar dentro de las normales para esa forma. A todos los efectos estás disfrazado como un miembro corriente de la raza de tu nueva forma. SI utilizas este conjuro para crear un disfraz, recibes un bonificador +10 en tu prueba de Disfrazarse.

Cuando se produce el cambio, tu equipo (si lo hay) permanece puesto o sujeto por la nueva forma (si ésta es capaz de llevar o sujetar el objeto), o se funde en el interior de la forma y se vuelve no útil. Cuando vuelves a tu auténtica forma, cualquier objeto que se hubiera fundido en la forma reaparece en la misma localización de tu cuerpo que ocupase previamente, y de nuevo puede utilizarse. Cualquier nuevo objeto que llevases en la forma asumida y que no pueda ser llevado por tu forma normal cae a tus pies; cualquier cosa que puedas llevar en ambas formas o transportar en una parte del cuerpo común a ambas formas (boca, manos o similar) durante el momento de la reversión, seguirá estando en el mismo lugar. Cualquier parte del cuerpo o del equipo que sea separada del conjuro vuelve a su forma auténtica.

Analizar esencia mágica

Adivinación Nivel: Brd 6, Hcr/Mag 6 Componentes: V, S, F Tiempo de lanzamiento: 1 acción estándar Alcance: corto (25' + 5'/2 niveles)

Objetivo: un objeto o criatura por nivel de lanzador Duración: 1 asalto/nivel (D) Tiro de salvación: ninguno o Vol niega; ver texto Resistencia a conjuros: no

Puedes discernir todos los conjuros y propiedades mágicas presentes en un grupo de criaturas u objetos. Cada asalto puedes examinar como acción gratuita a una única criatura u objeto que puedas ver. En el caso de un objeto mágico, aprendes cuáles son sus funciones, como activarlas (si es apropiado) y cuantas cargas le quedan (si utiliza cargas). En el caso de un objeto o criatura con conjuros activos sobre él, conoces cada conjuro, su efecto y su nivel de lanzador.

Un objeto "atendido" puede intentar una salvación de Vol para resistir este efecto si su esgrimidor así lo desea. Si la salvación tiene éxito, no aprendes nada del objeto, salvo lo que puedas deducir observándolo. Un objeto que supere su TS no puede ser afectado por ningún otro conjuro de analizar esencia mágica durante 24 horas.

Analizar esencia mágica no funciona cuando se utiliza sobre un artefacto (consulta la Guía del Dungeon Master para más detalles sobre los artefactos).

Foco: una diminuta lente hecha de rubí o zafiro engastada en un pequeño aro de oro. La piedra preciosa debe valer 1.500 po como mínimo.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura u objeto$c$, duration = $c$24 horas$c$, saving_throw = $c$Voluntad niega (objeto)$c$, spell_resistance = $c$sí (inofensivo, objeto) Alinear arma hace que un arma sea buena, caóti- ca, legal o maligna, a tu elección. Un arma que$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'alineamiento indetectable';
update spells set school = $c$Abjuración$c$, description = $c$Un rayo verdoso surge de tu mano extendida. Para alcanzar a tu objetivo, debes realizar un ataque de toque a distancia. Cualquier criatura u objeto tocado quedará cubierto por un brillante campo esmeralda que le impedirá completamente el viaje extradimensional. Las formas de movimiento impedidas por el ancla dimensional incluyen caminar por la sombra, desplazamiento de plano, etereidad, excursión etérea, intermitencia, laberinto, proyección astral, puerta dimensional, teleportar, umbral y demás aptitudes sortílegas o psiónicas parecidas. Mientras dure el conjuro, también impedirá el uso de umbrales v círculos de teletransporte.

Un ancla dimensional no impide el movimiento de criaturas que va estuvieran en forma etérea o astral al ejecutarse el conjuro, ni impedirá la percepción o formas de ataque extradimensionales (como la mirada del basilisco). Además, tampoco impedirá que las criaturas convocadas desaparezcan al finalizar su respectivo conjuro de convocación.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$rayo$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí (objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'ancla dimensional';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Obligas a un animal Menudo a ir hasta el lugar que elijas. El uso más común de este conjuro es hacer que lleve un mensaje a tus aliados. El animal objetivo no puede haber sido domesticado ni enseñado por otra persona, lo cual incluye criaturas tales como los familiares y los compafieros animales.

Puedes hacer que acuda hasta ti usando un poco de comida que le resulte apetecible. El animal avanzará y esperará tu orden, tras lo cual podrás transmitirle mentalmente la imagen de un lugar que conozcas bien o que sea fácilmente reconocible (como la cima de una montaña lejana o la desembocadura de un río cercano). Las indicaciones han de ser sencillas, pues el animal depende de lo que tú sepas y no podrá llegar a su destino por su cuenta. Puedes atar una nota u objeto pequeño al mensajero. A continuación, el animal irá al lugar indicado y esperará allí hasta que expire la duración del conjuro, momento en que reanudará su actividad normal.

Durante el período de espera, el mensajero dejará que se le acerquen extraños para retirar el pergamino u objeto que lleve. Ten en cuenta que el emisario podría resultar ignorado si el destinatario del mensaje no sabe que le han enviado un ave u otro animal pequeño. El destinatario del mensaje no obtendrá ninguna capacidad especial que le permita comunicarse con el animal o leen el mensaje portado por éste (si, por ejemplo, estuviera escrito en un idioma que no conociera)

Componente material: un poco de comida que le guste al animal.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$un animal Menudo$c$, duration = $c$1 día/nivel$c$, saving_throw = $c$ninguno; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'animal mensajero';
update spells set school = $c$Transmutación$c$, description = $c$Con este conjuro, infundes capacidad de movimiento y apariencia de vida en plantas inanimadas. A continuación, todas las plantas animadas atacarán a la cosa o criatura que designaras inícialmente, como si fuesen un objeto animado de la categoría de tamaño apropiada. Puedes animar una planta Grande o menor (como un árbol) por nivel de lanzador, o un número equivalente de plantas de mayor tamaño. Una planta Enorme cuenta como dos plantas Grandes o más pequeñas; una planta Gargantuesca como cuatro, y una planta Colosal como ocho. Puedes cambiar el objetivo u objetivos

designado como acción de movimiento, tal y como si estuvieses dirigiendo un conjuro activo.

Utiliza las estadísticas para los objetos animados que se encuentran en el Manual de monstruos, con la única excepción de que las plantas de un tamaño inferior a Grande no tienen dureza, salvo que el DM considere lo contrario en un caso concreto.

Animar plantas no puede afectar a criaturas tipo planta (como los ents), ni tampoco afecta a la materia vegetal muerta (como una túnica de algodón o una cuerda de cáñamo).

Este sortilegio no puede animar objetos que una criatura transporte o lleve puestos.

Enmarañar: de modo alternativo, puedes infundir cierta movilidad a todas las plantas dentro del alcance, lo cual les permite enroscarse en torno a las criaturas que estén en el área. Este uso del conjuro duplica el efecto de un conjuro de enmarañar. La RC no evita que una criatura sea enmarañada. Este efecto dura 1 hora por nivel de lanzador.$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una planta Grande por cada tres$c$, duration = $c$1 asalto/nivel o 1 hora/nivel; ver texto$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'animar las plantas';
update spells set school = $c$Transmutación$c$, description = $c$Con este conjuro, infundes capacidad de movimiento y apariencia de vida en los objetos inanimados. A continuación, el objeto u objetos animados atacarán a la cosa o criatura que designaras inicialmente. Un objeto animado puede ser de cualquier material no mágico (madera, metal, piedra, tela, cuero, cerámica, cristal, etc.). Puedes animar un objeto Pequeño o menor (como una silla) por nivel de lanzador, o un número equivalente de objetos de mayor tamaño. Un objeto Mediano (como un perchero) cuenta como dos objetos Pequeños o menores; un objeto Grande (como una mesa) cuenta como cuatro; un objeto Enorme como ocho; uno Gargantuesco como dieciséis; y uno Colosal como treinta y dos. Puedes cambiar el objetivo u objetivos designado como acción de movimiento, tal y como si estuvieses dirigiendo un conjuro activo.

Las estadísticas de los objetos animados se encuentran en el Manual de monstruos.

Este sortilegio no puede animar objetos que una criatura transporte o lleve puestos.

Animar los objetos puede ser hecho permanente mediante el conjuro de permanencia.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$un objeto Pequeño por nivel de$c$, duration = $c$1 asalto/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'animar los objetos';
update spells set school = $c$Transmutación$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$un objeto similar a una cuerda;$c$, duration = $c$1 asalto/nivel =====================================================================================================================================================$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'animar una cuerda';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Haces que de un objeto o lugar emanen vibraciones mágicas que repelen a un tipo concreto de criatura inteligente o a criaturas de un alineamiento particular (según elijas). El tipo de criatura al que afectará deberá ser nombrado concretamente (por ejemplo, dragones rojos, gigantes de las colinas, hombres-rata, lamasu, mantos o vampiros). Los subtipos de criaturas, como "trasgoides", no son lo bastante específicos. De un modo similar, ha de nombrarse el alineamiento concreto, en caso de elegirse esa opción (por ejemplo, caótico maligno, caótico bueno, legal neutral o neutral auténtico). Las criaturas del tipo o alineamiento designado

sentirán el abrumador deseo de abandonar el área u objeto, evitándolo por completo y no queriendo regresar a él mientras el conjuro siga surtiendo efecto. Una criatura que tenga éxito en su TS podrá quedarse en el área o tocar el objeto, pero se sentirá muy incómoda cuando lo haga. Esta incómoda molestia reducirá en 4 puntos la Destreza de la criatura.

Antipatía contrarresta y disipa simpatía. Componente material arcano: un trozo de alumbre empapado en vinagre.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 hora$c$, spell_range = $c$corto (25' + 5'/2 niveles) objeto$c$, target = $c$un lugar (hasta 10' cúbicos/nivel) u$c$, duration = $c$2 h/nivel (D)$c$, saving_throw = $c$Voluntad parcial Daciatancia a comititos. Cl$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'antipatia';
update spells set description = $c$Te permite conservar los restos de una criatura muerta para evitar que se descompongan, cosa que prolongará el período de tiempo en que podrá ser devuelta a la vida (consulta revivir a los muertos). Los días transcurridos bajo la influencia de este conjuro no se tendrán en cuenta para el límite de tiempo. Además, este conjuro también hace que transportar a un compañero caído resulte más agradable. El sortilegio también funciona con fragmen-

tos corporales seccionados y cosas parecidas.

Componentes materiales arcanos: una pizca de sal y una pieza de cobre por ojo que tenga (o tuviera) el cadáver.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$cadáver tocado$c$, duration = $c$1 día/nivel$c$, saving_throw = $c$Voluntad niega (objeto)$c$, spell_resistance = $c$sí (objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'apacible descanso';
update spells set school = $c$Transmutacion$c$, description = $c$A

Este conjuro abre cerraduras atascadas, atrancadas, cerradas con llave, trabadas o protegidas con un conjuro de cerradura arcana, además de puertas secretas y cajas o cofres que se abran con llave o con resortes ocultos. También aflojará soldaduras, grilletes o cadenas (siempre y cuando sirvan para asegurar un cierre). Si se utiliza para abrir una puerta protegida por una cerradura arcana, el conjuro no elimina el citado cierre, sino que se limita a suspender su funcionamiento durante 10 minutos. En todos los demás casos, la puerta no volverá a cerrarse o atascarse por sí misma. El conjuro de apertura no levantará puertas de reja u otros obstáculos similares (rastrillos, por ejemplo), ni afectará a las cuerdas, enredaderas y otras cosas parecidas. Ten en cuenta que el efecto quedará limitado por el área. Un lanzador de 3.ª nivel puede ejecutar un conjuro de apertura sobre una puerta de 30' cuadrados o menos (por ejemplo, una puerta corriente de 4 × 7'). Cada lanzamiento del conjuro puede eliminar hasta dos formas de impedir atravesar una entrada. Por tanto, una puerta que estuviera cerrada con llave, atrancada y trabada, o una con cuatro cerraduras, necesitaría dos conjuros de apertura.

| Arma disruptora |
| |
| Transmutacion |
| Nivel: Clr 5 |
| Componentes: V, S |
| Tiempo de lanzamiento: 1 acción estándar |
| Alcance: toque |
| Objetivo: un arma de cuerpo a cuerpo |
| Duración: 1 asalto/nivel |
| Tiro de salvación: Voluntad niega (inofensivo, |
| objeto); ver texto |
| Resistencia a conjuros: sí (inotensivo, objeto) |

Este conjuro hace que un arma cuerpo a cuerpo se vuelva mortal para los muertos vivientes. Cualquier criatura muerta viviente con unos DG iguales o menores a tu nivel de lanzador debe superar una salvación de Voluntad o ser destruida totalmente si es golpeada en combate con esta arma. La RC no se aplica contra el efecto de destrucción.

Arma espiritual

Evocación [fuerza] Nivel: Clr 2, Guerra 2 Componentes: V, S, FD Tiempo de lanzamiento: 1 acción estándar Alcance: intermedio (100' + 10'/nivel) Efecto: arma mágica de fuerza de fuerza , шты Duración: 1 asalto/nivel (D) Tiro de salvación: ninguno =================================================================================================================================================== Resistencia a conjuros: sí los to la contro

Un arma hecha de pura fuerza aparece de la nada y ataca a tus oponentes a distancia, siguiendo tus órdenes e infligiendo 1d8 puntos de daño por fuerza por golpe, +1 por cada tres niveles de lanzador (máximo +5 a nivel 15.º). El efecto adoptará la forma del arma predilecta de tu deidad o de un arma con un significado espiritual o simbólico para ti (véase más abajo), y tendrá el mismo rango de amenaza y multiplicador de crítico que el arma real imitada. Golpeará al oponente que designes, atacando una vez en el mismo asalto en que lances el conjuro y continuando cada asalto subsiguiente en tu turno. El arma utilizará tu ataque base como bonificador de ataque (lo cual podría permitirle atacar varias veces por asalto en asaltos subsiguientes), más tu modificador de Sabiduría como bonificador de ataque. Golpea como un conjuro, no como un arma; por tanto, podrá, por ejemplo, alcanzar a las criaturas incorporales. El arma siempre atacará desde la dirección en que te encuentres y no obtendrá bonificador de flanqueo ni ayudará a otro contendiente a conseguirlo. Tus dotes (como Soltura con un arma) o acciones de combate (como cargar) no afectarán al arma. Si esta llega a exceder el alcance del conjuro, dejas de verla o dejas de dirigirla, regresará hasta ti y se quedará flotando a tu lado.

Cada asalto después del primero podrás usar una acción de movimiento para dirigir el arma contra un nuevo objetivo. Si no lo haces, ésta seguirá atacando al mismo objetivo que en el asalto anterior. El arma sólo podrá atacar una vez en aquellos asaltos en que cambie de objetivo, aunque en los subsiguientes podrá efectuar varios ataques (siempre y cuando tu ataque base lo permita). Incluso aunque el arma espiritual sea un arma a distancia, utiliza el alcance del conjuro, no el incremento de distancia normal del arma, y sigue siendo necesaria una acción de movimiento para cambiar de objetivo.

Un arma espiritual no puede ser atacada ni dañada por ataques físicos, pero disipar magia, desintegrar, una esfera de aniquilación o un cetro de cancelación la afectarán. La CA de un arma espiritual contra ataques de toque es de 12 (10 + bonificador de tamaño por ser un objeto Menudo). Si la criatura atacada tiene RC, debes realizar una prueba de nivel de lanzador (1d20 + tu nivel de lanzador) contra la RC la primera vez que el arma la alcance. Si la criatura logra resistirse al arma, el conjuro será disipado. Si no, ésta afectará de modo normal a esa criatura mientras dure el sortilegio.

Por lo general, el arma que obtendrás gracias al conjuro será una réplica hecha de pura fuerza del arma personal de tu deidad, muchas de las cuales tienen nombre propio. Un clérigo que carezca de dios obtendrá un arma según su alineamiento. Un clérigo neutral sin deidad podrá crear un arma espiritual de cualquier alineamiento, siempre y cuando esté actuando de acuerdo a él en líneas generales. Éstas son las armas de las distintas deidades:

Boccob: bastón, "Bastón de Boccob" Corellon Larethian: espada larga, "Sahandrian" Ehlonna: arco largo, "Jenevier" Erythnul: maza de armas, "Agonía" Fharlanghn: bastón, "Amigo del viajero"

Garl del Oro luminoso: hacha de batalla, "Arumdina" Gruumsh: lanza. "Lanza sangrienta" Heironeous: espada larga, "Portadora de justicia" Hextor: mangual, "Verdugo" Kord: espadón, "Kelmar" Moradin: martillo de guerra, "Mazalma" Nerull: guadaña, "Siegavidas" Obad-Hai: bastón, "Tocatormentas" Olidammarra: estoque, "Golpeaveloz" Pelor: maza, "Cetrosolar" San Cuthbert: maza pesada, "la Maza de Cuthbert" Vecna: daga, "Reflexión" Wee Jas: daga, "Discreción" Yondalla: espada corta, "Cornudaga" Bien: martillo de guerra, "Martillo de la justicia" Caos: hacha de batalla, "Filo del cambio" Ley: espada, "Espada de la verdad"$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel) Area u objetivo: un cubo de 20'/nivel (Mo) o un objeto mágico basado en el fuego$c$, target = $c$una puerta, caja o cofre con un área<br>de hasta 10 cuadrados/nivel Duración: instantánea; ver texto Tiro de salvación: ninguno Resistencia a conjuros: no$c$, duration = $c$instantanea$c$, saving_throw = $c$ninguno o Voluntad niega (objeto)$c$, spell_resistance = $c$no o sí (objeto) Este conjuro suele utilizarse para extinguir fuegos forestales y demás conflagraciones, pues apaga to- do fuego no mágico que haya en su área. El sortile- aio tempión dicino loc consurac da fuago de cu$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'apagar';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro concede a un arma un bonificador +1 de mejora en las tiradas de ataque y daño (un bonificador de mejora no se apila con el bonificador +1 a las tiradas de ataque de las armas de gran calidad).

No puedes lanzar este conjuro sobre un arma natural, por ejemplo un impacto sin arma (en su lugar debes utilizar colmillo mágico). El impacto sin arma de un monje es considerado como un arma, y por lo tanto puede ser mejorado con este conjuro.$c$, components = $c$V. S. FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$arma tocada$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo, objeto)$c$, spell_resistance = $c$sí (inofensivo, objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'arma magica';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro funciona como arma mágica, salvo en que proporciona a un arma un bonificador de mejora al ataque y daño de +1 por cada cuatro niveles de lanzador (máximo +5).

Otra posibilidad es afectar a un máximo de 50 flechas, piedras o virotes. Todos los proyectiles deben ser del mismo tipo y estar formando un grupo (por ejemplo, dentro de un mismo carcaj). Los proyectiles (no así las armas arrojadizas) pierden su transmutación en cuanto son utilizados (considera los shurikens como proyectiles, no como armas arrojadizas, a efectos de este conjuro).

Componente material arcano: cal en polvo y carbón.

- Armadura de mago Conjuración (creación) [fuerza] == == Nivel: Hcr/Mag 1 Componentes: V. S. F Tiempo de lanzamiento: 1 acción estándar Alcance: toque Obietivo: criatura tocada Duración: 1 h/nivel (D) Tiro de salvación: Voluntad niega (inofensivo)
- Resistencia a conjuros: no

Un campo de fuerza invisible, pero tangible, rodea al receptor de la armadura de mago, proporcionándole un honificador +4 de armadura a la CA. Al contrario que la armadura mundana, la de este conjuro no impone ningún penalizador de armadura, no da lugar a fallo de conjuro arcano ni reduce la velocidad. Al estar hecha de fuerza, las criaturas incorporales no pueden atravesar la armadura de mago igual que hacen con la normal. Foco: un fragmento de cuero curado.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$un arma o 50 proyectiles (todos los
- cuales han de estar en contacto en el momento del lanzamiento)$c$, duration = $c$1 h/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo, objeto)$c$, spell_resistance = $c$sí (inofensivo, objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'arma magica mayor';
update spells set school = $c$Ilusión$c$, subschool = $c$fantasmagoría$c$, descriptors = $c$enajenador, miedo$c$, description = $c$Creas la imagen fantasmal de la criatura más terrible que pueda imaginar el receptor, combinando sus miedos inconscientes para crear algo que pueda visualizar: la bestia más horrible. Solamente el receptor del conjuro podrá ver al asesino fantasmal; tú sólo verás una figura vaga. Al principio, el receptor tendrá derecho a un TS de Voluntad para darse cuenta de que la imagen no es real. Si el tiro falla, el asesino entrará en contacto con él y la víctima tendrá que realizar un TS de Fortaleza para evitar morir de miedo. Incluso aunque el TS de Fortaleza tenga éxito, el receptor sufrirá 3d6 puntos de daño.

Si la víctima descree con éxito y, además, lleva puesto un yelmo de telepatía, podrá volver a la bestia contra ti. Si eso sucede, deberás conseguir descreer o serás el objetivo de su ataque mortal de miedo.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel) Ohietivo: una criatura viva$c$, duration = $c$instantánea$c$, saving_throw = $c$Voluntad descree (si se
- interactúa con el conjuro) y, a continuación,
- Fortaleza parcial; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'asesino fantasmal';
update spells set school = $c$Nigromancia$c$, description = $c$Este conjuro agosta una única planta de cualquier tamaño. Una criatura tipo planta afectada recibe 1d6 puntos de daño por nivel (máximo 15d6) y puede intentar un TS de Fortaleza para medio daño. Una planta que no sea una criatura (como un árbol o un arbusto) no recibe salvación y se marchita y muere de manera inmediata. Este conjuro no tiene efecto en el suelo ni en la vida vegetal de los alrededores.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$una planta$c$, duration = $c$instantánea$c$, saving_throw = $c$Fortaleza mitad, ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'asolar';
update spells set school = $c$Transmutación$c$, description = $c$La criatura transmutada por este conjuro se vuelve más inteligente. El conjuro otorga un bonificador +4 de mejora a la Inteligencia, proporcionando los beneficios usuales a las habilidades relacionadas con la misma. Los magos (v otros lanzadores de conjuros que se basen en la Inteligencia) que reciban este conjuro no obtiene conjuros adicionales por el aumento de la característica, pero sí ven aumentadas las CD de sus conjuros. Este conjuro no proporciona puntos de habilidades adicionales.

Componente material arcano: unos cuantos pelos o una pizca de heces de un zorro.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'astucia de zorro';
update spells set school = $c$Conjuración$c$, subschool = $c$convocación$c$, description = $c$Este conjuro mete la fuerza vital de una criatura (y su cuerpo material) dentro de una gema.

La gema albergará a la entidad atrapada indefinidamente o hasta que la piedra se rompa y la fuerza vital quede liberada, lo que permitirá también que el cuerpo material vuelva a formarse. Si la entidad atrapada fuera una criatura poderosa de otro plano (lo que incluye a los personajes que estén fuera del plano Material y sean atrapados por habitantes de otro plano), se le podría pedir que llevara a cabo un servicio nada más ser liberada.

Por lo demás, la criatura quedará libre en cuanto alguien ponga fin a su cautiverio en la gema.

Dependiendo de la versión elegida, el conjuro podrá ser desencadenado de una de estas dos maneras:

Finalización de conjuro: con el primer método, el conjuro puede completarse pronunciando su palabra final como acción estándar, igual que si estuvieras lanzando un conjuro normal contra el receptor. Esto permitirá usar la RC (en caso de haberla) y realizar un TS de Voluntad para evitar el efecto. Si se pronuncia también el nombre de la criatura, la RC se ignorará y la CD de la salvación aumentará en 2. Si la salvación o la RC tienen éxito, la gema estallará en pedazos.

Objeto desencadenante: el segundo método es más insidioso y consiste en engañar al receptor para que acepte un objeto desencadenante inscrito con la palabra final del conjuro, momento en que el alma de la criatura es encerrada automáticamente en la trampa. Para usar este método, tanto el nombre de la criatura como la palabra desencadenante han de inscribirse en el objeto al encantar la gema. Además, es posible situar un conjuro de simpatía en el objeto desencadenante. En cuanto el receptor acepte el objeto o lo coja en la mano, su fuerza vital será transferida automáticamente a la gema sin derecho a salvarse ni a usar su RC.

Componente material: antes de llegar a ejecutar el lanzamiento definitivo del conjuro de atrapar el alma, debes obtener una gema que valga 1.000 po por DG que posea la criatura a atrapar (por

ejemplo, necesitarías una gema de 10.000 po para una criatura de 10 DG). Si la piedra preciosa no valiera lo suficiente, se romperá en el momento de intentar atrapar a la criatura (aunque los personajes no tengan concepto del nivel ni los DG como tales, sí que podrán hacer averiguaciones para saber el valor que ha de tener una gema para encerrar a alguien; sin embargo, recuerda que tal valor podría cambiar con el paso del tiempo al evolucionar los personajes).

Foco (sólo con el objeto desencadenante): si utilizas el método de objeto desencadenante, necesitaras un objeto especial, como el descrito anteriormente.

| uqurio |
| |
| Adivinación |
| Nivel: Clr 2 |
| Componentes: V, S, M, F |
| Tiempo de lanzamiento: 1 minuto |
| Alcance: personal |
| Objetivo: tú |
| Duración: instantanea |
| |

A

Un augurio te revela si una acción concreta te beneficiará o perjudicará en el futuro inmediato. Por ejemplo, si un grupo se estuviera planteando destruir un extraño sello con el que está cerrada una entrada, este conjuro podría confirmarles si es buena idea o no.

La posibilidad inicial de recibir una respuesta inteligible es de 70% + 1% por nivel de lanzador, hasta un máximo de 90%; el DM realizará la tirada en secreto, aunque podrá decidir que el éxito es automático cuando la pregunta sea muy clara o completamente nulo cuando esta pregunta sea demasiado vaga. Si el augurio tiene éxito, obtendrás una de las siguientes respuestas:

- · "Dicha" (si es probable que la acción tenga buenos resultados).
- "Desdicha" (si es probable que tenga malos resultados).
- · "Dicha y desdicha" (si puede resultar en ambas cosas).
- · "Nada" (para aquellas acciones que no tengan un resultado especialmente bueno o malo).

Si el conjuro fracasa, obtendrás el resultado de "nada". Un clérigo que obtenga la respuesta "nada" no tendrá manera de averiguar si el conjuro ha resultado acertado o fallido.

El augurio sólo puede responder sobre lo que vaya a suceder durante la media hora siguiente. Lo que pase después no afectará en absoluto a la predicción, que, de hecho, podría pasar por alto las consecuencias a largo plazo de la acción sobre la que se pregunte. Todos los augurios sobre una cuestión concreta que ejecute una misma persona utilizarán el mismo resultado de dado que el primero.

Componente material: incienso por un valor mínimo de 25 po.

Foco: un conjunto de objetos marcados (como palillos, huesos, etc.) por un valor mínimo de 25 po.

Aura mágica de Nystul

Ilusión (engaño) Nivel: Brd 1, Hcr/Mag 1, Magia 1 Componentes: V, S, F F F F F F J

Tiempo de lanzamiento: 1 acción estándar Alcance: toque

Objetivo: un objeto tocado, que no pese más de 5 lb/nivel Duración: 1 día/nivel (D)

Tiro de salvación: ninguno; ver texto Resistencia a conjuros: no

Alteras el aura de un objeto para que aparezca ante los sortilegios de detección (y conjuros con capacidades similares) como si no fuese mágico, o como si fuese un objeto mágico del tipo que especifiques, o como si estuviese bajo los efectos de un conjuro que especifiques. Gracias a este sortilegio, podrás hacer que una espada normal parezca una vorpalina +2 o que una vorpalina +2 parezca una espada +1 o incluso una espada no mágica. Si el objeto portador del aura mágica de Nystul se convierte en objetivo de un conjuro de identificar (o se examina de forma parecida), quien lo esté examinando podrá reconocer que su aura es falsa y detectar sus verdaderas cualidades teniendo éxito en un TS de Voluntad. De lo contrario, pensará que el aura de Nystul es verdadera y no averiguará la auténtica naturaleza de la magia por mucho que lo intente.

Si el aura del objeto custodiado es excepcionalmente poderosa (si es, por ejemplo, un artefacto), el aura mágica de Nystul no funcionará. Nota: las armas, armaduras y escudos mágicos han de ser objetos de gran calidad; por tanto, una espada de manufactura mediocre resultaría bastante sospechosa si irradiara un aura mágica. Foco: un pequeño retal cuadrado de seda que debe pasarse sobre el objeto para que éste adquiera el aura.

Aura sacrílega

Abjuración [maligno] Nivel: Clr 8, Mal 8 Componentes: V, S, F Tiempo de lanzamiento: 1 acción estándar Alcance: 20' Objetivos: una criatura/nivel en una explosión de 20' de radio. centrada en ti Duración: 1 asalto/nivel (D)

Tiro de salvación: ver texto Resistencia a conjuros: sí (inofensivo)

Una malévola oscuridad rodea a los receptores, protegiéndolos de los ataques, concediéndoles resistencia a los conjuros lanzados por criaturas buenas y debilitando a las criaturas de este alineamiento que logren alcanzarlos con sus ataques. Esta abjuración posee cuatro efectos:

En primer lugar, las criaturas custodiadas obtienen un bonificador +4 de desvío a la CA y un bonificador +4 de resistencia en sus TS. Al contrario que sucede con protección contra el bien, este beneficio se aplica contra todos los ataques, no sólo contra los procedentes de criaturas buenas.

En segundo lugar, las criaturas custodiadas ganan RC 25 contra los conjuros buenos y los sortilegios ejecutados por criaturas buenas.

En tercer lugar, la abjuración bloquea la posesión y la influencia mental del mismo modo que protección contra el bien.

Por último, las criaturas buenas que logren alcanzar con un ataque a un defensor custodiado por el conjuro sufrirán 1d6 puntos de daño temporal de Fuerza (Fortaleza niega).

Foco: un pequeño relicario que contenga una reliquia sagrada, como un fragmento de pergamino de un texto sacrílego. El relicario ha de costar 500 po como mínimo.$c$, components = $c$V, S, M (F); ver texto$c$, casting_time = $c$1 acción estándar o<br>ver texto$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura$c$, duration = $c$permanente; ver texto$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$si; ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'atrapar el alma';
update spells set school = $c$Abjuración$c$, descriptors = $c$bueno$c$, description = $c$Un brillante resplandor divino rodea a los receptores, protegiéndolos contra los ataques, concediéndoles resistencia a los conjuros lanzados por criaturas malignas y cegando a las criaturas de este alineamiento que alcancen a los receptores con sus ataques. Esta abjuración tiene cuatro efectos:

En primer lugar, las criaturas custodiadas obtienen un bonificador +4 de desvío a la CA y un bonificador +4 de resistencia en sus TS. Al contrario que sucede con protección contra el mal, este beneficio se aplica contra todos los ataques, no sólo contra los procedentes de criaturas malignas.

En segundo lugar, las criaturas custodiadas ganan RC 25 contra los conjuros malignos y los sortilegios ejecutados por criaturas malignas. En tercer lugar, la abjuración bloquea la posesión y la influencia mental del mismo modo que protección contra el mal.

Por último, las criaturas malignas que logren alcanzar con un ataque a un defensor custodiado por el conjuro quedarán cegadas en el acto (Fortaleza niega, igual que ceguera/sordera, pero con la CD de salvación del aura sagrada).

Foco: un pequeño relicario que contenga una reliquia sagrada, como un jirón de la túnica de un santo o un fragmento de pergamino de un texto sagrado. El relicario costará 500 po como mínimo.$c$, components = $c$V, S, F A 12 12 12 12 12$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$20'$c$, target = $c$una criatura/nivel en una explosión$c$, duration = $c$1 asalto/nivel (D)$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'aura sagrada';
update spells set description = $c$+1 de moral a las tiradas de ataque y las salvaciones contra efectos de miedo, además de puntos de golpe temporales por un valor igual a 1d8 + el nivel del lanzador (hasta un máximo de 1d8+10 puntos de golpe temporales a nivel de lanzador 10.º).$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estandar$c$, spell_range = $c$toque$c$, target = $c$criatura viva tocada$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$si (inofensivo) Auxilio divino otorga al objetivo un bonificado$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'auxilio divino';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$El receptor siente la irrefrenable necesidad de bailar y empieza a hacerlo sin dudar, arrastrando los pies y taconeando. El baile impide al receptor llevar a cabo más acciones que brincar y hacer cabriolas. El efecto impone un penalizador -4 a su CA y un penalizador -10 en las salvaciones de Reflejos, y niega cualquier bonificador a la CA proporcionado por un escudo que lleve el objetivo. El bailarín provoca ataques de oportunidad cada asalto en su turno.$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura viva tocada$c$, duration = $c$1d4+1 asaltos$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'baile irresistible de otto';
update spells set school = $c$Evocación$c$, descriptors = $c$fuerza$c$, description = $c$Niega; ver texto

Este conjuro hace aparecer un cortina vertical e inmóvil de afiladas cuchillas giratorias de pura fuerza. Toda criatura que atraviese la barrera de cuchillas sufrirá 1d6 puntos de daño cortante por nivel de lanzador (con un máximo de 15d6), con una salvación de Reflejos para medio daño Si evocas la barrera para que aparezca en un espacio donde haya criaturas, cada criatura sufre daño como si hubiese atravesado el muro. Cada una de estas criaturas puede evitar el muro (terminando en el lado que elija) y no recibir daño de él si supera una salvación de Reflejos.

Una barrera de cuchillas proporciona cobertura (bonificador +4 a la CA, bonificador +2 a las salvaciones de Reflejos) frente los ataques que se hagan a través de ella.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$muro de cuchillas giratorias, de hasta$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Reflejos mitad o Reflejos$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'barrera de cuchillas';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro te permite convertir un bastón, preparado especialmente, en una criatura Enorme, parecida a un ent de unos 24' de estatura. Cuando toques el suelo con un extremo del bastón y pronuncies una orden especial que pone fin al lanzamiento del conjuro, tu bastón se convertirá en una criatura con el mismo aspecto y capacidades de combate que un ent de verdad (consulta el Manual de monstruos). El bastón-ent te defenderá y obedecerá las órdenes que le dictes en voz alta. Sin embargo, la criatura no será un ent verdadero; es decir, no podrá conversar con otros ents ni controlar a los árboles. Si los pg del bastón-ent quedan reducidos a cero (0) o menos, éste queda reducido a polvo, y el bastón destruido. En los demás casos, el bastón vuelve a su forma normal cuando concluye la duración del conjuro (o cuando es disipado), y puede ser utilizado de nuevo como foco en un posterior lanzamiento. El bastón-ent siempre estará a pleno potencial en el momento de su creación, sin importar las heridas que sufriera en su última aparición.

Foco: el bastón, que debe estar preparado especialmente. El bastón debe ser una rama sólida, cortada de un fresno, roble o tejo, que ha de ser curada, dotada de forma, tallada y pulida (proceso que suele necesitar unos 28 días). Mientras estés dando forma y tallando el bastón no podrás implicarte en ninguna aventura ni realizar ninguna actividad extenuante.$c$, components = $c$V, S, F$c$, casting_time = $c$1 asalto$c$, spell_range = $c$toque$c$, target = $c$tu bastón (al que has de tocar)$c$, duration = $c$1 h/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'baston cambiante';
update spells set school = $c$Transmutación$c$, description = $c$Te permite almacenar en tu bastón un conjuro que puedes ejecutar normalmente. Sólo puedes tener almacenado uno de esos conjuros al mismo tiempo, y tampoco podrás poseer más de un bastón de conjuro a la vez. Podrás ejecutar el conjuro almacenado como si se encontrara entre los que tuvieras preparados, pero éste no se tendrá en cuenta para tu asignación del día. No obstante, deberás gastar los componentes materiales necesarios para lanzar el conjuro almacenado. Foco: el bastón que almacenará el sortilegio.$c$, components = $c$V, S, F$c$, casting_time = $c$10 minutos$c$, spell_range = $c$toque$c$, target = $c$bastón de madera tocado$c$, duration = $c$permanente hasta ser descargado (D)$c$, saving_throw = $c$Voluntad niega (objeto) Resistencia a conjuros: sí (objeto)$c$, spell_resistance = $c$si$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'baston de conjuro';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Les obtendrán un bonificador +1 de moral tanto en sus tiradas de ataques como en los TS contra efectos de miedo.

Bendecir contrarresta y disipa el conjuro de perdición.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$50$c$, target = $c$el lanzador y todos sus aliados en una explosión de 50' de radio, centrada en el lanzador$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí (inofensivo) Este conjuro llena de valor a tus aliados, los cua- lass and such in bandicados il do mano family$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'bendecir';
update spells set school = $c$Transmutación$c$, descriptors = $c$bueno$c$, description = $c$Esta transmutación infunde energía positiva en un frasco de agua (1 pinta), convirtiendo su contenido en agua bendita (pág. 128).

Componente material: 5 lb. de plata pulverizada (por valor de 25 po).$c$, components = $c$V, S, M$c$, casting_time = $c$1 minuto$c$, spell_range = $c$toque$c$, target = $c$frasco de agua tocado$c$, duration = $c$instantanea$c$, saving_throw = $c$Voluntad niega (objeto)$c$, spell_resistance = $c$sí (objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'bendecir aqua';
update spells set school = $c$Transmutación$c$, description = $c$Debilidad, atontamiento Hasta el nivel de lanzador -10 Muerte, parálisis, debilidad, atontamiento

Los efectos son acumulativos y coexistentes, y no se permite TS contra ellos.

Atontamiento: la criatura no podrá realizar acciones durante 1 asalto, aunque se defenderá con total normalidad.

Debilidad: la puntuación de Fuerza de la criatura se reduce en 2d6 puntos durante 2d4 asaltos. Parálisis: la criatura queda paralizada e inde-

fensa durante 1d10 minutos.

Muerte: una criatura viva muere. Un muerto viviente es destruido

Además, si estás en tu plano natal al lanzar este conjuro, las criaturas extraplanarias no malignas que haya en el área serán desterradas inmediatamente y devueltas a sus planos de origen. Las criaturas desterradas de esta forma no podrán regresar durante 24 horas, como mínimo. Este efecto tendrá lugar independientemente de si las criaturas oyen o no la blasfemia. El efecto de destierro permite una salvación de Voluntad (con un penalizador -4) para negarlo.

Las criaturas cuyos DG excedan tu nivel de lanzador no resultan afectadas por la blasfemia.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$arma tocada$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$ninguno Resistencia a coniuros: no$c$, spell_resistance = $c$sí Toda criatura no maligna dentro del área de un conjuro de blasfemia sufre los siguientes efectos negativos. Efecto<br>DG lgual al nivel de lanzador<br>Atontamiento Debilidad,<br>Hasta el nivel de lanzador -1 atontamiento Hacts al nival do lanzador -5<br>Darslicic$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'bendecir arma';
update spells set school = $c$Ilusión$c$, subschool = $c$engaño$c$, description = $c$Este conjuro infunde al objeto o criatura elegido con una boca encantada que aparecerá de repente y comunicará un mensaje la siguiente vez que suceda algo concreto. El mensaje, que debe tener un máximo de 25 palabras, puede estar en cualquier idioma que conozcas y ser transmitido durante un período de 10 minutos. La boca no podrá pronunciar componentes verbales, usar palabras de mando ni activar efectos mágicos. No obstante, sí que podrá coordinar sus movimientos con las palabras pronunciadas. Si, por ejemplo, forma parte de una estatua, ésta dará la sensación de estar hablando. Por supuesto, la boca mágica puede colocarse sobre un árbol, una piedra, una puerta o cualquier otro objeto o criatura.

El conjuro se pondrá en funcionamiento en cuanto se cumplan las condiciones que hayas establecido en el momento del lanzamiento. Tales condiciones pueden ser tan generales o detalladas como desees, aunque sólo podrás usar desencadenantes visuales o audibles, como: "Habla solamente cuando una humana venerable que porte un saco se siente cruzando las piernas a un pie de distancia". Los desencadenantes reaccionarán ante aquello que parezca cumplir las condiciones; por tanto, el conjuro puede ser engañado por los disfraces e ilusiones. La oscuridad normal no supondrá obstáculo alguno para un desencadenante visual, pero la oscuridad mágica o la invisibilidad sí lo serán. El movimiento silencioso o el silencio mágico también supondrán un obstáculo para los desencadenantes audibles, que pueden ajustarse a un tipo general de ruido (pasos, choque de metal, etc.) o bien a un sonido concreto o una palabra pronunciada (una aguja al caer, cuando alguien diga: "¡Uuh!"). Nótese que las acciones pueden servir de desencadenante siempre y cuando sean visibles o audibles; "Habla en cuanto una criatura toque la estatua", por ejemplo, sería una condición aceptable, siempre y cuando la criatura en cuestión fuera visible. Una boca mágica es incapaz de distinguir alineamientos, niveles, DG o clases de personaje, a menos que lo haga mediante el atuendo que se lleve puesto.

El límite de alcance de un desencadenante es de 15' por nivel de lanzador; por tanto, un lanzador de nivel 6.º puede ordenar a la boca mágica que responda a los desencadenantes que tengan lugar a 90' de distancia como máximo. Sin importar cuál sea el alcance, la boca sólo podrá responder a los desencadenantes y acciones visibles que haya en su línea de visión o estén dentro de su alcance auditivo. Boca mágica puede ser hecho permanente con

un conjuro de permanencia. •

Componente material: un pequeño fragmento de un panal y polvo de jade por valor de 10 po.

| ola de fuego |
| |
| Evocación [fuego] |
| Nivel: Hcr/Mag 3 |
| Componentes: V, S, M |
| Tiempo de lanzamiento: 1 acción estándar |
| Alcance: largo (400' + 40'/nivel) |
| Area: expansión de 20' de radio |
| Duración: instantánea |
| Tiro de salvación: Reflejos mitad |
| Resistencia a conjuros: sí |
| |

Un conjuro de bola de fuego es una explosión de llamas que detona con un estampido grave e inflige 1d6 puntos de daño por fuego por nivel de lanzador (máximo 10d6) a todas las criaturas que haya en el área. Los objetos no atendidos por ninguna criatura (portados, puestos, etc.) también sufrirán el daño. El efecto apenas genera presión.

Sólo tienes que señalar con el dedo y decidir a qué alcance (tanto en distancia como en altura) deseas que explote la bola de fuego. Una cuenta, brillante y del tamaño de un guisante, surgirá de tu dedo y explotará formando una bola de fuego al llegar a su punto de origen, siempre y cuando no golpee contra un cuerpo material o una barrera sólida antes de cubrir la distancia elegida (un impacto prematuro dará lugar a una explosión prematura). Si intentas enviar la cuenta a través de un paso estrecho (como una saetera), deberás "alcanzar" la abertura en cuestión con un ataque de toque a distancia; si fallas esta tirada, la cuenta golpeará contra la barrera y detonará prematuramente.

La bola de fuego incendiará todo lo que sea combustible y causará daño a los objetos que haya en el área. Puede fundir metales con un punto de fusión bajo, como el plomo, el oro, el cobre, la plata o el bronce. Si el daño causado a una barrera interpuesta la rompe o pasa a través de ella, la bola de fuego podrá continuar más allá, siempre que su área se lo permita; de lo contrario, se detendrá al llegar a la barrera, igual que haría cualquier otro efecto de conjuro.

Componente material: una pequeña bola de guano de murciélago y azufre.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura u objeto$c$, duration = $c$permanente hasta ser descargada$c$, saving_throw = $c$Voluntad niega (objeto)$c$, spell_resistance = $c$sí (objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'boca magica';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro borra la escritura tanto mágica como mundana de un rollo de pergamino o dos páginas de papel, pergamino u otros materiales similares. Con este sortilegio puedes eliminar glifos custodios, improntas de la serpiente sepia, marcas arcanas o runas explosivas, pero no borra la escritura ilusoria ni los conjuros de símbolo. Los escritos de naturaleza no mágica se borran automáticamente si los tocas y nadie más los tiene en su poder; de lo contrario, las posibilidades de borrarlos quedan reducidas a un 90%.

La escritura mágica ha de ser tocada, y para poder borrarla debes realizar una prueba de nivel de lanzador (1d20 + nivel de lanzador) contra una CD de 15; en esta tirada, un resultado natural de 1 ó 2 se considerará siempre un fallo. Si fracasas al intentar borrar un glifo custodio, una impronta de la serpiente sepia o unas runas explosivas, activarás accidentalmente el efecto de la escritura.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$un rollo de pergamino o dos páginas$c$, duration = $c$instantánea$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'borrar';
update spells set school = $c$Transmutación$c$, description = $c$Toda la vegetación que cubra el suelo en el área del conjuro se volverá muy dura y espinosa, sin que ello cambie lo más mínimo su apariencia. Allá donde la tierra esté desnuda, se transmutarán de ese modo las raíces que pueda haber. Normalmente, este conjuro puede ejecutarse en cualquier lugar al aire libre que no esté cubierto por agua, hielo, una capa espesa de nieve, arenas de desierto o piedra desnuda. Toda criatura que entre o atraviese a pie el área del conjuro sufrirá 1d4 puntos de daño por cada 5' que se desplace por ella.

Las criaturas dañadas por este conjuro deberán realizar un TS de Reflejos o sufrirán heridas en los pies y piernas que reducirán su velocidad a la mitad. Esta penalización a la velocidad durará 24 horas o hasta que la criatura herida reciba un conjuro de curar (que también le hará recuperar puntos de golpe). Otra criatura podría librar a una vícti-

ma de la penalización dedicando 10 minutos a vendar las heridas y teniendo éxito en una prueba de Sanar contra la CD de salvación del conjuro. Brotar de espinas es una trampa mágica que no

puede ser desactivada mediante la habilidad de Inutilizar mecanismo.

Nota: las trampas mágicas, como ésta, son difíciles de detectar e inutilizar. Un pícaro (y sólo un pícaro) puede usar la habilidad de Buscar para encontrar el efecto mágico; la CD sería 25 + el nivel de conjuro, es decir, CD 28 en el caso del brotar de espinas (o CD 27 para la versión lanzada por un explorador).$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$un cuadro de 20'/nivel$c$, duration = $c$1 h/nivel (D)$c$, saving_throw = $c$Reflejos parcial$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'brotar de espinas';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, descriptors = $c$ácido$c$, description = $c$La bruma ácida es una nube de vapores similar a la producida por el conjuro bruma sólida. Además de ralentizar a las criaturas y oscurecer su visión, los vapores de este conjuro son altamente ácidos. Durante tu turno de cada asalto, empezando en el que hayas lanzado el conjuro, la niebla infligirá 2d6 de daño por ácido a las criaturas y objetos que se encuentren en su interior.

Componentes materiales arcanos: una pizca de guisante seco en polvo combinada con pezuña de animal pulverizada.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$bruma que se expande en un radio de 20', 20' alto$c$, duration = $c$1 asalto/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'bruma acida';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Este conjuro crea un banco de niebla que debilita la resistencia mental de todo aquel a quien rodea. Las criaturas que estén dentro de la bruma mental sufrirán un penalizador -10 de capacidad en todos sus TS y pruebas de Sabiduría (una criatura que logre salvarse contra la niebla no resultará afectada y no tendrá que realizar nuevos TS aunque permanezca dentro de ella). Las criaturas afectadas sufrirán el penalizador mientras permanezcan dentro de la niebla y 2d6 asaltos después de abandonarla. La bruma en sí no se mueve, y dura 30 minutos (o hasta ser dispersada por el viento).

Un viento moderado (11 millas/h o más) dispersará la niebla en cuatro asaltos; un viento fuerte (21 millas/h o más) lo hará en 1 asalto. Esta bruma no es densa y no supone un obs-

táculo significativo para la visión.

206$c$, components = $c$V. S.$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$bruma que se expande en un radio de 20', con 20' de alto$c$, duration = $c$30 min y 2d6 asaltos; ver texto$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'bruma mental';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, description = $c$Este conjuro funciona igual que nube brumosa, pero, además de emborronar la visibilidad, la bruma sólida es tan espesa que toda criatura que intente moverse por ella lo hará a una velocidad de 5', sin importar su velocidad normal, y todas las tiradas de ataque y daño en cuerpo a cuerpo sufrirán un penalizador -2. Los vapores impedirán efectuar ataques a distancia efectivos (exceptuando los rayos mágicos y cosas parecidas). Una criatura u objeto que caiga en el interior de la bruma sólida será frenado, reduciéndose el daño de su caída en 1d6 por cada 10' de vapor atravesados. Una criatura no puede realizar un paso de 5' mientras esté en el interior de este conjuro.

Al contrario de lo que sucedería con una bruma normal, ésta sólo se dispersará por la acción de un viento severo (31 millas/h o más), tardando un asalto en desaparecer.

Bruma sólida puede ser hecho permanente con un conjuro de permanencia. Una bruma sólida permanente que sea dispersada por el viento se vuelve a formar en 10 minutos.

Componentes materiales: una pizca de guisante seco en polvo combinada con pezuña de animal pulverizada.$c$, components = $c$V, S, M$c$, duration = $c$1 min/nivel$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'bruma solida';
update spells set school = $c$Transmutación$c$, description = $c$El conjuro afecta a uno o más objetos o criaturas Medianas o más pequeñas (incluyendo el equipo y objetos llevados por ellas, hasta su carga máxima), o al equivalente en criaturas mayores. Una criatura u objeto Grande cuenta como dos criaturas u objetos Medianos; una criatura u objeto Enorme como dos Grandes, etc.

Puedes lanzar este conjuro pronunciándolo en un instante, lo bastante rápido como para salvarte de una caída inesperada. Lanzar este sortilegio es una acción gratuita, se lanza igual que un conjuro apresurado y cuenta para el límite normal de un conjuro apresurado por asalto. Puedes lanzar este conjuro incluso cuando no sea tu turno.

Este sortilegio no causa ningún efecto especial en las armas de ataque a distancia a no ser que estén cayendo desde bastante altura. Si el conjuro se lanzara sobre un objeto que estuviera cayendo, como una piedra lanzada desde lo alto de una muralla, éste sólo infligirá la mitad del daño normal correspondiente a su peso y no se aplicará el bonificador por la altura de la caída (consulta la Guía del Dungeon Master para obtener más información acerca de la caída de objetos).

Caída de pluma sólo funciona en objetos que estén en caída libre; no surtirá efecto en el golpe de una espada ni en una criatura que vuele o vaya a la carga.

| Calentar metal |
| |
| Transmutación [fuego] |
| Nivel: Drd 2, Sol 2 |
| Componentes: V, S, FD |
| Tiempo de lanzamiento: 1 acción estándar |
| Alcance: corto (25 + 5'/2 niveles) |
| Objetivo: equipo metálico de una criatura/2 |
| niveles (dos criaturas cualesquiera no |
| pueden distar más de 30'); o 25 lb de |
| metal/nivel (todo el cual debe estar dentro |
| de un círculo de 30'). |
| Duración: 7 asaltos |
| Tiro de salvación: Voluntad niega (objeto) |

Resistencia a conjuros: sí (objeto)

Este conjuro hace que el metal se caliente hasta alcanzar temperaturas extremas. Los objetos que no sean mágicos ni estén atendidos no podrán realizar un TS. El metal encantado tendrá derecho a un TS contra el conjuro (los TS de los objetos mágicos son tratados en la Guía del Dungeon Master). Los objetos que obren en poder de una criatura utilizarán los TS

de su portador, a no ser que los suyos sean mejores. Una criatura sufre daño por fuego si su equipo se calienta. El daño sufrido será completo si la armadura resulta afectada o si la criatura estuviera asiendo, tocando, vistiendo o portando un peso metálico equivalente a una quinta parte de su carga. La criatura sufrirá un daño mínimo (1 ó 2 puntos; consulta la tabla) si no llevara puesta armadura metálica o si el metal transportado fuera menos de la quinta parte de su carga.

En el primer asalto del conjuro, el metal se calentará mucho y resultará muy incómodo al tacto, pero no infligirá daño alguno (éste será también el efecto correspondiente al último asalto de la duración del conjuro). Durante el segundo asalto (y en el penúltimo), el intenso calor causará daño y dolor. Durante los asaltos tercero, cuarto y quinto, el metal estará terriblemente caliente e infligirá un daño superior, tal y como se indica en la siguiente tabla:

| | Temperatura | |
| | | |
| Asalto | del metal | Daño |
| | Templado | Ninguno |
| 2 | Caliente | 1d4 puntos |
| 3-5 | Abrasador | 2d4 puntos |
| 6 | Caliente | 1d4 puntos |
| 7 | Templado | Ninguno |
| | | |

Cualquier frío lo bastante intenso como para infligir daño a la criatura negará el daño por fuego del conjuro (y viceversa) en una proporción 1:1. Si, por ejemplo, la tirada de daño del conjuro de calentar metal indicara 2 puntos de daño por fuego y la criatura es golpeada por un rayo de escarcha en el mismo asalto (que le infligiera 3 puntos de daño por frío), no sufriría ninguna cantidad de daño por fuego y sólo sufriría 1 punto restante de daño por frío. Si es lanzado bajo el agua, calentar metal inflige sólo medio daño y hace hervir el agua circundante.

Calentar metal contrarresta y disipa el conjuro helar metal$c$, components = $c$V$c$, casting_time = $c$1 acción gratuita$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$un objeto o criatura Mediano o más pequeño en caída libre/nivel; dos objetivos no pueden estar a más de 20' de distancia$c$, duration = $c$1 asalto/nivel o hasta aterrizar$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (objeto) Las criaturas u objetos afectados caerán lentamente, aunque a mayor velocidad de lo que suelen hacerlo las plumas. Su velocidad de caída quedará reducida instantáneamente a sólo 60' por asalto (el equivalente al final de una caída desde pocos pies de altura), por lo que los objetivos no sufrirán daño alguno al tocar tierra mientras el conjuro esté surtiendo efecto. Sin embargo, se recuperará la velocidad normal de caída en cuanto finalice el sortilegio.$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'caida de pluma';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Este conjuro calma y tranquiliza a los animales, haciendo que se muestren dóciles e inofensivos. Sólo los animales normales (aquellos con puntuaciones de Inteligencia de 1 ó 2) resultan afectadas por este sortilegio. Todos los receptores deben ser de la misma especie, y ninguno puede estar a más de 30' del resto. El número máximo de DG de animales que puedes afectar es 2d4 + tu nivel de lanzador. Los animales adiestrados para atacar o vigilar y los animales terribles tendrán derecho a realizar un TS; los demás animales no (un druida podría calmar a un oso o un lobo normal sin muchos problemas, pero es más difícil afectar a un perro guardián entrenado).

Las criaturas afectadas se quedarán donde estén y no atacarán ni huirán. No estarán indefensas y se defenderán con total normalidad en caso de ser atacadas. Cualquier amenaza (fuego, un depredador hambriento o un ataque inminente) romperá el conjuro sobre las criaturas en peligro.

20'$c$, components = $c$V. S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$animales a no más de 30' unos de otros$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'calmar animales';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Este conjuro calma a las criaturas nerviosas. No tendrás control sobre las criaturas afectadas, pero el sortilegio podrá evitar que los receptores ataquen si están enfurecidos o se rebelen en caso de estar predispuestos. Las criaturas afectadas de este modo no podrán llevar a cabo acciones violentas (aunque podrán defenderse) ni hacer nada destructivo, a excepción de protegerse. Toda acción agresiva o daño que se le inflija a una criatura calmada romperá el conjuro en todas las criaturas afectadas.

Este conjuro suprime automáticamente (pero no disipa) los efectos enajenadores como bendecir, esperanza alentadora, o furia, además de negan la aptitud de infundir valor del bardo y la furia del bárbaro. También suprime cualquier efecto de miedo y elimina la confusión de todos los receptores. El conjuro suprimido no surtirá efecto mientras dure el conjuro de calmar emociones. Cuando este finalice, el conjuro original volverá a surtir efecto en la criatura, siempre y cuando su duración no haya expirado mientras tanto.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$criaturas en una expansión de 20' de radio$c$, duration = $c$concentración, hasta 1 asalto/nivel (D)$c$, saving_throw = $c$Voluntad niega >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'calmar emociones';
update spells set school = $c$Transmutacion$c$, description = $c$Este conjuro funciona como polimorfar, salvo en que te permite adoptar la forma de cualquier criatura no única (de cualquier tipo), desde tamaño Minúsculo hasta Colosal. La forma adoptada no puede tener más DG que el doble de tu nivel (hasta un máximo de 50 DG). A diferencia de polimorfar, este conjuro sí permite adoptar formas incorporales o gaseosas

Obtienes todas las aptitudes extraordinarias y sobrenaturales (tanto ataques como cualidades) de la forma asumida, pero pierdes tus propias aptitudes sobrenaturales. También serás considerado como una criatura del tipo correspondiente a la nueva forma (por ejemplo, "dragón" o "bestia mágica") en lugar del que corresponda a la tuya. La nueva forma no te desorientará. Los fragmentos de tu cuerpo o los objetos de tu equipo que se separen de ti no recuperarán sus formas originales.

Podrás transformarte prácticamente en cualquier cosa con la que estés familiarizado, y podrás cambiar de forma cada asalto como acción gratuita. Este cambio tendrá lugar justo antes de tu acción normal o justo después, pero no durante la misma. Por ejemplo, imagina que estás comba-

208

tiendo y te transformas en un fuego fatuo. Cuando esta forma deje de serte útil, puedes convertirte en un gólem de piedra y alejarte caminando. Si empezaran a perseguirte, podrías convertirte en pulga y esconderte en un caballo hasta poder marcharte de un salto. A partir de ahí, podrías convertirte en dragón, hormiga o cualquier otra cosa con la que estés familiarizado.

Si utilizas este conjuro para disfrazarte, obtendrás un bonificador +10 en tu prueba de Disfrazarse. Foco: un ceño de jade (parecido a una diadema) por un valor mínimo de 1.500 po que debes ponerte en la cabeza al lanzar el conjuro (el foco se fundirá con tu nueva forma en cuanto la adoptes).$c$, components = $c$V, S, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$10 min/nivel (D)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'cambiar de forma';
update spells set school = $c$Transmutación$c$, descriptors = $c$aire$c$, description = $c$Te permite transformar la sustancia de tu cuerpo en un vapor similar a una nube (como por el conjuro de forma gaseosa) y desplazarte por el aire, posiblemente a gran velocidad. Podrás llevar a otras criaturas contigo y todas ellas podrán actuar de manera independiente.

Normalmente, un caminante con el viento vuela a una velocidad de 10' con maniobrabilidad perfecta. Si así lo desea el objetivo, un viento mágico lo llevará a una velocidad máxima de 600' por asalto (60 millas/h) con maniobrabilidad mala. Los que caminen con el viento no serán invisibles, sino más bien translúcidos y hechos de niebla. En caso de ir vestidos completamente de blanco, tendrán un 80% de posibilidades de ser confundidos con nubes, bruma, vapor, etc.

Todo caminante con el viento puede recuperar su forma física cuando lo desee y volver más tarde a la de nube. Cualquiera de estos cambios tarda 5 asaltos, que cuentan como parte de la duración del conjuro (así como todo el tiempo que se pase en forma física). Como se ha indicado, podrás deshacer el sortilegio, poniéndole fin inmediatamente, e incluso podrás deshacer el efecto para unos caminantes concretos y no para otros.

Durante el último minuto del conjuro, todo caminante con el viento descenderá automáticamente a 60' por asalto (para un total de 600'), aunque podrá hacerlo a mayor velocidad, si así lo desea. Este descenso advierte que el conjuro está a punto de finalizar. Filma lizar por cu

ﺍﻟﻘﻮﺍﺭ ﻭﺍﻟﻤﺴﺎﻋﺪ ﺍﻟ$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$tú y una criatura tocada/3 niveles$c$, duration = $c$1 h/nivel (D); ver texto$c$, saving_throw = $c$ninguno y Voluntad niega (inofensivo)$c$, spell_resistance = $c$no y sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'caminar con el viento';
update spells set school = $c$Transmutación$c$, descriptors = $c$aire$c$, description = $c$La criatura puede caminar por el aire como si se tratara de suelo firme. El desplazamiento ascendente es como subir por una ladera. El mayor ángulo posible, tanto de subida como de bajada, es de 45°, a un ritmo equivalente a la mitad de la velocidad normal de la criatura.

Un viento fuerte (21 millas/h o más) puede empujar al caminante aéreo o impedirle avanzar. Cada asalto, al final de su turno, el viento le empujará 5' por cada 5 millas/h de velocidad a la que sople. A discreción del DM, la criatura puede sufrir penalizadores adicionales a causa de un viento excepcionalmente fuerte o turbulento, como perder el control sobre su movimiento o sufrir daño físico al ser azotado por este fenómeno.

Si la duración del conjuro expira mientras el objetivo todavía está en el aire, la magia desaparece lentamente. El receptor desciende flotando 60' por asalto durante 1d6 asaltos. Si alcanza el suelo en ese tiempo, aterriza sin daño. Si no, cae el resto de la distancia, recibiendo 1d6 puntos de daño por cada 10' de caída. Ya que disipar un conjuro lo termina a todos los efectos, el objetivo también descenderá de este modo si el conjuro de caminar por e laire es disipado, pero no si es negado por un campo antimagia.

Puedes lanzar caminar por el aire sobre una montura entrenada especialmente para ser cabalgada por los aires. Puedes entrenar a una montura para que se mueva con la ayuda de caminar por el aire (cuenta como un truco, consulta la pag. 82) con una semana de trabajo y una prueba de Trato con Animales (CD 25).$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura (Gargantuesca o menor) tocada$c$, duration = $c$10 min/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'caminar por el aire';
update spells set school = $c$Ilusión$c$, subschool = $c$sombra$c$, description = $c$Para usar este conjuro, debes estar en un lugar en el que haya muchas sombras. El efecto te transporta por una tortuosa senda de materia sombría, junto a las criaturas a las que estés tocando, hasta el lugar en que el plano Material limita con el plano de la Sombra. El efecto es ilusorio en su mayor parte, pero la senda es cuasirreal. Podrás llevar contigo a más de una criatura (hasta donde permita tu nivel), pero éstas tendrán que estar en contacto unas con otras.

En la región de las sombras podrás moverte a un ritmo de 50 millas por hora, desplazándote con normalidad por los límites del plano de la Sombra, pero mucho más rápido respecto al plano Material. Por tanto, puedes usar este conjuro para viajar rápidamente entrando en el plano de la Sombra, desplazándote la distancia deseada y regresando al plano Material

Debido a que la realidad queda desdibujada entre el plano de la Sombra y el plano Material, no

puedes percibir los detalles del terreno o zonas por las que pasas durante el tránsito, ni puedes predecir con exactitud dónde terminará tu viaje. Es imposible calcular distancias con precisión, haciendo el conjuro virtualmente inútil para la exploración o el espionaje. Además, cuando el efecto del conjuro termina, eres desviado 1d10×100' en una dirección horizontal al azar de tu punto de salida deseado. Si esto te situaría dentro de un objeto sólido, eres expulsado a 1d10×1.000' en la misma dirección. Si esto todavía te sitúa en el interior de un objeto sólido, cualquier criatura que esté contigo y tú sois desviados hasta el espacio vacio más próximo disponible, aunque el esfuerzo de esta actividad os dejará a todos fatigados (sin TS).

Caminar por la sombra también puede utilizarse para viajar hasta otros planos que limiten con el plano de la Sombra, pero ello requerirá un viaje, potencialmente peligroso, por el propio plano de la Sombra hasta llegar a la frontera con el plano de realidad deseado. El tránsito por el plano de la Sombra llevará 1d4 horas.

Las criaturas a las que toques al ejecutar el conjuro entrarán contigo en los límites del plano de la Sombra. Una vez allí, podrán seguirte, ponerse a recorrer el citado plano o regresar a trompicones al plano Material (si se perdieran o fueran abandonadas por ti, habría un 50% de que les sucediera lo segundo y un 50% de que les sucediera lo tercero). Las criaturas que no estén dispuestas a acompañarte al plano de la Sombra tendrán derecho a un TS de Voluntad, negando el efecto en caso de tener éxito.

| aminar sobre las aquas |
| |
| Transmutación [agua] |
| Nivel: Clr 3, Exp 3 |
| Componentes: V, S, FD |
| Tiempo de lanzamiento: 1 acción estándar |
| Alcance: toque |
| Objetivos: una criatura tocada/nivel |
| Duracion: 10 min/nivel (D) |
| Tiro de salvación: Voluntad niega (inofensivo) |
| Resistencia a conjuros: si (inotensivo) |

Las criaturas transmutadas podrán caminar sobre cualquier líquido como si se tratara de suelo firme. Barro, aceite, nieve, arenas movedizas, agua corriente, hielo e incluso lava podrán ser atravesados con facilidad, pues los pies de los receptores flotarán una o dos pulgadas por encima de la superficie (las criaturas que crucen sobre lava fundida seguirán sufriendo daño a consecuencia de su proximidad al calor). Las criaturas podrán caminar, correr, cargar o moverse como deseen por esa superficie igual que si fuera suelo normal. Si el sortilegio es lanzado bajo el agua (o mientras los receptores estén total o parcialmente sumergidos en cualquier otro líquido), los objetivos serán elevados hasta la superficie a una velocidad de 60' por asalto, hasta poder ponerse de pie sobre ella.

Campanas fúnebres

Nigromancia [maligno, muerte] Nivel: Clr 2, Muerte 2 Componentes: V, S

Tiempo de lanzamiento: 1 acción estándar Alcance: toque Objetivo: criatura viva tocada Duración: instantánea/10 minutos por DG de

la víctima; ver texto Tiro de salvación: Voluntad niega

Resistencia a conjuros: sí

Te permite extraer la escasa fuerza vital de una criatura herida de gravedad para alimentar tu propio poder. Al lanzar este coniuro, has de tocar a una criatura viva a la que le queden -1 puntos de golpe o una cifra inferior. Si la víctima falla su TS, morirá y tú obtendrás 1d8 puntos de golpe temporales y un +2 en tu puntuación de Fuerza. Además, tu nivel de lanzador efectivo se incrementará en +1, mejorando los efectos de tus sortilegios que dependan de dicho nivel (este incremento efectivo no te permitirá acceder a más conjuros). Estos efectos durarán 10 minutos por DG que posevera la criatura.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$hasta una criatura tocada/nivel$c$, duration = $c$1 h/nivel (D)$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'caminar por la sombra';
update spells set school = $c$Abjuración$c$, description = $c$Una barrera invisible te rodea y se mueve contigo. El espacio rodeado por la barrera está protegido contra la mayoría de efectos mágicos, incluyendo conjuros, aptitudes sortílegas y aptitudes sobrenaturales. Así mismo, la barrera impedirá el funcionamiento de todo conjuro u objeto mágico dentro de sus límites.

Un campo antimagia suprime todo conjuro o efecto mágico que se use en él, se lance hacia su interior o se ejecute en su área, pero no lo disipa. Una criatura acelerada, por ejemplo, no estará acelerada en el interior del campo, pero el conjuro volverá a funcionar en cuanto su receptor salga de él. No obstante, el tiempo que pase dentro del campo antimagia se tiene en cuenta al calcular la duración del conjuro suprimido.

Las criaturas de cualquier tipo que hayan sido convocadas, y los muertos vivientes incorporales desaparecen cuando entran en un campo antimagia, reapareciendo en el mismo punto una vez desaparezca el efecto del conjuro. El tiempo que pasen desaparecidos se tiene en cuenta de manera normal al calcular la duración de la conjuración que esté manteniendo a la criatura. Si lanzas campo antimagia en un área ocupada por una criatura conjurada que posea RC, tendrás que realizar una prueba de nivel de lanzador (1d20 + nivel de lanzador) contra la RC de la criatura para que ésta desaparezca (los efectos de conjuración instantánea, como crear agua, no resultan afectados por el campo antimagia porque la conjuración en sí ya ha dejado de surtir efecto, quedando solamente su resultado).

Una criatura normal (un grifo encontrado de manera normal en lugar de uno conjurado, por

ejemplo), puede entrar en el área, igual que los proyectiles normales. Es más, aunque una espada mágica no dispondrá de sus atributos especiales dentro del campo, seguirá siendo una espada (de hecho, una espada de gran calidad). El conjuro no surte efecto sobre los gólem y otros constructos a los que se haya infundido magia durante el proceso de creación y ahora sean autosuficientes (a no ser que hayan sido convocados, en cuyo caso serán tratados igual que el resto de esas criaturas). Los elementales, muertos vivientes corpóreos y los ajenos tampoco resultan afectados, siempre que no hayan sido convocado. Sin embargo, las aptitudes sortílegas y sobrenaturales de tales criaturas pueden ser anuladas temporalmente por el campo. Disipar magia no anulará el campo. Dos o más campos antimagia que compartan algo de espacio no se afectarán mutuamente. Ciertos conjuros, como muro de fuerza, esfera prismática y muro prismático, tampoco resultan afectados por el conjuro (consulta sus correspondientes descripciones). Los artefactos y deidades no resultan afectados por la magia mortal de este tipo (consulta la Guía del Dungeon Master para más información sobre los artefactos).

Si una criatura es mayor que el área encerrada por la barrera, las partes de su cuerpo que queden fuera de ella no resultarán afectadas por el campo.

Componente material arcano: una pizca de hierro pulverizado o limaduras de hierro.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$10'$c$, target = $c$emanación de 10' de radio, centrada en ti$c$, duration = $c$10 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'campo antimagia';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, description = $c$Este conjuro causa que los que están dentro del área se enfrenten entre ellos en lugar de atacar a sus enemigos. Cada criatura afectada tiene una probabilidad del 50% de atacar al blanco más cercano cada asalto (tira para determinar el comportamiento de cada criatura todos los asaltos al comienzo de su turno). Una criatura que no ataque a su vecino más próximo es libre de actuar normalmente durante ese asalto.

Las criaturas forzadas a atacar a sus compañeros por una canción de discordía emplean todos los métodos que tienen a su disposición, eligiendo los conjuros más mortíferos y las tácticas de combate más ventajosas. Sin embargo, no dañarán a los blancos que han caído inconscientes.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$criaturas en una expansión de 20' de$c$, duration = $c$1 asalto/nivel$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'cancion de discordia';
update spells set school = $c$Abjuración$c$, descriptors = $c$caótico$c$, description = $c$Una pauta de color aleatorio rodeará a los receptores, protegiéndolos contra los ataques, concediéndoles resistencia contra los conjuros lanzados por oponentes legales y confundiendo a las criaturas legales que los golpeen. Esta abjuración posee cuatro efectos:

El primero es que las criaturas custodiadas (es decir, protegidas por el conjuro) obtienen un bonificador +4 de desvío a la CA y un bonificador +4 de resistencia en los TS. Al contrario que protección contra la ley, este beneficio se aplicará contra todos los ataques, no sólo contra los de criaturas legales.

El segundo es que las criaturas custodiadas obtendrán RC 25 contra conjuros legales y sortilegios lanzados por criaturas legales.

El tercero es que la abjuración bloquea la posesión y la influencia mental del mismo modo que protección contra la ley.

Por último, una criatura legal quedará confusa durante 1 asalto cuando alcance con un ataque de cuerpo a cuerpo a una criatura custodiada (una salvación de Voluntad niega este efecto, igual que sucede con el conjuro de confusión, pero la CD del tiro será la de la capa del caos).

Foco: un pequeño relicario que contenga una reliquia sagrada, como un fragmento de pergamino de un texto caótico. El relicario ha de costar 500 po como mínimo.$c$, components = $c$V, S, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$20'$c$, target = $c$una criatura/nivel en una explosión de 20' de radio, centrada en ti$c$, duration = $c$1 asalto/nivel (D) = plan$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'capa del caos';
update spells set school = $c$Abjuración$c$, description = $c$El conjuro de caparazón antivegetal crea una barrera, móvil e invisible, que protege a todo el que se encuentre en su interior de los ataques de las criaturas vegetales y las plantas animadas. Como sucede con muchos conjuros de abjuración, si el efecto es empujado contra criaturas a las que mantiene a rava, la barrera sufrirá tensiones y se vendrá abajo de inmediato (consulta 'Abjuración', pág. 172).$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$10'$c$, target = $c$emanación de 10' de radio, centrada en ti$c$, duration = $c$10 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'caparazon antivegetal';
update spells set description = $c$Con este conjuro creas un campo de energía, móvil semiesférico, que impide la entrada a muchas clases de criaturas vivas. El efecto mantiene a raya a aberraciones, animales, bestias mágicas, cienos, dragones, fatas, gigantes, humanoides, humanoides monstruosos, plantas y sabandijas; pero no a ajenos, constructos, elementales ni muertos vivientes. Consulta el Manual de monstruos para la descripción de los tipos de criaturas.

Este conjuro sólo puede utilizarse como defensa, no como ataque. Forzar una barrera de abjuración contra las criaturas a las que mantiene a raya colapsa la barrera (consulta 'Abjuración', pág. 172).

Castigo divino Evocación [bueno] Nivel: Bien 4 Componentes: V. S Tiempo de lanzamiento: 1 acción estándar Alcance: intermedio (100' + 10'/nivel) Área: explosión de 20' de radio Duración: instantánea (1 asalto); ver texto Tiro de salvación: Voluntad parcial; ver texto Resistencia a conjuros: sí

Este conjuro atrae hasta ti un poder divino con el que castigar a tus enemigos. Sólo las criaturas malignas y neutrales pueden ser dañadas por este sortilegio; las de alineamiento bueno no serán afectadas.

El conjuro inflige 1d8 puntos de daño por cada dos niveles de lanzador (máximo 5d8) a las criaturas malignas en el área (o 1d6 puntos de daño por nivel de lanzador, máximo 10d6, a los ajenos malignos), y las ciega durante 1 asalto. Tener éxito en un TS de Voluntad reduce el daño a la mitad y niega el efecto cegador.

El conjuro sólo inflige la mitad del daño a las criaturas que no son ni buenas ni malignas y no las deja ciegas. Además, éstas pueden volver a reducir a la mitad el daño (sufriendo la cuarta parte de lo que indique el resultado de los dados) si tienen éxito en una salvación de Voluntad.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 asalto$c$, spell_range = $c$10'$c$, target = $c$emanación de 10' de radio, centrada en ti$c$, duration = $c$10 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'cascaron antivida';
update spells set school = $c$Nigromancia$c$, description = $c$Para dejar al objetivo ciego o sordo, a tu elección.$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$una criatura viva$c$, duration = $c$permanente (D) 11 24 0 11 11 11 11 11 11 11$c$, saving_throw = $c$Fortaleza niega niega$c$, spell_resistance = $c$sí Llamas a los poderes de la destrucción de la vida$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'cequera/sordera';
update spells set school = $c$Abjuracion$c$, description = $c$Este conjuro cierra mágicamente el cofre, puerta o entrada sobre el que se lance. Podrás abrir con total libertad las cerraduras de tu creación sin que éstas resulten afectadas, pero si no fueras tú el que lo intenta, la puerta u objeto protegido con la cerradura arcana sólo se abrirá por la fuerza o lanzando con éxito un conjuro de disipar magia o apertura. Añade 10 a la CD normal de echar abajo la puerta o entrada afectada por este sortilegio. Ten en cuenta que un conjuro de apertura no elimina otro de cerradura arcana, sino que sólo lo suprime durante 10 minutos.

Componente material: oro en polvo por valor de 25 po.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estandar$c$, spell_range = $c$toque$c$, target = $c$el cofre, puerta o entrada que se toque; tamaño maximo 30' cuadrados/niv$c$, duration = $c$permanente$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'cerradura arcana';
update spells set description = $c$Creas una reluciente barrera esmeralda que bloquea completamente el viaje extradimensional. Las formas de movimiento impedidas por el ancla dimensional incluyen caminar por la sombra, desplazamiento de plano, etereidad, excursión etérea, intermitencia, laberinto, proyección astral, puerta dimensional, teleportar, umbral y demás aptitudes sortílegas o psiónicas parecidas. Mientras dure el conjuro no es posible ningún tipo de viaje extradimensional hacia el interior o el exterior del área.

Un cerradura dimensional no impide el movimiento de criaturas que ya estuvieran en forma etérea o astral al ejecutarse el conjuro, ni impedirá la percepción o formas de ataque extradimensionales (como la mirada del basilisco). Además, tampoco impedirá que las criaturas convocadas desaparezcan al finalizar sus respectivos conjuros de convocación.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$emanación de 20' de radio centrada en un punto concreto$c$, duration = $c$1 día/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'cerradura dimensional';
update spells set school = $c$Nigromancia$c$, descriptors = $c$muerte$c$, description = $c$Este conjuro extrae la fuerza vital a las criaturas vivas, matándolas instantáneamente.

El conjuro acaba con la vida de 1d4 DG de criaturas vivas por nivel de lanzador (con un máximo de 20d4). Las criaturas con menos DG serán las primeras afectadas; cuando haya víctimas con los mismos DG, las más cercanas al punto de origen de la explosión serán las primeras en sufrir el daño. Las criaturas con 9 DC o más ignorarán por completo los efectos del sortilegio y los DG que no basten para afectar a una criatura se perderán sin más.

Componente material: una perla negra pulverizada, con un valor mínimo de 500 po.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$varias criaturas vivas en una explosión de 40' de radio$c$, duration = $c$instantánea$c$, saving_throw = $c$Fortaleza niega sa per$c$, spell_resistance = $c$sí difendem pa$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'circulo de muerte';
update spells set school = $c$Conjuración$c$, subschool = $c$teletransporte$c$, components = $c$V, M$c$, casting_time = $c$10 minutos$c$, spell_range = $c$0'$c$, target = $c$círculo de hasta 5' de radio, que teleporta a quienes lo activan$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'circulo de teletransporte';
update spells set school = $c$Abjuración$c$, descriptors = $c$bueno$c$, description = $c$Todas las criaturas dentro del área obtienen los efectos de un conjuro de protección contra el mal, y ninguna criatura convocada no buena puede

entrar en esta zona. Debes superar la RC de una criatura para poder mantenerla a raya (como en la tercera función de protección contra el mal), aunque los bonificadores de resistencia y desvío y la protección frente al control mental se siguen aplicando independientemente de la RC del objetivo.

Este conjuro tiene una versión alternativa que puedes elegir en el momento del lanzamiento: un círculo mágico puede ejecutarse hacia dentro en lugar de hacia fuera. En este caso, el conjuro aprisiona a una criatura llamada de alineamiento no bueno (como las llamadas por los conjuros de ligadura menor de los planos, ligadura de los planos y ligadura mayor de los planos) durante un máximo de 24 horas por nivel del lanzador, suponiendo que seas tú el que lances el conjuro que llame a la criatura en el asalto siguiente al lanzamiento del círculo mágico. La criatura no puede cruzar los límites del círculo. Si esta fuese demasiado grande como para caber dentro del área del conjuro, el sortilegio funcionaría como un protección contra el mal normal, pero sólo para esa criatura.

Un círculo mágico deja mucho que desear como trampa. Si el círculo de polvo de plata que se crea durante el lanzamiento se rompe, el efecto acaba inmediatamente. La criatura atrapada no puede hacer nada que afecte al círculo, directa o indirectamente, pero otras criaturas sí pueden hacerlo. Si la criatura llamada tiene RC, puede poner a prueba la trampa una vez por día. Si fallas en superar su RC, la criatura quedará libre, destruyendo el círculo. Una criatura capaz de cualquier forma de viaje dimensional (caminar por la sombra, desplazamiento de plano, etereidad, intermitencia, proyección astral, puerta dimensional, teleportar, umbral y aptitudes similares) puede simplemente abandonar el círculo mediante cualquiera de estos medios. Puedes evitar la huída extradimensional de la criatura lanzando un conjuro de ancla dimensional, pero debes hacerlo antes de que la criatura actúe. Si tienes éxito, el efecto del ancla dura tanto como el círculo mágico. La criatura no puede alcanzarte a través del círculo mágico, pero sus ataques a distancia (armas a distancia, conjuros, aptitudes mágicas, etc.) si podrán. La criatura puede atacar a cualquier objetivo que esté dentro del alcance de sus ataques a distancia desde el círculo.

Puedes añadir un diagrama especial (una figura sin huecos que encierra la circunferencia, aumentada con varios símbolos mágicos) al círculo mágico para hacerlo más seguro. Dibujar el diagrama a mano lleva 10 minutos y requiere una prueba de Conocimiento de conjuros (CD 20). El DM realiza esta prueba en secreto. Si falla, el diagrama no tiene efecto. Si no tienes una prisa especial en completar la tarea, puedes elegir 10 (ver pág. 65) cuando dibujes el diagrama. Hacerlo así te seguiría costando 10 minutos completos. Si el tiempo no importa en absoluto, puedes dedicar 3 horas y 20 minutos a la tarea y elegir 20.

Un diagrama realizado con éxito te permite lanzar un conjuro de ancla dimensional en el círculo mágico durante el asalto anterior al lanzamiento de cualquier conjuro de convocación. El ancla inmoviliza a cualesquiera criaturas llamadas durante 24 horas por nivel de lanzador. Una criatura no puede utilizar su RC contra un círculo mágico preparado con un diagrama, y ninguna de sus aptitudes ni ataques pueden cruzar el diagrama. Si la criatura intenta una prueba de Carisma para liberarse de la trampa (consulta el conjuro de ligadura menor de los planos), la CD aumenta en 5. La criatura es liberada inmediatamente si algo altera el diagrama (incluso una brizna de paja que caiga sobre él). No obstante, la propia criatura no puede alterarlo ni directa ni indirectamente, como se ha señalado antes.

Este conjuro no puede acumularse con protección contra el mal, ni viceversa.

Componentes materiales arcanos: un poco de plata en polvo, con la cual trazas en el suelo un círculo de 3' de diámetro, en torno a la criatura que debe ser custodiada.$c$, components = $c$V, S, M/FD$c$, target = $c$emanación de 10' de radio desde la criatura tocada$c$, duration = $c$10 min/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$no; ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'circulo magico contra el mal';
update spells set school = $c$Adivinación$c$, subschool = $c$escudriñamiento$c$, description = $c$Este conjuro crea un sensor mágico invisible en un lugar específico, que te permite ver u oír (según escojas) prácticamente como si estuvieras allí. No necesitas línea de visión ni línea de efecto, pero el lugar debe ser conocido: un lugar que te resulte familiar o cuya situación sea evidente (como lo que haya tras una puerta, a la vuelta de una esquina o dentro de una arboleda). Una vez que hayas elegido el lugar, el sensor no se mueve, pero puedes apuntarlo en todas las direcciones para ver la zona como desees. A diferencia de otros conjuros de escudriñamiento, este sortilegio no permite la utilización de sentidos mejorados mágica o sobrenaturalmente. Si el lugar elegido ha sido oscurecido mediante magia, no verás nada en absoluto. Si se trata de oscuridad total natural, podrás ver en un radio de 10' en torno al centro del efecto del sortilegio. El conjuro sólo funciona en el plano de existencia en que te encuentres.

Foco arcano: un pequeño cuerno (para oír) o un ojo de cristal (para ver). O DO VAJU$c$, components = $c$V, S, F/FD$c$, casting_time = $c$10 minutos por el es$c$, spell_range = $c$largo (400' + 40'/nivel) + 40'/nivel$c$, target = $c$sensor mágico$c$, duration = $c$1 min/nivel (D) =$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'clariaudiencia/clarividencia';
update spells set school = $c$Nigromancia$c$, description = $c$Este conjuro crea un doble inerte de una criatura. Si el individuo original muere, su alma se trasladará hasta el clon, creando un sustituto de sí mismo (suponiendo que el alma sea libre y desee volver a la vida; consulta 'Devolver la vida a los muertos', en la pág. 171). Los restos físicos originales (si aún existen) se convertirán en materia inerte y no podrán ser devueltos a la vida. Si el original hubiera llegado a su límite de vida natural (y hubiera muerto por causas naturales), todo intento de clonación resultará fallido. Para crear un doble debes tener un fragmento de carne (no sirven los cabellos, uñas, escamas, etc.), tomado del cuerpo vivo original, con un volumen mínimo de 1 pulgada cúbica. La carne no necesita estar fresca, pero hay que evitar que se pudra (usando, por ejemplo, el conjuro apacible descanso). Una vez se haya lanzado el conjuro, el doble deberá desarrollarse en un laboratorio durante 2d4 meses.

Una vez esté completo, el clon albergará el alma del original en cuanto éste muera, o inmediatamente, si ya ha muerto. El clon es físicamente identico al original, y tiene su misma personalidad y recuerdos. En los demás aspectos, trata al clon como si el personaje original hubiese sido revivido de entre los muertos, incluyendo la pérdida de un nivel o 2 puntos de Constitución (si el personaje original era de 1." nivel). Si esto redujera su puntuación a 0, el conjuro fallaría. Si la criatura original perdió niveles desde que se le tomara la muestra de carne y murió con un nivel inferior al que correspondería al clon, este último tendrá el mismo nivel que el original en el momento de su muerte menos uno.

El conjuro sólo duplica el cuerpo y la mente del original, no su equipo.

Un doble puede desarrollarse mientras el original siga con vida o mientras no pueda disponerse del alma original, pero la criatura resultante no será más que un pedazo de carne inerte, carente de alma, que se pudrirá si no se hace nada para evitarlo.

Componentes materiales: el fragmento de carne y varios accesorios de laboratorio (con un coste de 1.000 po).

Foco: equipo especial de laboratorio (coste de 500 po).$c$, components = $c$V, S, M, F$c$, casting_time = $c$10 minutos$c$, spell_range = $c$0'$c$, target = $c$un clon$c$, duration = $c$instantanea$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'clonar';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, description = $c$Conjuras una robusta casa o refugio construidos de un material que sea común en el lugar en que lances el conjuro (piedra, madera o, en el peor de los casos, tepe). El suelo estará igualado, limpio y seco. El refugio parecerá una casa normal en todos los aspectos, con una puerta sólida, dos ventanas provistas de contraventanas y una pequeña chimenea.

El refugio no tendrá fuente alguna de calor o frío (aparte de sus cualidades normales de aislamiento). Por tanto, podrá calentarse igual que una vivienda normal y el calor extremo resultará perjudicial para sus ocupantes. Por lo demás, el refugio proporcionará una seguridad considerable, pues será tan fuerte como un edificio normal de piedra, sin importar de qué material esté hecho. La vivienda resistirá las llamas y el fuego como si fuera de piedra y no resultará afectada por los proyectiles normales (siempre que no hayan sido lanzados por gigantes o máquinas de asedio).

Las ventanas, contraventanas e incluso la chimenea están protegidas contra los intrusos: las dos primeras están provistas de cerraduras arcanas y la última tiene una rejilla de hierro en lo alto y un cañón estrecho. Además, las tres zonas citadas están protegidas por conjuros de alarma. Por último, un sirviente invisible es conjurado para que te sirva mientras dure el sortilegio.

El cobijo seguro contiene un tosco mobiliario: ocho literas, una mesa de caballete, ocho taburetes y un escritorio.

Componentes materiales: una lasca cuadrada de piedra, cal machacada, unos cuantos granos de sal, un poco de agua y varias astillas de madera. A esto hay que añadir los componentes del conjuro sirviente invisible (un cordel y una astilla de madera) si quiere incluirse este beneficio.

Foco: el foco del sortilegio de alarma (una campanilla y un finísimo alambre de plata), si quiere incluirse este beneficio$c$, components = $c$V, S, M, F; ver texto$c$, casting_time = $c$10 minutos$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$edificio de planta cuadrada (20' de lado)$c$, duration = $c$2 h/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'obijo seguro de leomund';
update spells set school = $c$Conjuración$c$, subschool = $c$convocación$c$, description = $c$Te permite esconder un cofre en el plano Etéreo durante un máximo de 60 días, pudiendo recuperarlo cuando desees. El cofre puede contener hasta 1 pie cúbico de material por nivel de lanzador (sin importar el tamaño real del cofre, que mide 3×2×2'). Si en el cofre hubiera criaturas vivas, el conjuro tendría un 75% de posíbilidades de fallar sin más. Cuando el cofre esté escondido, podrás recuperarlo con sólo concentrarte (una acción estándar) y éste aparecerá a tu lado.

El cofre debe ser muy caro, poseer una manufactura excepcional y haber sido construido

por maestros de la fabricación. Si está hecho principalmente de madera, ésta debe ser ébano, palisandro, sándalo, teca, etc., y todos los refuerzos en esquinas, accesorios, clavos, etc. deben ser de platino. Si está hecho de marfil, los accesorios metálicos deberán ser de oro. Si el cofre es de bronce, cobre o plata, sus accesorios deberán ser de plata o electro (un metal precioso). El coste de un cofre así nunca puede ser inferior a 5.000 po. Una vez construido, debes fabricar una réplica en miniatura (con los mismos materiales e idéntica en todos los detalles) que parezca una copia exacta (la réplica costará 50 po). Sólo puedes tener un par de cofres de este tipo a la vez (ni siquiera los conjuros de deseo te permitirán hacer excepciones). Los cofres en sí no son mágicos y pueden ser provistos de cerraduras, custodias, etc., igual que cualquier cofre normal.

Para esconder el cofre, debes ejecutar el sortilegio tocando tanto el original como la réplica. Después, el original irá a parar al plano Etéreo, siendo necesaria la réplica para recuperarlo. Transcurridos 60 días, cada día habrá un 5% acumulativo de que el cofre se pierda para siempre. Si su versión en miniatura se pierde o es destruida, no habrá forma de recuperar el cofre grande, ni siquiera mediante un deseo (aunque podría organizarse una expedición a otros planos para buscarlo).

Las criaturas vivas que haya en el cofre comerán, dormirán y envejecerán normalmente; además, morirán si se quedan sin comida, aire, agua o cualquier otro sustento que necesiten para sobrevivir.

Foco: el cofre y su réplica.$c$, components = $c$V, S, F$c$, casting_time = $c$10 minutos$c$, spell_range = $c$ver texto$c$, target = $c$un cofre y hasta 1 pie cúbico de bienes/nivel de lanzador$c$, duration = $c$60 días o hasta ser descargado$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'cofre secreto de leomund';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro concede un bonificador +1 de mejora a las tiradas de ataque y daño de un arma natural del receptor. El colmillo mágico puede afectar a un ataque de golpetazo, un puñetazo, mordisco o cualquier otra arma natural (el conjuro no hace que el daño de un impacto sin arma pase de no letal a letal).

Colmillo mágico puede ser hecho permanente con un conjuro de permanencia.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura viva tocada$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'colmillo magico';
update spells set school = $c$Nigromancia$c$, description = $c$Este conjuro te permite un cierto grado de control sobre una criatura muerta viviente. Asumiendo que el objetivo sea inteligente, percibe tus palabras y acciones del modo más favorable posible (considera su actitud como amistosa). No te atacará durante la duración del conjuro. Puedes intentar darle órdenes, pero deberás ganar una prueba enfrentada de Carisma para convencerle de que haga algo que no haría normalmente (no se permiten nuevos intentos). Un muerto viviente inteligente comandado nunca obedece una orden suicida o claramente dañina, pero puede ser convencido para de que vale la pena hacer algo muy peligroso (consulta hechizar persona).

Una criatura muerta viviente no inteligente (como un esqueleto o un zombi) no recibe TS contra este conjuro. Cuando controlas a una criatura sin mente, sólo puedes comunicarle órdenes simples, como "ven aquí", "ve allí", "lucha", "quédate quieto" y similares. Los muertos vivientes no inteligentes no se resisten a las órdenes suicidas o evidentemente dañinas.

Cualquier acto que realicéis tú o quienes aparentemente sean tus aliados, que amenace a la criatura comandada (sin importar su inteligencia) rompe el conjuro.

Tus órdenes no son telepáticas, por lo que la criatura muerta viviente debe ser capaz de oírte. Componentes materiales: un jirón de carne cruda y una astilla de hueso.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura muerta viviente$c$, duration = $c$1 día/nivel$c$, saving_throw = $c$Voluntad niega; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'comandar muertos vivientes';
update spells set description = $c$Este conjuro te permite un cierto grado de control sobre una o más criaturas tipo planta. Las criaturas afectadas pueden comprenderte, y perciben tus palabras y acciones del modo más favorable posible (considera su actitud como amistosa). No te atacarán durante la duración del conjuro. Puedes intentar darle órdenes a un receptor, pero deberás ganar una prueba enfrentada de Carisma para convencerle de que haga algo que no haría normalmente (no se permiten nuevos intentos). Una planta comandada nunca obedece una orden suicida o claramente dañina, pero puede ser convencida para de que vale la pena hacer algo muy peligroso (consulta hechizar persona).

Puedes afectar a un grupo de criaturas tipo planta cuyos DG o niveles combinados no excedan el doble de tu nivel.$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$hasta 2 DG/nivel de criaturas tipo
- planta; dos receptores cualesquiera no pueden distar más de 30'$c$, duration = $c$1 día/nivel$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'comandar plantas';
update spells set school = $c$Adivinación$c$, description = $c$Puedes comprender las palabras pronunciadas por criaturas o leer mensajes escritos que, de lo contrario, resultarían incomprensibles para ti. Sea como fuere, deberás estar en contacto con la criatura o escrito en cuestión. Ten en cuenta que la capacidad para leer un texto no tiene por qué implicar una mejor comprensión del mismo; sólo sirve para conocer su significado literal. Recuerda también que el conjuro te permitirá leer y entender un idioma desconocido, pero no hablarlo ni escribirlo.

El material escrito puede leerse a un ritmo de una página (250 palabras) por minuto. Un escrito mágico no puede leerse con este conjuro, sólo averiguarás que se trata de escritura mágica. No obstante, suele ser muy útil a la hora de descifrar mapas del tesoro. El sortilegio puede ser frustrado por ciertos efectos mágicos de custodia (como los conjuros de página secreta o escritura ilusoria). No sirve para descifrar códigos ni revelar mensajes ocultos en textos normales y corrientes.

Comprender lenguajes puede ser hecho permanente con un conjuro de permanencia.

Componentes materiales arcanos: una pizca de hollín y unos cuantos granos de sal.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$10 min/nivel$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'comprension idiomatica';
update spells set school = $c$Adivinación$c$, description = $c$Te permite ponerte en contacto con tu deidad (o sus agentes) y hacerle preguntas que puedan contestarse con un "sí" o un "no" (un clérigo que carezca de deidad concreta contactará con un dios de filosofía afín a la de su alineamiento).

Puedes realizar una pregunta por nivel de lanzador, y las respuestas que obtendrás serán correctas hasta donde sepa el dios en cuestión. Una respuesta posible es "Confuso", pues las criaturas poderosas de los planos Exteriores no tienen por qué ser necesariamente omniscientes. Cuando una respuesta de una sola palabra pudiera inducir a error o a algo que se oponga a los intereses de la deidad, el DM debería contestar con una frase corta (de 5 palabras como máximo) en su lugar.

Lo más que hará el conjuro será facilitar información que pueda ayudar al personaje en la toma de decisiones. Las entidades con las que se entre en contacto construirán sus respuestas pensando en sus propios intereses. El conjuro finalizará si pierdes el tiempo, discutes una respuesta, cambias de tema o haces alguna otra cosa.

Componentes materiales: agua bendita (o sacrílega) e incienso.

Coste en PX: 100 PX.

Comunión con la naturaleza Adivinación Nivel: Animal 5, Drd 5, Exp 4 Componentes: V, S Tiempo de lanzamiento: 10 minutos Alcance: personal Obietivo: tú Duración: instantánea

Este conjuro te hace uno con la naturaleza, lo que te permite compartir el conocimiento del territorio circundante. Averiguarás instantáneamente hasta tres hechos relacionados con las siguientes cuestiones: el suelo o el terreno, las plantas, los minerales, las masas de agua, las gentes, la población animal en general, la presencia de criaturas del bosque, la presencia de poderosas criaturas antinaturales o, incluso la situación general del entorno natural. Por ejemplo, podrías averiguar dónde hay poderosas criaturas muertas vivientes, en qué lugar se encuentran las principales fuentes de agua potable y la situación exacta de posibles edificios (que serán percibidos como puntos ciegos).

En entornos al aire libre, el conjuro funciona en un radio de una milla por nivel de lanzador. En lugares subterráneos naturales (cuevas, cavernas, etc.), el alcance está limitado a 100' por nivel de lanzador. El sortilegio no funcionará donde la naturaleza haya sido reemplazada por construcciones o poblaciones, como en los dungeons o en pueblos.$c$, components = $c$V, S, M, FD, PX$c$, casting_time = $c$10 minutos$c$, spell_range = $c$personal Obietivo: tú$c$, duration = $c$1 asalto/nivel$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'comunion';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Este conjuro hace que los objetivos queden confundidos, haciéndoles incapaces de decidir qué hacer de manera independiente. Al comienzo del turno de cada uno de ellos, tira en la siguiente tabla para ver qué hace el receptor ese asalto.

| d% | Comportamiento |
| | |
| 01-10 | Ataca al lanzador con armas cuerpo |
| | a cuerpo o a distancia (o se acerca al |
| | lanzador, si no le es posible atacarle) |
| 11-20 | Actúa de forma normal. |
| 21-50 | No hace nada más que balbucear de |
| | manera incoherente. |
| 51-70 | Huye del lanzador a su máxima |
| | velocidad posible. |
| 71-100 | Ataca a la criatura más próxima (en lo |
| | que a esto se refiere, un familiar se |
| | considera como parte de su amo). |

Un personaje confundido que no pueda llevar a cabo la acción indicada, solamente balbuceará de manera incoherente. Los atacantes no tienen ningún beneficio especial cuando ataquen a un personaje confuso; es más, los personajes confusos que sean atacados atacarán automáticamente a su atacante en su siguiente turno, si es que siguen confusos en ese momento. Ten en cuenta que un personaje confuso no realiza ataques de oportunidad contra ninguna criatura a la que no se esté dedicando a atacar (sea porque la ha atacado en su última acción, o porque ha sido atacado por ella).

Componente material arcano: tres cáscaras de nuez vacías.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$todas las criaturas en un radio de 15'.$c$, duration = $c$1 asalto/nivel$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'canfusion';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Este conjuro hace que una única criatura quede confusa durante 1 asalto. Consulta el conjuro confusión, más arriba, para determinar los efectos exactos sobre el objetivo.$c$, components = $c$V, S, FD$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura viva$c$, duration = $c$1 asalto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'confusion menor';
update spells set school = $c$Ilusion$c$, subschool = $c$sombra$c$, description = $c$Cono de frío crea un área de intenso frío que tiene su origen en tu mano y se extiende hacia delante en forma de cono. El sortilegio consume el calor que encuentra a su paso, infligiendo 1d6 puntos de daño por frío por nivel de lanzador (máx. 15d6).

Componente material arcano: un diminuto cono de vidrio o cristal.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estandar$c$, spell_range = $c$ver texto$c$, target = $c$ver texto$c$, duration = $c$ver texto$c$, saving_throw = $c$Voluntad descree (si se interactúa con el conjuro); varía; ver texto Resistencia a contiros si ver texto$c$, spell_resistance = $c$si$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'conjuracion sombria';
update spells set school = $c$Adivinación$c$, description = $c$Averiguas instantáneamente dónde se halla el norte con respecto a tu posición actual. El conjuro resulta eficaz en cualquier entorno en el que normalmente exista un "norte", pero podría no funcionar en lugares de otros planos. Sabrás dónde se balla el norte en el momento del lanzamiento, pero recuerda que podrías perderte en cuestión de segundos si no logras encontrar un punto de referencia externo que te ayude a orientarte.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$instantaneo$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'conocer la direccion';
update spells set school = $c$Evocación$c$, descriptors = $c$bueno$c$, description = $c$Este conjuro bendice un lugar con energía positiva. Todas las tiradas de Carisma que se lleven

a cabo para expulsar muertos vivientes en ese lugar obtendrán un bonificador +3 sagrado. Los muertos vivientes que entren en la zona sufrirán una perturbación menor que les impondrá un penalizador -1 sagrado en las tiradas de ataque, daño y en los tiros de salvación. Los muertos vivientes no pueden ser creados ni convocadas dentro de un terreno consagrado.

Si en la zona consagrada hay un altar, capilla u otra estructura permanente dedicada a tu deidad, panteón o poder superior con el que compartas alineamiento, los modificadores indicados se duplicarán (bonificador +6 sagrado a la expulsión, penalizador -2 sagrado a las tiradas de los muertos vivientes). Por otro lado, no podrás consagrar ningún lugar que incluya un objeto permanente de este tipo dedicado a un dios que no sea tu patrón.

Si la zona contiene un altar, capilla u otra estructura permanente dedicada a una deidad, panteón o poder superior que no sea tu patrón, el conjuro de consagrar maldice el área, cortando sus conexiones con el poder o deidad asociado. Esta funciona secundaria, si se usa, no proporciona los bonificadores y penalizadores relativos a los muertos vivientes dados más arriba.

Consagrar contrarresta y disipa el conjuro de profanar.

Componentes materiales: un vial de agua bendita y plata pulverizada, por valor de 25 po (unas 5 libras), que ha de espolvorearse en su totalidad por el área a consagrar.$c$, components = $c$V, S, M, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$emanación de 20' de radio$c$, duration = $c$2 h/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'consagrar';
update spells set school = $c$Adivinación$c$, description = $c$Te permite enviar tu mente a otro plano de existencia (un plano Elemental o algún plano aún más lejano) para recibir consejo o información de los poderes que viven en ellos (consulta la tabla adjunta para hallar las posibles consecuencias y resultados del intento). Los poderes responderán en un idioma que comprendas, pero suelen tomarse a mal este tipo de comunicación y contestarán de forma muy breve a tus preguntas (el DM contestará a todas ellas con "sí", "no", "quizá", "jamás", "irrelevante" o alguna otra respuesta de una sola palabra). Para poder realizar preguntas al ritmo de una por asalto, tendrás que concentrarte en mantener el conjuro (como acción estándar). El poder en cuestión contestará cada pregunta en el mismo asalto en el que se formule. Podrás hacer una pregunta por cada dos niveles de lanzador que poseas.

Ponerte en contacto con una mente más alejada de tu plano natal incrementa la posibilidad

de sufrir una reducción efectiva de Inteligencia y Carisma, pero llegar a lugares alejados también hará que el poder encontrado tenga más posibilidades de conocer la respuesta y de darte la más adecuada. Una vez llegues a los planos Exteriores, el poder o deidad con el que contactes será quien determine los efectos (los resultados aleatorios de la tabla podrán ser alterados por el DM, podrán depender de la personalidad del dios en cuestión, etc.).

En raras ocasiones, esta adivinación puede ser obstaculizada por la acción de ciertas fuerzas o deidades.$c$, components = $c$V$c$, casting_time = $c$10 minutos$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$concentración$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'contactar con otro plano';
update spells set school = $c$Evocación$c$, descriptors = $c$electricidad$c$, description = $c$Un ataque tuyo de toque en cuerpo a cuerpo con éxito infligirá 1d6 puntos de daño por electricidad por nivel de lanzador (máximo 5d6). Al transmitir la descarga, obtienes un bonificador +3 en la tirada de ataque si tu oponente viste armadura metálica (o está hecho de metal, o lleva encima muchas cosas metálicas, etc.).$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura u objeto tocado$c$, duration = $c$instantaneo$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'contacto electrizante';
update spells set school = $c$Transmutacion$c$, description = $c$Corroes el hierro y las aleaciones de hierro con tu toque. El objeto o aleación de hierro que toques se oxidará, picará y quedará inutilizado al instante, quedando prácticamente destruido. Si el objeto es tan grande que no cabe en un radio de 3 pies (como, por ejemplo, una gran puerta o un muro de hierro), un radio de 3 pies de su volumen sufrirá los efectos del conjuro y quedará destruido. Los objetos mágicos de metal son inmunes a este sortilegio.

En combate, puedes utilizar el toque herrumbroso si tienes éxito con un ataque de toque en cuerpo a cuerpo. Al ser utilizado de este modo, el sortilegio corroerá y destruirá instantáneamente 1 d6 puntos de CA obtenidos gracias a una armadura metálica (hasta la protección máxima concedida por la armadura). Por ejemplo, la protección de una armadura completa (CA +8) podría quedar reducida desde +7 a +2 (como máximo) dependiendo del resultado de la tirada.

Las armas que esté usando el oponente contra el que se dirija el conjuro serán más difíciles de agarrar, siendo necesario un ataque de toque en cuerpo a cuerpo contra la propia arma. Un arma metálica que sea alcanzada quedará destruida.

Nota: golpear el arma de un oponente provoca ataques de oportunidad; además, tendrás que ser tú el que toque el arma, y no ésta la que te alcance a ti.

Contra las criaturas de hierro, cada ataque con éxito del contacto herrumbroso inflige instantáneamente 3d6 puntos de daño, +1 punto adicional por nivel de lanzador (máx. +15). El conjuro durará 1 asalto por nivel y tendrás derecho a realizar un ataque de toque en cuerpo a cuerpo por asalto de combate.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$un objeto de hierro que no sea mágico (o el volumen del objeto en un radio de 3 pies del punto tocado) o una criatura de hierro$c$, duration = $c$ver texto$c$, saving_throw = $c$ninguno Resistencia a coniuros: no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'contacto herrumbroso';
update spells set school = $c$Nigromancia$c$, descriptors = $c$maligno$c$, description = $c$El receptor contrae una enfermedad elegida de la tabla siguiente, que le afectará inmediatamente (sin periodo de incubación). La CD indicada es para las salvaciones posteriores (utiliza la CD de salvación normal de contagio para el tiro de salvación inicial).

| Enfermedad | CD | Daño |
| | | |
| Ascua mental | 12 | 1d4 Int |
| Dolor carmesí | 15 | 1d6 Fue |
| Fiebre de la mugre | 12 | 1d3 Des y 1d3 Con |
| Fiebre hilarante | 16 | 1d6 Sab |
| Mal de ceguera | 16 | 1d4 Fuel |
| Muerte viscosa | 14 | 1d4 Con |
| Temblequeo | 13 | 1d8 Des |
| | | |

1 Cada vez que una víctima sufre 2 o más puntos de daño de Fuerza del mal de ceguera, debe realizar otra salvación de Fortaleza (utilizando la CD de la salvación de la enfermedad) para no quedar cegado de manera permanente. I all con

Consulta la Guía del Dungeon Master para encontrar información sobre cada una de estas enfermedades. 1 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 - 1 -$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura viva tocada$c$, duration = $c$instantaneo$c$, saving_throw = $c$Fortaleza niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'contagio';
update spells set school = $c$Evocación$c$, description = $c$Te permite llevar sobre tu persona otro conjuro que se lanzará nada más darse las condiciones

que hayas dictado en el momento de ejecutar la contingencia. Tanto el conjuro contingencia como el conjuro complementario deben ejecutarse a la vez. El tiempo de lanzamiento de 10 minutos es el mínimo que hará falta para lanzar ambos conjuros. Si el conjuro complementario tiene un tiempo de lanzamiento superior a los 10 minutos, tendrás que usarlo en lugar del tiempo mínimo de la contingencia.

El sortilegio a ejecutar por arte de la contingencia debe afectar a tu persona (caída de pluma, levitar, teleportar, volar, etc.) y debe ser de un nivel de conjuro no superior a un tercio de tu nivel de lanzador (redondeando a la baja; máx. 6.º nivel).

Las condiciones necesarias para la ejecución del sortilegio deben ser claras, aunque también podrán ser generales. Por ejemplo, una contingencia lanzada junto a una respiración acuática podría eiecutar instantáneamente su conjuro complementario en cuanto cayeras al agua u otro líquido similar (o fueras rodeado por él). Otra contingencia podría ejecutar una caída de pluma si cayeras desde una altura superior a 4 pies. Sea como fuere, la contingencia hará que su conjuro complementario surta efecto en cuanto se cumpla la condición (es decir, lo ejecutará instantaneamente). Ten en cuenta que unas condiciones complejas o enrevesadas pueden evitar que la combinación de conjuros (la contingencia más el complementario) surta efecto cuando más falta te haga. El sortilegio complementario sólo será ejecutado cuando se den las condiciones especificadas, sin importar el momento que más te convenga. פילו ביניות מידוח מוניים

Sólo puedes usar un conjuro de contingencia a la vez; si lanzas un segundo, el primero se disipará sin más (en caso de seguir activo).

Componentes materiales: los del conjuro complementario, además de mercurio y una pestaña de ogro hechicero, ki-rin u otra criatura parecida que utilice conjuros.

Foco: una estatuilla de ti mismo, hecha de colmillo de elefante y decorada con gemas (por un valor mínimo de 1.500 po). Debes llevar el foco para que la contingencia pueda funcionar.$c$, components = $c$V, S, M, F$c$, casting_time = $c$10 min como minimo; ver texto$c$, spell_range = $c$Personal Obietivo: tú$c$, duration = $c$1 día/nivel (D) o hasta ser descargado$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'contingencia';
update spells set school = $c$Ilusión$c$, subschool = $c$engaño$c$, description = $c$El contorno del receptor cambia y oscila, dando la sensación de estar borroso. Esta distorsión le concederá ocultación (20% de posibilidad de fallo).

Un conjuro de ver lo invisible no contrarrestará el efecto del contorno borroso, pero uno de visión verdadera sí lo hará.

Los oponentes que no vean al receptor ignorarán los efectos de este conjuro (aunque com-

![](_page_218_Picture_0.jpeg)

El receptor de un conjuro de contorno borroso.

batir contra un oponente al que no se ve impone sus propias penalizaciones; consulta la pág. 151).$c$, components = $c$V$c$, casting_time = $c$1 acción estandar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$1 min/nivel (D)$c$, saving_throw = $c$Voluntad niega (inofensivo) Resistencia a coniuros: si (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'contorno borroso';
update spells set school = $c$Transmutación$c$, description = $c$Te permite cambiar el clima a nivel local. Tardas 10 minutos en lanzar el conjuro y los efectos tardarán otros 10 minutos en manifestarse. Las condiciones climáticas naturales serán determinadas por el DM. Podrás generar unas condiciones apropiadas para el clima y la estación del lugar en que te halles.

Controlarás la tendencia general del clima, como por ejemplo, la dirección y la intensidad del viento. Sin embargo, no podrás controlar aplicaciones específicas, como el lugar que será alcanzado por un rayo o el camino que seguirá un tornado. Cuando elijas una condición climática concreta para que tenga lugar, ésta se dejará notar 10 minutos más tarde (el cambio será gradual, no repentino). El clima seguirá como lo

hayas dejado mientras dure el conjuro o hasta que uses una acción estándar para indicar unas nuevas condiciones atmosféricas (que también tardarán 10 minutos en manifestarse por completo). Las condiciones contradictorias no pueden sucederse directamente (la niebla no puede suceder directamente a un fuerte viento, por ejemplo).

| | Estación | Clima posible |
|--| | |
| | Primavera | Tornado, tormenta, aguanieve o<br>clima caluroso |
| | Verano | Lluvia torrencial, ola de calor o<br>granizada |
| | Otoño | Clima caluroso o frío, niebla o<br>aguanieve |
| | Invierno | Frío glacial, ventisca o deshielo |
| | Finales del | Vientos huracanados o |
| | invierno | primavera temprana (zonas<br>costeras) |
| | | |

Controlar el clima sirve tanto para crear fenómenos atmosféricos como para eliminarlos (sean naturales o de otro tipo).

Los druidas que ejecuten este sortilegio conseguirán el doble de duración y afectarán a un círculo de tres millas de radio.$c$, components = $c$V, S$c$, casting_time = $c$10 minutos; ver$c$, spell_range = $c$dos millas$c$, target = $c$círculo de dos millas de radio, centrado en ti; ver texto$c$, duration = $c$4d12 horas; ver texto$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'controlar el clima';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro hará que las aguas fluyan o refluyan dependiendo de la versión que elijas.

Refluir las aguas: este conjuro hace que el agua o un líquido similar retroceda, reduciendo su profundidad hasta en 2' por nivel de lanzador (hasta una profundidad mínima de 1"). El nivel del agua descenderá en una depresión cuadrangular con lados de 10' de longitud por nivel de lanzador. En aguas extremadamente grandes y profundas, como un océano, el conjuro creará un remolino que frenará a barcos y otras embarcaciones similares, poniéndolas en peligro e impidiendo que marchen mediante el desplazamiento normal mientras dure el conjuro. Cuando se ejecuta sobre elementales de agua y otras criaturas basadas en el agua, este conjuro funciona igual que uno de ralentizar (Voluntad niega). El sortilegio no surte efecto en ningún otro tipo de criatura.

Fluir las aguas: este conjuro hace subir el nivel del agua u otro líquido similar, del mismo modo que refluir las aguas lo hace bajar. Las embarcaciones elevadas de este modo caerán por los lados del efecto creado por el conjuro. Si en el área afectada por el conjuro hubiera orillas, una playa u otro tipo de tierra cercana, el agua podría derramarse sobre ella.

En ambas versiones existe la posibilidad de reducir a la mitad una de las dimensiones horizontales y duplicar la longitud de la otra. Componente material arcano: una gota de agua (para fluir las aguas) o un poco de polvo (para refluir las aguas).

| ontrolar los vientos |
| |
| Transmutación Aire |
| Nivel: Aire 5, Drd 5 |
| Componentes: V, S |
| Tiempo de lanzamiento: 1 acción estándar |
| Alcance: 40 pies/nivel |
| Area: cilindro de radio de 40'/nivel y 40' de |
| alto |
| Duracion: 10 min/nivel |
| Tiro de salvación: Fortaleza niega |
| Resistencia a conjuros: no |
| |

Te permite alterar la fuerza del viento a tu alrededor. Puedes hacer que el viento sople en una dirección o de una forma concreta, o que lo haga con mayor o menor fuerza. La nueva dirección y fuerza del viento persistirá hasta acabar el conjuro o decidas cambiar tu obra, lo que te obliga a concentrarte. Puedes crear un "ojo" de aire en calma de hasta 80' de diámetro centrado en el lugar que desees; también podrás generar un efecto en un área circular inferior a tu alcance total (por ejemplo, un tornado de 20' de diámetro, centrado a 100' de distancia).

Dirección del viento: puedes hacer que el viento sople en el área del conjuro según una de estas cuatro formas básicas.

- Una corriente que descienda hacia el centro del área y sople hacia fuera con igual fuerza en todas direcciones.
- Una corriente ascendente que sople hacia el centro desde los bordes, con igual fuerza
- desde todas direcciones, y elevándose antes de llegar al "ojo" central.
- Una corriente rotatoria que gire en torno al centro en un sentido o en el otro.
- Una ráfaga que cruce toda el área en una sola dirección, de un extremo al otro.

Fuerza del viento: por cada tres niveles de lanzador que poseas, podrás incrementar o reducir la fuerza del viento en un nivel de fuerza (los efectos de la fuerza del viento se describen con detalle en la Guía del Dungeon Master). Cada asalto, toda criatura azotada por el viento deberá realizar un tiro de salvación de Fortaleza o sufrir sus efectos.

Los vientos fuertes (21 millas/h o más) dificultarán la navegación.

Un viento severo (31 millas/h o más) causará daño a las embarcaciones y edificios pequeños.

Un vendaval (51 millas/h o más) impedirá volar a las criaturas voladoras, desarraigará los árboles pequeños, derribará los edificios hechos de madera ligera, arrancará techos y hará que los barcos peligren.

Los vientos de un huracán (75 millas/h o más) destruirán los edificios de madera, podrán desarraigar algunos árboles grandes y mandarán a pique a la mayoría de barcos.

Un tornado (175 millas/h o más) destruirá todos los edificios no fortificados y desarraigará muchos árboles grandes.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$largo (400' + 40'/nivel)$c$, target = $c$volumen de agua de 10/nivel × 10/ nivel × 2 / nivel (Mo)$c$, duration = $c$10 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'controlar las aquas';
update spells set school = $c$Nigromancia$c$, description = $c$Este conjuro te permite controlar las acciones de uno o más muertos vivientes durante un breve periodo de tiempo. Impartes las órdenes a las criaturas mediante la voz, y ellas te comprenden, sin importar qué lenguaje hables. Incluso si la comunicación oral es imposible (en el área de un conjuro de silencio, por ejemplo), los muertos vivientes controlados no te atacan. Al final del conjuro, los objetivos vuelven a su comportamiento normal. Las criaturas muertas vivientes inteligentes recuerdan que las has controlado Componentes materiales: un pequeño frag-

mento de hueso y un poco de carne cruda.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25 + 5'/2 niveles)$c$, target = $c$hasta 2 DG de muertos vivientes/nivel; dos receptores cualesquiera no pueden distar más de 30 pies$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'controlar muertos vivientes';
update spells set school = $c$Transmutacion$c$, description = $c$Este conjuro te permite controlar las acciones de una o más criaturas tipo planta durante un breve periodo de tiempo. Impartes las órdenes a las criaturas mediante la voz, y ellas te comprenden, sin importar qué lenguaje hables. Incluso si la comunicación oral es imposible (en el área de un conjuro de silencio, por ejemplo), las plantas controladas no te atacan. Al final del conjuro, los objetivos vuelven a su comportamiento normal.

Las órdenes suicidas o autodestructivas son simplemente ignoradas.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles) Objetívos: hasta 2 DG/nivel de criaturas tipo planta; dos receptores cualesquiera no pueden distar más de 30 pies$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'controlar plantas';
update spells set school = $c$Conjuración$c$, subschool = $c$convocación$c$, description = $c$Te permite hacer que un objeto inerte, venido prácticamente de cualquier parte, aparezca directamente en tu mano.

En primer lugar, debes poner tu marca arcana (pág. 260) en el objeto; tras hacer eso, debes ejecutar este sortilegio, que inscribirá el nombre del objeto, de forma mágica e invisible, en un zafiro con un valor mínimo de 1.000 po. A partir de ese momento podrás convocar el objeto con sólo pronunciar una palabra especial (elegida por ti al ejecutar el sortilegio) y aplastar la piedra preciosa. El objeto aparecerá instantáneamente en tu mano. Sólo tú podrás usar la gema de este modo.

Si el objeto obra en poder de otra criatura, el conjuro no funcionará, pero sabrás quién lo tiene y el lugar aproximado en el que estaba al convocarlo.

La inscripción de la gema podrá verse a simple vista. Sin embargo, sólo tú podrás comprenderla sin tener que recurrir al conjuro de leer magia.

El objeto podrá ser convocado desde otro plano, pero sólo si nadie ha tomado posesión de él.

Componente material: un zafiro que valga 1.000 po como mínimo.

| Convocar instrumento |
| |
| Conjuración (convocación) |
| Nivel: Brd 0 |
| Componentes: V, S |
| Tiempo de lanzamiento: 1 asalto |
| Alcance: 0 pies |
| Efecto: un instrumento musical portátil |
| convocado |
| Duración: 1 minuto/nivel (D) |
| Tiro de salvación: no |
| Resistencia a conjuros: no |
| |

Este conjuro convoca un instrumento musical portátil de tu elección. El instrumento aparece en tus manos o a tus pies, según prefieras, y es normal dentro de su tipo. Sólo aparece un instrumento por lanzamiento, y sólo sonará para ti. No puedes convocar un instrumento demasiado grande como para ser sostenido con ambas manos (como un arpa, un piano, un clavicémbalo, un cuerno alpino o un órgano de tubos).$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$ver texto$c$, target = $c$un objeto que pese 10 lb como máx., cuya dimensión más larga no exceda los 6.$c$, duration = $c$permanente hasta que sea$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'convocaciones instantaneas de drawmij';
update spells set school = $c$Conjuración$c$, subschool = $c$convocación$c$, description = $c$Este conjuro convoca a una criatura natural. Esta aparecerá en el lugar que designes y actuará inmediatamente, durante tu turno, atacando a tus oponentes al máximo de sus capacidades. Si puedes comunicarte con la criatura, podrás indicarle que no ataque, que ataque a enemigos concretos o que lleve a cabo otras acciones.

Un monstruo convocado no puede convocar ni conjurar de ningún otro modo a otras criaturas, ni puede utilizar ninguna aptitud de teleportación o viaje planario. Las criaturas no pueden ser convocadas a un entorno que no sea soportable para ellas. Por ejemplo, una marsopa sólo puede ser convocada en un entorno acuático.

El sortilegio conjura una de las criaturas de 1.5ª nivel que aparecen en la tabla Convocar aliado natural (en esta misma página). Tú eliges qué criatura convocar, y puedes cambiar esa elección cada vez que lanzas el conjuro. A menos que se indique otra cosa, todas las criaturas que aparecen en la tabla son neutrales.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 asalto$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura convocada$c$, duration = $c$1 asalto/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'convocar aliado natural i';
update spells set school = $c$Conjuración$c$, subschool = $c$convocación$c$, descriptors = $c$ver texto$c$, description = $c$Este conjuro convoca a una criatura extraplanaria (normalmente un ajeno, un elemental o una bestia mágica nativa de otro plano). Ésta aparecerá en el lugar que designes y actuará inmediatamente, durante tu turno, atacando a tus oponentes al máximo de sus capacidades. Si puedes comunicarte con la criatura, podrás indicarle que no ataque, que ataque a enemigos concretos o que lleve a cabo otras acciones. El sortilegio conjura una de las criaturas de la lista de 1.6º nivel según aparece en la tabla Convocar monstruo' adjunta. Tú eliges qué criatura convocar, y puedes cambiar esa elección cada vez que lanzas el conjuro. Puedes encontrar información sobre estas criaturas en el Manual de monstruos.

Un monstruo convocado no puede convocar ni conjurar de ningún otro modo a otras criaturas, ni puede utilizar ninguna aptitud de teleportación o viaje planario. Las criaturas no pueden ser convocadas a un entorno que no sea soportable para ellas. Por ejemplo, una marsopa celestial sólo puede ser convocada en un entorno acuático. Un conjuro de convocación utilizado para traer a criaturas de agua, aire, fuego, tierra, buenas, caóticas, legales o malignas se convierte en un sortilegio de ese tipo en cuestión. Por ejemplo, convocar monstruo I es un conjuro legal y maligno cuando se utiliza para convocar a una rata terrible infernal.

Foco arcano: una diminuta bolsa y una pequeña vela (que no tiene por qué encenderse).$c$, components = $c$V, S, F/FD$c$, casting_time = $c$1 asalto$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura convocada$c$, duration = $c$1 asalto/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'convocar monstruo i';
update spells set school = $c$Conjuración$c$, subschool = $c$convocación$c$, description = $c$Convocas a una plaga de arañas, murciélagos o ratas (a tu elección), que atacan a todas las demás criaturas dentro del área (puedes convocar a la plaga para que comparta el área con otras criaturas). Si no hay criaturas vivas dentro del área, la plaga persigue a la criatura más cercana lo mejor queda. El lanzador no tiene control sobre su objetivo o la dirección en que viaja.

Consulta el Manual de monstruos para los detalles sobre las plagas de arañas, murciélagos y ratas.

Componente material arcano: un retal cuadrado de tela roja.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 asalto$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una plaga de arañas, murciélagos o rata$c$, duration = $c$concentración + 2 asaltos$c$, saving_throw = $c$ninguno Resistencia a coniuros: no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'convocar plaga';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, description = $c$Te permite conjurar a una criatura équida Grande cuasirreal, que sólo podrá ser montada por ti o por aquella otra persona para la que hayas creado el corcel. Una montura fantasmal tiene negros el cuerpo y la cabeza, grises las crines y la cola, y de color humo las pezuñas, que son insustanciales y no hacen ruido alguno. El corcel llevará también lo que parece ser una silla, un bocado y una brida. Aunque no combatirá, todos los animales normales se apartarán de él y se negarán a atacarlo.

El corcel tiene una Clase de Armadura de 18 (-1 de tamaño, +4 de armadura natural, +5 de Des) y 7 puntos de golpe +1 punto adicional por nivel de lanzador. Si pierde todos sus puntos de golpe, el corcel fantasmal desaparecerá. Esta criatura tiene una velocidad de 20 por nivel de lanzador (hasta un máximo de 240 pies) y puede transportar el peso de su jinete, más un máximo de 10 libras adicionales por nivel de lanzador.

Las monturas de este tipo adquieren ciertos poderes dependiendo del nivel de lanzador del conjuro. Entre estas aptitudes se incluyen también las poseídas por monturas con un nivel de lanzador inferior. Por tanto, un corcel creado por un lanzador de nivel 12.º tendrá las aptitudes correspondientes a los niveles de lanzador 8.º, 10.º y 12.º.

8.º nivel: la montura podrá cabalgar sobre terreno arenoso, embarrado e incluso pantanoso, sin que suponga ninguna reducción de su velocidad. 10.º nivel: la montura podrá utilizar caminar so-

bre las aguas a voluntad (como el conjuro, no se requiere ninguna acción para activar esta aptitud). 12.º nivel: la montura podrá utilizar caminar por el aire a voluntad (como el conjuro, no se requiere ninguna acción para activar esta aptitud) durante 1 asalto cada vez, después del cual cae al suelo de nuevo.

14.º nivel: la montura podrá volar a su velocidad normal (maniobrabilidad regular).$c$, components = $c$V, S$c$, casting_time = $c$10 minutos$c$, spell_range = $c$0 pies$c$, target = $c$una criatura équida cuasirreal$c$, duration = $c$1 h/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'corcel fantasmal';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, description = $c$Este conjuro funciona como creación menor, salvo en que también puedes crear un objeto de naturaleza mineral: piedra, cristal, metal, etc. La duración del objeto creado varía dependiendo de su dureza y su rareza relativas, tal y como se indica en la siguiente tabla: momo lo una

| Ejemplos de | |
| | |
| dureza y rareza | Duración |
| Material vegetal | 2 h/nivel |
| Piedra, cristal, metales básicos | 1 h/nivel |
| Metales preciosos | 20 min/nivel |
| Gemas | 10 min/nivel |
| Metal raro* | 1 asalto/nivel |
| * Incluye adamantina, plata alquímica y mithril | |

No puedes utilizar creación mayor para crear un objeto de hierro frío. Consulta la Guía del Dungeon Master para los detalles.$c$, casting_time = $c$10 minutos$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, duration = $c$ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'creacion mayor';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, description = $c$Te permite crear un objeto desatendido, no mágico y hecho de materia vegetal inerte: ropa de lino, una

cuerda de cáñamo, una escalera de mano hecha de madera, etc. El volumen del objeto creado no puede exceder 1 pie cúbico por nivel de lanzador. Necesitarás tener éxito en una prueba de la habilidad apropiada para conseguir crear un objeto complejo, como una prueba de Artesanía (fabricación de arcos) para conseguir astiles de flecha rectos. El conjuro fracasará si intentas utilizar un objeto ya fabricado como componente material. Componente material: un diminuto fragmento del mismo material que el objeto que desees fabricar con la creación menor, por ejemplo, un poco de cáñamo para hacer una cuerda.$c$, components = $c$V, S, M$c$, casting_time = $c$1 minuto$c$, spell_range = $c$0 pies$c$, target = $c$un objeto desatendido, no mágico y hecho de materia vegetal inerte, de hasta 1 pie cúbico/nivel$c$, duration = $c$1 h/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'creacion menor';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, descriptors = $c$agua$c$, description = $c$Este conjuro crea agua, potable y en perfectas condiciones, igual al agua de lluvia limpia. El agua puede ser creada en un área lo bastante pequeña como para contener el líquido en cuestión, o bien en un área tres veces mayor (posiblemente creando un aguacero o llenando numerosos recipientes pequeños).

Nota: las conjuraciones no permiten crear sustancias u objetos dentro de una criatura. El agua pesa, más o menos, 8 libras por galón. Un pie cúbico de agua contiene aproximadamente 8 galones y pesa en torno a 60 lb.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25 + 5'/2 niveles)$c$, target = $c$hasta 2 galones de agua/nivel$c$, duration = $c$instantaneo$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'crear aqua';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, description = $c$La sencilla comida creada por este conjuro será del tipo que elijas (muy nutritiva, pero un poco sosa). Los alimentos así creados se pudrirán y se volverán incomestibles al cabo de 24 horas, aunque podrán mantenerse frescos durante otras 24 horas si se les lanza un conjuro de purificar comida y agua. El líquido creado por este conjuro será igual que agua de lluvia limpia, y no se pudrirá como la comida.$c$, components = $c$V, S$c$, casting_time = $c$10 minutos$c$, spell_range = $c$corto (25' + 5'/2 niveles) ===$c$, target = $c$comida y agua para dar sustento durante 24 horas a tres humanos o un caballo/nivel$c$, duration = $c$24 horas; ver texto$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'crear comida y aqua';
update spells set school = $c$Nigromancia$c$, descriptors = $c$maligno$c$, description = $c$Este conjuro, mucho más potente que reanimar a los muertos, te permite crear muertos vivientes más poderosos: necrarios, necrófagos, momias y mohrgs (consulta el Manual de monstruos para más información sobre todos los tipos de muertos vivientes). El tipo o tipos de muertos vivientes que puedes crear depende de tu nivel de lanzador, tal y como se muestra en la siguiente tabla:

| Nivel de lanzador | Muerto viviente creado | |
| | |--|
| 11.º o menos | Necrófago | |
| 12°-14° | Necrario | |
| 15 - 17.º | Momia | |
| 18.º o superior | Mohrg | |
| | | |

Si quieres, puedes crear muertos vivientes de tipo inferior al que indique tu nivel. Por ejemplo, a 16.º nivel puedes decidir crear un necrófago o un necrario en lugar de una momia. De hecho, esto puede ser buena idea, pues los muertos vivientes recién creados no están directamente bajo el control de quien los haya reanimado. Si eres capaz de comandar muertos vivientes, puedes intentar comandar a las criaturas mientras se estén formando (consulta 'Expulsar y reprender muertos vivientes', en la pág. 156). Este sortilegio debe ser ejecutado de noche. Componentes materiales: un tarro de arcilla lleno de tierra de cementerio y otro más lleno de

agua salobre. El conjuro debe lanzarse sobre un cadáver. Debes colocar un ónice negro (con un valor mínimo de 50 po por DG del muerto viviente que vayas a crear) en la boca o una de las cuencas oculares de cada cadáver. La magia del conjuro transformará estas gemas en cáscaras fundidas y sin valor.

rear muertos vivientes mayores Nigromancia [maligno] Nivel: Clr 8, Hch/Mag 8, Muerte 8

Este conjuro funciona como crear muertos vivientes, pero te permite crear criaturas más poderosas e inteligentes: sombras, incorpóreos, espectros y devoradores (consulta el Manual de monstruos para más información sobre todos los tipos de muertos vivientes). El tipo o tipos de muerto viviente que puedes crear depende de tu nivel de lanzador, tal y como se indica en la siguiente tabla:

| Nivel de lanzador | Muerto viviente creado | |
| | |--|
| 15.º o menos | Sombra | |
| 16 .- 17.º | Incorpóreo | |
| 18°-19° | Espectro | |
| 20.º o superior | Devorador | |$c$, components = $c$V, S, M$c$, casting_time = $c$1 hora$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$un cadáver$c$, duration = $c$instantáneo$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'crear muertos vivientes';
update spells set school = $c$Transmutación$c$, description = $c$Los animales objetivo crecen hasta alcanzar el doble de su tamaño normal, y su peso se multiplica por ocho. Esta alteración cambia la categoría de tamaño de cada animal hasta la siguiente mayor (de Grande a Enorme, por ejemplo), le proporciona un bonificador +8 de tamaño a la Fuerza y un bonificador +4 de tamaño a la Constitución (y por lo tanto 2 puntos de golpe adicionales por DG), y le impone un penalizador -2 de tamaño a Destreza. El bonificador de armadura natural que tuviese aumenta en 2. El cambio de tamaño del animal también afecta a su modificador a la CA y las tiradas de ataque, y a su daño base, tal y como se detalla en la tabla 2-2 de la Guía del Dungeon Master. El espacio y alcance del animal cambian tal y como se indica en la tabla 8-4: tamaño y escala de las criaturas (pag. 149), pero su velocidad no cambia.

El conjuro también proporciona a cada receptor reducción del daño 10/magia y un bonificador +4 de resistencia a los tiros de salvación. Si no hay espacio suficiente para el tamaño deseado, la criatura alcanza el máximo tamaño posible y debe realizar una prueba de Fuerza (utilizando su Fuerza aumentada) para hacer estallar cualquier elemento que la encierre durante el proceso. Si falla, queda encerrada sin daño para el material que la rodea (no es posible utilizar el conjuro para aplastar a una criatura aumentando su tamaño).

Todo equipo que el animal lleve puesto o transporte es agrandado de forma proporcional por el conjuro, aunque este cambio no afectará a las propiedades mágicas de este equipo. Todo objeto agrandado que deje de estar en posesión de la criatura agrandada volverá instantáneamente a su tamaño normal.

El conjuro no te concede ningún método especial para comandar a los animales agrandados o influir en ellos.

Varios efectos mágicos que aumenten el tamaño no se apilan; lo cual quiere decir (entre otras cosas) que no puedes utilizar un segundo lanzamiento de este conjuro para aumentar aún más el tamaño de un animal que ya esté bajo el efecto del primer lanzamiento. I en man$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$hasta un animal (Gargantuesco o menor) cada dos niveles; dos receptores cualesquiera no pueden distar más de 30 pies$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Fortaleza niega$c$, spell_resistance = $c$sí manus$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'crecimiento animal';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro posee efectos diferentes dependiendo de la versión elegida:

Enriquecimiento: este efecto del conjuro se centra en todas las plantas en media milla a la redonda, incrementando en un tercio su potencial de productividad durante el siguiente año. En muchas comunidades granjeras, los clérigos o los druidas lanzan este conjuro durante la siembra, como parte de las celebraciones de la primavera.

Espesura: este efecto hace que la vegetación normal (hierba, brezos, arbustos, plantas rastreras, cardos, árboles, enredaderas, etc.) en un alcance largo (400' + 40'/nivel de lanzador) se vuelva más tupida. Las plantas se enmarañarán formando una espesura o jungla que las criaturas deberán cortar o apartar para poder pasar. La velocidad de quienes atraviesen la zona se verá reducida a 5' o a 10 si se trata de criaturas Grandes o mayores (el DM puede aceptar que las criaturas muy pequeñas o muy grandes se muevan más deprisa). Para que el conjuro surta efecto, el área afectada debe tener árboles y arbustos.

Según prefieras, el área afectada puede ser un círculo de 100' de radio, un semicírculo con un radio de 150'o un cuarto de círculo con un radio de 200'. También puedes hacer que ciertas zonas del área elegida no resulten afectadas. Crecimiento vegetal contrarresta el conjuro de reducir plantas.

Este conjuro no tiene efecto sobre las criaturas tipo planta. Este$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar .$c$, spell_range = $c$ver texto Objetivo o á$c$, target = $c$ver texto en 11 1 - 12:4$c$, duration = $c$instantáneo$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no la mandera$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'crecimiento vegetal';
update spells set school = $c$Evocación$c$, descriptors = $c$fuerza$c$, description = $c$Creas en torno a ti una esfera inmóvil, opaca y del color que desees. Uno de sus hemisferios sobresaldrá por encima del suelo y la mitad inferior quedará bajo tierra. Además de ti, dentro del campo cabrán como máximo otras nueve criaturas Medianas, que podrán entrar y salír libremente del cubículo sin causarle daño alguno. No obstante, el conjuro finalizaría si eres tú el que sale del cubículo.

La temperatura dentro del cubículo será de 70° F [20° C] cuando la temperatura exterior esté entre 0° F [-18° C] y 100° F [37° C]. Una temperatura exterior por debajo de los 0° F o por encima de los 100° F elevará o reducirá la temperatura interior en una proporción de 1:1 (por tanto, una temperatura exterior de -20° F [-30° C] reduciría la interior a 50° F [10° C]). Además, el cubículo protege contra los elementos, como la lluvia, el polvo o las tormentas de arena, y resiste cualquier viento con fuerza menor a la de los vientos de un huracán, aunque uno de esta intensidad o mayor (≥ millas/h) lo destruiría. El interior del cubículo es un hemisferio, y podrás iluminarlo tenuemente con sólo dar una orden, o apagar la luz cuando desees. Nótese que aunque el campo de fuerza sea opaco visto desde fuera, es transparente para quienes están dentro de él. Los proyectiles, armas y la mayoría de efectos de conjuro atravesarán el cubículo sin afectarlo, aunque sus ocupantes no podrán ser vistos desde fuera (dispondrán de ocultación total).

Componente material: una pequeña cuenta de cristal que estallará en cuanto expire la duración del conjuro o éste sea disipado.$c$, components = $c$V, S, M. goda al enlas$c$, casting_time = $c$1 acción estándar March Cashma$c$, spell_range = $c$20'$c$, target = $c$esfera de 20' de radio, centrada donde - estés mind b$c$, duration = $c$2 h/nivel (D) ======================================================================================================================================================$c$, saving_throw = $c$ninguno consiliado de la$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'cubiculo de leomund';
update spells set school = $c$Transmutación$c$, descriptors = $c$dependiente del idioma$c$, description = $c$Puedes cuchichear mensajes y recibir respuestas cuchicheadas con escasas posibilidades de que alguien pueda oírlas. Para ello, debes señalar con el dedo a todas las criaturas a las que desees incluir en el efecto del conjuro. Cuando cuchichees el mensaje, éste podrá ser oído por todos los receptores que se encuentren dentro del alcance. El silencio mágico, la piedra de 1' de espesor, el metal común de 1" de grosor, una placa delgada de plomo o 3' de madera o tierra, bastarán para bloquear el conjuro. Sin embargo, el mensaje no tendrá por qué desplazarse en línea recta, pudiendo rodear las barreras mientras haya espacio libre entre el receptor y tú y todo el camino que recorra se encuentre dentro del alcance del conjuro. Las criaturas que oigan el mensaje podrán cuchichear una respuesta que será escuchada por ti. El conjuro transmite sonidos, no significados, y no puede superar las barreras idiomáticas.

Nota: para comunicar un mensaje, tendrás que pronunciar sus palabras y cuchichear, por lo que un pícaro entrenado tendría oportunidad de leerte los labios.

Foco: un pequeño fragmento de hilo de cobre.

| uerpo férreo | |
| |--|
| Transmutación | |
| Nivel: Hcr/Mag 8, Tierra 8 | |
| Componentes: V, S, M/FD | |
| Tiempo de lanzamiento: 1 acción estándar | |
| Alcance: personal | |
| Objetivo: tú | |
| Duración: 1 min/nivel (D) | |

Este conjuro transforma tu cuerpo en hierro vivo, lo cual te concede poderosas resistencias y aptitudes.

Obtienes una reducción del daño de 15/adamantina. Te vuelves inmune a la asfixia, el atur-

dimiento, la ceguera, el daño a las puntuaciones de característica, la electricidad, la enfermedad, los golpes críticos, la sordera, el veneno y todos los conjuros o ataques que afecten a tu fisiología o respiración, ya que mientras el conjuro esté surtiendo efecto no tendrás ni la una ni la otra. Sólo sufrirás la mitad del daño infligido por el ácido y cualquier tipo de fuego. Sin embargo, también te volverás vulnerable a todos los ataques especiales que puedan afectar a los gólems de hierro.

Ganas un bonificador +6 de mejora en tu puntuación de Fuerza, pero también sufres un penalizador -6 a la Destreza (hasta una puntuación mínima de 1 en esa característica) y tu velocidad quedará reducida a la mitad de la normal. También tendrás un 50% de fallo de conjuro arcano y un penalizador -8 de armadura, igual que si fueras embutido en una armadura completa. Además, no podrás beber (lo cual te impedirá usar pociones) ni tocar instrumentos de viento. Tus ataques sin arma infligirán un daño igual al de una clava del tamaño que sea apropiado para ti (1d4 para personajes Pequeños o 1d6 para personajes Medianos), y se considerará que estás armado aun cuando efectúes ataques sin arma.

Tu peso se multiplica por diez, lo cual hará que te hundas en el agua igual que una piedra. Sin embargo, podrás sobrevivir a la tremenda presión y falta de aire del fondo del océano (al menos, hasta que expire el conjuro).

Componente material arcano: un pequeño fragmento de hierro que en su día formara parte de un gólem de hierro, la armadura de un héroe o una máquina de guerra.$c$, components = $c$V, S, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$una criatura/nivel$c$, duration = $c$10 min/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'cuchichear mensaje';
update spells set school = $c$Conjuración$c$, subschool = $c$curación$c$, description = $c$Canalizas energía positiva para curar 1d8 puntos de daño +1 punto por nivel de lanzador (máximo +25) à cada criatura seleccionada.

Como otros conjuros de curar, curar heridas ligeras en grupo inflige daño a los muertos vivientes en su área de efecto, en lugar de curarles. Cada muerto viviente afectado puede intentar una salvación de Voluntad para medio daño. Ho$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura/nivel; dos receptores cualesquiera no pueden distar más de 30 nies$c$, duration = $c$instantáneo$c$, spell_resistance = $c$sí (inofensivo) o sí; ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'curar heridas leves en grupo';
update spells set school = $c$Nigromancia$c$, description = $c$El receptor se vuelve inmune a todos los conjuros de muerte, efectos de muerte mágica, consunción de energía y cualquier efecto de energía negativa (como los de los conjuros de infligir y de toque gélido).

Este conjuro no quita niveles negativos que el objetivo ya haya adquirido, ni afecta al tiro de salvación necesario 24 horas después de adquirir un nivel negativo.

Custodia contra la muerte no ofrece protección contra ataques de otro tipo, como la pérdida de puntos de golpe, el veneno, la petrificación y demás efectos que puedan resultar mortales.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura viva tocada$c$, duration = $c$10 min/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'custodia contra la muerte';
update spells set school = $c$Nigromancia$c$, description = $c$Este conjuro carga al receptor con energía negativa, que inflige 10 puntos de daño por nivel de lanzador (hasta un máximo de 150 puntos a 15.º nivel). Si la criatura tiene éxito en su salvación, dañar causa la mitad de esta cantidad. En ninguno de los dos casos puede reducir los puntos de golpe del objetivo por debajo de 1. Cuando se utiliza sobre muertos vivientes, el conjuro de dañar funciona igual que uno de sanar.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque Obietivo: criatura tocada$c$, duration = $c$instantánea$c$, saving_throw = $c$Voluntad mitad; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'danar';
update spells set school = $c$Transmutación$c$, description = $c$El receptor, junto con todas las posesiones que lleve encima, queda convertido en una estatua inerte y sin mente. Si la estatua creada por este conjuro se rompe o resulta dañada, la criatura sufrirá un daño o deformidad similar en caso de volver a su estado normal. La víctima no estará muerta pero tampoco parecerá estar viva (al ser examinada, por ejemplo, con un conjuro de reloj de la muerte). Sólo las criaturas de carne pueden ser afectadas con este conjuro. Componente material: cal, agua y tierra.

De la piedra a la carne Transmutación

Nivel: Hcr/Mag 6

Componentes: V, S, M

Tiempo de lanzamiento: 1 acción estándar

Alcance: intermedio (100' + 10'/nivel)

Objetivo: una criatura petrificada o un

cilindro de piedra de entre 1 y 3' de

diámetro y hasta 10' de largo

Duración: instantánea

Tiro de salvación: Fortaleza niega (objeto); ver texto

Resistencia a conjuros: sí

Este conjuro permite que una criatura petrificada vuelva a su estado normal, recuperando la vida y todo el equipo que llevara. La criatura ha de tener éxito en un tiro de salvación de Fortaleza (CD 15) para sobrevivir al proceso. Cualquier criatura petrificada podrá ser devuelta a su estado normal, sin importar cuál sea su tamaño.

Este conjuro también puede transformar una masa de piedra en una sustancia carnosa. Esta sustancia estará inerte y carente de vida, a no ser que hubiera disponible fuerza vital o energía mágica (por ejemplo, este conjuro podría transformar a un gólem de piedra en uno de carne, pero una estatua de piedra normal y corriente se transformaría en un cadáver). Podrás afectar a un objeto que quepa dentro de un cilindro de entre 1 y 3' de diámetro y hasta 10' de largo, o bien a un cilindro de esas dimensio-

nes dentro de una masa de piedra mayor.

Componentes materiales: un poco de tierra y una gota de sangre.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$una criatura$c$, duration = $c$instantáneo$c$, saving_throw = $c$Fortaleza niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'de la carne a la piedra';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Sus puntuaciones de Inteligencia y Carisma quedan reducidas a 1, lo cual corresponde, más o menos, al intelecto de un lagarto. La criatura afectada será incapaz de lanzar conjuros, usar habilidades basadas en la Inteligencia o el Carisma o comunicarse de manera coherente. Aun así, el receptor sabrá quiénes son sus amigos y podrá seguirlos e incluso protegerlos. La víctima continuará en ese estado hasta que se lance sobre ella un conjuro de deseo, deseo limitado, milagro o sanar que cancele los efectos. Las criaturas capaces de lanzar conjuros arcanos (como los hechiceros y magos) sufrirán un penalizador -4 en sus tiros de salvación.

Componente material: un puñado de esferas de arcilla, vidrio, cristal o mineral.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$una criatura$c$, duration = $c$instantánea$c$, saving_throw = $c$Voluntad niega; ver texto$c$, spell_resistance = $c$sí Si la criatura objetivo falla un TS de Voluntad,$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'debilidad mental';
update spells set school = $c$Nigromancia$c$, descriptors = $c$muerte$c$, description = $c$Puedes matar a una criatura viva cualquiera que se encuentre dentro del alcance. El receptor tendrá derecho a un TS de Reflejos para sobrevivir al ataque. Si la salvación tiene éxito, solamente sufrirá 3d6 puntos de daño +1 punto adicional por nivel de lanzador que poseas (máx. +25). La víctima puede morir a consecuencia del daño sufrido incluso aunque haya tenido éxito en su tiro de salvación.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura viva$c$, duration = $c$instantanea$c$, saving_throw = $c$Fortaleza parcial$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'dedo de la muerte';
update spells set school = $c$Transmutación$c$, description = $c$Puedes doblar y deformar la madera, destruyendo de forma permanente su forma, fuerza y corte recto. Una puerta deformada se abre (o se queda atrancada, siendo necesaria una prueba de Fuerza para abrirla, según elijas); en un bote o barco se abrirá una vía de agua; un arma a distancia deformada quedará inútil; y un arma de cuerpo a cuerpo deformada sufrirá un penalizador -4 en las tiradas de ataque.

Puedes deformar un objeto Pequeño o menor (como la rueda de un carromato o la ballesta de un humano) o su equivalente por nivel de lanzador. Un objeto Mediano (como un remo o una lanza humana) cuenta como dos objetos Pequeños; un objeto Grande (como un bote de remos o la clava de un gigante de las colinas) como cuatro; uno Enorme (como un carro o la maza de armas de un gigante de las nubes) como ocho; uno Gargantuesco (como una chalupa) como dieciséis; y un objeto Colosal (como un velero) como treinta y dos.

Este conjuro también te permitirá devolver su forma a la madera (es decir, volver a deformarla hasta que sea normal de nuevo), por ejemplo poniendo recta la madera que haya sido deformada por este conjuro o por otros medios. El conjuro de integrar, no obstante, no servirá para devolver su forma a un objeto deformado.

Puedes combinar varios lanzamientos consecutivos de deformar madera para deformar (o devolver su forma) a un objeto que sea demasiado grande como para resultar afectado con un único conjuro. Por ejemplo, un druida de 8.º nivel puede lanzar dos conjuros de deformar madera para deformar un objeto Gargantuesco, o cuatro para deformar uno Colosal. El objeto no sufrirá efectos negativos hasta que no esté completamente deformado.

| esacralizar | |
| |--|
| Evocación [maligno] | |
| Nivel: Clr 5, Drd 5 | |
| Componentes: V, S, M | |
| Tiempo de lanzamiento: 24 horas | |
| Alcance: toque | |
| Area: emanación de 40' de radio | |
| que surge del punto tocado | |
| Duración: instantaneo | |
| Tiro de salvación: ver texto | |
| Resistencia a conjuros: ver texto | |
| | |

Este conjuro hace que un lugar, edificio o construcción se convierta en lugar sacrílego. Esto tiene tres efectos principales:

El primero es que la construcción queda protegida por un círculo mágico contra el bien.

El segundo es que todas las pruebas de expulsión de muertos vivientes sufren un penalizador -4 profano y las de reprender a este tipo de criaturas obtienen un bonificador +4 profano. La resistencia a conjuros no se aplica a este efecto. (Nota: esta condición no es aplicable a la versión druídica del conjuro).

Por último, tendrás la posibilidad de unir un efecto de conjuro al lugar desacralizado. Este efecto de conjuro durará un año y funcionará en todo el lugar sacrílego, sin importar cuál sea su duración normal o qué área o efecto tenga. Podrás decidir si el efecto se aplicará a todas las criaturas, a aquellas que compartan tu misma religión o alineamiento o a las que profesen otra fe o tengan un alineamiento distinto. Por ejemplo, podrías crear un efecto de bendecir que ayudara a todas las criaturas de tu fe o alineamiento que se encuentren en el área o uno de perdición que entorpezca a las de una religión o alineamiento contrario al tuyo. Al terminar el año, el efecto elegido finalizará, aunque podrá ser renovado o vuelto a colocar en el lugar lanzando un nuevo conjuro de desacralizar.

Entre los efectos de conjuro que pueden unirse a un sortilegio de desacralizar se encuentran: ancla dimensional, auxilio divino, bendecir, causar miedo, custodia contra la muerte, detectar el bien, detectar magia, discernir mentiras, disipar magia, don de lenguas, libertad de movimiento, luz del día, oscuridad, oscuridad profunda, perdición, protección contra la energía, purgar invisibilidad, quitar el miedo, resistir energía, silencio, soportar los elementos y zona de verdad. La RC y los TS pueden aplicarse a estos efectos (consulta la descripción individual de cada conjuro para encontrar los detalles).

Un área sólo puede recibir un sortilegio de desacralizar (y su correspondiente efecto de conjuro) al mismo tiempo.

Desacralizar contrarresta, pero no disipa, el conjuro sacralizar.

Componentes materiales: hierbas, aceite e incienso por un valor mínimo de 1.000 po, más 1.000 po por nivel del conjuro que quiera unirse al área desacralizada.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$1 objeto Pequeño de madera/nivel, todos ellos dentro de un radio de 20'$c$, duration = $c$instantánea$c$, saving_throw = $c$Voluntad niega (objeto)$c$, spell_resistance = $c$sí (objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'deformar madera';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, description = $c$Este conjuro crea 1d4+2 brozas movedizas (masas bamboleantes) con 11 DG cada una (consulta el Manual de monstruos para encontrar más detalles sobre estas criaturas). Estos monstruos, que se quedarán contigo durante siete días a no ser que deshagas el conjuro, estarán dispuestos a ayudarte en el combate, llevando a cabo una misión concreta o haciendo las veces de guardaespaldas. No obstante, si las brozas fueron creadas sólo con fines de protección, el conjuro durará siete meses. En este caso, sólo podrás ordenar a los monstruos que guarden un sitio o lugar concreto. Las brozas movedizas convocadas para guardar un lugar no podrán abandonar los límites del alcance del conjuro, que se medirán desde el punto en que cada monstruo apareciera por primera vez.

Estas criaturas poseerán la resistencia al fuego de las brozas movedizas normales solamente si el terreno es húmedo o pantanoso o si hubiera llovido.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$tres o más brozas movedizas; dos cualesquiera no pueden distar más de 30 pies; ver texto$c$, duration = $c$siete días o siete meses (D); ver texto$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'desbrozar';
update spells set school = $c$Evocación$c$, descriptors = $c$fuego$c$, description = $c$La descarga flamigera genera una columna vertical de fuego divino que desciende sobre sus víctimas infligiendo 1d6 puntos de daño por nivel de lanzador (máx. 15d6). La mitad del daño es por fuego, pero el resto procede directamente del poder divino y, por tanto, no puede ser reducido por una resistencia a los ataques basados en el fuego, como la proporcionada por protección contra la energía (fuego), escudo de fuego (escudo gélido) ni efectos mágicos similares.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$cilindro (10' de radio, 40' de altura)$c$, duration = $c$instantáneo$c$, saving_throw = $c$Reflejos mitad$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'descarga flamigera';
update spells set school = $c$Universal$c$, description = $c$Este es el conjuro más poderoso que un mago o hechicero puede llegar a ejecutar, alterando la realidad a su gusto con sólo pronunciar unas palabras. No obstante, hasta un deseo tiene sus límites.

Este sortilegio puede hacer una cualquiera de las cosas siguientes:

· Duplicar cualquier conjuro de hechicero/ mago, de nivel 8.º o inferior, siempre y cuando el sortilegio no pertenezca a una escuela que te esté prohibida.

Duplicar cualquier otro conjuro, de nivel 6.º o inferior, siempre y cuando el sortilegio no per-

tenezca a una escuela que te esté prohibida. · Duplicar cualquier conjuro de hechicero/

mago, de nivel 7.º o inferior, aunque pertenezca a una escuela que te esté prohibida.

Duplicar cualquier otro conjuro, de nivel 5.º o inferior, aunque pertenezca a una escuela que te esté prohibida.

Deshacer los efectos perjudiciales de numerosos conjuros, como geas/empeño o locura. Crear un objeto no mágico de un valor que no exceda las 25.000 po.

Crear un objeto mágico, o añadir poderes a uno ya existente.

- Conceder a una criatura un bonificador inherente +1 en una puntuación de característica. Entre dos y cinco conjuros de deseo, ejecutados en sucesión inmediata, podrán conceder a una criatura un bonificador inherente de entre +2 y +5 en una puntuación de característica (dos deseos para obtener un bonificador +2 inherente, tres para un bonificador +3, etc.). Los bonificadores inherentes son instantáneos, por lo que no pueden ser disipados. Nota: ningún bonificador inherente puede superar el +5 en una misma puntuación de característica. Además, los distintos bonificadores inherentes de una misma puntuación de característica no se apilan; solamente se aplica el mejor de ellos.
- Eliminar heridas y afecciones. Un conjuro de deseo puede ayudar a una criatura por nivel de lanzador, aunque todos los receptores han de ser curados del mismo tipo de afección. Por ejemplo, podrías curar a tu grupo de todo el

daño o eliminar todos los efectos sufridos por tus compañeros a causa del veneno, pero no las dos cosas con un mismo deseo. Un deseo jamás podrá recuperar la pérdida de puntos de experiencia acarreada por lanzar un conjuro ni los niveles o puntos de Constitución perdidos al ser devuelto a la vida.

- · Devolver la vida a los muertos. Un deseo puede devolver la vida a una criatura duplicando el efecto de un conjuro de resurrección. Este conjuro podrá traer de entre los muertos a una criatura cuyo cuerpo haya sido destruido, pero tal hazaña requerirá dos deseos: uno para volver a crear el cuerpo y otro para infundirle vida de nuevo. Un deseo no puede impedir que un personaje devuelto a la vida pierda un nivel de experiencia.
- Transportar a viajeros. Un deseo puede trasladar a una criatura por nivel de lanzador desde un lugar cualquiera de un plano hasta un punto de un plano cualquiera, sean cuales fueren las condiciones locales. Los receptores no voluntarios tendrán derecho a realizar un tiro de salvación de Voluntad, y a aplicar su RC (en caso de tenerla).
- · Deshacer una desgracia. Un deseo puede deshacer un acontecimiento reciente, obligando a repetir una tirada cualquiera que se hava efectuado durante el último asalto (incluyendo tu último turno). La realidad será modificada para adaptarse al nuevo resultado. Por ejemplo, el deseo podría deshacer el éxito en el TS de un oponente, el éxito en el crítico de un enemigo (tanto la tirada de ataque como la tirada crítica), la salvación de un amigo, etc. Sin embargo, nada impedirá que el nuevo resultado sea igual de malo (o peor) que el de la tirada original. Los receptores no voluntarios tendrán derecho a realizar un TS de Voluntad y a aplicar su RC (en caso de tenerla).

Puedes desear que sucedan cosas más poderosas que éstas, pero eso resultará muy peligroso. Un deseo así te dará la oportunidad de cumplir lo que pidas sin hacerlo por completo (el conjuro podría tergiversar tu intención, cumpliendo el deseo de una forma literal no deseada o bien cumpliéndolo sólo en parte). Por ejemplo, desear la posesión de un bastón de los magos podría transportarte a la presencia del dueño actual de uno de ellos. Formular el deseo de ser inmortal podría trasladarte hasta una prisión escondida en un espacio extradimensional (como en el conjuro de cautiverio) en la que puedas "vivir" indefinidamente.

Todo conjuro duplicado permite los mismos TS y RC que su versión normal (aunque la CD de la salvación será la de un conjuro de 9.º nivel).

Componentes materiales: cuando un deseo duplique un conjuro con un componente material que cueste más de 10.000 po, deberás proporcionarlo.

Coste en PX: el coste mínimo para lanzar un deseo es de 5.000 PX. Cuando un deseo duplique los efectos de un conjuro con coste en PX, tendrás que pagar ese coste o 5.000 PX (la cantidad que sea superior). Cuando un deseo cree o mejore un objeto mágico, deberás pagar el doble del coste normal en PX para fabricar o mejorar el objeto, además de 5.000 PX adicionales.$c$, components = $c$V, PX$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$ver texto Objetivo, efecto o á$c$, target = $c$ver texto$c$, duration = $c$ver texto en en mana main$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'deseg';
update spells set school = $c$Universal$c$, description = $c$Este conjuro te permite crear prácticamente cualquier tipo de efecto. Un deseo limitado puede hacer cualquiera de las siguientes cosas: · Duplicar cualquier conjuro de hechicero/ mago, de nivel 6.º o inferior, siempre y cuando el sortilegio no pertenezca a una escuela que te esté prohibida.

Duplicar cualquier otro conjuro, de nivel 5.ºo inferior, siempre y cuando el sortilegio no pertenezca a una escuela que te esté prohibida. Duplicar cualquier conjuro de hechicero/

- mago, de nivel 5.º o inferior, aunque pertenezca a una escuela que te esté prohibida. · Duplicar cualquier otro conjuro, de nivel 4.º
- o inferior, aunque pertenezca a una escuela que te esté prohibida.
- Deshacer los efectos perjudiciales de numerosos conjuros, como geas/empeño o locura. Cualquier otro efecto cuyo nivel de poder no exceda lo citado anteriormente, como hacer que una criatura tenga éxito automáticamente en su siguiente ataque o que sufra un penalizador -7 en su siguiente tiro de salvación. In la m

Todo conjuro duplicado permite los mismos TS y RC que su versión normal (aunque la CD de la salvación será la de un conjuro de 7.º nivel). Cuando el deseo limitado duplique los efectos de un conjuro con coste en PX, tendrás que pagar ese coste o 300 PX (la cantidad que sea superior). Cuando el deseo limitado duplique los efectos de un conjuro con un componente material que cueste más de 1.000 po, necesitarás disponer del componente en cuestión.

Coste en PX: 300 PX o más (véase más arriba).$c$, components = $c$V, S, PX$c$, casting_time = $c$1 acción$c$, spell_range = $c$ver texto Obietivo, efecto o á$c$, target = $c$ver texto$c$, duration = $c$ver texto$c$, saving_throw = $c$ninguno;$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'deseg limitado';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Un cono invisible de desesperación causa una gran tristeza en los objetivos. Cada criatura afectada recibe un penalizador -2 en las tiradas de ataque, tiros de salvación, pruebas de habilidad, pruebas de característica y tiradas de daño.

Desesperación aplastante contrarresta y disipa esperanza alentadora.

Componente material: un vial de lágrimas.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$30 pies$c$, target = $c$explosión en forma de cono$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'desesperacion aplastante';
update spells set school = $c$Transmutación$c$, description = $c$Un delgado rayo verdoso surge de tu dedo índice. Debes tener éxito en un ataque de toque a distancia para impactar. Cualquier criatura golpeada por el rayo sufre 2d6 puntos de daño por nivel de lanzador (hasta un máximo de 40d6). Toda criatura reducida a 0 puntos de golpe o menos por este conjuro quedará totalmente desintegrada, dejando tras de sí solamente un fino rastro de polvo. El equipo de una criatura desintegrada no resulta afectado.

Cuando se utiliza sobre un objeto, el rayo simplemente desintegra hasta un cubo de 10 pies de materia no viva; por tanto, el sortilegio sólo desintegrará parte de un objeto muy grande o de un edificio contra el que sea dirigido.

El rayo afecta incluso a los objetos construidos totalmente de fuerza, como la mano forzuda de Bigby o un muro de fuerza, pero no a los efectos mágicos como un globo de invulnerabilidad o un campo antimagia.

Toda criatura u objeto que tenga éxito en su tiro de salvación de Fortaleza sólo resultará parcialmente afectado, sufriendo 5d6 puntos de daño en lugar de ser desintegrado.

Sólo será afectada la primera criatura u objeto alcanzado por este rayo; es decir, el conjuro de desintegración afecta a un solo objetivo por lanzamiento.

Componentes materiales arcanos: magnetita y un poco de polvo.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$rayo$c$, duration = $c$instantaneo$c$, saving_throw = $c$Fortaleza parcial (objeto) Resistencia a coniuros: SI$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'desintegrar';
update spells set school = $c$Tlusión$c$, subschool = $c$engaño$c$, description = $c$Mediante este sortilegio puedes engañar a los conjuros de adivinación que sirvan para revelar las auras (detectar el mal, detectar magia, discernir mentiras y conjuros similares). Al ejecutar el sortilegio, tienes que elegir otro objeto que se encuentre dentro del alcance. Mientras dure el efecto, el receptor de desorientar será detectado como si fuera el otro objeto (ni el objetivo ni el otro objeto recíben un TS contra este efecto). Los conjuros de detección proporcionarán información basándose en el segundo objeto en lugar de en su objetivo real, a no ser que su lanzador tenga éxito en una salvación de Voluntad. Por ejemplo, puedes hacer que te detecten como si fueras un árbol, siempre y cuando haya uno dentro del alcance del conjuro: no maligno, no mentiroso, no mágico, de alineamiento neutral, etc. Este conjuro no afecta a otros tipo de magia de adivinación (augurio, clariaudiencia/clarividencia, detectar pensamientos, etc.).$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura u objeto (tamaño máx. de un cubo de 10 pies de lado)$c$, duration = $c$1 h/nivel$c$, saving_throw = $c$ninguno o Voluntad niega; ver texto$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'desorientar';
update spells set school = $c$Ilusión$c$, subschool = $c$engaño$c$, description = $c$Emulando la aptitud natural de las bestias trémulas (consulta el Manual de monstruos), el receptor parecerá encontrarse a 2' de distancia de su verdadera posición, por lo que se beneficiará de un 50% de posibilidad de fallo en los ataques contra él, como si dispusiera de ocultación total. Sin embargo, al contrario que sucede con la verdadera ocultación total, desplazamiento no impedirá que sus enemigos puedan dirigir contra él sus ataques con normalidad. El conjuro de visión verdadera revelará su posición real.

Componente material: una pequeña tira de cuero, hecha de piel de bestia trémula, que esté formando un lazo.$c$, components = $c$V, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$1 asalto/nivel (D)$c$, saving_throw = $c$Voluntad niega (inotensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'desplazamiento';
update spells set school = $c$Conjuración$c$, subschool = $c$teleportacion$c$, description = $c$Desplazas tu propia persona o a otra criatura hasta otro plano de existencia o dimensión alternativa. Si varias personas voluntarias unen sus manos formando un círculo, ocho de ellas (como máximo) podrán ser afectadas al mismo tiempo por el desplazamiento de plano. Resulta casi imposible elegir un punto de llegada exacto en el plano al que se desee viajar. Podrás llegar a cualquier lugar desde el plano Material,

pero aparecerás a una distancia de entre 5 y 500 millas (5d%) del lugar de destino deseado. Nota: el desplazamiento de plano transporta a las criaturas inmediatamente y después finaliza. Los receptores del conjuro deberán valerse de sus propios medios para realizar el viaje de vuelta.

Foco: una pequeña horquilla metálica de dos púas. El tamaño y el tipo de metal de este objeto determinará el plano de existencia o la dimensión alternativa al que llegarán los receptores del conjuro. A discreción del DM, las horquillas de este tipo vinculadas con ciertos planos pueden resultar difíciles de conseguir.$c$, components = $c$V, S, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada o hasta ocho criaturas voluntarias con las manos unidas$c$, duration = $c$instantáneo$c$, saving_throw = $c$Voluntad niega Resistencia a comuros, sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'desplazamiento de plano';
update spells set school = $c$Abjuración$c$, description = $c$Destierro es una versión más poderosa del conjuro exorcismo y te permite obligar a criaturas extraplanarias a abandonar tu plano natal. Puedes desterrar hasta 2 DG de criaturas por nivel de lanzador que poseas. Puedes mejorar las posibilidades de éxito del conjuro presentando a la criatura al menos un objeto o sustancia que odie, tema o se oponga a ella de alguna otra forma. Por cada objeto o sustancia de ese tipo que utilices, obtendrás un +1 en la prueba de nivel de lanzador con la que intentarás superar la RC de la víctima (si la tuviera), y un +2 en la CD del tiro de salvación. Por ejemplo, si lanzas el conjuro sobre un demonio que odia la luz y es vulnerable al agua bendita y las armas de hierro, podrías usar este metal, agua bendita y una antorcha en el conjuro: los tres objetos añadirían +3 a tu prueba para superar la RC del demonio y +6 a la CD del conjuro.

A discreción del DM, los objetos especialmente raros podrían funcionar el doble de bien en cuanto a los bonificadores (proporcionando cada uno un +2 contra la RC y añadiendo +4 a la CD).

Foco arcano: cualquier objeto que sea desagradable para el objetivo (opcional, ver más arriba).$c$, components = $c$V, S, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una o más criaturas extraplanarias (dos cualesquiera no pueden distar más de 30 pies)$c$, duration = $c$instantáneo$c$, saving_throw = $c$Voluntad niega niega mar$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'destierro';
update spells set school = $c$Nigromancia$c$, descriptors = $c$muerte$c$, description = $c$Este conjuro mata instantáneamente a su receptor, y consume sus restos por completo (pero no

su equipo y posesiones). Si la salvación de Fortaleza tiene éxito, la víctima sólo sufrirá 10d6 puntos de daño. La única forma de devolver la vida a un personaje que haya fallado su salvación contra este conjuro es usar resurrección verdadera, un sortilegio de deseo formulado con sumo cuidado y seguido de un resurrección, o un milagro.

Foco: un símbolo sagrado (o sacrílego) especial, hecho de plata y grabado con versículos de anatema (coste de 500 po).$c$, components = $c$V, S, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura$c$, duration = $c$instantáneo$c$, saving_throw = $c$Fortaleza parcial$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'destruccion';
update spells set school = $c$Adivinación$c$, description = $c$Puedes detectar un tipo concreto de animal o planta en una emanación en forma de cono en la dirección a la que estés mirando. Al usar el conjuro, debes pensar en una especie animal o vegetal, pudiendo variar tu elección cada asalto que pase. La cantidad de información revelada dependerá del tiempo que dediques a investigar un área concreta o que te concentres en un tipo específico de planta o animal:

1." asalto: presencia o ausencia del tipo de planta o animal en ese cuarto de círculo.

2.º asalto: cantidad de individuos de la especie concreta presentes en el área y situación del espécimen más sano.

3." asalto: condición (ver más abajo) y situación de cada individuo presente. Si una planta o animal estuviera fuera de tu línea de visión, sabrías en qué dirección se encuentra, pero no su posición exacta.

Condiciones: en lo que se refiere a este conjuro, éstas son las distintas categorías en que estará dividida la condición de las criaturas:

Normal: posee, como mínimo, un 90% de sus puntos de golpe; no está enfermo.

Aceptable: le quedan entre un 30 y un 90% de sus puntos de golpe originales.

Mal: le quedan, como mucho, un 30% de sus puntos de golpe originales; está contagiado de una enfermedad; sufre una herida debilitadora.

Débil: con 0 puntos de golpe o menos; contagiado de una enfermedad terminal; lisiado. Si una criatura entra en más de una categoría, el conjuro indicará la más débil de las dos.

Cada asalto podrás cambiar el área o tipo de animal o planta a examinar. El sortilegio puede atravesar barreras, pero 1' de piedra, 1" de metal corriente, una plancha delgada de plomo o 3 de madera o tierra bastarán para bloquearlo.

El DM será quien decida si hay presente un tipo concreto de planta o animal.

Detectar el bien

Adivinación Nivel: Clr 1

Como detectar el mal, excepto en que detecta las auras de criaturas buenas, clérigos o paladines de deidades buenas, conjuros buenos y objetos mágicos buenos, y en que si eres maligno eres vulnerable a las auras buenas abrumadoras. Las pociones curativas, antídotos y demás objetos beneficiosos no se consideran buenos.$c$, components = $c$V. S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$largo (400' + 40'/nivel)$c$, target = $c$emanación en forma de cono$c$, duration = $c$concentración, hasta 10 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'detectar animales o plantas luga';
update spells set school = $c$Adivinación$c$, description = $c$Eres consciente inmediatamente de todo intento de observarte por medio de un conjuro o efecto de adivinación (escudriñamiento). El sortilegio, que irradia de ti, se desplazará contigo. Serás consciente de la situación exacta de todo sensor mágico que se encuentre en el área del conjuro.

Si el intento de escudriñamiento tiene su origen dentro del área en sí, también sabrás el$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$40 pies$c$, target = $c$emanación de 40' de radio, centrada en ti$c$, duration = $c$24 horas$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'detectar escudrinamiento';
update spells set school = $c$Adivinación$c$, description = $c$Te permite detectar auras mágicas. La cantidad de información revelada dependerá del tiempo que dediques a estudiar un área o receptor concreto:

1." asalto: presencia o ausencia de magia. 2.º asalto: cantidad de auras mágicas diferentes y potencia del aura más fuerte.

3.6 asalto: potencia y situación exacta de cada aura. Si los objetos o criaturas portadoras de las auras están en tu línea de visión, podrás realizar pruebas de Conocimiento de conjuros para determinar la escuela de magia relacionada con cada una de ellas (realiza una prueba por aura; CD 15 + nivel del conjuro, o 15 + la mitad del nivel de lanzador para los efectos no pertenecientes a conjuros).

Los lugares mágicos, varios tipos de magia en un mismo sitio o las emanaciones mágicas de potencia local pueden confundir u ocultar otras auras más débiles.

Potencia del aura: el poder y fuerza de un aura mágica dependerán del nivel de conjuro del sortilegio en funcionamiento o del nivel de lanzador del objeto en cuestión. Si un aura entra dentro de más de una categoría, detectar magia indica la más fuerte de las dos.

Permanencia de las auras residuales: un aura mágica permanece después de que su fuente original se disipe (si era un conjuro) o sea destruida (si era un objeto mágico). Si detectar magia es lanzado y dirigido hacia una localización de este tipo, el conjuro indica un aura tenue$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$60'$c$, target = $c$emanación en forma de cono$c$, duration = $c$concentración, hasta 1 min/ nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'detectar magia';
update spells set school = $c$Adivinacion$c$, description = $c$Puedes detectar el aura que rodea a los muertos vivientes. La cantidad de información revelada dependerá del tiempo que dediques a estudiar un área concreta:

1.ºº asalto: presencia o ausencia de auras de muertos vivientes.

2.º asalto: cantidad de auras de muertos vivientes presentes en el área y potencia de la más poderosa. Si eres de alineamiento bueno y el aura de muerto viviente más fuerte es abrumadora (ver más abajo), si los DG de la criatura son, como mínimo, iguales al doble de tu nivel de personaje, quedarás aturdido durante 1 asalto y el conjuro terminará.

3.4 asalto: potencia y situación exacta de cada una de las auras. Si una de ellas estuviera fuera de tu línea de visión, sabrías en qué dirección se encuentra, pero no su posición exacta.

Potencia del aura: el poder del aura depende de los DG de la criatura muerta viviente en cuestión, tal y como se da en la siguiente tabla.

| DG | Potencia |
| | |
| l o menos | Débil |
| 2-4 | Moderada |
| 5-10 | Fuerte |
| 11 o más | Abrumadora |

Permanencia de las auras residuales: un aura de muerto viviente permanece después de que su

fuente original sea destruida. Si detectar muertos vivientes es lanzado y dirigido hacia una localización de este tipo, el conjuro indica un aura tenue (menor incluso que un aura débil). La duración del aura residual dependerá de su potencia original:

| Potencia original | Duración | |
| | |--|
| Débil | 1d6 asaltos | |
| Moderada | 1d6 minutos | |
| Fuerte | 1d6x10 minutos | |
| Abrumadora | 1d6 días | |
| | | |

Cada asalto podrás cambiar el área a examinar. El sortilegio puede atravesar barreras, pero 1' de piedra, 1" de metal corriente, una plancha delgada de plomo o 3' de madera o tierra bastarán para bloquearlo.

Componente material arcano: un poco de tierra de una tumba.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$60 pies$c$, target = $c$emanación en forma de cono$c$, duration = $c$concentración, hasta 1 min/ nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'detectar muertos vivientes';
update spells set school = $c$Adivinacion$c$, description = $c$Puedes detectar los pensamientos superficiales. La cantidad de información revelada dependerá del tiempo que dediques a estudiar un área o receptor concreto.

1." asalto: presencia o ausencia de pensamientos (de criaturas conscientes con 1 o más en su puntuación de Inteligencia).

2.º asalto: cantidad de mentes pensantes y la puntuación de Inteligencia de cada una. Si la Inteligencia mayor es 26 o más (y al menos 10 puntos mayor que tu propia puntuación de Inteligencia), quedas aturdido durante 1 asalto, y el conjuro termina. Este conjuro no te permite determinar la localización de las mentes pensantes si no puedes ver a las criaturas cuyos pensamientos estás detectando.

3.º asalto: pensamientos superficiales de toda mente que se encuentre en el área. Tener éxito en un TS de Voluntad por parte de un receptor impedirá que se lean sus pensamientos, por lo que tendrás que volver a ejecutar el sortilegio si deseas tener una nueva oportunidad. Las criaturas con inteligencia animal (Int 1 ó 2) poseen pensamientos simples e instintivos que te resultan fáciles de interpretar.

Cada asalto puedes cambiar el área a examinar. El sortilegio puede atravesar barreras, pero 1' de piedra, 1" de metal corriente, una plancha delgada de plomo o 3' de madera o tierra bastarán para bloquearlo. Foco arcano: una pieza de cobre.$c$, components = $c$V, S, F/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$60 pies$c$, target = $c$emanación en forma de cono$c$, duration = $c$concentración, hasta 1 min/nivel (D)$c$, saving_throw = $c$Voluntad niega; ver texto$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'detectar pensamientos';
update spells set school = $c$Adivinación$c$, description = $c$Puedes detectar puertas y compartimentos secretos, escondrijos, etc. Este conjuro sólo servirá para detectar aquellos pasadizos, puertas o aberturas que hayan sido construidas específicamente para evitar ser detectados (una trampilla normal y corriente, situada bajo un montón de cajas de embalaje, no sería detectada por este sortilegio). La cantidad de información revelada dependerá del tiempo que dediques a estudiar un área o receptor concreto:

1.ºº asalto: presencia o ausencia de puertas secretas.

2.º asalto: cantidad de puertas secretas y situación exacta de cada una. Si un aura estuviera fuera de tu línea de visión, sabrías en qué dirección se encuentra, pero no su posición exacta. Cada asalto adicional: el mecanismo o método de desencadenamiento de una entrada secreta particular que examines detenidamente. Cada asalto podrás cambiar el área a examinar.

El sortilegio puede atravesar barreras, pero 1' de piedra, 1" de metal corriente, una plancha delgada de plomo o 3' de madera o tierra bastarán para bloquearlo.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$60'$c$, target = $c$emanación en forma de cono$c$, duration = $c$concentración, hasta 1 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'detectar puertas secretas';
update spells set school = $c$Adivinación$c$, description = $c$Puedes detectar trampas sencillas, como pozos, caídas de peso y lazos, así como trampas mecánicas construidas mediante materiales naturales. El conjuro no detecta trampas complejas, ni siquiera las de trampilla.

Detectar trampas y pozos revela ciertos peligros naturales, como las arenas movedizas (como trampa), los pozos y simas (como foso) o las paredes de roca natural que resulten peligrosas (caída de peso). Sin embargo, no revela otro tipo de condiciones potencialmente peligrosas, como una caverna que se inunde cuando llueva, una construcción insegura o una planta que sea venenosa por naturaleza. El sortilegio tampoco detecta las trampas mágicas (excepto aquellas que funcionen mediante un foso, una caída de peso o un lazo; consulta el conjuro trampa de lazo), las que poseen mecanismos complejos ni las que han sido desactivadas o ya no suponen peligro alguno.

La cantidad de información revelada depende del tiempo que dediques a estudiar un área concreta:

1.ª asalto: presencia o ausencia de peligros. 2.º asalto: cantidad de peligros y situación exacta de cada uno. Si un peligro estuviera fuera de tu línea de visión, sabrías en qué dirección se encuentra, pero no su posición exacta.

Cada asalto adicional: el tipo general y el método de desencadenamiento de un peligro particular que estés examinando detenidamente.

Cada asalto podrás cambiar el área a examinar. El sortilegio puede atravesar barreras, pero 1' de piedra, 1" de metal corriente, una plancha delgada de plomo o 3' de madera o tierra bastarán para bloquearlo.$c$, components = $c$V, S$c$, casting_time = $c$1 acción$c$, spell_range = $c$60'$c$, target = $c$emanación en forma de cono$c$, duration = $c$concentración, hasta 10 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'detectar trampas y fosos';
update spells set school = $c$Adivinación$c$, description = $c$Puedes averiguar si una criatura, objeto o lugar ha sido envenenado o es venenoso. Teniendo éxito en una prueba de Sabiduría (CD 20) podrás determinar el tipo exacto de veneno. Un personaje con la habilidad de Artesanía (alquimia) puede realizar una prueba con ella (CD 20) en caso de fallar la de Sabiduría, o usarla directamente en primer lugar.

El sortilegio puede atravesar barreras, pero 1' de piedra, 1" a de metal corriente, una plancha delgada de plomo o 3' de madera o tierra bastarán para bloquearlo. Lo La La La Della$c$, components = $c$V, S = Compone$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles) Objetivo o á$c$, target = $c$una criatura, un objeto o un cubo de 5'$c$, duration = $c$instantáneo$c$, saving_throw = $c$ninguno - minguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'detectar veneno';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro hace que el tiempo parezca dejar de transcurrir para todo el mundo excepto para ti. De hecho, te acelerarás tanto que todas las demás criaturas parecerán congelarse a pesar de estar moviéndose a sus velocidades normales. El conjuro te permitirá actuar libremente durante 1d4+1 asaltos de tiempo aparente. El fuego, el frío, el gas y otros agentes parecidos (tanto mágicos como normales) te seguirán afectando normalmente. Mientras el sortilegio esté surtiendo efecto, las demás criaturas serán invulnerables a tus ataques y conjuros, es decir, no podrás elegirlos como objetivo de ninguno de tus ataques ni conjuros. Un conjuro que afecte un área y que tenga una duración mayor que la restante de detener el tiempo (como nube aniquiladora) tiene sus efectos normales sobre las demás criaturas una vez que detener el tiempo termina. La mayoría de los lanzadores de conjuros utilizan este tiempo adicional para mejorar sus defensas convocar aliados o huir del combate.

No podrás mover ni dañar los objetos puestos, sujetos o transportados por una criatura que se esté moviendo en tiempo real, pero podrás afectar a todo objeto que no obre en poder de nadie.

Mientras dure el conjuro detener el tiempo, serás indetectable. Sin embargo, mientras estés bajo sus efectos no podrás entrar en una zona protegida por un campo antimagia.$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$1d4+1 asaltos (tiempo aparente); ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'detener el tiempo la min';
update spells set description = $c$Este conjuro inmoviliza a un máximo de tres muertos vivientes. Los muertos vivientes no inteligentes (como los esqueletos y los zombis) no tendrán derecho a realizar tiro de salvación; los inteligentes sí podrán realizarlo. Si el conjuro tiene éxito, inmovilizará a las criaturas hasta que expire su duración (generando un efecto similar al de un inmovilizar persona lanzado sobre una criatura viva). El efecto se romperá si la criatura detenida es atacada o sufre daño.

Componentes materiales: una pizca de azufre y ajo en polvo. En la mu$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$hasta tres muertos vivientes; dos cualesquiera no pueden distar más de 30 pies$c$, duration = $c$1 asalto/nivel$c$, saving_throw = $c$Voluntad niega; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'detener muertos vivientes';
update spells set school = $c$Adivinación$c$, description = $c$Cada asalto debes concentrarte en un objetivo, que debe encontrarse dentro del alcance. El conjuro te permitirá saber si el receptor está mintiendo de forma consciente y deliberada al discernir las perturbaciones causadas en su aura por tales mentiras. El sortilegio no revela la verdad, no descubre inexactitudes no intencionadas ni tiene por qué revelar necesariamente las evasivas. Cada asalto puedes concentrarte en un objetivo diferente.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura/nivel, dos cualesquiera no pueden distar más de 30'$c$, duration = $c$concentración, hasta 1 asalto/nivel$c$, saving_throw = $c$Voluntad niega n$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'discernir mentiras';
update spells set school = $c$Evocación$c$, descriptors = $c$fuerza$c$, description = $c$Creas un plano de fuerza, circular y ligeramente cóncavo, que te seguirá y transportará cargas para ti. El disco tiene 3'de diámetro, 1" de profundidad en el centro y puede soportar 100 lb. de peso por nivel de lanzador (cuando se emplea para transportar un líquido, su capacidad es de 2 galones). El disco flota aproximadamente a 3' del suelo y estará nivelado en todo momento. Podrá flotar horizontalmente hasta alcanzar el límite del conjuro y te seguirá a un ritmo no superior a tu velocidad normal por asalto. Mientras no lo dirijas, se mantendrá constantemente a 5'de distancia de ti. El disco desaparecerá cuando expire la duración del conjuro, aunque también lo hará si llega a superar el alcance del mismo (por moverte demasiado deprisa, teleportarte a otro lugar, etc.) o si intentas elevarlo a más de 3' de la superficie que hubiera bajo él. Cuando el disco desaparezca, todo aquello que haya sobre él caerá sobre la superficie que tuviera debajo.

Componente material: una gota de mercurio.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2-niveles)$c$, target = $c$disco de fuerza de 3' de diámetro$c$, duration = $c$1 h/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'disco flotante de tenser';
update spells set school = $c$Ilusión$c$, subschool = $c$engaño$c$, description = $c$Este conjuro hace que tu aspecto sea diferente (incluyendo tu ropa, armadura, armas y equipo). Puedes parecer 1' más alto o más bajo, más delgado, más gordo o algo intermedio. Sin embargo, no podrás cambiar de tipo de cuerpo; un humano, por ejemplo, sólo podría aparentar sen otro humano, humanoide o cualquier otra criatura bípeda que se parezca a las dos clases anteriores. Respetando lo dicho, el grado del cambio de aspecto queda totalmente en tus manos: puedes limitarte a añadir u ocultar un rasgo menor, como un lunar o una barba, o parecerte a una persona completamente distinta.

El conjuro no proporciona las aptitudes ni peculiaridades de la forma escogida. Tampoco altera la forma en que serán percibidas las propiedades táctiles (toque) ni audibles (sonido) de tu equipo o tu persona. Un hacha de batalla con aspecto de daga seguirá funcionando como lo que es en realidad.

Si utilizas este conjuro para crear un disfraz, obtendrás un +10 en la prueba de Disfrazarse. Cuando exista interacción entre el engaño y una criatura, ésta tendrá derecho a realizar un TS de Voluntad para darse cuenta de que se trata de una ilusión. Por ejemplo, una criatura que te tocara y advirtiera que no coincides demasiado con lo que ve tendría derecho a un tiro de salvación.

| Disipar el bien | |
| |--|
| Abjuración [maligno] | |
| Nivel: Clr 5, Mal 5 | |

Este conjuro funciona como disipar el mal, pero te rodeas de energía sacrílega, oscura y trémula, y el sortilegio afecta a criaturas y conjuros buenos en lugar de malignos.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal Obietivo: tú$c$, duration = $c$10 min/nivel (D)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'disfrazarse';
update spells set school = $c$Abjuración$c$, descriptors = $c$bueno$c$, description = $c$Te rodeas de una energía sagrada, blanca y resplandeciente. Este poder tiene tres efectos: Primero, obtienes un bonificador +4 de desvío a la CA contra los ataques de las criaturas malignas.

Segundo, cuando logres alcanzar a una criatura maligna de otro plano con un ataque de toque en cuerpo a cuerpo, podrás optar por devolverla a su plano de origen. La criatura podrá negar el efecto con un TS de Voluntad (la RC se aplica). Este uso descarga el conjuro y le pone fin.

Tercero, mediante un toque, puedes disipar automáticamente un encantamiento cualquiera lanzado por una criatura maligna o un conjuro cualquiera también maligno. Excepción: los sortilegios que no puedan ser disipados mediante un disipar magia tampoco podrán serlo mediante un disipar el mal. Los TS y la RC no se aplican con este efecto. Este uso descarga el conjuro y le pone fin.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque Objetivo u objetivos: tú y una criatura maligna de otro plano a la que toques; o tú y un encantamiento o conjuro maligno que afecte a la criatura u objeto tocado$c$, duration = $c$1 asalto/nivel o hasta ser descargado, lo que suceda antes$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'disipar el mal';
update spells set school = $c$Abjuracion$c$, description = $c$Ya que la magia es poderosa, también lo es la capacidad para disiparla. Puedes usar disipar magia para poner fin a conjuros activos que hayan sido lanzados sobre una criatura u objeto, suprimir temporalmente las aptitudes especiales de un objeto mágico, finalizar los conjuros (o al menos sus efectos) dentro del área o contrarrestar un sortilegio de otro lanzador de conjuros. Todo conjuro disipado finalizará como si su duración hubiera llegado a su fin. Algunos conjuros no resultan afectados por disipar magia (según indiquen sus descripciones). Este sortilegio puede disipar (pero no contrarrestar) a los efectos sortílegos igual que a los propios conjuros.

Nota: los efectos de conjuros con duración instantánea no pueden disiparse, pues el efecto mágico en sí ya habrá finalizado antes de actuar el disipar magia. Por tanto, no podrás usar este conjuro para reparar el daño por fuego causado por una bola de fuego ni devolver a su estado normal a un personaje petrificado. En estos casos la magia habrá desaparecido, dejando solamente

tras de sí carne humana quemada o una estatua de piedra perfectamente esculpida.

Puedes usar disipar magia de tres formas distintas: disipación dirigida, disipación de área o contraconjuro.

Disipación dirigida: un objeto, criatura o conjuro es el objetivo del sortilegio. Debes realizar una prueba de disipación (1d20 + tu nivel de lanzador, máximo +10) contra el conjuro en cuestión o cada uno de los sortilegios activos sobre el objeto o la criatura. La CD para esta prueba de disipación 11 + el nivel de lanzador del coniuro.

Por ejemplo, Mialee, que es de 5.º nivel, dirige su disipar magia contra un drow protegido con acelerar, armadura de mago y fuerza de toro. Los tres conjuros fueron lanzados sobre el receptor por un mago de 7.º nivel. Mialee realiza tres pruebas de disipación (1d20 + 5 contra CD 18), una por el efecto de acelerar, otra por el de armadura de mago y otra por el de fuerza de toro. Si tiene éxito en una prueba concreta, logrará disipar el conjuro correspondiente (la RC del drow no le servirá de nada); si falla, el conjuro correspondiente seguirá surtiendo efecto.

Si diriges la disipación contra una criatura u objeto afectado por un conjuro activo (como una criatura que hubiera aparecido gracias a un sortilegio de convocar monstruo), tendrás que realizar una prueba de disipación para finalizar el sortilegio que haya conjurado el objeto o criatura en cuestión.

Si el objeto contra el que diriges el conjuro es mágico, tendrás que realizar la prueba de disipación contra su correspondiente nivel de lanzador. Si tienes éxito, todas las propiedades mágicas del objeto quedarán suprimidas durante 1d4 asaltos, tras los cuales el objeto se recuperará por sí mismo. Todo objeto mágico suprimido dejará de ser mágico mientras dure tal efecto. Un objeto que se encuentre entre dos dimensiones (como una bolsa de contención) se cerrará temporalmente. Recuerda que las propiedades físicas del objeto mágico no cambiarán: una espada mágica afectada por la supresión seguirá siendo una espada (de hecho, será una espada de gran calidad). Los artefactos y deidades no resultan afectados por este tipo de magia de los mortales.

Tus pruebas de disipación tendrán éxito automáticamente contra cualquier conjuro que hayas lanzado tú mismo.

Disipación de área: el conjuro afecta a todo en un radio de 30'.

Por cada criatura presente que sea objetivo de uno o más conjuros, tendrás que realizar una prueba de disipación contra el sortilegio con mayor nivel de lanzador. Si ésta resulta fallida, deberás realizar pruebas sucesivas contra el resto de conjuros activos de esa criatura (en orden descendente de poder) hasta que logres disipar uno de ellos (lo cual pondrá fin al disipar magia en lo que respecta a la criatura afectada) o falles todas tus pruebas. Los objetos mágicos de la criatura no resultarán afectados.

Por cada objeto presente que sea objetivo de uno o más conjuros, tendrás que realizar prue-

bas de disipación igual que con las criaturas. Los objetos mágicos no resultan afectados por las disipaciones de área.

Tendrás que realizar una prueba para intentar disipar cada conjuro de área o efecto que esté activo dentro del área del disipar magia.

También tendrás que realizarla para intentar disipar cada conjuro activo cuya área esté solapándose con la disipación de área, pero sólo anularás el efecto dentro del área del disipar magia. Si en el área hay una criatura u objeto afectado por un conjuro activo (como una criatura que haya aparecido gracias a un sortilegio de convocar monstruo), tendrás que realizar una prueba de disipación para finalizar el sortilegio que lo haya conjurado (devolviéndolo a su lugar de origen), además de las citadas pruebas de disipación para eliminar los conjuros que se hubieran dirigido contra él.

Puedes optar por tener éxito de manera automática en las pruebas de disipación contra cualquier conjuro lanzado por ti.

Contraconjuro: esta versión ha de dirigirse contra un lanzador y se ejecuta igual que un contraconjuro (pág. 170). Sin embargo, al contrario que un verdadero contraconjuro, un disipar magia podría no dar resultado. Tendrás que realizar una prueba de disipación para disipar el sortilegio del otro lanzador de conjuros.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel) Objetivo o á$c$, target = $c$un lanzador de conjuros, criatura u objeto; o una explosión de 20' pies de radio$c$, duration = $c$instantaneo$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'disipar magia';
update spells set school = $c$Abjuración$c$, description = $c$Todos los efectos y objetos mágicos que haya en el radio del conjuro (a excepción de los que lleves encima o estés tocando) se desunen o descomponen; esto quiere decir que los conjuros y aptitudes sortílegas quedarán reducidos a sus componentes individuales (lo cual pone fin a sus efectos igual que haría un disipar magia) y que los objetos mágicos permanentes necesitarán tener éxito en un TS de Voluntad para no convertirse en objetos normales. Los objetos que obren en poder de una criatura utilizarán el bonificador de salvación de Voluntad de su dueño o bien el suyo propio (el que sea mejor de los dos).

Mediante este sortilegio, también tendrás un 1% por nivel de lanzador de destruir un campo antimagia. Si este último efecto logra sobrevivir a la disyunción, ninguno de los objetos que hubiera en su interior será desunido.

Incluso los artefactos pueden resultar afectados por la disyunción, aunque sólo hay un 1% por nivel de lanzador de que así sea. Además, si un artefacto es destruido, necesitarás tener éxito en un TS de Voluntad (CD 25) o perderás para siempre tus aptitudes de lanzamiento de conjuros (y no podrás recuperarlas por medio de la magia mortal, ni siquiera mediante un milagro o un deseo).

Nota: destruir un artefacto resulta muy peligroso y tiene un 95% de posibilidades de atraer a una criatura poderosa que esté interesada en el objeto o relacionada con él.$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$todos los efectos y objetos mágicos en$c$, duration = $c$instantáneo$c$, saving_throw = $c$Voluntad niega (objeto)$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'disquncion de mordenkainen';
update spells set school = $c$Ilusión$c$, subschool = $c$engaño, quimera$c$, components = $c$S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, duration = $c$1 asalto/nivel (D) y concentración$c$, saving_throw = $c$ninguno o Voluntad descree (si se interactúa con el conjuro); ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'doble enganoso';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Puedes encantar a un animal y dirigirlo dándole órdenes sencillas, como "ataca", "corre" o "trae". Las órdenes suicidas o autodestructivas (incluyendo la de atacar a una criatura dos o más categorías de tamaño por encima del animal dominado) serán ignoradas sin más.

Dominar animal establece un vínculo mental entre el animal receptor y tú. Este puede ser dirigido mediante órdenes mentales silenciosas, siempre y cuando permanezca dentro del alcance. No necesitas ver al animal para poder controlarlo. El efecto no te permite recibir las sensaciones directas del animal, pero serás consciente de lo que le esté sucediendo. Al estar dirigiendo al animal con tu propia inteligencia, éste podrá llevar a cabo acciones que normalmente escaparían a su comprensión, como manipular objetos con las patas o la boca. No tendrás que concentrarte exclusivamente en controlar al animal a no ser que le ordenes hacer alguna cosa que normalmente no podría hacer. Cambiar tus instrucciones o dar una nueva orden a un animal dominado es el equivalente de redirigir un conjuro, por lo que es una acción de movimiento.$c$, components = $c$V. S$c$, casting_time = $c$1 asalto$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$un animal$c$, duration = $c$1 asalto/nivel$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'dominar animal';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Puedes controlar las acciones de cualquier criatura humanoide mediante un vínculo telepático con la mente del receptor. Si compartís algún idioma, normalmente puedes obligarlo a hacer algo que desees, siempre dentro de los límites de sus posibilidades. Si no tuvierais ningún idioma en común, sólo podrás darle órdenes básicas, como "ven", "ve allí", "lucha" y "quieto". El efecto no te permite recibir las sensaciones directas de la persona y no puede comunicarse telepáticamente contigo, pero eres consciente de lo que le esté sucediendo.

Una vez que das una orden a una criatura dominada, esta continúa intentando llevar a cabo la orden dejando de lado todas las demás actividades, salvo las necesarias para su supervivencia diaria (como dormir, comer, etc.). Debido a su limitado campo de actividades, una prueba de Averiguar intenciones contra CD 15 (en lugar de CD 25) puede determinar que el comportamiento del objetivo está siendo influenciado por un efecto de encantamiento (consulta la descripción de la habilidad de Averiguar intenciones, pág. 68).

Cambiar tus instrucciones o dar a la criatura dominada una nueva orden es equivalente a redirigir un conjuro, por lo que es una acción de movimiento.

Concentrándote completamente en el conjuro (una acción estándar) puedes recibir la información sensorial completa que esté interpretando la mente del objetivo, aunque este sigue sin poder comunicarse contigo. No ves realmente a través de los ojos del receptor, por lo que esto no es tan útil como si realmente estuvieses allí, pero sigues haciéndote una buena idea de lo que está sucediendo (el objetivo está caminando por un patio maloliente, el objetivo está hablando con un guardia, el guardia le mira con sospecha, etc.).

Los receptores se resisten a este control, y cualquier objetivo obligado a llevar a cabo acciones en contra de su naturaleza recibe un nuevo TS con un bonificador +2.Las órdenes evidentemente autodestructivas no son llevadas a cabo. Una vez que el control se ha establecido, el alcance en el que puede ejercerse es ilimitado, siempre que tú y el receptor estéis en el mismo plano. No necesitar ver al objetivo para controlarlo.

Si no dedicas al menos 1 asalto cada día a concentrarte en el conjuro, el receptor recibe un nuevo TS para liberarse de la dominación.

Protección contra el mal u otro conjuro semejante puede impedirte ejercer tu control o usar el vínculo telepático mientras el receptor esté protegido, pero no impedirá el establecimiento de la dominación ni la disiparía.$c$, components = $c$V, S$c$, casting_time = $c$1 acción$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura humanoide$c$, duration = $c$1 día/nivel$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'dominar persona';
update spells set school = $c$Adivinacion$c$, description = $c$Este conjuro concede a la criatura tocada la capacidad para hablar y comprender el idioma de cualquier criatura inteligente, ya sea un idioma racial o un dialecto regional. Naturalmente, el receptor sólo podrá hablar un idioma a la vez, aunque podrá comprender varios de ellos al mismo tiempo. Este conjuro no permite el receptor comunicarse con criaturas que no hablen. La persona afectada podrá hacerse entender hasta donde llegue su voz. El sortilegio no hace que las criaturas a las que se

dirija estén predispuestas en modo alguno hacia el receptor.

Don de lenguas puede ser hecho permanente con un conjuro de permanencia.

Componente material arcano: una pequeña maqueta de un zigurat, hecha de arcilla, que ha de romperse al pronunciar el componente verbal.$c$, components = $c$V, M/FD$c$, casting_time = $c$1 acción estandar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$10 min/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'don de lenguas';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Este conjuro hace que 4 DG de criaturas entren en un estado comatoso. Los receptores con menos DG serán los primeros afectados. Cuando haya varios con los mismos DG, los que estén más cerca del punto de origen del conjuro serán los primeros que sufran el efecto, y los DG que no basten para afectar a un receptor se perderán sin más.

Por ejemplo, ejemplo, Mialee lanza un dormir a una rata (1/4 DG), un kóbold (1 DG), dos gnolls (2 DG) y a un ogro (4 DG). La rata, el kóbold y un gnoll resultan afectados (1/4 + 1 +2 = 3-1/4 DG). Los restantes 1/2 DG no son suficientes como para afectar al otro gnoll o al ogro. Mialee no puede elegir que el conjuro de dormir afecta al ogro o sólo a los dos gnolls. Las criaturas dormidas se consideran inde-

fensas. Abofetear o herir a una de ellas bastará para despertaria, pero el ruido normal no será suficiente. Despertar a una criatura se considera acción estándar (una de las aplicaciones de la acción de prestar avuda).

Dormir no puede tener como objetivo criaturas inconscientes, constructos ni muertos vivientes

Componente material arcano: una pizca de arena muy fina, pétalos de rosa o un grillo vivo.

Dotar de consciencia - Le Transmutación Nivel: Drd 5 Componentes: V, S, FD, PX Tiempo de lanzamiento: 24 horas Alcance: toque Objetivo: animal o árbol tocado Duración: instantáneo Tiro de salvación: Voluntad niega Resistencia a conjuros: sí

Este conjuro hará que dotes a un árbol o animal de consciencia similar a la humana. Para tener éxito, debes realizar un TS de Voluntad (CD 10 + los DG del objetivo o los DG que el árbol tendrá al adquirir consciencia).

El animal o árbol consciente se mostrará amistoso contigo. No tendrás ningún vínculo ni empatía especial con la criatura a la que dotes de consciencia, aunque ésta realizará tareas o encargos concretos si le comunicas tus deseos.

Un árbol dotado de consciencia se considerará objeto animado en lo que se refiere a estadísticas (consulta el Manual de monstruos), excepto en que será una criatura tipo planta y tendrá una puntuación de 3d6 en cada una de las siguientes características: Inteligencia, Sabiduría y Carisma. Las plantas dotadas de consciencia ganarán la aptitud de mover sus raíces, ramas enredaderas y trepadoras, etc. y tendrán sentidos parecidos a los de los humanos.

Un animal dotado de consciencia gana 3d6 en Inteligencia, +1d3 en Carisma y +2 DG. Su tipo pasa a ser bestia mágica (animal aumentado). Un animal dotado de consciencia no puede servir como compañero animal, familiar ni montura especial.

Un árbol o animal al que hayas dotado de consciencia podrá hablar uno de los idiomas que conozcas, más otro idioma conocido por ti por punto de su bonificador de Inteligencia (si es que lo tiene).

Coste en PX: 250 PX.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$una o más criaturas vivas en una explosión de 10' de radio$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'dormir';
update spells set school = $c$Transmutación$c$, description = $c$Transformas un tipo de material en un producto hecho de ese mismo material. Por tanto, podrás construir un puente de madera con unos cuantos árboles, una cuerda usando cáñamo, unos guantes empleando lino o lana, etc. Las criaturas y objetos mágicos no pueden ser creados ni transmutados por medio del conjuro de elaborar. La calidad de los objetos creados mediante este conjuro será proporcional a la de los materiales empleados en su fabricación. Si utilizaras minerales, el objetivo quedaría reducido a 1 pie cúbico por nivel en lugar de 10 pies cúbicos.

Deberás realizar una prueba de la habilidad apropiada de Artesanía en aquellos artículos que requieran un alto grado de artesanía (joyas, espadas, vidrio, cristal, etc.).

El lanzamiento requerirá 1 asalto completo por cada 10 pies cúbicos (o cada pie cúbico en los minerales) de material afectado por el conjuro. Componente material: la materia prima, que cuesta lo mismo que las materias primas necesarias para fabricar el objeto a ser creado.

Elucubración de Mordenkainen Transmutación Nivel: Mag 6 Componentes: V, S Tiempo de lanzamiento: 1 acción estándar Alcance: personal Objetivo: tú Duración: instantáneo

Recuerdas inmediatamente cualquier conjuro de hasta 5.º nivel que hayas usado durante las últimas 24 horas. El sortilegio en cuestión debe haber sido ejecutado por ti durante ese periodo de tiempo, y al recuperarlo quedará almacenado en tu mente como si lo hubieras preparado de la forma normal. Si el conjuro recordado tiene componente material, no podrás ejecutarlo hasta disponer de tal componente.$c$, components = $c$V, S, M$c$, casting_time = $c$ver texto$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$hasta 10 pies cúbicos/nivel; ver texto$c$, duration = $c$instantáneo$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'elaborar';
update spells set school = $c$Adivinación$c$, description = $c$El receptor de este conjuro puede encontrar el camino físico más corto y directo hasta un destino concreto, ya sea para entrar o para salir de un lugar. Este puede estar al aire libre, bajo tierra o ser incluso un conjuro de laberinto. Nótese que el conjuro funciona con respecto a lugares, no a los objetos ni criaturas que pueda haber en ellos. Por tanto, el sortilegio no podría encontrar el camino hasta "un bosque en el que vive un dragón verde" ni hasta "una montaña de pie-

zas de platino", pero sí serviría para salir de un laberinto. El lugar debe encontrarse en el mismo plano en el que estés al lanzar el sortilegio.

El conjuro permite al receptor presentir la dirección correcta que terminaría por llevarle hasta su destino, indicándole en cada momento el camino exacto a seguir o las acciones físicas a Ilevar a cabo. Advertirá, por ejemplo, la presencia de los cables de una trampa o sabrá la palabra adecuada para evitar un glifo custodio. El conjuro terminará cuando el receptor llegue a su destino o expire la duración, lo que suceda en primer lugar. Encontrar la senda puede utilizarse para liberar al receptor y a quienes estén con él de un conjuro de laberinto en un solo asalto. Esta adivinación está vinculada con el receptor, no con sus compañeros, y no prevé ni tiene en cuenta las acciones de las criaturas (ni siquiera las que sirvan de guardianas).

Foco: un conjunto de piezas de adivinación del tipo que prefieras (tabas, palillos, piezas de marfil, runas grabadas, etc.).$c$, components = $c$V, S, F$c$, casting_time = $c$3 asaltos$c$, spell_range = $c$personal o toque$c$, target = $c$tú o la criatura tocada$c$, duration = $c$10 min/nivel$c$, saving_throw = $c$ninguno o Voluntad niega (inofensivo)$c$, spell_resistance = $c$no o sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'encontrar la senda';
update spells set school = $c$A$c$, description = $c$Adquieres una perspicacia intuitiva en lo que se refiere al funcionamiento de las trampas. Esto te permite usar la habilidad de Buscar para detectar trampas igual que hacen los pícaros. Además, obtienes un bonificador introspectivo igual a la mitad de tu nivel de lanzador (máximo +10) en las pruebas de Buscar hechas para encontrar trampas mientras el conjuro esté en efecto.

Ten en cuenta que encontrar trampas no proporciona ninguna aptitud para inutilizar las trampas que puedas encontrar.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$1 min/nivel$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'encontrar trampas';
update spells set school = $c$Nigromancia$c$, description = $c$Al señalar con el dedo y pronunciar el ensalmo, liberas un rayo negro de crepitante energía negativa que suprime la fuerza vital de toda criatura viva a la que alcance. Debes realizar un ataque de toque a distancia para golpear a tu oponente, imponiéndole 1d4 niveles negativos en caso de alcanzarlo.

El receptor morirá si sus niveles negativos llegaran a igualar o superar sus DG. Cada nivel negativo impone los siguientes penalizadores a la víctima: penalizador -1 en las tiradas de ataque, TS, pruebas de habilidad y característica, y nivel efectivo (a la hora de determinar el poder, duración, CD y demás detalles de los conjuros y aptitudes especiales). Además, un lanzador de conjuros perderá un sortilegio o espacio de conjuro (del nivel más alto de que disponga) por nivel negativo que posea. Los niveles negativos se apilan unos con otros.

Suponiendo que el receptor sobreviva, éste recuperará los niveles perdidos cuando hayan transcurrido tantas horas como nivel de lanzador poseas. Normalmente, los niveles negativos tienen la posibilidad de consumir permanentemente los niveles de su receptor, pero los impuestos por el conjuro de enervación no son lo bastante duraderos para conseguirlo.

Si el rayo impacta a una criatura muerta viviente, le concederá durante 1 hora 1d4x5 pg temporales.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$rayo de energía negativa - h 1 4 4$c$, duration = $c$instantáneo 具体 - 合肥市场$c$, saving_throw = $c$ninguno ===================================================================================================================================================$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'enervacion';
update spells set school = $c$Conjuración$c$, subschool = $c$convocación$c$, descriptors = $c$ver texto$c$, description = $c$Este conjuro abre un portal a un plano Elemental. Los druidas pueden elegir el plano en cuestión (Agua, Aire, Fuego o Tierra); un clérigo abrirá el portal hasta el plano que coincida con su dominio.

Cuando el conjuro haya sido completado, aparecerán 2d4 elementales Grandes. Diez minutos más tarde, aparecerán 1d4 elementales Enormes. Diez minutos después, aparecerá un elemental mayor. Cada elemental tendrá el máximo de puntos de golpe por DG. Una vez aparezcan los elementales, estarán a tu servicio mientras dure el conjuro.

Las criaturas te obedecerán explícitamente y no te atacarán bajo ningún concepto, ni siquiera aunque otra persona logre hacerse con su

control. No necesitas concentrarte para mantener controlados a los elementales, y podrás exorcizarlos en cualquier momento, tanto individualmente como en grupos.

Cuando se lanza un conjuro para convocar criaturas de agua, aire, fuego o tierra, éste se convierte en un sortilegio de ese tipo en cuestión. Por ejemplo, el enjambre elemental será un conjuro de fuego cuando lo utilices para convocar elementales de fuego y un conjuro de agua cuando lo utilices para convocar a criaturas de agua.$c$, components = $c$V, S$c$, casting_time = $c$10 minutos$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$dos o más criaturas convocadas (dos criaturas cualesquiera no pueden distar más de 30')$c$, duration = $c$10 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'enjambre elemental';
update spells set school = $c$Transmitación$c$, description = $c$Las hierbas, la maleza, los arbustos e incluso los árboles se retuercen y giran para atrapar a las criaturas que se encuentren en el área o que entren en ella, inmovilizándolas con fuerza y dejándolas enmarañadas. Una criatura puede librarse y desplazarse a la mitad de su velocidad normal si emplea una acción de asalto completo en realizar una prueba de Fuerza o de Escapismo (CD 20). Una criatura que tenga éxito en un tiro de salvación de Reflejos no quedará enmarañada, pero aun así sólo podrá moverse a la mitad de su velocidad normal por el área del conjuro. Cada asalto, durante tu turno, las plantas intentarán atrapar de nuevo a las criaturas que las hayan evitado o se hayan librado de ellas.

Nota: el DM puede alterar en cierto modo los efectos del conjuro, según la naturaleza de las plantas que intenten enmarañar a las criaturas.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$largo (400' + 40'/nivel)$c$, target = $c$plantas en una expansión de 40 pies de radio$c$, duration = $c$1 min/nivel (D)$c$, saving_throw = $c$Reflejos parcial; ver texto$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'enmaranar';
update spells set school = $c$Abjuración$c$, description = $c$Los animales no pueden ver, oir ni oler a las criaturas protegidas. Ni siquiera las capacidades sensoriales extraordinarias o sobrenaturales, como el sentido ciego, la vista ciega, el olfato o el sentido de la vibración pueden detectar ni localizar a las criaturas bajo la custodia. Los animales se limitan a actuar como si estas criaturas no estuviesen allí. Las criaturas bajo la custodia del sortilegio pueden estar delante del más hambriento de los leones sin ser molestadas ni advertidas siquiera. Si una criatura protegida con este conjuro toca a un animal o ataca a cualquier criatura (aunque sea mediante un sortilegio), el conjuro termina para todos los receptores.

Esconderse de los muertos

| ivientes | |
| |--|
| Abjuración | |
| Nivel: Clr 1 | |
| Componentes: V, S, FD | |
| Tiempo de lanzamiento: 1 acción estándar | |
| Alcance: toque | |
| Objetivos: una criatura tocada/nivel | |
| Duración: 10 min/nivel (D) | |
| Tiro de salvación: Voluntad niega | |
| (inofensivo) | |
| Resistencia a conjuros: si | |
| | |

Los animales no pueden ver, oír ni oler a las criaturas protegidas. Ni siquiera las capacidades sensoriales extraordinarias o sobrenaturales, como el sentido ciego, la vista ciega, el olfato o el sentido de la vibración pueden detectar ni localizar a las criaturas bajo la custodia. Los muertos vivientes no inteligentes resultan afectados automáticamente y actúan como si las criaturas custodiadas no estuvieran allí. Los muertos vivientes inteligentes tendrán derecho a realizar un único TS; si éste resulta fallido, tampoco podrán ver a las criaturas custodiadas. No obstante, si tienen razones para creer que hay oponentes invisibles presentes, pueden intentar encontrarlos o golpearlos.

Si uno de los personajes custodiados intenta expulsar, comandar o tocar a los muertos vivientes o atacar a cualquier criatura (incluso mediante un conjuro), el conjuro finalizará para todos los receptores.$c$, components = $c$S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$una criatura tocada/nivel$c$, duration = $c$10 min/nivel (D)$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'esconderse de los animales';
update spells set school = $c$Ilusión$c$, subschool = $c$fantasmagoría$c$, descriptors = $c$enajenador$c$, description = $c$Te permite escribir instrucciones u otro tipo de información sobre pergamino, papel o cualquier otro material que lo permita. La escritura ilusoria parecerá ser extranjera o de naturaleza mágica. Sólo la persona (o personas) designada por ti en el momento del lanzamiento será capaz de entender la escritura, que resultará incomprensible para cualquier otro personaje (aunque un ilusionista la reconocerá como escritura ilusoria).

Toda criatura no autorizada que intente leer el escrito desencadenará un poderoso efecto ilusorio y deberá realizar un TS. Un resultado de éxito indica que la criatura logra apartar la mirada, sintiéndose un poco desorientada; uno de fallo indica que la criatura se convierte en receptora de una sugestión implantada por ti en la escritura en el momento de ejecutar el sortilegio. Esta sugestión dura solamente 30 minutos, y entre las más típicas se encuentra: "cierra el libro y vete", "olvida que este libro existe", etc. Si es disipada con éxito por medio de un disipar magia, la escritura ilusoria y su mensaje secreto desaparecerán. El mensaje oculto puede ser leído combinando el sortilegio visión verdadera con otro de leer magia o de comprensión idiomática.

El tiempo de lanzamiento depende de la extensión del mensaje que desees escribir, pero siempre será 1 minuto como mínimo.

Componente material: tinta con base de plomo (con un coste mínimo no inferior a 50 po).$c$, components = $c$V, S, M$c$, casting_time = $c$1 minuto o más; ver texto$c$, spell_range = $c$toque$c$, target = $c$un objeto tocado, que no pese más de 10 lb$c$, duration = $c$1 día/nivel (D)$c$, saving_throw = $c$Voluntad niega; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'escritura ilusoria';
update spells set school = $c$Abjuración$c$, descriptors = $c$fuerza$c$, description = $c$11 2102

Este conjuro crea un disco de fuerza, móvil e invisible, del tamaño de un escudo pavés que flota delante de ti negando el efecto de los proyectiles mágicos dirigidos contra ti. El disco además proporciona un bonificador +4 de escudo a la CA. Este bonificador se aplica contra los ataques de toque incorporales, ya que es un efecto de fuerza. El escudo no tiene penalizador de armadura ni posibilidad de fallo de conjuro arcano. A diferencia de un escudo pavés normal, no puedes utilizar el escudo para obtener cobertura.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal Obietivo: tú$c$, duration = $c$1 min/nivel (D)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'escudo';
update spells set school = $c$Abjuración$c$, description = $c$En torno a ti aparece un campo mágico que brilla con una caótica explosión de tonalidad multicolor. Este campo desvía las flechas, rayos y demás ataques a distancia que se aproximen a ti. Todo ataque a distancia dirigido contra ti en el que el atacante realice una tirada de ataque (incluyendo flechas, flechas mágicas, flecha ácida de Melf, rayo de debilitamiento, etc.) tiene un 20% de posibilidad de fallo (similar al efecto de la ocultación). Otros ataques que simplemente funcionen desde lejos, como el aliento de los dragones, no resultan afectados.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal Obietivo: tú$c$, duration = $c$1 min/nivel (D)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'escudo de entropia';
update spells set school = $c$Evocación$c$, descriptors = $c$frío o fuego$c$, description = $c$Este conjuro te envuelve en llamas e inflige daño a toda criatura que te ataque en cuerpo a cuerpo. Las llamas también te protegen contra los ataques basados en el fuego o en el frío (según elijas).

Toda criatura que te golpee usando un arma natural o empuñada te infligirá el daño normal, pero, a la vez, ella sufrirá 1d6 puntos de daño, +1 punto adicional por nivel de lanzador que poseas (máx. +15). Este daño será por frío (si el escudo protege contra efectos basados en el fuego) o por fuego (si protege contra los basados en el frío). La RC de los atacantes se aplicará a este efecto. Ten en cuenta que las armas con un alcance excepcional, como las lanzas largas, no pondrán en peligro a sus usuarios si te atacan.

Al lanzar este conjuro, parecerás estar inmolándote, pero, en realidad, las llamas serán delgadas y tenues, no desprenderán calor alguno y sólo iluminarán la mitad que una antorcha normal (10 pies). El color de las llamas se determina al azar (50% de ser un color o el otro): azuladas o verdosas, si se ejecuta el conjuro de escudo gélido; y violáceas o azuladas, si se utiliza el escudo cálido. Éstos son los poderes de cada versión: Escudo cálido: las llamas son cálidas al tacto.

Sólo sufres la mitad del daño infligido por ataques basados en el frío. Cuando éstos permitan realizar un TS de Reflejos para sufrir la mitad del daño, un resultado de éxito evitará que el ataque te inflija daño alguno.

Escudo gélido: las llamas son frías al tacto. Sólo sufres la mitad del daño infligido por ataques basados en el fuego. Cuando éstos permitan realizar un TS de Reflejos para sufrir la mitad del daño, un resultado de éxito evitará que el ataque te inflija daño alguno.

Componente material arcano: un poco de fósforo para el escudo cálido; una luciérnaga viva (o las colas de cuatro muertas) para el escudo gélido.

Escudo de la fe Abjuración Nivel: Clr 1$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$1 asalto/nivel (D)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'escudo de fuego';
update spells set school = $c$Abjuración$c$, descriptors = $c$legal$c$, description = $c$Un tenue brillo azulado rodea a los receptores, protegiéndolos contra los ataques, concediéndoles protección contra los conjuros lanzados por criaturas caóticas y ralentizando a las criaturas de ese alineamiento que logren alcanzarlos con sus ataques. Esta abjuración posee cuatro efectos: En primer lugar, las criaturas custodiadas obtienen un bonificador +4 de desvío a la CA y un bonificador +4 de resistencia en sus TS. Al contrario que sucede con protección contra el caos, este beneficio se aplica contra todos los ataques, no sólo contra los procedentes de criaturas caóticas.

En segundo lugar, las criaturas custodiadas ganan RC 25 contra los conjuros caóticos y los sortilegios ejecutados por criaturas caóticas. En tercer lugar, la abjuración bloquea la posesión y la influencia mental del mismo modo que protección contra el caos.

Por último, las criaturas caóticas que logren alcanzar con un ataque cuerpo a cuerpo a un defensor custodiado por el conjuro quedarán ralentizadas (Voluntad niega, igual que sucede con el conjuro de ralentizar, pero con la CD de salvación del escudo de la ley).

Foco: un pequeño relicario que contenga una reliquia sagrada, como un fragmento de pergamino de un texto sagrado legal. El relicario costará 500 po como mínimo.$c$, components = $c$V, S, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$20 pies$c$, target = $c$una criatura/nivel en una explosión de 20' de radio, centrada en ti$c$, duration = $c$1 asalto/nivel (D)$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'escudo de la ley';
update spells set school = $c$Adivinación$c$, subschool = $c$escudriñamiento$c$, description = $c$Te permite ver y oír a una criatura, que puede estar a cualquier distancia. Si el objetivo tiene éxito en una salvación de Voluntad, el intento de escudriñamiento simplemente falla. La dificultad de la salvación dependerá de lo bien que conozcas al receptor del conjuro y del tipo de conexión física (si la hay) que te una a tal criatura. Además, si el receptor se encuentra en otro plano, recibirá un bonificador +5 a su salvación de Voluntad.

| | Modificador a la |
| | |
| Conocimiento | salvación de Vol |
| Ninguno | +10 |
| Por terceros (has oído hablar del receptor) +5 | |
| Personal (te has encontrado con el receptor)+0 | |
| Familiar (conoces bien al receptor) | -5 |
| Debes poseer algún tipo de conexión con una | |
| criatura a la que no conozcas. | |
| | |
| | Modificador a la |
| Conexion | salvación de Vol |
| Retrato o cuadro | |

| Posesión o prenda | |
| | |
| Fragmento corporal, mechón, | -10 |
| cabello, recorte de uña, etc. | |
| Li la celvecion to la prodoc var para no escu- | |

Si la salvación falla, puedes ver (pero no char) al objetivo y a la zona circundante (aproximadamente 10' en todas las direcciones desde el objetivo). Si este se mueve, el sensor le sigue a una velocidad de hasta 150'.

Como sucede con todos los conjuros de adivinación (escudriñamiento), el sensor tendrá toda tu agudeza visual, incluyendo cualquier efecto mágico. Además, los siguientes conjuros tienen un 5% por nivel de lanzador de funcionar a través del sensor: cuchichear mensaje, detectar el bien, detectar el caos, detectar la ley, detectar magia y detectar el mal.

Si la salvación tiene éxito, no puedes intentar escudriñar de nuevo a ese objetivo durante 24 horas.

Componentes materiales arcanos: el ojo de un halcón, un águila o incluso un roc, además de ácido nítrico, cobre y cinc.

Foco para bardos, hechiceros y magos: un espejo | de fina manufactura, hecho de plata muy pulida, por un precio no inferior a 1.000 po. Sus medidas han de ser 2' × 4', como mínimo.

Foco para clérigos: una pila para el agua bendita, por un valor mínimo de 100 po.

Foco para druidas: un estanque natural.$c$, components = $c$V, S, M/FD, F$c$, casting_time = $c$1 hora$c$, spell_range = $c$ver texto$c$, target = $c$sensor magico$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'escudrinamiento';
update spells set school = $c$Adivinación$c$, subschool = $c$escudriñamiento$c$, description = $c$Este conjuro funciona como escudriñamiento, a excepción de lo indicado más arriba. Además,

los siguientes conjuros podrán ser ejecutados a la perfección a través del sensor: cuchichear mensaje, detectar el bien, detectar el caos, detectar la ley, detectar magia, detectar el mal, don de lenguas y leer magia.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, duration = $c$1 h/nivel$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'escudrinamiento mayor';
update spells set school = $c$Transmutación$c$, description = $c$Cambias los sonidos producidos por los objetos o las criaturas. Puedes crear sonidos donde no los haya (por ejemplo, haciendo cantar a los árboles), amortiguar los existentes (evitando que un grupo de aventureros haga ruido) o transformar unos en otros (por ejemplo, haciendo que la voz de un lanzador de conjuros suene como un cerdo). Todos los objetos o criaturas afectados han de ser transmutados del mismo modo. La transmutación no puede cambiarse una vez se ha realizado

Podrás cambiar las cualidades de los sonidos, pero te resultará imposible crear palabras con las que no estés familiarizado. Por ejemplo, no podrías usar tu voz para pronunciar la palabra de mando que activara un objeto mágico sin conocer la palabra de mando en cuestión.

Los lanzadores de conjuros cuya voz sea transformada drásticamente (como el citado mago que chillaba como un cerdo) no podrán ejecutar sortilegios que tengan componente verbal.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25 + 5'/2 niveles)$c$, target = $c$una criatura u objeto/nivel; dos receptores cualesquiera no pueden distar más de 30'<br>$c$, duration = $c$1 h/nivel (D)$c$, saving_throw = $c$Voluntad niega (objeto)$c$, spell_resistance = $c$sí (objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'esculpir sonido';
update spells set school = $c$Evocación$c$, descriptors = $c$frío$c$, description = $c$Este conjuro crea una un globo helado de energía de frío que surge de las yemas de tus dedos e impacta en el lugar que determines, estallando en una explosión de 10' de radio que inflige 1d6 puntos de daño por frío por nivel de lanzador (máximo 15d6) a toda criatura en su área. Una criatura elemental (agua) recibirá en lugar de ello 1d8 puntos de daño por frío por nivel de lanzador (máximo 15d8).

Si la esfera congelante impacta en una masa de agua o de otro líquido que esté compuesto principalmente de agua (no incluidas las criaturas basadas en el agua), esta congelará el líquido

hasta una profundidad de 6" en un área equivalente a 100 pies cuadrados (un cuadro de 10' de lado) por nivel de lanzador (máximo 1.500 pies cuadrados). El hielo creado por este efecto durará 1 asalto por nivel de lanzador. Las criaturas que estén nadando en la superficie del agua congelada quedarán atrapadas en el hielo. Intentar liberarse requerirá una acción de asalto completo y la criatura atrapada necesitará tener éxito en una prueba de Fuerza (CD 25) o de Escapismo (CD 25) para conseguirlo.

Puedes retener el lanzamiento del globo después de completar el conjuro, si así lo deseas. Considéralo entonces como si fuese un conjuro de toque en el cual estuvieses reteniendo la descarga (ver pág. 176). Puedes retener la descarga hasta 1 asalto por nivel, y si no la has descargado al final de este tiempo la esfera congelante explotará centrada en ti (sin que recibas un tiro de salvación para resistir sus efectos). Disparar el globo en un asalto posterior es una acción estándar.

Foco: una pequeña esfera de cristal.$c$, components = $c$V, S, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$largo (400' + 40'/nivel)$c$, target = $c$ver texto$c$, duration = $c$instantáneo o 1 asalto/nivel; ver texto$c$, saving_throw = $c$Reflejos mitad; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'sfera congelante de otiluke';
update spells set school = $c$Ilusión$c$, subschool = $c$engaño$c$, description = $c$Este conjuro funciona como invisibilidad, salvo en que confiere invisibilidad a todas las criaturas en un radio de 10' del receptor. El centro del efecto se moverá con el receptor.

Los afectados por el conjuro podrán verse unos a otros, así como a ellos mismos. Toda criatura afectada que se mueva fuera del área se volverá visible, pero las que penetren en ésta después del lanzamiento del conjuro no se volverán invisibles. Toda criatura afectada (que no sea el receptor) negará su propia invisibilidad en cuanto ataque. Si el que ataca es el receptor del conjuro, la esfera de invisibilidad terminará de inmediato.$c$, components = $c$V, S, M$c$, target = $c$esfera de 10' de radio alrededor de la criatura u objeto tocado$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'esfera de invisibilidad';
update spells set school = $c$Evocación$c$, descriptors = $c$fuego$c$, description = $c$Este conjuro genera un globo ardiente que gira en la dirección que indiques, quemando todo lo que toca. El efecto se mueve a 30' por asalto, y puede ascender o saltar hasta 30' de altura para alcanzar un objetivo. Si entra en un espacio ocupado por una criatura, deja de moverse durante ese asalto y le inflige 2d6 puntos de daño por fuego (la víctima puede negar este daño con un tiro de salvación con éxito de Reflejos). Una esfera flamígera rueda sobre las barreras que tengan menos de 4' de alto, como muebles o paredes bajas; además, prende fuego a las sustancias inflamables que toque e ilumina el área como si se tratara de una antorcha.

La esfera se desplazará mientras la dirijas activamente (lo cual será una acción de movimiento para ti); de lo contrario, seguirá ardiendo sin moverse del sitio. El efecto puede ser apagado por cualquier medio capaz de extinguir un fuego normal de sus mismas dimensiones. La superficie de la esfera tiene una consistencia flexible y esponjosa y, por tanto, no infligirá más daño que el producido por sus llamas. No puede empujar a las criaturas que se resistan a moverse ni derribar los obstáculos de gran tamaño. La esfera desaparecerá si supera el alcance del conjuro.

Componentes materiales arcanos: un poco de sebo, una pizca de azufre y un poco de hierro pulverizado (para espolvorear).$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$esfera de 5' de diámetro$c$, duration = $c$1 asalto/nivel$c$, saving_throw = $c$Reflejos niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'esfera flamigera';
update spells set school = $c$Abjuración$c$, description = $c$Este conjuro funciona como muro prismático, salvo en que te permite conjurar un globo inmóvil, opaco y de brillante luz multicolor, que te rodea y protege contra todas las formas de ataque. La esfera despedirá luz de todos los colores del espectro visible.

El efecto cegador de la esfera en criaturas con 8 DG o menos dura 2d4 × 10 minutos.

Podrás entrar y salir de la esfera prismática y permanecer cerca de ella sin sufrir daño por ello. No obstante, mientras estés dentro de ella, la esfera bloqueará todo intento de proyectar algo a través de sus paredes (incluyendo conjuros). Las demás criaturas que intenten atacarte o atravesar la esfera sufrirán una vez el efecto de cada color.

Lo más normal es que sólo exista el hemisferio superior del globo, pues tú estarás en el centro de la esfera; por tanto, la mitad inferior suele estar bajo el suelo en que te encuentres.

Los colores de la esfera generan los mismos efectos que los de un muro prismático.

Esfera prismática puede ser hecha permanente mediante un conjuro de permanencia.$c$, components = $c$V$c$, spell_range = $c$10'$c$, target = $c$esfera de 10' de radio, centrada en ti$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'esfera prismatica';
update spells set school = $c$Evocación$c$, descriptors = $c$fuerza$c$, description = $c$Este conjuro funciona como la esfera elástica de Otiluke, pero las criaturas u objetos que haya en su interior apenas pesarán. Todo lo que haya dentro de este efecto mágico pesará una dieciseisava parte de lo normal y el conjuro te permitirá elevar la esfera telecinéticamente siempre que el peso real de su contenido no supere las 5.000 libras. El alcance del control telecinético será intermedio (100' + 10'/nivel) desde el lugar en que te encuentres cuando la esfera haya logrado encerrar a su contenido.

Concentrándote en ella, podrás mover los objetos y criaturas que haya en su interior, siempre y cuando su peso real no supere las 5.000 libras. Podrás empezar a mover el globo un asalto después de haber ejecutado el sortilegio. Concentrándote (como acción estándar), podrás desplazar la esfera hasta 30' por asalto. Si dejas de concentrarte, el globo no se moverá durante ese asalto (en caso de estar sobre una superficie igualada) o descenderá a su velocidad normal de caída (en caso de estar elevada) hasta llegar a una superficie igualada, hasta que expire el conjuro o hasta que vuelvas a concentrarte en ella. Si dejas de concentrarte en la esfera (ya sea voluntariamente o por haber fallado una prueba de Concentración), podrás reanudar la concentración en tu siguiente turno o cualquier turno subsiguiente mientras dure el sortilegio.

La esfera caerá solamente a un ritmo de 60' por asalto, velocidad insuficiente como para que su contenido resulte dañado.

Podrás mover la esfera por medios telecinéticos aunque te encuentres en su interior. Componentes materiales: un fragmento semiesférico de cristal transparente, un fragmento semiesférico de goma arábiga que encaje con el de cristal y un par de barritas magnéticas.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$esfera de 1' de diámetro/nivel, centrada en torno a criaturas u objetos$c$, duration = $c$1 min/nivel (D)$c$, saving_throw = $c$Reflejos niega (objeto)$c$, spell_resistance = $c$sí (objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'esfera telecinetica de otiluke';
update spells set school = $c$Evocación$c$, descriptors = $c$fuerza$c$, description = $c$Este conjuro te permite crear un plano brillante de fuerza similar a una espada. Comenzando en el asalto en que lances el conjuro, el arma podrá atacar a quien desees, siempre y cuando esté dentro del alcance. La espada atacará a la víctima que hayas elegido una vez por asalto durante tu turno. Su bonificador de ataque es igual a tu nivel + tu bonificador de Inteligencia o de Carisma (para magos y hechiceros, respectivamente), con un bonificador +3 de mejora adicional. Al tratarse de un efecto de fuerza, puede alcanzar a las criaturas etéreas e incorporales. El arma inflige 4d6 + 3 puntos de daño y tiene un rango de amenaza de 19-20 y crít. ×2. La espada siempre golpeará desde la dirección en la que te encuentres y no obtendrá bonificador alguno por flanquear ni tampoco facilitará que otro contendiente lo haga. Si en algún momento la espada llega a superar el alcance del conjuro, desaparece de tu vista o deja de ser dirigida por ti, volverá hasta ti y se quedara flotando a tu lado.

Cada asalto después del primero, puedes usar una acción estándar para que el arma cambie de objetivo; si no lo haces, la espada atacará de nuevo a la misma víctima que en el asalto anterior. La espada no puede ser atacada ni dañada mediante ataques físicos, pero resultará afectada por los conjuros de disipar magia y desintegrar, por una esfera de aniquilación o por un cetro de cancelación. Su CA es de 13 (10, bonificador +0 de tamaño por ser un objeto mediano, bonificador +3 de desvió).

Si una criatura atacada tiene RC, ésta sólo se comprobará la primera vez que sea golpeada por la espada de Mordenkainen. Si la víctima logra resistirse con éxito al efecto, el conjuro será disipado; si no, la espada surtirá su efecto completo sobre la criatura mientras dure el sortilegio.

Foco: una espada de platino en miniatura, con la empuñadura y el pomo hechos de cobre y cinc (fabricar esta pieza cuesta 250 po).$c$, components = $c$V, S, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una espada$c$, duration = $c$1 asalto/nivel (D) D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'espada de mordenkainen';
update spells set school = $c$Evocación$c$, descriptors = $c$bien$c$, description = $c$Este conjuro te permite canalizar el poder divino hacia tu espada, o cualquier otra arma de cuerpo a cuerpo que elijas, que actuará como un arma sagrada +5 (bonificador +5 de mejora en las tiradas de ataque y daño, e inflige 2d6 puntos de daño adicionales contra los oponentes malignos). Además, la espada emite un círculo mágico contra el mal (igual que el conjuro); si éste finalizara, la espada crearía uno nuevo en tu turno como acción gratuita. El conjuro quedará cancelado automáticamente 1 asalto después de que el arma abandone tu mano (por la razón que sea). No puedes tener más de una espada sagrada a la vez.

Si este conjuro se lanza sobre un arma mágica, los poderes del conjuro prevalecerán sobre los que el arma tenga normalmente; los poderes y bonificadores de mejora que tenga el arma mágica no funcionarían mientras el conjuro de espada sagrada esté activo. Este sortilegio no puede acumularse con bendecir arma ni con cualquier otro conjuro que pueda modificar el arma, sin importar cómo lo haga.

Este conjuro no funciona sobre los artefactos.

Nota: el bonificador al ataque de un arma de gran calidad no puede apilarse con un bonificador de mejora al ataque.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$arma de cuerpo a cuerpo tocada$c$, duration = $c$1 asalto/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no ===================================================================================================================================================$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'espada sagrada';
update spells set school = $c$Nigromancia$c$, descriptors = $c$enajenador, miedo$c$, description = $c$Este conjuro funciona igual que causar miedo, salvo en que hace que todos los objetivos que tengan 6 DG o menos queden asustados.

Componente material: un trozo de hueso de unos de estos muertos vivientes: esqueleto, zombi, necrófago, necrario o momia.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$una criatura viva por cada tres niveles; dos cualesquiera no pueden distar más de 30'$c$, duration = $c$1 asalto/nivel o 1 asalto; ver el texto de causar miedo$c$, saving_throw = $c$Voluntad parcial$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'espantar';
update spells set school = $c$A$c$, description = $c$Este conjuro funciona igual que terreno alucinatorio, pero te permite hacer que una zona parezca distinta de cómo es en realidad. La ilusión incluirá elementos audibles, visuales, táctiles y olfativos. Al contrario que sucede con el terreno alucinatorio, el conjuro puede cambiar la apariencia de los edificios (o incluirlos allá donde no los hubiera). Aun así, el conjuro no podrá disfrazar, ocultar ni añadir criaturas (aunque las criaturas que se encuentren en el área podrían valerse de los escondrijos de la ilusión igual que harían en un lugar real).$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, target = $c$un cubo de 20'/nivel (Mo)$c$, duration = $c$concentración + 1 h/nivel (D)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'foneiismo arcano';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Este conjuro imbuye a los receptores de una poderosa esperanza. Cada criatura afectada obtiene un bonificador +2 de moral en los TS, tiras de ataque, pruebas de habilidad, pruebas de característica y tiradas de daño con arma.

Esperanza alentadora contrarresta y disipa desesperación aplastante.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$o área: una criatura viva/nivel, dos cualesquiera no pueden distar más$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega
- (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'esperanza alentadora';
update spells set school = $c$Transmutación$c$, description = $c$La criatura transmutada por este conjuro se vuelve más desenvuelta, más elocuente y con una personalidad más firme.. El conjuro otorga un bonificador +4 de mejora al Carisma, proporcionando los beneficios usuales a las habilidades relacionadas con el Carisma. Los hechiceros y bardos (y otros lanzadores de conjuros que se basen en el Carisma) que reciban este conjuro no obtiene conjuros adicionales por el aumento de la característica, pero sí ven aumentada la CD de sus conjuros. 11 1

Componente material arcano: Unas cuantas plumas o una pizca de heces de un águila.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'esplendor de aguila';
update spells set school = $c$Evocación$c$, description = $c$Este conjuro crea un fuerte zumbido que puede hacer estallar los objetos quebradizos de naturaleza no mágica, romper un solo objeto sólido no mágico o infligir daño a una criatura cristalina. Cuando se utiliza como ataque de área, el conjuro destruye todos los objetos no mágicos que estén hechos de vidrio, cristal, cerámica o porcelana, como viales, botellas, frascos, botijas, espejos, etc. Todos los objetos de ese tipo que haya en un radio de 5' del punto de origen se romperán en mil pedazos por el sortilegio. Los objetos que pesen más de una libra, multiplicada por tu nivel de lanzador, no resultarán afectados, pero todos los demás que posean la composición apropiada estallarán sin remedio. Otra opción es romper un solo objeto sólido, sin importar su composición, que pese, como máximo, 10 lb. por nivel de lanzador que poseas.

Al ser dirigido contra una criatura cristalina (del peso que sea), el conjuro infligirá 1d6 puntos de daño por nivel de lanzador (máx. 10d6), aunque la víctima podrá realizar un TS de Fortaleza para sufrir sólo la mitad de daño. Componente material arcano: un trocito de mineral de mica.$c$, components = $c$V. S. M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles) Area u objetivo: expansión de 5 pies de radio; o un objeto sólido o una criatura cristalina$c$, duration = $c$instantáneo$c$, saving_throw = $c$Voluntad niega (objeto); Voluntad niega (objeto) o Fortaleza mitad; ver texto$c$, spell_resistance = $c$sí (objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'estallar';
update spells set school = $c$Transmutacion$c$, description = $c$Si tienes éxito en un ataque de toque en cuerpo a cuerpo, harás que el receptor entre en un estado de animación suspendida. El tiempo dejará de pasar para la criatura y su situación se vuelve fija. La criatura no envejecerá, sus funciones vitales prácticamente cesarán y ninguna fuerza ni efecto podrá hacerle ningún daño. Tal estado continuará hasta que la magia sea eliminada (como mediante un conjuro de disipar magia con éxito o un conjuro de libertad).

Componentes materiales: unos polvos compuestos de polvo de diamante, esmeralda, rubí y zafiro, cuyo valor total ha de ser, como mínimo, de 5.000 po. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$permanente$c$, saving_throw = $c$Fortaleza niega$c$, spell_resistance = $c$si$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'estasis temporal';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro hace que el receptor se transforme en piedra sólida, incluyendo la ropa y equipo que vista o porte. En forma de estatua, el receptor adquirirá una dureza de 8, además de retener sus propios puntos de golpe.

El receptor podrá ver, oír y oler con total normalidad, pero no necesitará comer ni respirar. Su tacto quedará limitado a aquellas sensaciones que puedan afectar a la sustancia granítica que compondrá su cuerpo. Las lascas que se le desprendan corresponderán a simples rasguños, pero romper uno de sus brazos supondría un daño más grave.

Mientras dure el conjuro, el individuo que esté bajo sus efectos podrá volver a su estado normal, actuar y, a continuación, recuperar instantáneamente su forma de estatua (como acción gratuita), siempre que lo desee y mientras dure el efecto.

Componentes materiales: cal, arena y una gota de agua, todo ello removido con una barra de hierro, como un clavo o una púa.$c$, components = $c$V. S. M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$1 h/nivel (D)$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'estatua';
update spells set school = $c$Ilusión$c$, subschool = $c$sombra$c$, description = $c$Te permite manipular la energía del plano de la Sombra para ejecutar versiones, ilusorias y cuasirreales, de conjuros de evocación de mago y hechicero de nivel 4.º o inferior (cuando un conjuro tenga más de un nivel, utiliza el que más te convenga).

Los conjuros que infligen daño, como rayo relampagueante, tienen sus efectos normales salvo que una criatura afectada tenga éxito en una salvación de Voluntad. Todas las criaturas que descrean la ilusión reciben sólo un quinto del daño del ataque. Si el ataque descreído tiene un efecto especial que no sea daño, ese efecto sólo tendrá 1/5 de su fuerza (si es aplicable) o sólo tendrá un 20% de posibilidades de darse. Si es reconocido como una evocación sombría, un conjuro que cause daño sólo infligirá 1/5 (20%) de su daño. Sin importar cuál sea el resultado del TS para descreer, las criaturas afectadas por tales evocaciones tendrán derecho a todo TS (o resistencia a conjuros) permitido por el sortilegio en cuestión, aunque la CD del mismo se corresponderá con el nivel de la evocación sombría (5.º) y no con el nivel del sortilegio normal.

Los efectos que no inflijan daño, como ráfaga de viento tienen sus efectos normales salvo contra aquellos que los descreen. En ese caso no tiene efecto.

Los objetos tienen éxito automáticamente en sus salvaciones de Voluntad contra este conjuro.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$ver texto$c$, target = $c$ver texto$c$, duration = $c$ver texto$c$, saving_throw = $c$Voluntad descree (si se interactua con el conjuro) Resistencia a conimros: si$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'evocacion sombria';
update spells set school = $c$Transmutación$c$, description = $c$Te vuelves etéreo junto a tu equipo. Durante la duración del conjuro estás en un lugar llamado plano Etéreo, que se solapa con el mundo normal o físico llamado plano Material. Cuando el sortilegio expire, regresas a tu existencia material. Una criatura etérea es invisible e incorporal, y puede moverse en cualquier dirección, incluso hacia arriba o hacia abajo (aunque a la mitad de su velocidad normal). Como criatura insustancial, podrás moverte a través de los objetos sólidos, incluyendo las criaturas vivas. Una criatura etérea puede ver y oír lo que sucede en el plano Material, aunque todo les parecerá gris e irreal. La vista y el oído de lo que suceda en el plano Material quedará limitado a 60 pies. Los efectos de fuerza (como proyectil mágico y muro

de fuerza) y las abjuraciones te afectarán normalmente. Sus efectos se extenderán desde el plano Material hasta el Etéreo, pero no a la inversa. Una criatura etérea no puede atacar a enemigos materiales y los conjuros que lances siendo etéreo sólo afectarán a otras criaturas etéreas. Ciertas criaturas u objetos materiales disponen de ataques y efectos que afectan el plano Etéreo (como el ataque de mirada del basilisco). Trata a las demás criaturas y objetos etéreos como si fueran materiales.

Si terminas el conjuro y te materializas en el interior de un objeto material (como una pared) serás apartado hasta el espacio vacío más cercano y sufrirás 1d6 puntos de daño por cada 5 pies de desplazamiento.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$1 asalto/nivel (D)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'excursion eterea';
update spells set school = $c$Abjuración$c$, description = $c$Este conjuro obliga a una criatura extraplanaria a regresar a su correspondiente plano, si falla una salvación de Voluntad especial (CD = CD de la salvación del conjuro - DG de la criatura + tu nivel del lanzador). Si el conjuro tiene éxito, la criatura será expulsada instantáneamente, pero habrá un 20% de posibilidades de que la criatura sea enviada por error a un plano distinto del suvo.

| xpiación |
| |
| Abjuración |
| Nivel: Clr 5, Drd 5 |
| Componentes: V, S, M, F, FD, PX |
| Tiempo de lanzamiento: 1 hora |
| Alcance: toque |
| Objetivo: criatura viva tocada |
| Duración: instantaneo |
| Tiro de salvación: ninguno |
| Resistencia a conjuros: sí |
| |

Este conjuro libera de la carga impuesta por las faltas y malas obras del receptor. La criatura que desee expiarse debe estar verdaderamente arrepentida y deseosa de enmendar sus errores. Si la criatura cometió la mala obra involuntariamente o por culpa de alguna forma de compulsión, la expiación funcionará normalmente sin coste alguno para ti. No obstante, si se tratara de alguien que quisiera expiar una fechoría voluntaria y actos llevados a cabo con plena consciencia, deberías interceder ante tu deidad (pagando 500 puntos de experiencia) para poder librar de su carga a la criatura. Naturalmente, hay mucha gente que, antes de lanzar este conjuro, impone al interesado un empeño (consulta geas/empeño) u otra penitencia similar para determinar si la criatura en cuestión está verdaderamente arrepentida.

Expiación puede lanzarse con varios propósitos, dependiendo de la versión elegida:

Invertir un cambio mágico de alineamiento: si el alineamiento de una criatura hubiera sido alterado mágicamente, este conjuro lo devolvería a su estado original sin coste alguno de puntos de experiencia.

Restablecer una clase: un paladín que haya perdido sus rasgos de clase por cometer un acto de maldad podría recuperar su condición de paladín por medio de este conjuro.

Restablecer la capacidad y poderes para los conjuros de clérigos y druidas: un clérigo o druida que haya perdido su capacidad de lanzar conjuros por haber incurrido en la ira de su dios puede recuperar tales poderes expiándose ante otro clérigo de la misma deidad o ante otro druida. Si la violación fue intencionada, el clérigo que ejecute el sortilegio perderá 500 PX por interceder ante la deidad; si la trasgresión fue involuntaria, no habrá coste en PX.

Redención o tentación: puedes lanzar este conjuro sobre una criatura de alineamiento opuesto, ofreciéndole la posibilidad de cambiar su moralidad para que se acerque a la tuya. El posible receptor ha de estar presente durante todo el proceso de lanzamiento. Al completarse el conjuro, el receptor elegirá libremente si conserva su alineamiento original o si consiente en aceptar tu oferta y adquirir el mismo que tengas tú. Ninguna coacción, compulsión ni influencia mágica podrá obligar a la criatura a aceptar la oportunidad ofrecida si no está dispuesta a abandonar voluntariamente su viejo alineamiento. El uso de este conjuro no funciona sobre los ajenos o cualquier otra criatura incapaz de cambiar su alineamiento de manera natural.

Aunque la descripción del conjuro se refiere a actos malignos, expiación también puede usarse con cualquier criatura que haya realizado actos contra su alineamiento, sean estos malignos, buenos, caóticos o legales.

Nota: normalmente, cambiar de alineamiento es algo que queda en manos del jugador (para el caso de los PJs) o del DM (para los PNJs). Este uso de la expiación sólo ofrece una forma creíble de que el personaje pueda cambiar de alineamiento drástica, repentina y definitivamente.

Componente material: incienso que ha de quemarse.

Foco: además de tu símbolo sagrado o foco divino normal, necesitarás un rosario (u otro objeto relacionado con la plegaria, como una rueda o un libro de oraciones) por un valor mínimo de 500 po.

Coste en PX: cuando lances el conjuro en beneficio de criaturas cuya culpabilidad fuera el resultado de actos deliberados, cada ejecución del conjuro te costará 500 PX (véase más arriba).$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura extraplanaria$c$, duration = $c$instantáneo$c$, saving_throw = $c$Voluntad niega; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'exorcismo';
update spells set school = $c$Evocación$c$, descriptors = $c$sónico$c$, description = $c$Haces sonar una tremenda cacofonía dentro del área del conjuro. Las criaturas que se encuentren en ella sufrirán 1d8 puntos de daño sónico y deben tener éxito en un TS de Fortaleza para evitar quedar aturdidas durante 1 asalto.

Las criaturas que no puedan oír no quedarán aturdidas, pero sufrirán daño igualmente. Foco arcano: un instrumento musical.$c$, components = $c$V, S, F/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$expansión de 10' de radio$c$, duration = $c$instantáneo$c$, saving_throw = $c$Fortaleza parcial$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'explosion de sonido';
update spells set school = $c$Evocación$c$, descriptors = $c$luz$c$, description = $c$Este conjuro hace que un globo de calor y radiación abrasadores explote en silencio a partir del punto que elijas. Todas las criaturas que se encuentren en el globo quedarán cegadas y sufrirán 6d6 puntos de daño. Una criatura para la cual la luz del sol sea dañina o antinatural recibe doble daño. Tener éxito en un TS de Reflejos negará la ceguera y reducirá el daño a la mitad.

Los muertos vivientes envueltos por la luz sufrirán 1 d6 puntos de daño por nivel de lanzador (máx. 25d6), la mitad si tienen éxito en su salvación de Reflejos. Además, la explosión destruirá directamente a los muertos vivientes que resulten afectados por la luz solar (como los vampiros) si fallan su TS.

La luz ultravioleta generada por el sortilegio infligirá daño a los hongos, mohos, cienos, limos, gelatinas, pudines y criaturas fúngicas, igual que si fueran muertos vivientes.

Explosión solar disipa cualquier conjuro de oscuridad de hasta nivel 8.º en su área.

Componente material arcano: un fragmento de piedra de sol (un feldespato irisado de tonos rojizos) y una llama descubierta.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$largo (400' + 40'/nivel)$c$, target = $c$explosión de 80' de radio$c$, duration = $c$instantáneo$c$, saving_throw = $c$Reflejos parcial; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'explosion solar';
update spells set school = $c$Nigromancia$c$, description = $c$Empleas el poder de la muerte viviente para otorgarte una aptitud limitada para evitar la muerte. Mientras este conjuro esté en efecto, obtienes puntos de golpe temporales por un valor de 1d10 + 1 por nivel de lanzador (máximo +10).

Componente material: una pequeña cantidad de alcohol o licor destilado, que utilizas para trazar ciertos símbolos en tu cuerpo durante el lanzamiento. Estos no pueden ser vistos una vez que el alcohol o licor se evapora.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estánda$c$, spell_range = $c$personal$c$, target = $c$tú Children Service Personal Construction Construction Corporation Coronal$c$, duration = $c$1 hora/nivel o hasta que sea descargado; ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'falsa vida';
update spells set school = $c$Nigromancia$c$, descriptors = $c$enajenador, miedo$c$, description = $c$Esta conjuro transmite a un solo receptor un terrible pavor que hace que quede estremecido.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$una criatura viva$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'fatalidad';
update spells set components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal ============================================================================================================================================================$c$, target = $c$tú$c$, duration = $c$1 minuto
```
Gracias a la invocación de la fuerza y sabiduría de una deidad, obtienes un bonificador +1 de suerte en las tiradas de ataque y daño por arma por cada tres niveles de lanzador que tengas (con un mínimo de +1 y un máximo de +6). Este bonificador no se aplica al daño de los conjuros.$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'favor divino';
update spells set school = $c$Conjuración$c$, descriptors = $c$creación$c$, description = $c$Te permite crear un gran festín que incluirá unas magníficas sillas, mesa, servicio y comida y bebida. El festín tardará una hora en ser consumido y sus efectos beneficiosos no se dejarán sentir hasta que haya transcurrido ese tiempo. Toda criatura que participe del banquete quedará curada de todas sus enfermedades, se volverá inmune al veneno durante 12 horas y ganará 1d8 puntos de golpe temporales (+1 por cada dos niveles de lanzador; máx. +10) tras beber el brebaje nectarino que forma parte del banquete. La ambrosíaca comida ingerida proporciona a cada criatura que participe un bonificador +1 de moral en las tiradas de ataque y salvaciones de Voluntad, así como inmunidad a los efectos de miedo; todo ello durará 12 horas. Durante ese mismo periodo de tiempo, la gente que deguste tales alimentos será inmune al miedo y la desesperación.

Si el festín fuera interrumpido por alguna razón, el conjuro se perderá y todos sus efectos serán negados.$c$, components = $c$V, S, FD$c$, casting_time = $c$10 minutos$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$festín para una criatura/nivel$c$, duration = $c$1 hora + 12 horas; ver texto$c$, saving_throw = $c$ninguno a mont$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'festin de los heroes';
update spells set school = $c$Evocación$c$, descriptors = $c$fuego$c$, description = $c$De tu mano surge un haz ardiente, hecho de fuego al rojo vivo y de 3' de longitud, que podrás blandir como si fuera una cimitarra. Los ataques con el filo flamígero se consideran de toque en cuerpo a cuerpo. El arma inflige 1d8 puntos de daño por fuego, +1 punto adicional por cada dos niveles de lanzador que poseas (máx. +10). Como el filo es inmaterial, tu modificador de Fuerza no se aplica al daño. El filo flamígero puede prender fuego a los materiales inflamables, como el pergamino, la paja, las ramas secas y la tela.

El conjuro no funciona bajo el agua.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$0 pies$c$, target = $c$un haz similar a una espada$c$, duration = $c$1 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'filo flamigero';
update spells set school = $c$Evocación$c$, descriptors = $c$fuego$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$0 pies$c$, target = $c$llama en la palma de tu mano$c$, duration = $c$1 min/nivel (D)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'flamear';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, descriptors = $c$ácido$c$, description = $c$Una flecha mágica hecha de ácido surge de tu mano y avanza a toda velocidad hacia su objetivo. Para alcanzar a tu oponente, debes tener éxito en un ataque de toque a distancia. La flecha inflige 2d4 de daño por ácido, sin daño por salpicadura. De no ser neutralizado, el ácido durará un asalto adicional por cada tres niveles de lanzador que poseas (hasta un máximo de nivel 18.º), infligiendo otros 2d4 puntos de daño por ácido por asalto.

Componente material: hoja de ruibarbo pulverizada y un estómago de víbora. La ma est Foco: un dardo. A novembre a manual m$c$, components = $c$V, S, M, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$largo (400' + 40'/nivel) ============================================================================================================================================$c$, target = $c$una flecha de ácido$c$, duration = $c$1 asalto +1 asalto/3 niveles$c$, saving_throw = $c$ninguno 12 14 435 11$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'flecha acida de melf';
update spells set school = $c$Transmutación$c$, descriptors = $c$fuego$c$, description = $c$Transformas munición (como flechas, virotes, shuriken y piedras) en proyectiles ardientes. Cada elemento de la munición inflige 1d6 puntos de daño adicionales por fuego a cualquier objetivo al que golpee. Un proyectil flamígero puede incendiar fácilmente un objeto o estructura inflamable, pero no echará a arder a una criatura a la que golpee.

Componentes materiales: una gota de aceite y un pequeño fragmento de pedernal.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)
- Objetivos o efecto: cincuenta proyectiles, todos los cuales deben estar en contacto
- entre sí en el momento del lanzamiento$c$, duration = $c$10 min./nivel$c$, saving_throw = $c$ninguno Resistencia a coniuros: no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'flecha flamigera';
update spells set school = $c$Transmutación$c$, description = $c$Por medio de este conjuro, puedes adoptar la forma de un árbol o arbusto vivos Grandes, o bien del tronco de un árbol muerto Grande que tenga unas cuantas ramas. Ni siquiera una inspección minuciosa revelará que el árbol en cuestión es en realidad una criatura escondida mágicamente. Ante cualquier comprobación normal, serás un árbol o un arbusto, aunque un conjuro de detectar magia revelará que la planta en cuestión ha sido levemente transmutada. Mientras estés en forma arbórea, podrás observar todo lo que suceda a tu alrededor igual que si estuvieras en tu forma normal, y tus puntos de golpe y tiros de salvación no resultarán afectados. Obtendrás un bonificador +10 de armadura natural a la CA, pero tendrás una puntuación efectiva de Destreza de 0 y una velocidad de 0 pies. Mientras estés en forma arbórea serás inmune a los golpes críticos. Todo la ropa o equipo que lleves encima se transformará contigo. Puedes deshacer la forma arbórea usando una acción gratuita en lugar de una acción estándar.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal and and and a$c$, target = $c$tú$c$, duration = $c$1 h/nivel (D) ======================================================================================================================================================$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'forma arborea';
update spells set school = $c$Transmuracion$c$, description = $c$Tanciales, borrosos y traslúcidos. Su armadura material (incluyendo la natural) se volverá inservible, pero seguirán aplicándose sus bonificadores de tamaño, Destreza, desvío y bonificadores de armadura por efectos de fuerza (como el concedido por la armadura de mago). El receptor obtiene una reducción del daño 10/magia, y se vuelve inmune al veneno y los golpes críticos. Sin embargo, no podrá atacar ni lanzar conjuros que tengan componente verbal, somático, material o de foco. (Nótese que esto no excluye aquellos conjuros que el receptor pueda haber preparado usando las dotes metamágicas de Conjurar en silencio y Conjurar sin moverse). El receptor pierde sus aptitudes sobrenaturales mientras esté en forma gaseosa. Si tuviera un conjuro de toque listo para usar, éste se descargará de manera inofensiva en cuanto surta efecto el conjuro de forma gaseosa.

Una criatura gaseosa no puede correr, pero sí volar a una velocidad de 10' (maniobrabilidad perfecta). También puede atravesar pequeños orificios o aberturas estrechas (incluyendo simples grietas) junto a todo lo que lleve puesto o transporte, siempre y cuando el conjuro persista. El receptor podrá ser afectado por el viento, y no podrá penetrar en el agua ni en ningún otro líquido. Además, no podrá manipular objetos ni activarlos, ni siquiera los que lleve con él en su forma gaseosa. Los objetos activos de manera continua lo siguen estando, aunque en algunos casos sus efectos pueden ser poco útiles (como los que proporcionan bonificadores de armadura o de armadura natural).

Componente material arcano: un poco de grasa y una voluta de humo. La per la fr$c$, components = $c$S, M, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura corporal voluntaria tocada$c$, duration = $c$2 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no El receptor y todo su equipo se vuelven insus$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'forma gaseosa';
update spells set school = $c$Transmutación$c$, description = $c$Como polimorfar, salvo en que puedes transformar en un animal de tu elección a un máximo de una criatura voluntaria por nivel; el conjuro no surte efecto en los receptores no voluntarios. Todas las criaturas deben adoptar la forma del mismo tipo de animal; por ejemplo, no puedes transformar a un objetivo en un halcón y a otro en un lobo terrible. Los receptores permanecen en la forma animal hasta que expire el sortilegio o deshagas el conjuro para todos los afectados. Además, cada receptor puede volver a adoptar libremente su forma normal como acción de asalto completo, poniendo fin al conjuro en lo que respecta sólo a él. Los DG máximos de la forma que se asuma son iguales a los DG del objetivo o tu nivel de lanzador, lo que sea menor, hasta un máximo de 20 DG a nivel 20.º.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$hasta una criatura voluntaria/nivel (dos receptores cualesquiera no pueden distar más de 30')$c$, duration = $c$1 h/nivel (D) = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =$c$, saving_throw = $c$ninguno; ver texto ========================================================================================================================================$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'formas de animal';
update spells set school = $c$Evocación$c$, descriptors = $c$luz$c$, description = $c$Un brillo pálido rodea y perfila a los receptores del conjuro, que despedirán una luz equivalen-

te a la de las velas. Las criaturas rodeadas por el brillo no se beneficiarán de la ocultación concedida normalmente por la oscuridad (aunque un efecto mágico de oscuridad de nivel 2.º o superior funcionará de manera normal), el contorno borroso, el desplazamiento, la invisibilidad y efectos similares. Esta luz es demasiado tenue como para tener efecto en los muertos vivientes o las criaturas que vivan en la oscuridad y sean vulnerables a la luz. El fuego feérico puede ser azulado, verdoso o violáceo, según decidas en el momento del lanzamiento. Este conjuro no inflige daño alguno ni a los objetos ni a las criaturas que rodee.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$largo (400' + 40'/nivel) 5 de radio$c$, target = $c$criaturas y objetos en una explosión de$c$, duration = $c$1 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'fuego feerico';
update spells set school = $c$Transmutacion$c$, description = $c$El receptor se vuelve más fuerte. El conjuro concede un bonificador +4 de mejora a la Fuerza, añadiendo los beneficios usuales a los ataques de cuerpo a cuerpo, tiradas de daño cuerpo a cuerpo y demás usos del modificador de Fuerza.

Componente material arcano: unos cuantos cabellos o una pizca de estiércol de toro.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega (inotensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'fuerza de toro';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro permite que tu cuerpo y tus posesiones se fundan con un bloque de piedra, que debe ser lo bastante grande como para darte cabida en las tres dimensiones. Cuando se haya completado el lanzamiento, tú y tu equipo inerte (por un peso máximo de 100 lb.) os fundiréis con la piedra. Si no se cumple cualquiera de estas condiciones, el conjuro fracasará y se perderá sin más.

Mientras estés en el interior de la piedra, te mantendrás en contacto (aunque éste sea te-

nue) con la cara de la roca en la que te fundiste. Seguirás siendo consciente del paso del tiempo y podrás lanzar conjuros sobre ti mismo mientras estés escondido. No podrás ver nada de lo que suceda fuera, pero podrás seguir escuchando lo que pase a tu alrededor. Un daño menor sufrido por la piedra no supondrá perjuicio alguno para ti, pero una destrucción parcial que impida que quepas en su interior te expulsará de ella y te infligirá 5d6 puntos de daño. La destrucción total de la piedra te expulsará de su interior y te matará en el acto si no tienes éxito en un tiro de salvación de Fortaleza (CD 18).

Hasta que expire la duración del conjuro, podrás abandonar tu escondite en cualquier momento, saliendo por la misma cara por la que entraste. Si expira la duración del sortilegio o el efecto es disipado antes de que salgas voluntariamente, serás expulsado violentamente y sufrirás 5d6 puntos de daño.

Los siguientes conjuros te infligirán daño cuando sean lanzados sobre la piedra en cuyo interior estés: de la piedra a la carne te expulsará de la piedra y te infligirá 5d6 puntos de daño. Transformar piedra te infligirá 3d6 puntos de daño pero no te expulsará. Transmutar roca en barro te expulsará y te matará en el acto si no logras tener éxito en un TS de Voluntad (CD 18); si logras salvarte, serás expulsado sano y salvo. Por último, pasamiento te expulsará sin hacerte daño.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$10 min/nivel$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'fundirse con la piedra';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Cada criatura afectada obtiene un bonificador +2 de moral a Fuerza y Constitución, un bonificador +1 de moral a las salvaciones de Voluntad, y un penalizador -2 a la CA. El efecto, por lo demás, es idéntico a la furia del bárbaro (consulta la pág. 25), salvo en que los objetivos no quedan fatigados al terminar la furia.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$una criatura viva voluntaria por cada tres niveles, dos cualesquiera no nueden estar a más de 30' de distancia$c$, duration = $c$concentración + 1 asalto/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'furia';
update spells set school = $c$Transmutación$c$, description = $c$Tu garrote o bastón no mágicos se convierten en un arma con un bonificador +1 de mejora en las tiradas de ataque y daño (un bastón gana esto bonificador en ambos extremos). Inflige daño como si fuera dos categorías de tamaño más grande (una clava o bastón Pequeños así trasmutados infligirán 1d8 puntos de daño, uno mediano 2d6, y uno grande 3d6), +1 por su bonificador de mejora. Cuando no seas tú quien blanda el arma, funcionará como si no estuviera afectado por el conjuro.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$una clava o bastón tocado, hecho de roble y de naturaleza no mágica$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega (objeto)$c$, spell_resistance = $c$sí (objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'garrote';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador, idioma-dependiente$c$, description = $c$Este conjuro obliga a una criatura a cumplir la orden mágica de llevar a cabo un servicio o abstenerse de hacer algo, según desee el lanzador. La criatura debe tener 7 DG o menos y poder entenderte. Aunque un conjuro de este tipo no puede obligar a una criatura a matarse o hacer algo que conlleve una muerte segura, sí que puede obligarla a realizar casi cualquier otra acción. La criatura bajo el geas debe seguir las instrucciones que le den hasta haberlo completado, no importa lo mucho que tarde. Si las instrucciones implican una tarea ambigua que el receptor no puede llevar a término por sus propios medios (como "Espera aquí" o "Defiende este lugar de cualquier ataque"), el conjuro permanecerá activo durante un periodo máximo de 1 día por nivel de lanzador. Ten en cuenta que un receptor inteligente podrá tergiversar ciertas instrucciones: si, por ejemplo, le ordenaras protegerte de todo daño, podría encerrarte en una buena mazmorra perfectamente segura mientras durase el sortilegio.

Si al receptor se le impidiera obedecer el geas menor durante 24 horas, sufrirá un penalizador -2 en cada una de sus puntuaciones de característica. Por cada día más que se le impidiese, sufriría otro penalizador -2 acumulativo, hasťa un máximo de -8 (aunque ninguna característica podrá quedar por debajo de 1). Las penalizaciones a las características terminarán 24 horas después de que el personaje vuelva a obedecer el geas menor.

Un geas menor, y todas las penalizaciones a las características, pueden eliminarse mediante un conjuro de deseo, deseo limitado, milagro, quitar maldición y romper encantamiento. Sin embargo, geas menor no resulta afectado por el sortilegio de disipar magia.$c$, components = $c$V$c$, casting_time = $c$1 asalto$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura viva de hasta 7 DG$c$, duration = $c$1 día/nivel o hasta ser descargado (D)$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'geas menor';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador, idioma-dependiente$c$, description = $c$Este conjuro funciona de manera similar a geas menor, salvo en que afecta a una criatura con cualquier cantidad de DG y no permite realizar tiro de salvación.

En lugar de sufrir penalizadores en las características (como sucede en el geas menor), el receptor sufrirá 3d6 puntos de daño cada día que no intente respetar el conjuro. Además, cada día tendrá que realizar un TS de Fortaleza o enfermará. Estos efectos finalizarán 1 día después de que la criatura intente reanudar lo impuesto por el conjuro de geas/empeño.

Quitar maldición pondrá fin al conjuro de geas/empeño solamente si su nivel de lanzador es, como mínimo, dos niveles superior al tuyo. Romper encantamiento no acabará con un coniuro de geas/empeño, pero un deseo limitado, un milagro y un deseo sí lo harán.

Los magos y bardos suelen referirse a este conjuro como geas, mientras que los clérigos suelen llamarlo empeño.$c$, casting_time = $c$10 minutos$c$, target = $c$una criatura viva$c$, saving_throw = $c$ninguno$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'geas/empeno';
update spells set school = $c$TTA$c$, description = $c$Una esfera mágica, inmóvil y ligeramente brillante, te rodea y protege contra todo efecto mágico de hasta 3.5 nivel. El área o efecto de cualquier conjuro de ese tipo no incluirá el área del globo menor de invulnerabilidad. Tales sortilegios no podrán afectar a ningún objetivo que se halle dentro del globo (esto incluye las aptitudes sortílegas y los conjuros o efectos sortílegos procedentes de objetos). Sin embargo, podrá ejecutarse cualquier tipo de sortilegio dentro del globo mágico o desde su interior. Los conjuros de nivel 4.º superior no resultarán afectados por el globo, ni tampoco los conjuros que ya estuvieran en efecto cuando se lance el globo. Este sortilegio puede ser eliminado por un conjuro de disipar magia dirigido contra él, pero no por un disipar magia que afecte a un área. Puedes salir del globo y volver a entrar en él sin penalizador alguno.

Ten en cuenta que los efectos de conjuros no resultarán perjudicados a no ser que sus efectos entren en el globo y, aun así, sólo serán suprimidos, no disipados. Por ejemplo, las criaturas del interior del globo seguirían viendo una imagen múltiple creada por un lanzador que estuviera fuera de él. Si, a continuación, ese lanzador entrara en el globo, las imágenes desaparecerían inmediatamente, volviendo a aparecer en cuanto saliera de él. Así mismo, un lanzador que estuviera en el área de un conjuro de luz seguiría pudiendo ver, aunque el volumen del conjuro de luz que estuviera dentro del globo no iluminara en absoluto.

Si un conjuro tiene más de un nivel, dependiendo de la clase de personaje que lo ejecute, se tendrá en cuenta el nivel adecuado al lanzador para averiguar si resulta afectado o no por el globo menor de invulnerabilidad.

Componente material: una cuenta de vidrio o cristal que estallará al expirar el sortilegio.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$10'$c$, target = $c$emanación esférica de 10' de radio, centrada en ti$c$, duration = $c$1 asalto/nivel (D)$c$, saving_throw = $c$ninguno Resistencia a conturos: no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'globo menor de invulnerabilidad';
update spells set description = $c$La criatura transmutada adquiere mayor gracia, agilidad y coordinación. El conjuro concede un bonificador +4 de a la Destreza, añadiendo los beneficios usuales a la CA, la salvación de Reflejos y demás cuestiones relacionadas con el modificador de Destreza.

Componente material: un poco de pelo de gato.

| racia felina en grupo | | | |
| |--|--|--|
| Transmitscion | | | |

| the be belock of the bear the became be to be be have be be for the be | |
| |--|
| Nivel: Brd 6, Drd 6, Hch/Mag 6 | |
| Alcance: corto (25' + 5'/2 niveles) | |
| Objetivos: una criatura/nivel (dos | |
| receptores cualesquiera no pueden distar | |
| más de 30') | |
| | |

Este conjuro funciona como gracia felina, salvo en que afecta a varias criaturas.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'gracia felina';
update spells set school = $c$AVA$c$, description = $c$Este conjuro cubre una superficie sólida con una capa de grasa resbaladiza. Toda criatura que esté en el área al ser ejecutado el sortilegio deberá realizar un TS de Reflejos para evitar resbalar, patinar o caer. Esta salvación se repite en tu turno cada asalto que la criatura permanezca dentro del área. Una criatura puede caminar en el interior o a través de la zona de grasa a la mitad de su velocidad normal con una prueba de Equilibrio (CD 10). El fallo implica que no puede moverse ese asalto (y deberá por lo tanto realizar una salvación de Reflejos para no caer), y si se falla por 5 o más caerá automáticamente (consulta la habilidad de Equilibrio para los detalles).

El DM debería ajustar los TS dependiendo de las circunstancias. Por ejemplo, una criatura que estuviera cargando cuesta abajo por un lugar que se engrasara de repente lo tendría muy difícil para librarse del efecto, pero tendría prácticamente asegurada la posibilidad de abandonar el área afectada (quisiera o no hacerlo).

El conjuro también puede utilizarse para cubrir un objeto con una capa grasienta (como, por ejemplo, una cuerda, los peldaños de una escalera o la empuñadura de un arma). Los ob-

jetos materiales que no se estén utilizando siempre resultarán afectados por el conjuro; los que se encuentren en poder de una criatura o estén siendo utilizados por ésta tendrán derecho a realizar TS de Reflejos para evitar el efecto. Si el tiro inicial falla, la criatura dejará caer inmediatamente el objeto. Cada asalto que intente tomar o usar un objeto engrasado, la criatura tendrá que realizar un nuevo TS. Una criatura que lleve puesta una armadura o ropas engrasadas obtiene un bonificador +10 de circunstancia en las pruebas de Escapismo y en las pruebas de presa realizadas para resistir o escapar de una presa o escapar de una sujeción. Componente material: un poco de corteza o manteca de cerdo.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles) Objetivo o á$c$, target = $c$un objeto o un cuadro de 10' × 10'$c$, duration = $c$1 asalto/nivel (D)$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'grasa';
update spells set school = $c$Comments$c$, description = $c$Este poderoso conjuro se utiliza principalmente para defender tu fortaleza. Esta protección abarca 200 pies cuadrados por nivel de lanzador. El área custodiada puede tener hasta 20' de alto y tener la forma que desees. Puedes custodiar varias plantas de una fortaleza dividiendo el área entre ellas; para poder ejecutar el sortilegio, debes estar dentro del área que va a ser custodiada. El sortilegio genera los siguientes efectos dentro del área custodiada:

Bruma: una bruma invadirá los pasillos, enturbiando y entorpeciendo la visión más allá de 5' (incluyendo la visión en la oscuridad). Las criaturas que estén a 5' o menos de quien mire dispondrán de ocultación (los ataques contra ellas tendrán un 20% de posibilidad de fallo). Las criaturas que estén más allá de esa distancia tendrán ocultación total (un 50% de posibilidad de fallo; además, quienes les ataquen no podrán usar la vista para localizarlas). Tiro de salvación: ninguno. Resistencia a coniuros: no.

Cerraduras arcanas: todas las puertas del área custodiada dispondrán de cerradura arcana. Tiro de salvación: ninguno. Resistencia a conjuros: no.

Telarañas: las escaleras se llenarán de telarañas desde abajo hasta arriba. Estas hebras serán idénticas a las creadas por el conjuro de telaraña, pero se regenerarán al cabo de 10 minutos en caso de ser quemadas o desgarradas, siempre y cuando siga activo el conjuro de guardas y custodias. Tiro de salvación: Reflejos niega; ver texto de telaraña. Resistencia a conjuros: no.

Confusión: allá donde deban tomarse decisiones con respecto a la dirección (como un cruce de pasillos o un pasadizo lateral) habrá un efecto menor, similar a confusión, que tendrá un 50% de posibilidades de hacer creer a los intrusos que están avanzando en la dirección contraria a la que querían. Esto es un efecto de encantamiento (enajenador). Tiro de salvación: ninguno. Resistencia a conjuros: sí.

Puertas perdidas: una puerta por nivel quedará cubierta por una imagen silenciosa que la hará parecer una simple pared. Tiro de salvación: Voluntad descree (si se interacciona con la ilusión). Resistencia a conjuros: no.

Además, puedes colocar a tu gusto uno de estos cinco efectos mágicos:

1. Luces danzantes en cuatro pasillos. Podrás establecer una pauta sencilla mediante la cual las luces se repetirán mientras dure el conjuro de guardas y custodias. Tiro de salvación: ninguno. Resistencia a conjuros: no.

2. Una boca mágica en dos lugares. Tiro de salvación: ninguno. Resistencia a conjuros: no.

3. Una nube apestosa en dos lugares. Los vapores aparecerán en los sitios que elijas; mientras siga activo el conjuro de guardas y custodias, las nubes que sean dispersadas reaparecerán al cabo de 10 minutos. Tiro de salvación: Fortaleza niega; ver el texto de nube apestosa. Resistencia a coniuros: sí.

4. Una ráfaga de viento en un pasillo o habitación. Tiro de salvación: Fortaleza niega. Resistencia a conjuros: sí.

5. Una sugestión en un lugar. Podrás seleccionar un área de hasta 5 pies cuadrados y toda criatura que entre en ella o la atraviese experimentará la sugestión mentalmente. Tiro de salvación: Voluntad niega. Resistencia a conjuros: sí. Toda el área custodiada irradiará una fuerte magia de la escuela de abjuración. En caso de tener éxito, un conjuro de disipar magia lanzado sobre un efecto concreto eliminará sólo el efecto en cuestión. Una disyunción de Mordenkainen con éxito destruirá todos los efectos de las guardas y custodias.

Componentes materiales: incienso (que ha de quemarse), un poco de azufre y aceite, un cordel anudado y un poco de sangre de mole sombría. Foco: un pequeño cetro de plata.$c$, components = $c$V, S, M, F$c$, casting_time = $c$30 minutos$c$, spell_range = $c$cualquier punto del área custodiada$c$, target = $c$hasta 200 pies cuadrados/nivel (Mo$c$, duration = $c$2 h/nivel (D)$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'guardas u custodias';
update spells set school = $c$Adivinación$c$, description = $c$Te permite comprender a los animales y comunicarte con ellos. Podrás hacerles preguntas y obtener respuestas, pero el conjuro no hará que se muestren más amistosos o dispuestos a cooperar que de costumbre. Es más, los animales cautos o astutos podrían mostrarse bruscos y evasivos, mientras que los más estúpidos podrían hacer comentarios inútiles. Si un animal es amistoso, podría hacerte algún favor o servicio (a discreción del DM).$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$1 min/nivel ு நிறுவ$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'hablar con los animales';
update spells set school = $c$Nigromancia$c$, descriptors = $c$dependiente del idioma$c$, description = $c$Te permite hacer que un cadáver parezca vivo e inteligente, pudiendo así responder a varias preguntas que le plantees. Podrás hacerle una pregunta por cada dos niveles de lanzador que poseas. Las preguntas que no se formulen se perderán una vez expire la duración. El conocimiento del cadáver estará limitado a lo que la criatura supiera en vida, incluyendo los idiomas que hablase (si es que hablaba alguno). Por lo general, las respuestas serán breves, crípticas o repetitivas. Si el alineamiento de la criatura era distinto del tuyo, el cadáver tendrá derecho a un tiro de salvación de Voluntad, igual que si estuviera con vida.

El conjuro fracasará si el cadáver hubiera sido receptor de otro lanzamiento de hablar con los muertos durante la última semana. Puedes ejecutar este sortilegio sin importar el tiempo que lleve muerto el cadáver, pero el cuerpo ha de estar intacto en su mayor parte para poder responder. Un cadáver deteriorado podría dar respuestas parciales o correctas sólo en parte, pero al menos deberá quedarle la boca para poder contestar siquiera.

Este conjuro no te permite hablar realmente con la persona, pues su alma ya se habrá marchado; en su lugar, sacará a relucir los conocimientos "grabados" en el cuerpo. El cadáver, parcialmente animado, retiene la huella del alma que lo habitó y, por tanto, posee el mismo

conocimiento que la criatura tuvo en vida. Sin embargo, no podrá aprender nueva información; de hecho, ni siquiera recordará que le han estado interrogando.

Este conjuro no sirve para comunicarse con cadáveres que hayan sido transformados en muertos vivientes. و تاريخ والتاليون سان المحمد

A 1 1 1 10 1 172$c$, components = $c$V, S, FD$c$, casting_time = $c$10 minutos$c$, spell_range = $c$10'$c$, target = $c$una criatura muerta$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega; ver text Resistencia a conturos: no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'hablar con los muertos';
update spells set school = $c$Encantamiento$c$, subschool = $c$hechizo$c$, descriptors = $c$enajenador$c$, description = $c$Este conjuro funciona como hechizar monstruo, salvo en que afecta a un número de criaturas cuyos DG combinados no excedan el doble de tu nivel, o a una sola criatura sin importar sus DG. Si hay más objetivos potenciales de los que puedes afectar, los eliges uno a uno hasta que elijas a una criatura con demasiados DG.$c$, components = $c$V$c$, target = $c$una o más criaturas, ninguna de las cuales puede estar a más de 30' del resto$c$, duration = $c$1 día/nivel Tran$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'hechizar monstruo en grupo';
update spells set school = $c$Encantamiento$c$, subschool = $c$hechizo$c$, descriptors = $c$enajenador$c$, description = $c$Este conjuro hace que una criatura humanoide te considere su aliado y amigo de confianza (considera la actitud del objetivo como amistosa; consulta 'Cómo Influir en la actitud de los PNJs', pág. 71). No obstante, si la criatura estuviera siendo amenazada por ti o tus amigos en el momento de ser afectada por el conjuro, obtendría un bonificador +5 en su TS.

El conjuro no te permite controlar a la persona hechizada como si fuera un autómata, pero ésta verá tus palabras y actos del modo más favorable. Puedes intentar dar órdenes al receptor, pero deberás tener éxito en una prueba enfrentada de Carisma para convencerle de hacer algo que normalmente no haría (no se permiten nuevos intentos). Una persona afectada no obedecerá bajo ningún concepto una orden suicida o claramente perjudicial, pero un guerrero hechizado podría, por ejemplo, creerte si le aseguraras que la única forma de que pueda salvar tu vida es frenar "tan sólo durante unos segundos" al dragón rojo que se os echa encima. Cualquier acto tuyo o de tus aliados que suponga una amenaza para el receptor romperá el conjuro. Ten en cuenta que debes hablar el idioma de la persona en cuestión para poder comunicarle tus órdenes (de lo contrario, tendrás que ser muy bueno con la pantomima).$c$, components = $c$V, S. Ba Bangle Sul Holmil$c$, casting_time = $c$1 acción de de moni arman miga sa kai estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles) ==========================================================================================================================================$c$, target = $c$una criatura humanoide manoide$c$, duration = $c$1 h/nivel - 1 h/nivel - 1 h Jen - 1 - 1$c$, saving_throw = $c$Voluntad niega no morela co$c$, spell_resistance = $c$sí sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'hechizar persona';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Este conjuro imbuye a una única criatura con una gran valentía y moral en la batalla. El objetivo obtiene un bonificador +2 de moral en las tiradas de ataque, salvaciones y pruebas de habilidad.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$10 min/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'heroismo';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Tus gestos y ensalmos monótonos fascinan a las criaturas cercanas, haciendo que se detengan y te miren fijamente. Además, al embelesarlas de este modo haces que tus sugerencias y peticiones parezcan más convincentes. Lanza 2d4 para comprobar el total de DG de criaturas a los que podrás afectar. Las criaturas con menos DG resultarán afectadas antes que las que tengan una mayor cantidad. El conjuro sólo afecta a las criaturas que puedan verte u oírte, aunque no tienen por qué entenderte para ser hipnotizadas.

Si usas este conjuro en combate, los receptores obtendrán un bonificador +2 en sus TS. Si el conjuro afecta a una sola criatura que no esté combatiendo en ese momento, ésta realizaría su TS con un penalizador -2.

Mientras una criatura esté fascinada por este conjuro, actuará como si su actitud fuese dos grados más amistosa (consulta Cómo influir en la actitud de los PNJs', pág. 71). Esto te permitirá hacer una única sugerencia o petición a la criatura afectada (siempre y cuando puedas comunicarte con ella). La sugerencia ha de ser breve y razonable. La criatura conservará su actitud hacia ti aun cuando el conjuro haya finalizado, pero sólo en lo que se refiere a esa sugerencia concreta.

Aquellas criaturas que fallen su TS no recordarán haber estado bajo tu influjo.$c$, components = $c$V, S$c$, casting_time = $c$1 asalto$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$varias criaturas vivas; dos receptores cualesquiera no pueden distar más de 30'$c$, duration = $c$2d4 asaltos (D)$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'lipnotismo';
update spells set school = $c$Nigromancia$c$, description = $c$Este conjuro evapora la humedad de los cuerpos de todos los receptores vivos, infligiendo 1d6 puntos de daño por nivel de lanzador (máximo 20d6). El sortilegio resulta especialmente devastador cuando se utiliza contra elementales de agua y criaturas vegetales, que sufren 1 d8 puntos de daño por nivel de lanzador (máximo 20d8).

Componente material arcano: un fragmento de esponja.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$largo (400' + 40'/nivel)$c$, target = $c$criaturas vivas; dos receptores cualesquiera no pueden distar más de 6$c$, duration = $c$instantanea$c$, saving_throw = $c$Fortaleza mitad$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'horrible marchitamiento';
update spells set description = $c$Este conjuro determina todas las propiedades mágicas de un único objeto mágico, incluyendo el modo de activación de esas funciones (cuando resulte apropiado) y la cantidad de cargas que quedan disponibles (en caso de haberlas).

Identificar no funciona cuando se utiliza sobre un artefacto (consulta la Guía del Dungeon Master para más detalles sobre los artefactos).

Componentes materiales arcanos: una perla con un valor mínimo de 100 po, pulverizada y mezclada con vino, todo ello removido con una pluma de búho; la infusión ha de ingerirse antes de lanzar el conjuro.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 hora$c$, spell_range = $c$toque$c$, target = $c$1 objeto tocado$c$, duration = $c$instantánea$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'identificar';
update spells set school = $c$Ilusión$c$, subschool = $c$quimera$c$, description = $c$Varios dobles ilusorios de ti mismo aparecen a tu alrededor, haciendo que tus enemigos lo tengan más difícil para adivinar a quién han de atacar. Las quimeras se quedarán cerca de ti y desaparecerán en cuanto sean golpeadas.

Este conjuro crea 1d4 imágenes más una imagen adicional por cada 3 niveles de lanzador que poseas (hasta un máximo de 8 imágenes). Las quimeras se separarán de ti formando una piña y se situarán a 5' de distancia unas de otras o de ti. El efecto te permitirá meterte dentro de una imagen múltiple o atravesarla; cuando la imagen múltiple y tú os separéis, los observadores no podrán emplear la vista ni el oído para saber quién eres tú y qué es una mera imagen tuya. Las quimeras también pueden moverse unas a través de otras; además, imitarán tus acciones, fingiendo que lanzan conjuros cuando tú ejecutes un sortilegio, bebiendo pociones cuando tú ingieras una de ellas, levitando cuando tú levites, etc.

Los enemigos que intenten atacarte o lanzar conjuros contra ti deberán elegir entre los distintos objetivos, imposibles de diferenciar. Por lo general, habrá que lanzar un dado para determinar si el objetivo elegido es real o quimérico. Toda tirada de ataque que logre alcanzar a una quimera la destruirá de inmediato. La CA de las quimeras es 10 + tu modificador de tamaño + tu modificador de Destreza. Las imágenes múltiples parecerán reaccionar con naturalidad a los conjuros de área (por ejemplo, parecerán quemadas o muertas cuando sean alcanzadas por una bola de fuego).

Mientras te muevas, podrás fundirte y separarte con una de las quimeras para que los ene-

migos que hayan averiguado cuál es la imagen real vuelvan a estar confundidos.

Todo atacante debe poder ver las imágenes para ser engañado por ellas. Si eres invisible o el agresor cierra los ojos, el conjuro no surtiría efecto (no poder ver impone los mismos penalizadores que estar ciego)$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal; ver texto$c$, target = $c$tú$c$, duration = $c$1 min/nivel (D)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'imagen multiple';
update spells set school = $c$Ilusión$c$, subschool = $c$quimera$c$, components = $c$V, S, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$largo (400' + 40'/nivel)$c$, target = $c$quimera visual que no puede exceder cuatro cubos de 10' + un cubo de 10'/nivel$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'imagen silenciosa';
update spells set description = $c$Te permite transferir a otra criatura algunos de los conjuros que tengas preparados, así como la aptitud para poder ejecutarlos. Esta concesión sólo puede ser recibida por criaturas que tengan, como mínimo, puntuaciones de 5 en Inteligencia y 9 en Sabiduría. Sólo pueden transferirse los conjuros de clérigo de las escuelas de abjuración, adivinación o conjuración (curación). La cantidad y el nivel de los conjuros que el receptor pueda obtener dependerá de sus DG; este límite no podrá ser superado ni siquiera por varios lanzamientos del conjuro de imbuir aptitud para los conjuros. conjuros.

| DG del | Conjuros | |
| | |--|
| receptor | infundidos | |
| 2 o menos | Un conjuro de 1.ª nivel | |
| 3-4 | Uno o dos conjuros de 1.6ª nive | |
| 5 o más | Uno o dos conjuros de 1.ª nive<br>y uno de 2.º nivel | |

Las características variables de los conjuros transferidos (alcance, duración, área, etc.) funcionarán de acuerdo a tu nivel, no al del receptor.

Una vez hayas lanzado un imbuir aptitud para los conjuros sobre otra criatura, no podrás preparar un nuevo conjuro de 4.º nivel que lo reemplace hasta que el receptor use los conjuros transferidos o muera, o hasta que decidas disiparlo por tu cuenta. Mientras tanto, tú serás responsable ante tu deidad o tus principios del uso que se le dé a la magia transferida. Si tu límite de conjuros de 4.º nivel quedara reducido por debajo de la cantidad de conjuros de infundir aptitud para los conjuros activos, los conjuros infundidos que se hayan ejecutado más recientemente serán disipados.

Para ejecutar un sortilegio con componente verbal, el receptor debe poder hablar. Para lanzar uno con componente somático, debe poseer manos humanoides. Para ejecutar uno con componente material o foco, debe tener a mano el foco o los materiales necesarios.

| mpacto verdadero | |
| |--|
| Adivinacion | |
| Nivel: Hcr/Mag 1 | |
| Componentes: V, F | |
| Tiempo de lanzamiento: 1 acción estándar | |
| Alcance: personal | |
| Objetivo: tú | |
| Duración: ver texto | |
| | |

Obtienes un conocimiento temporal e intuitivo del futuro inmediato durante tu siguiente ataque. Tu siguiente tirada de ataque (una sola, y que debe hacerse antes del fin del próximo asalto) obtendrá un bonificador +20 introspectivo. Además, no resultarás afectado por la posibilidad de fallo que sufren los ataques efectuados contra un defensor que disponga de ocultación.

Foco: una pequeña réplica de una diana, hecha de madera.$c$, components = $c$V, S, FD$c$, casting_time = $c$10 minutos$c$, spell_range = $c$toque$c$, target = $c$criatura tocada; ver texto$c$, duration = $c$permanente hasta ser descargado (D)$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'imbuir aptitud para los conjuros';
update spells set school = $c$Helel$c$, description = $c$Creas una resonancia destructiva en el cuerpo de una criatura corporal. Cada asalto que te concentres, harás que una criatura se hunda sobre sí misma, muriendo en el acto (al ser instantáneo, este efecto no podrá ser disipado).

Una misma criatura sólo puede convertirse en objetivo de este conjuro una vez por lanzamiento. La implosión no surte efecto en las criaturas incorporales o de forma gaseosa.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles) ==================$c$, target = $c$una criatura corporal/asalto$c$, duration = $c$concentración (hasta 4 asaltos)$c$, saving_throw = $c$Fortaleza niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'implosion';
update spells set description = $c$Al imponer tu mano sobre una criatura, canalizas energía negativa que le inflige 1d8 puntos de daño, +1 punto adicional por nivel de lanzador (hasta un máximo de +5).

Como los muertos vivientes se impulsan con energía negativa, los conjuros de este tipo les curarán daño en lugar de infligírselo.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$instantanea$c$, saving_throw = $c$Voluntad mitad$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'infligir heridas leves';
update spells set school = $c$Nigromancia$c$, description = $c$La energía negativa se expande desde el punto de origen en todas direcciones, infligiendo 1d8 puntos de daño +1 punto adicional por nivel de lanzador (máximo +25) a los enemigos vivos próximos. Como otros conjuro de infligir, infligir heridas leves en grupo cura a los muertos vivientes dentro de su área, en lugar de causarles daño. Un clérigo capaz de lanzar espontáneamente conjuros de infligir puede también lanzar espontáneamente conjuros de infligir en grupo.$c$, components = $c$V. S$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura/nivel; dos cualesquiera no pueden estar a más de 30' de distancia$c$, duration = $c$instantánea$c$, saving_throw = $c$Voluntad mitad$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'infligir heridas leves en grupo';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Este conjuro funciona como inmovilizar persona, salvo en que afecta a un animal en lugar de a un humanoide.$c$, components = $c$V, S$c$, target = $c$un animal$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'inmovilizar animal';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Este conjuro funciona como inmovilizar persona, salvo en que afecta a cualquier criatura viva que falle su salvación de Voluntad.

Componente material arcano: una barra o cetro de metal duro, incluso del tamaño de un clavo sencillo.

Inmovilizar monstruo en grupo Encantamiento (compulsión) [enajenador]

Nivel: Hch/Mag 9

Objetivos: una o más criaturas; dos cualesquiera no pueden estar a más de 30' de distancia$c$, components = $c$V, S, M/FD$c$, target = $c$una criatura viva$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'inmovilizar monstruo';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$El receptor se queda paralizado y se detiene allá donde esté. Será consciente de lo que pase a su alrededor y podrá respirar con normalidad, pero no podrá llevar a cabo ninguna acción física, ni siquiera hablar. Cada asalto en su turno, el objetivo puede intentar un nuevo TS para romper el efecto (esta es una acción de asalto completo que no provoca ataques de oportunidad).

Las criaturas aladas que sean inmovilizadas por este conjuro no podrán batir sus alas y caerán. Las que estén en un líquido no podrán nadar y por tanto, si sólo respiran aire, podrían ahogarse. Foco arcano: un fragmento de hierro, recto y

pequeño.$c$, components = $c$V, S, F/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$una criatura humanoide$c$, duration = $c$1 asalto/nivel (D); ver texto$c$, saving_throw = $c$Voluntad niega; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'inmovilizar persona';
update spells set school = $c$ADJuraCron$c$, description = $c$La criatura custodiada se vuelve inmune a los efectos de un conjuro concreto por cada 4 niveles que poseas. Tales conjuros han de ser de nivel 4.º o inferior. La criatura custodiada poseerá una RC efectiva que no podrá ser superada por ese conjuro o conjuros. Naturalmente, este sortilegio no protegerá a la criatura contra aquellos conjuros en los que no se aplique la RC. Este efecto protege contra los conjuros, los efectos sortílegos de los objetos mágicos y las aptitudes sortílegas innatas de las criaturas, pero no contra las aptitudes sobrenaturales o extraordinarias, como las armas de aliento o los ataques de mirada. El conjuro sólo protege contra conjuros concretos, no contra dominios, escuelas de magia ni grupos de conjuros que posean efectos similares. Por tanto, una criatura que posea protección contra el rayo relampagueante seguirá siendo vulnerable al contacto electrizante o el relámpago zigzagueante.

Una criatura sólo puede tener activo un sortilegio de inmunidad a conjuros o inmunidad a conjuros mayor en un momento dado.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$10 min/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'inmunidad a conjuros';
update spells set description = $c$Descargado

Este conjuro te proporciona un poderoso sexto sentido referido sólo a ti. Una vez durante la duración del conjuro, puedes decidir utilizar este efecto. El conjuro te proporciona un bonificador introspectivo igual a tu nivel de lanzador (máximo +25) en una única tirada de ataque, prueba enfrentada de habilidad o característica, o TS. De modo alternativo, puedes aplicar el bonificador introspectivo a tu CA contra un único ataque (incluso estando desprevenido). Activar el efecto no requiere una acción; puedes hacerlo incluso en el turno de otro personaje, si es necesario. Debes elegir si utilizas el instante de presciencia antes de realizar la tirada que modifique. Una vez se ha utilizado, el conjuro termina.

No puedes tener más de un momento de presciencia activo sobre ti al mismo tiempo.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$1 hora/nivel o hasta que sea$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'instante de presciencia';
update spells set school = $c$Abjuracion$c$, description = $c$Interdicción sella un área contra todo viaje planario hacia su interior o hacia su exterior. Esto incluye los conjuros de teleportación (como puerta dimensional o teleportar), desplazamiento de plano, el viaje astral, el viaje etéreo, y todos los conjuros de convocar. Estos efectos simplemente fallan de manera automática.

Además, causa daño a las criaturas que entren en la zona y que tengan un alineamiento diferente al tuyo. El efecto sobre las criaturas que intenten entrar en el área custodiada depende la relación que tenga su alineamiento con el tuyo (consulta más adelante). Una criatura que ya esté dentro del área cuando el conjuro sea lanzado no recibe daño salvo que salga y vuelva a entrar, en cuyo caso resultará afectada del modo normal. Mismo alineamiento: sin efecto. La criatura puede entrar con total libertad (aunque no por medio del viaie planario).

Alineamiento diferente respecto al bien/mal o a la ley/caos: la criatura sufre 6d6 puntos de daño. Un TS de Voluntad con éxito negará el daño, y la RC se aplicará con normalidad.

Alineamiento diferente respecto tanto al bien/mal como a la ley/caos: la criatura sufre 12d6 puntos de daño Un TS de Voluntad con éxito negará el daño, y la RC se aplicará con normalidad.

A elección tuya, la abjuración puede incluir una contraseña, en cuyo caso las criaturas de alineamiento diferente al tuyo pueden evitar el daño, pronunciándola al entrar en el área. Debes elegir esta opción (y la contraseña) en el momento del lanzamiento.

Disipar magia no disipa una interdicción, a no ser que el nivel de quien lo intente sea igual o superior a tu nivel de lanzador.

No puedes tener varios efectos de interditción solapados. En ese caso, el efecto más reciente se detiene en los límites del efecto más antiguo.

Componentes materiales: agua bendita (rociada) y un raro incienso que costarán, como mínimo, 1.500 po, y 1.500 po más por cada cubo de 60' de lado. Si quieres incluir una contraseña, tendrás que quemar más incienso raro por un valor mínimo de 1.000 po y 1.000 po más por cubo de 60' de lado.$c$, components = $c$V, S, M, FD$c$, casting_time = $c$6 asaltos$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$un cubo de 60 /nivel (Mo)$c$, duration = $c$permanente$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'interdiccion';
update spells set school = $c$Transmutación$c$, description = $c$Al igual que un perro intermitente (consulta el Manual de monstruos), podrás moverte entre el plano Material y el Etéreo. A ojos de los demás, parecerás estar "parpadeando", apareciendo y desapareciendo de la realidad rápidamente y al azar. La intermitencia tiene dos efectos:

Los ataques físicos tendrán un 50% de posibilidad de fallo y la dote Lucha a ciegas no servirá de nada contra ello, ya que el personaje afectado es etéreo, no meramente invisible. Si el atacante es capaz de golpear a las criaturas etéreas o incorporales, la posibilidad de fallo será solamente de 20% (por ocultación). Si el atacante puede ver a las criaturas invisibles, la posibilidad de fallo también quedaría reducida a 20%. Si el atacante puede tanto ver como atacar a las criaturas etéreas, no sufre penalizador. Así mismo, tus propios ataques tendrán un 20% de posibilidad de fallo cuando estés intermitente, pues habrá momentos en que te volverás etéreo justo cuando vayas a golpear.

Los conjuros dirigidos contra un solo objetivo tendrán un 50% de posibilidad de fallo mientras, estés intermitente, a no ser que tu atacante pueda dirigirlo contra criaturas invisibles y etéreas. Tus propios conjuros tendrán un 20% de activarse cuando estés en forma etérea, situación en la que, generalmente, no afectarán al plano Material.

Mientras estés intermitente, sólo sufrirás la mitad del daño infligido por los ataques de área (0) el daño completo de aquellos que lleguen también al plano Etéreo). Atacarás como si fueras una criatura invisible (+2 al ataque), negando a tu víctima el bonificador de Destreza a la CA. Sólo sufrirás la mitad del daño de las caídas, pues sólo caerás cuando seas material.

Mientras estés intermitente, podrás atravesar los objetos sólidos (aunque no podrás ver a través de ellos). Por cada 5' de material sólido que atravieses, habrá un 50% de posibilidades de que te vuelvas material. Si esto se produce, eres apartado hasta el espacio vacío más próximo y recibes 1d6 puntos de daño por cada 5' que seas desplazado de este modo. Sólo podrás moverte a 3/4 de tu velocidad, ya que en el plano Etéreo el movimiento queda reducido a la mitad, y, mientras dure el conjuro, pasarás la mitad del tiempo allí y la otra mitad siendo material.

Como pasas más o menos la mitad del tiempo en el plano Etéreo, podrás ver e incluso atacar a las criaturas etéreas. Tu interacción con ellas será prácticamente la misma que con las criaturas materiales. Por ejemplo, tus conjuros contra criaturas etéreas tendrán un 20% de activarse justo cuando seas material, desperdiciándose sus efectos.

Las criaturas etéreas son invisibles e incorporales, y pueden moverse en cualquier dirección, incluso hacia arriba o hacia abajo. Como criatura incorporal, podrás moverte a través de los objetos sólidos, incluyendo las criaturas vivas. Una criatura etérea puede ver y oír lo que sucede en el plano Material, aunque todo le parecerá gris e irreal. La vista y el oído de lo que suceda en el plano Material quedarán limitados a 60'. Los efectos de fuerza (como proyectil mágico y muro de fuerza) y las abjuraciones te afectarán normalmente. Sus efectos se extenderán desde el plano Material hasta el Etéreo, pero no a la inversa. Una criatura

etérea no puede atacar a enemigos materiales, y los conjuros que lances siendo etéreo sólo afectarán a otras criaturas etéreas. Ciertas criaturas u objetos materiales disponen de ataques y efectos que afectan al plano Etéreo (como el ataque de mirada del basilisco). Trata a las demás criaturas y objetos etéreos como si fueran materiales.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$1 asalto/nivel (D)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'intermitencia';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro invierte la gravedad en su área de efecto, haciendo que todos los objetos sueltos y las criaturas "caigan" hacia arriba y lleguen al límite del área en un asalto. Si en ese recorrido hubiera un objeto sólido (como un techo), los objetos y criaturas se golpearán contra él igual que si se tratara de una caída normal. Si un objeto o criatura llega al límite del área sin golpear contra nada, se quedará allí sin más, oscilando levemente hasta que termine el conjuro. Al expirar la duración del conjuro, los objetos y criaturas afectados caerán hacia abajo.

Suponiendo que tengan algo donde agarrarse, las criaturas atrapadas en el área podrán realizar un TS de Reflejos para sujetarse antes de surtir efecto el conjuro. Los receptores capaces de volar o levitar podrán evitar la caída. Componentes materiales arcanos: magnetita y limaduras de hierro.$c$, components = $c$V. S. M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$hasta un cubo de 10'/2 niveles (Mo)$c$, duration = $c$1 asalto/nivel (D)$c$, saving_throw = $c$ninguno; ver texto$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'invertir gravedad';
update spells set school = $c$Ilusión$c$, subschool = $c$engaño$c$, description = $c$La criatura u objeto tocado desaparece de la vista, incluso ante aquellos que dispongan de visión en la oscuridad. Si el receptor es una criatura que llevara equipo, éste desaparecerá también. Si lanzas el conjuro sobre otra criatura, ni tú ni tus aliados podréis ver al receptor, a no ser que normalmente podáis ver las cosas invisibles o dispongáis de magia que os lo permita.

Los objetos que se le caigan al receptor o sean soltados por éste se volverán visibles; los objetos que coja con la mano desaparecerán, siempre y cuando el receptor los meta bajo la ropa que lleve puesta o dentro de una bolsa que porte. Sin embargo, la luz no se volverá invisible jamás, aunque

una fuente de luz sí podría hacerlo (por tanto, el efecto sería el de una luz sin fuente visible). Todo fragmento de un objeto portado por el receptor que se extienda a más de 10' de él (como, por ejemplo, una cuerda que lleve atada) se volverá visible. Ni qué decir tiene que el receptor no queda silenciado mágicamente y que ciertas condiciones pueden permitir que sea detectado (como, por ejemplo, que pisara un charco al caminar). El conjuro termina en cuanto el receptor ataque a una criatura. En lo que se refiere a este sortilegio, "atacar" incluye todo conjuro dirigido contra un oponente o en cuya área o efecto esté incluido un oponente (el punto de vista del personaje invisible será el que determine qué es un enemigo y qué no lo es). Las acciones dirigidas contra objetos no atendidos no romperán el conjuro. Hacer daño de forma indirecta no se considera un ataque. Por tanto, una criatura invisible podría abrir puertas, hablar, comer, subir escaleras, convocar monstruos y hacer que ataquen, cortar las cuerdas de sujeción de un puente mientras los enemigos están sobre él, disparar trampas a distancia, abrir rastrillos para dejar libres a unos perros guardianes, etc, etc. No obstante, el receptor se volverá visible junto a todo su equipo en cuanto efectúe un ataque. Ten en cuenta que, a efectos de este conjuro, los sortilegios como bendecir, que afecten específicamente a tus aliados pero no a tus enemigos, no serán considerados ataques aunque haya oponentes dentro de su área.

Consulta la tabla 8-5: modificadores a la tirada de ataque, y la tabla 8-6: modificadores a la CA, en la pág. 151, para encontrar los efectos de la invisibilidad en el combate. - -

Invisibilidad puede ser hecho permanente (sólo en objetos) con un conjuro de permanencia.

Componentes materiales arcanos: una pestaña mezclada con un poco de goma arábiga.

s roil all A$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal o toque$c$, target = $c$tú o una criatura u objeto que no pese más de 100 lb/nivel$c$, duration = $c$1 min/nivel (D)$c$, saving_throw = $c$Voluntad niega (inofensivo) o Voluntad niega (inofensivo, objeto)$c$, spell_resistance = $c$si (inofensivo) o sí (inofensivo, objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'invisibilidad';
update spells set school = $c$Ilusión$c$, subschool = $c$engaño$c$, description = $c$Receptores cualesquiera no pueden distar más de 180'

Este conjuro funciona como invisibilidad, salvo en que el efecto se mueve con los miembros del grupo y se rompe en cuanto alguno de ellos efectúa un ataque. Los afectados no podrán verse unos a otros. El efecto se romperá para todo individuo que se aleje más de 180' de cualquiera de sus compañeros (si sólo hubiera dos individuos afectados, el que se estuviera alejando del otro sería quien perdiese la invisibilidad; si ambos estuvieran alejándose el uno del otro, los dos se volverían visibles en cuanto la distancia que los separase fuera superior a 180').

Componentes materiales: una pestaña mezclada con un poco de goma arábiga.

Invisibilidad mayor

Ilusión (engaño) Nivel: Brd 4, Hcr/Mag 4 SONNINOS$c$, components = $c$V. S. M. Incon i il$c$, spell_range = $c$largo (400' + 40'/nivel)$c$, target = $c$cualquier cantidad de criaturas; dos$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'invisibilidad en grupo';
update spells set school = $c$Evocación$c$, descriptors = $c$fuerza$c$, description = $c$Este poderoso conjuro crea una prisión invisi-

ble, cúbica e inmóvil, provista de barrotes o sólidos muros de fuerza (según elijas).

процесс

Las criaturas que estén dentro del área serán atrapadas y retenidas, a no ser que su gran tamaño les impida caber dentro, en cuyo caso el conjuro falla automáticamente. El teletransporte y otras formas de viaje astral permitirán escapar de la jaula, pero los muros o barrotes de fuerza se extienden hasta el plano Etéreo, lo cual impide huir a través de él.

Al igual que muro de fuerza, la jaula de fuerza es resistente a disipar magia; sin embargo, es vulnerable al conjuro de desintegrar y puede ser destruida mediante una esfera de aniquilación o un cetro de cancelación.

Celda sin aberturas: esta celda es un cubo de 10' de lado del que es imposible entrar o salir. Sus seis lados están formados por sólidos muros de fuerza.

Jaula con barrotes: esta jaula es un cubo de 20' de lado con bandas de fuerza (similares a un conjuro de muro de fuerza) haciendo las veces de barrotes. Las bandas tienen media pulgada de anchura y están separadas unas de otras por espacios de otra media pulgada. Cualquier criatura capaz de pasar a través de estos pequeños espacios puede escapar; las demás están confinadas en su interior. No puedes atacar a una criatura en el interior de una jaula con barrotes con un arma salvo que esta puede caber por los huecos. Incluso en este caso (incluyendo flechas y ataques a distancia similares), una criatura en el interior de la jaula contará con cobertura. Todos los conjuros y armas de aliento pueden atravesar perfectamente los espacios entre los barrotes.

Componente material: polvo de rubí por valor de 1.500 po, que se lanza al aire y desaparece cuando lanzas el conjuro.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$jaula (cubo de 20' de lado) o celda sin aberturas (cubo de 10' de lado)$c$, duration = $c$2 h/nivel (D) ......................................................................................................................................................$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'laula de fuerza';
update spells set school = $c$Conjuración$c$, subschool = $c$teleportación$c$, description = $c$Te permite desterrar al objetivo a un laberinto extradimensional de planos de fuerza. Cada asalto durante su turno, el objetivo puede intentar una prueba de Inteligencia a CD 20 para escapar del laberinto como acción de asalto completo. Si el receptor no logra escapar, el laberinto desaparecería al cabo de 10 minutos, obligándolo a salir. Al abandonar o dejar el laberinto, el receptor aparece justo donde estuviera en el momento de ejecutarse el sortilegio. Si en ese punto hay ahora un objeto sólido, el receptor aparecerá lo más cerca posible del punto en que estuviera.

Los conjuros y aptitudes que trasladan a una criatura de un plano a otro, como teleportar y puerta dimensional, no ayudarán al receptor a librarse de un conjuro de laberinto (aunque uno de desplazamiento de plano le permitirá salir al plano indicado en tal conjuro). Los minotauros no resultan afectados por este sortilegio.$c$, components = $c$V, S - Chil$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles) ==========================================================================================================================================$c$, target = $c$una criatura 11$c$, duration = $c$ver texto$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'laberinto';
update spells set school = $c$Transmutación$c$, description = $c$Tu habla se vuelve fluida y más creíble. Obtienes un bonificador +30 en las pruebas de Engañar realizadas para convencer a otro de que tus palabras

son ciertas (este bonificador no se aplica a otros usos de la habilidad de Engañar, como fintar en combate, crear una diversión para esconderse o comunicar un mensaje oculto mediante germanía).

Si se intenta contra ti una adivinación que detectaría tus mentiras o te obligaría a decir la verdad (como discernir mentiras o zona de verdad), el lanzador de la adivinación debe tener éxito en una prueba de nivel de lanzador (1d20 + su nivel de lanzador) contra una CD de 15 + tu nivel de lanzador para tener éxito. El fallo implica que la adivinación no detecta tus mentiras o no te obliga a decir sólo la verdad.$c$, components = $c$S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$10 min/nivel (D)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'labia';
update spells set school = $c$Nigromancia$c$, description = $c$Emites un terrible alarido que mata a las criaturas que lo oigan (excepto a ti mismo). Los receptores que se encuentren más cerca del punto de origen serán los primeros en resultar afectados.$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25 + 5'/2 niveles)$c$, target = $c$una criatura viva/nivel en una expansión de 40' de radio$c$, duration = $c$instantanea$c$, saving_throw = $c$Fortaleza niega Rocistencia a comitiros si$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'lamento de la banshee';
update spells set school = $c$Transmutación$c$, description = $c$Lanzas una maldición sobre el objetivo. Elige uno de los tres efectos siguientes.

· Reducción efectiva de -6 en una puntuación de característica (mínimo 1).

Penalizador -4 en las tiradas de ataque, TS y

pruebas de habilidad y característica.

Cada turno, la víctima tendrá un 50% de posi-

bilidades de actuar con normalidad; de lo

contrario, no llevará a cabo acción alguna. También puedes inventar una maldición, pero ésta no debería ser más poderosa que las cita-

das anteriormente y el DM será quien tenga la última palabra en cuanto a sus efectos.

La maldición lanzada por este conjuro no puede ser disipada, pero puede eliminarse mediante los conjuros de deseo, deseo limitado, milagro, quitar maldición y romper encantamiento.

Lanzar maldición contrarresta el sortilegio de quitar maldición. In a come$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$permanente$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'lanzar maldicion';
update spells set school = $c$I$c$, description = $c$Mediante este conjuro podrás descifrar las inscripciones mágicas de los objetos (libros, rollos de pergamino, armas, etc.) que, de lo contrario, resultarían ininteligibles. Por lo general, esta lectura no invocará la magia contenida en el escrito, aunque sí podría hacerlo en el caso de un rollo de pergamino maldito. Es más, una vez hayas ejecutado el sortilegio y leído la inscripción mágica, podrás volver a leer ese texto posteriormente sin necesidad de lanzar de nuevo leer magia. Puedes leer al ritmo de una página (250 palabras) por minuto. El conjuro te permite identificar un glifo custodio teniendo éxito en una prueba de Conocimiento de conjuros (CD 13), un glifo custodio mayor con una prueba de Conocimiento de conjuros (CD 16), o un símbolo mediante una prueba de Conocimiento de conjuros (CD 10 + nivel del conjuro).

Leer magia puede ser hecho permanente mediante un conjuro de permanencia.

Foco: un cristal transparente o un mineral con forma de prisma.$c$, components = $c$V, S, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$10 min/nivel$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'leer magia';
update spells set school = $c$Conjuracion$c$, subschool = $c$curación$c$, description = $c$El receptor se vuelve temporalmente inmune al veneno. Ningún veneno en su organismo o al que se vea expuesto logrará afectarle mientras dure el conjuro. Lentificar veneno no cura el daño infligido por un veneno antes de surtir efecto el conjuro.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$1 h/nivel$c$, saving_throw = $c$Fortaleza niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'lentificar veneno';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro te permite desplazar tu cuerpo, el de otra criatura o un objeto hacia arriba y hacia abajo según tus deseos. La criatura debe estar dispuesta a que la hagan levitar, y el objeto debe estar desatendido o ser poseído por una criatura que acceda voluntariamente a su manipulación. Puedes dirigir mentalmente al receptor para que suba o baje a una velocidad máxima de

20' por asalto (lo cual es una acción de movimiento). El efecto no permite desplazarlo horizontalmente, aunque una criatura afectada podría agarrarse, por ejemplo, a la cara de un acantilado, o impulsarse con el techo para moverse lateralmente (generalmente, a la mitad de su velocidad base).

Una criatura que ataque mientras esté levitando, ya sea con un arma de cuerpo a cuerpo o a distancia, encontrará su posición cada vez más inestable; la tirada del primer ataque sufrirá un penalizador -1, la del segundo un -2, etc., hasta un penalizador máximo de -5. Si emplea un asalto completo en estabilizarse, la criatura puede empezar de nuevo con un penalizador -1.

Foco: un pequeño lazo de cuero o un fragmento de alambre de oro doblado en forma de copa con un largo astil en un extremo.$c$, components = $c$V, S, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal o corto (25' + 5'/2 niveles)$c$, target = $c$tú o un objeto o criatura voluntaria (con un peso máximo de 100 lb/nivel)$c$, duration = $c$1 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'levitar';
update spells set school = $c$Abjuración$c$, description = $c$El receptor quedará libre de todo conjuro o efecto que restrinja su movimiento, incluyendo aturdimiento, cautiverio, dormir, enmarañar, estasis temporal, inmovilizar, laberinto, ligadura, parálisis, petrificación, presa, ralentizar, y telaraña. Para liberar a alguien de un cautiverio o laberinto, debes saber su nombre e historia, y aparte ejecutar el sortilegio en el lugar donde fue encerrado o desterrado al laberinto.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles) o ver texto$c$, target = $c$una criatura$c$, duration = $c$instantanea$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$si$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'libertad';
update spells set school = $c$an$c$, description = $c$Este efecto permite (a ti o a una criatura tocada) moverse y atacar con normalidad mientras dure el coniuro, incluso baio la influencia de magia que suela impedir el movimiento, como los conjuros de bruma sólida, la parálisis, ralentizar y telaraña. El objetivo tiene éxito automáticamente en cualquier prueba de presa para resistir un intento de presa, así como en las pruebas de presa o Escapismo realizadas para escapar de una presa o una sujeción.

El sortilegio también permite al personaje moverse y atacar normalmente estando bajo el agua, incluso con armas cortantes como hachas y espadas, o contundentes, como mazas, martillos y manguales, siempre y cuando sean blandidas con la mano y no arrojadas. Sin embargo, el conjuro de libertad de movimiento no permite respirar bajo el agua.

Componente material: una correa de cuero, atada alrededor del brazo o una extremidad similar.$c$, components = $c$V, S, M, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal o toque$c$, target = $c$tú o una criatura tocada$c$, duration = $c$10 min/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo) Decratanaio a gamtringa a linatancina)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'libertad de movimiento';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, description = $c$Un conjuro de ligadura crea una forma de retener a una criatura. La víctima sólo tendrá derecho al TS inicial si sus DG equivalen, como mínimo, a la mitad de tu nivel de lanzador.

Un máximo de seis ayudantes pueden colaborar contigo en este conjuro. Por cada ayudante que lance una sugestión, tu nivel de lanzador aumentará en +1 al ejecutar este conjuro. Por cada ayudante que lance dominar animal, dominar persona o dominar monstruo, tu nivel efectivo aumentará en una cantidad equivalente a 1/3 del nivel del ayudante (siempre y cuando la víctima pueda convertirse en receptor del conjuro lanzado por este último). Como los conjuros de los ayudantes se lanzan con el único propósito de mejorar tu nivel de lanzador del conjuro de ligadura, las salvaciones y resistencia a conjuros contra ellos son irrelevantes. Tu nivel de lanzador determinará si la víctima tiene derecho al TS inicial de Voluntad y cuánto durará la ligadura. Todas las ligaduras pueden disiparse.

Sin importar qué versión de la ligadura ejecutes, podrás especificar las condiciones desencadenantes que pondrán fin al conjuro y dejarán libre a la criatura en el momento en que tengan lugar. Estas pueden ser tan sencillas o complicadas como desees, aunque el DM debe estar de acuerdo en que son razonables y en que existen posibilidades de que tengan lugar. Las condiciones pueden estar basadas en el nombre, identidad o alineamiento de la criatura, o en cualquier otra cosa, siempre que sea algo basado en acciones o cualidades observables. Las cosas intangibles, como el nivel, la clase, los DG o los puntos de golpe no sirven para esto. Por ejemplo, la víctima de una ligadura podría ser liberada cuando se le acercara una criatura legal buena, pero no cuando se aproximara a ella un paladín. Una vez que se lance el conjuro, las condiciones desencadenantes no podrán ser cambiadas. Imponer una condición o condiciones a la liberación aumenta en +2 la CD de la salvación (suponiendo que ésta pueda llevarse a cabo para ese caso concreto).

En el caso de las tres primeras versiones del conjuro (las que tienen duraciones limitadas), puedes lanzar nuevos conjuros de ligadura para prolongar tales efectos (las duraciones de ambos sortilegios se solaparían). Si hicieras eso, la víctima tendrá derecho a realizar un TS al finalizar la duración del primer conjuro, incluso aunque tu nivel de lanzador sea lo bastante elevado como para no permitir un TS inicial. Si la criatura logra salvarse, se romperán todos los conjuros de ligadura que se hayan lanzado contra ella.

El conjuro de ligadura tiene seis versiones. Elige una de las siguientes cuando lances el coniuro:

Encadenamiento: el receptor queda confinado en un lugar dotado de un conjuro de antipatía que afecta a todas las criaturas que se le acerquen, excepto a ti mismo. La duración es de un año por nivel de lanzador. El receptor de esta forma de ligadura quedará confinado en el lugar en que se le haya lanzado el sortilegio.

Sopor: infunde en el receptor un sueño comatoso que dura un año por nivel de lanzador. La víctima no necesitará comer ni beber mientras esté presa de este sueño y tampoco envejecerá. Esta forma de ligadura resulta más difícil de lanzar que el encadenamiento, lo cual permite resistirse a ella con mayor facilidad. La CD de la salvación contra este conjuro se reduce en 1.

Sopor encadenado: una combinación de encadenamiento y sopor que dura hasta un mes por nivel de lanzador. Esta versión reduce en 2 la CD de la salvación.

Prisión de confinamiento: el receptor es transportado o llevado por algún otro método hasta un lugar de espacio limitado (como un laberinto) del que no podrá salir bajo ningún concepto. Esta versión del conjuro es permanente, y reduce en 3 la CD de la salvación.

Metamorfosis: el cuerpo del receptor adopta forma gaseosa, a excepción de su cabeza o rostro. La víctima será confinada en un tarro u otro recipiente, sin que ello suponga peligro alguno para ella; el recipiente puede ser transparente o no, según prefieras. La criatura será consciente de su entorno y podrá hablar, pero no podrá abandonar el recipiente, atacar ni usar ninguno de sus poderes o aptitudes. Esta ligadura es permanente. El receptor no necesitará respirar, comer ni beber mientras esté metamorfoseado; tampoco envejecerá. Esta versión del conjuro reduce en 4 la CD de la salvación.

Contención mínima: el receptor queda reducido a una altura de una pulgada o incluso menos y encerrado en un tarro, gema u otro objeto similar. Esta ligadura es permanente. El receptor no necesitará respirar, comer ni beber mientras esté contenido en su prisión; tampoco envejecerá. Esta versión del conjuro reduce en 4 la CD de la salvación.

No puedes disipar un conjuro de ligadura con disipar magia o un efecto similar, aunque un campo antimagia o una disyunción de Mordenkainen le afectan de forma normal. Una criatura extraplanaria afectada por una ligadura no puede ser devuelta a su plano natal por un exorcismo, destierro u otro efecto similar.

Componentes: los componentes de una ligadura varían según la versión del conjuro que se ejecute, pero siempre incluyen la pronunciación de un cántico continuo leído en un rollo de pergamino o la página de un libro que incluya el sortilegio, gestos somáticos, y materiales apropiados para la versión empleada. Entre éstos se incluyen cosas como cadenas en miniatura hechas de

metales especiales (como plata para los licántropos, hierro frío para los demonios, etc.), las más raras hierbas soporíferas (para las ligaduras de sopor), una jarra del más fino cristal, etc.

Además de los objetos fabricados específicamente para el tipo concreto de ligadura (con un coste de 500 po), el conjuro requiere la utilización de ópalos por un valor mínimo de 500 po por DG de la víctima y un dibujo en vitela o bien una estatuilla tallada de la víctima a encerrar.$c$, components = $c$V, S, M$c$, casting_time = $c$un minuto$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura viva$c$, duration = $c$ver texto (D)$c$, saving_throw = $c$Voluntad niega (ver texto)$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'ligadura';
update spells set school = $c$Conjuración$c$, subschool = $c$llamada$c$, description = $c$Dos cualesquiera no podrán distar más de 30' cuando hagan su aparición

Este conjuro funciona igual que ligadura de los planos menor, salvo en que llamar a una sola criatura de hasta 12 DG, o a varias de ellas, cuyo total de DG no supere los 12. Cada criatura podrá realizar su TS, tendrá derecho a llevar a cabo sus propios intentos de huida y deberá ser persuadida individualmente para que te ayude.$c$, components = $c$V, S$c$, target = $c$hasta tres elementales o ajenos convocados, para un total de hasta 12 DG,$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'ligadura de los planos';
update spells set school = $c$Conjuración$c$, subschool = $c$Ilamada$c$, description = $c$Cuando hagan su aparición

Este conjuro funciona como ligadura de los planos menor, pero llama a una sola criatura de hasta 18 DG o a varias del mismo tipo cuyo total de DG no supere los 18. Cada criatura tendrá derecho a realizar un TS, llevará a cabo intentos independientes de huida y deberá ser convencida por separado para que te preste ayuda.$c$, components = $c$V, S$c$, target = $c$hasta tres elementales o ajenos convocados, para un total de hasta 18 DG, dos cualesquiera no podrán distar más de 30'$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'ligadura de los planos mayor';
update spells set school = $c$Conjuración$c$, subschool = $c$llamada$c$, descriptors = $c$ver texto$c$, description = $c$Lanzar este conjuro es un acto peligroso, pues implica atraer a una criatura de otro plano hasta una trampa, especialmente preparada, que debe hallarse dentro del alcance del sortilegio. La criatura llamada quedará inmovilizada en la trampa hasta que acceda a realizar un servicio a cambio de su libertad.

Para crear la trampa, debes usar un conjuro de círculo mágico, orientado hacia dentro. El tipo de

criatura a ligar debe ser conocido y especificado por ti; si quieres llamar a un individuo específico, deberás utilizar el nombre propio de este al ejecutar el sortilegio.

La criatura objetivo podrá realizar un TS de Voluntad. Si éste tiene éxito, la víctima logrará resistirse al conjuro; si el tiro falla, la criatura será atraída de inmediato hasta la trampa (la resistencia a conjuros no impedirá que sea llamada). La criatura podrá escapar del interior de la trampa si tiene éxito en una tirada de RC, por medio del viaje entre planos o con una prueba con éxito de Carisma (CD 15 + 1/2 de tu nivel de lanzador + tu modificador de Carisma). Puede tratar de emplear cada método una vez al día. Si logra liberarse, podrá huir o atacarte. Un ancla dimensional lanzada sobre la criatura impedirá que pueda huir recurriendo al viaje interdimensional. Además, podrás usar un diagrama de llamada (consulta círculo mágico contra el mal, en la pág. 212) para hacer la trampa más segura.

Si la criatura no logra liberarse de la trampa, puedes mantenerla ligada todo el tiempo que quieras. Puedes intentar obligar a la criatura a llevar a cabo un servicio describiendo lo que quieres y, quizás, ofreciéndole una recompensa a cambio. Para ello, deberás realizar una prueba de Carisma enfrentada a la prueba de Carisma de la criatura, encargándose el DM de asignar a la tuya un bonificador de entre 0 y +6, basado en el servicio exigido y la recompensa ofrecida. Si la criatura vence en la prueba enfrentada, se niega a llevar a cabo el servicio. Cada 24 horas podrás proponer nuevos servicios, sobornos, etc., o probar de nuevo con los antiguos. Este proceso podrá repetirse hasta que la criatura prometa servirte, hasta que consiga escapar o hasta que decidas librarte de ella por medio de algún otro sortilegio. Las criaturas ligadas no aceptarán bajo ningún concepto una exigencia que no pueda cumplirse o no sea razonable. Si obtienes un 1 en la prueba de Carisma, la criatura quedará libre de la ligadura y podrá escapar o atacarte.

Una vez llevado a cabo el servicio exigido, la criatura no tendrá más que informarte para ser devuelta de inmediato al lugar del que hubiera venido (aunque podría buscar venganza más adelante). Si las instrucciones implican una tarea ambigua que el receptor no puede llevar a término por sus propios medios (como "Espera aquí" o "Defiende este lugar de cualquier ataque"), el conjuro permanece activo durante un periodo máximo de 1 día por nivel de lanzador, y la criatura obtendrá una posibilidad inmediata de liberarse. Nótese que un receptor inteligente podrá tergiversar ciertas instrucciones.

Cuando se lanza un conjuro de llamada para traer a criaturas de agua, aire, fuego, tierra, buenas, caóticas, legales o malignas, éste se convierte en un sortilegio de ese tipo en cuestión. Es decir, que una ligadura de los planos menor será un conjuro de agua cuando lo utilices para llamar a un elemental de ese mismo elemento.

Ligadura del alma

Nigromancia Nivel: Clr 9, Hcr/Mag 9 Componentes: V, S, F Tiempo de lanzamiento: 1 acción estándar Alcance: corto (25' + 5'/2 niveles) Objetivo: un cadáver Duración: permanente Tiro de salvación: Voluntad niega Resistencia a conjuros: no

Te permite extraer el alma de un muerto reciente, encerrándola dentro de un zafiro negro. El cuerpo no puede llevar muerto más de 1 asalto por nivel de lanzador. Una vez atrapada en la gema, el alma no podrá volver a la vida mediante los conjuros de clonar, revivir a los muertos, reencarnar, resurrección y resurrección verdadera, ni siquiera mediante un milagro o un deseo. Sólo la destrucción de la gema en sí o la disipación del conjuro sobre ella liberarán el alma encerrada (que, hecho eso, seguirá estando muerta). E

Foco: un zafiro negro por valor de al menos 1.000 po por DG poseído por la criatura cuya alma vaya a ser encerrada. Si la piedra no es lo bastante valiosa, se romperá nada más intentarse la ligadura (aunque los personajes no tengan concepto del nivel ni los DG como tales, sí que podrán hacer averiguaciones para saber el valor que ha de tener una gema para encerrar a alguien; sin embargo, recuerda que tal valor podría cambiar con el paso del tiempo al evolucionar los personajes). I mando a la mana mana$c$, components = $c$V, S$c$, casting_time = $c$10 minutos$c$, spell_range = $c$corto (25' + 5'/2 niveles); ver texto$c$, target = $c$un elemental o ajeno de hasta 6 DG$c$, duration = $c$instantánea$c$, saving_throw = $c$voluntad niega a allean sale$c$, spell_resistance = $c$no y sí; ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'ligadura de los planos menor';
update spells set school = $c$Evocación$c$, descriptors = $c$luz$c$, description = $c$Una llama, de brillo equivalente al de una antorcha, surgirá del objeto que toques. El efecto parecerá real, pero no despedirá calor ni necesitará oxigeno. La llama podrá ser cubierta y escondida, pero resultará imposible apagarla.

Los conjuros de luz contrarrestan y disipan conjuros de oscuridad de un nivel igual o inferior.

Componente material: tendrás que espolvorear rubí pulverizado (por valor de 50 po) sobre el objeto que haya de portar la llama. Lama.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$objeto tocado Efecto: llama ilusoria sin calor$c$, duration = $c$permanente$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'llama continua continua de se more';
update spells set school = $c$Evocación$c$, descriptors = $c$electricidad$c$, description = $c$Inmediatamente después de completar el conjuro, y una vez por asalto subsiguiente, puedes llamar a un relámpago vertical de 5' de ancho y 30' de largo que inflige 3d6 puntos de daño por electricidad. El rayo desciende en un impacto vertical hacia cualquier punto que hayas elegido dentro del alcance del conjuro (medido desde tu posición en ese momento). Cualquier criatura en la casilla objetivo o en el camino del ravo es afectada.

No tienes por qué llamar a un relámpago inmediatamente, sino que puedes realizar otras acciones, incluso el lanzamiento de conjuros. Cada asalto tras el primero puedes utilizar una acción estándar (concentrarte en el conjuro) para llamar a un rayo. Puedes llamar a un total de relámpagos igual a tu nivel de lanzador (máximo 10 rayos).

Si te encuentras al aire libre y en una zona tormentosa (lluvia, nubes y viento, un clima cálido y nuboso o incluso un tornado, incluido el formado por un djinn o un elemental de aire de tamaño Grande o superior [consulta el Manual de monstruos]), cada rayo inflige 3d10 puntos de daño por electricidad en lugar de 3d6. Este conjuro funciona en el interior o bajo tierra, pero no bajo el agua. La mente en la$c$, components = $c$V, S$c$, casting_time = $c$1 asalto$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$una o más líneas de relámpago<br>verticales de 30' de largo$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Reflejos mitad$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'llamar al relampago';
update spells set school = $c$Evocación$c$, description = $c$Este truco crea una explosión de luz brillante. Si haces que el efecto se produzca justo delante de una criatura, ésta quedará deslumbrada durante 1 minuto, salvo que supere una salvación de Fortaleza. Las criaturas sin visión o las criaturas ya deslumbradas no resultan afectadas por la llamarada.$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25 + 5/2 niveles)$c$, target = $c$explosión de luz$c$, duration = $c$instantanea$c$, saving_throw = $c$Fortaleza niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'ilamarada';
update spells set school = $c$Adivinación$c$, description = $c$Este conjuro funciona como localizar objeto, salvo en que el conjuro encuentra a una criatura conocida o que te resulte familiar.

Al girar lentamente, notarás en qué momento estás mirando en la dirección en que se encuentre la criatura, siempre y cuando esté dentro del alcance. También sabrás en qué dirección se mueve el objetivo, en caso de estar haciéndolo. El sortilegio puede localizar a una criatura de un tipo concreto (como un humano o un unicornio) o a un individuo particular al que conozcas. Sin embargo, no servirá para encontrar a una criatura de tipo general (como un humanoide o una bestia). Para encontrar a un tipo de criatura, tienes que haber visto a una de cerca (30' o menos) una vez como mínimo.

El agua corriente bloquea este conjuro, que no sirve para detectar objetos y puede ser engañado mediante los sortilegios de doble engañoso, indetectabilidad y polimorfar.

Componente material: un poco de pelaje de sabueso. -$c$, components = $c$V, S, M$c$, duration = $c$10 min/nivel$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'localizar criatura maria de';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsion$c$, description = $c$La criatura afectada sufre un efecto continuo de confusión, como el conjuro. E

Quitar maldición no sirve para eliminar la locura, pero deseo, deseo limitado, milagro, restablecimiento mayor y sanar pueden restablecerla.$c$, components = $c$V. S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$una criatura viva$c$, duration = $c$instantánea$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'locura locura';
update spells set school = $c$Evocación$c$, descriptors = $c$luz$c$, description = $c$Dependiendo de la versión por la que te inclines, creas hasta cuatro luces que podrás utilizar como linternas o antorchas (y despedirán la misma cantidad de luz que estos objetos de iluminación), hasta cuatro esferas de luz brillante (que tendrán el aspecto de fuegos fatuos) o una figura, vagamente humanoide y de brillo tenue. Las luces danzantes deberán mantenerse unas respecto de las otras en un área de 10' de radio, pero por lo demás podrán moverse como desees (sin necesidad de concentración): adelante o atrás, arriba o abajo, en línea recta o doblando las esquinas, etc. Las luces pueden desplazarse hasta 100' por asalto; aquellas que se separen de ti más allá del alcance máximo del conjuro desaparecerán inmediatamente. Luces danzantes puede ser hecho permanente

con permanencia.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$hasta cuatro luces ilusorias, todas ellas en un área de 10' de radio$c$, duration = $c$1 minuto (D)$c$, saving_throw = $c$ninguna$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'luces danzantes';
update spells set school = $c$Evocación$c$, descriptors = $c$luz$c$, description = $c$Antorcha, despidiendo luz brillante en un radio de 20' desde el punto que toques (y luz tenue en 20' adicionales). El efecto es inmóvil, pero puede ejecutarse sobre un objeto móvil. Una luz que sea llevada al interior de una zona de oscuridad mágica no funcionará.

Un conjuro de luz (uno con el descriptor 'luz') contrarresta y disipa un conjuro de oscuridad (uno con el descriptor 'oscuridad') de nivel igual o inferior.

Componente material arcano: una luciérnaga o un poco de musgo fosforescente.

Convental Comm$c$, components = $c$V, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$objeto tocado$c$, duration = $c$10 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no Este conjuro hace que un objeto brille como una$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'luz';
update spells set school = $c$Evocación$c$, description = $c$Concentrando el poder sagrado en forma de rayo de sol, puedes proyectar una descarga luminosa desde la palma de tu mano abierta. Para alcanzar a un oponente, debes tener éxito en un ataque de toque a distancia. La criatura alcanzada por este rayo de luz sufrirá 1d8 puntos de daño por cada dos niveles de lanzador que poseas (máximo 5d8). Los muertos vivientes sufrirán 1d6 puntos de daño por nivel de lanzador (máximo 10d6) o 1d8 por nivel (máximo 10d8) cuando sean especialmente vulnerables a la luz, como los vampiros. Los constructos y los objetos inanimados sufrirán solamente 1d6 puntos de daño por cada dos niveles de lanzador (máximo 5d6).$c$, components = $c$V, S . . Paper at and and$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$rayo and and sundeles Marine Market$c$, duration = $c$instantánea$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'luz abrasadora';
update spells set school = $c$Evocación$c$, descriptors = $c$luz$c$, description = $c$El objeto tocado despedirá luz y brillará como la

luz del día en un radio de 60' y dejará en penumbra otros 60' adicionales. Las criaturas que sufran penalizadores por la luz brillante también los sufrirán cuando se vean expuestos a esta luz mágica. A pesar de su nombre, este conjuro no es equivalente a la luz del día, a efectos de las criaturas que son dañadas o destruidas por la luz (como los vampiros). Si luz del día es lanzado sobre un objeto pequeño y colocado después dentro o debajo de una cobertura capaz de contener la luz, sus efectos quedarán bloqueados hasta retirarse tal cobertura.

Un conjuro de luz del día que penetre en un área afectada por una oscuridad mágica (o viceversa) será negado temporalmente, dejando tras de sí las condiciones de luz que hubiera normalmente en el lugar en que ambos efectos se hayan solapado.

Luz del día contrarresta o disipa todo conjuro de oscuridad de nivel equivalente o inferior al suyo (como oscuridad).

Madera férrea con minulasi sa lem Transmutación Nivel: Drd 6 Componentes: V, S, M Tiempo de lanzamiento: 1 minuto/lb. de sustancia final transformada Alcance: 0' Efecto: un objeto de madera férrea que pese hasta 5 lb./nivel Duración: 1 día/nivel (D) nivel (D) (D) (D) ( Tiro de salvación: ninguno = ================================================================================================================================================= Resistencia a conjuros: no more a contra la

por los druidas a partir de la madera normal. Aunque el material seguirá siendo madera normal en casi todos los aspectos, la sustancia es tan fuerte, pesada y resistente al fuego como el acero. Los conjuros que afecten al metal o al hierro (como calentar metal) no funcionan contra la madera férrea. Los que afecten a la madera (como transformar madera) sí la afectarán, aunque no arderá. Usando este conjuro junto a transformar madera o una habilidad de Artesanía relacionada con la madera, podrás crear objetos de madera que funcionen igual que los de acero. Por tanto, podrás crear armaduras completas y espadas de madera igual de duraderas que sus versiones normales de acero, que los druidas podrán emplear con total libertad. Es más, si creas solamente la mitad de madera

La madera férrea es una sustancia mágica creada

férrea permitida normalmente por el conjuro, toda arma, armadura o escudo transmutado se considerará como un objeto mágico con un bonificador +1 de mejora.

Componente material: madera a la que se ha dado la forma del objeto de madera férrea deseado.$c$, components = $c$V, S$c$, casting_time = $c$1 acción 1$c$, spell_range = $c$toque in a simile a more and ser$c$, target = $c$objeto tocado a sheali com i$c$, duration = $c$10 min/nivel (D) >> 10 = =$c$, saving_throw = $c$ninguno no me m$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'luz del dia mar';
update spells set school = $c$orgentation$c$, description = $c$Te permite conjurar una vivienda en otra dimensión, cuya única entrada estará situada en el plano en que hayas lanzado el conjuro. La entrada parecerá brillar tenuemente en el aire, tendrá 4' de ancho por 8' de alto y sólo podrá ser atravesada por aquellos que designes. El portal se cerrará y se volverá invisible en cuanto lo atravieses, aunque podrás abrirlo a voluntad desde el lado en que te encuentres. Cuando las criaturas designadas hayan atravesado la entrada, se encontrarán dentro de un magnífico vestíbulo que se abre a numerosas salas. La atmósfera del lugar es limpia, fresca y acogedora.

El edificio podrá tener la planta que desees, siempre dentro de los límites del efecto del conjuro. El lugar estará amueblado y tendrá comida suficiente para servir un banquete de nueve platos a tantas docenas de personas como niveles de lanzador poseas. También habrá servidumbre (hasta 2 sirvientes por nivel de lanzador), semitransparente, vestida con librea y obediente, dispuesta a atender a todo el que entre. Los sirvientes funcionan igual que el conjuro de sirviente invisible, pero serán visibles y podrán ir hasta cualquier lugar de la mansión.

Dado que a la mansión sólo puede accederse a través de su puerta especial, las condiciones externas no afectan al edificio, y las que se dan en su interior no llegarán al plano en que se encuentre la entrada. Con en 2 2 2 2 2

Foco: una talla de marfil con forma de puerta en miniatura, un pequeño fragmento de mármol pulido y una cucharilla de plata (cada objeto cuesta 5 po).$c$, components = $c$V, S, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25 + 5'/2 niveles)$c$, target = $c$mansión en otra dimensión, de hasta tres cubos de 10'/nivel (Mo)$c$, duration = $c$2 h/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'magnifica mansion de';
update spells set school = $c$Nigromancia$c$, descriptors = $c$maligno$c$, description = $c$Ño a los ajenos benignos, del mismo modo que el agua bendita inflige daño a los muertos vivientes y los ajenos malignos.

Componente material: 5 lb. de plata pulverizada (por valor de 25 po).$c$, components = $c$V, S, M$c$, casting_time = $c$1 minuto$c$, spell_range = $c$toque$c$, target = $c$frasco de agua tocado$c$, duration = $c$instantánea$c$, saving_throw = $c$Voluntad niega (objeto)$c$, spell_resistance = $c$si (objeto) Este conjuro infunde energía negativa en un frasco de agua (de 1 pinta), convirtiendo su con- tenido en agua sacrílega. Este líquido inflige da$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'maldecir agua';
update spells set school = $c$Evocación$c$, descriptors = $c$Fuerza$c$, description = $c$Este conjuro funciona como la mano interpuesta de Bigby, pero ésta también podrá apresar al oponente que elijas. La mano aferradora puede realizar un ataque de presa por asalto. Su bonificador de ataque para entrar en contacto con el oponente será igual a tu nivel de lanzador + tu modificador de Inteligencia, Sabiduría o Carisma (para magos, clérigos o hechiceros, respectivamente). +10 por la puntuación de Fuerza de la propia mano (31), -1 por ser Grande. Su prueba de presa obtendrá este mismo bonificador, aunque el hecho de ser Grande le concederá un bonificador +4 en lugar de un penalizador -1. La mano puede retener a las criaturas apresadas, pero no infligirles daño. Dirigir el conjuro a un nuevo objetivo es una acción de movimiento.

La mano aferradora también puede embestir a un oponente como la mano forzuda de Bigby, pero con +16 a la prueba de Fuerza (+10 por Fuerza 31, +4 por ser Grande, y un bonificador +2 por cargar, que siempre obtiene), o interponerse como la mano interpuesta de Bigby.

Los clérigos que posean este conjuro cambiarán el nombre de Bigby por el de su deidad correspondiente (por ejemplo, mano aferradora de Kord). Foco arcano: un guante de cuero.$c$, components = $c$V, S, F/FD$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'mano aferradora de bigby';
update spells set school = $c$Evocación$c$, descriptors = $c$fuerza$c$, description = $c$Este conjuro funciona como la mano interpuesta de Bigby, salvo en que la mano puede interponerse, empujar o aplastar al oponente que elijas.

La mano aplastante puede apresar a un oponente del mismo modo que la mano aferradora de Bigby. Su bonificador de presa es igual a tu nivel + tu modificador de Inteligencia, Sabiduría o Carisma (para magos, clérigos o hechiceros, respectivamente), +12 por la puntuación de Fuerza de la propia mano (35), +4 por ser Grande. La mano inflige 2d6+12 de daño (letal, no no letal) en cada prueba de presa con éxito contra un oponente.

La mano aplastante también puede interponerse igual que la mano interpuesta de Bigby o embestir a un oponente como la mano forzuda de Bigby, pero con bonificador +18.

Dirigir el conjuro a un nuevo objetivo es una acción de movimiento.

Los clérigos que posean este conjuro cambiarán el nombre de Bigby por el de su correspondiente deidad (por ejemplo, mano aplastante de San Cuthbert).

Componente material arcano: la cáscara de un huevo.

Foco arcano: un guante de piel de serpiente.$c$, components = $c$V, S, M, F/FD$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'mano aplastante de bigby';
update spells set school = $c$Evocación$c$, description = $c$Creas la imagen fantasmal de una mano que puede ser enviada en busca de alguien hasta una distancia de 5 millas. A continuación, la mano llama a la persona buscada haciendo señas y le sirve de guía hasta ti si decide seguirla.

Cuando se lanza el conjuro, la mano aparece delante de ti. A continuación, debes especificar una persona (o criatura) dando su descripción física, que puede incluir raza, sexo y apariencia, pero no factores ambiguos como el nivel, el alineamiento o la clase. Cuando la descripción esté completa, la mano marchará en busca de un receptor que encaje con tales datos. La cantidad de tiempo que tardará en encontrar al receptor dependerá de lo lejos que éste se encuentre.

| | Tiempo para | | |
| | |--|--|
| Distancia | localizarlo | | |
| Hasta 100' | 1 asalto | | |
| 1.000' | 1 minuto | | |
| Una milla | 10 minutos | | |
| Dos millas | 1 hora | | |
| Tres millas | 2 horas | | |
| Cuatro millas | 3 horas | | |
| Cinco millas | 4 horas | | |
| | | | |

Una vez localiza al receptor, la mano le hace señas para que la siga. Si éste lo hace, la mano señalará en tu dirección y lo dirigirá por el camino más directo y viable. La mano flota 10' por delante del receptor, desplazándose en cualquier dirección a una velocidad máxima de 240' por asalto. La mano desaparecerá en cuanto haya dirigido al receptor hasta ti.

El receptor no estará obligado a seguir a la mano ni a actuar de un modo concreto ante ti. Si optase por no seguir a la mano, ésta seguirá llamándolo hasta que expire la duración del conjuro y después desaparecerá. Si el conjuro expira mientras el receptor está acercándose hasta ti, la mano desaparecerá igualmente y la criatura deberá confiar en sus propias capacidades para dar contigo.

Si en un radio de 5 millas hay más de un receptor que coincida con la descripción, la mano irá en busca del que más se ajuste a ella. Si tal criatura se niega a seguir a la mano, ésta no irá en busca de un segundo receptor.

Si, tras 4 horas de búsqueda, la mano no ha encontrado a un receptor que se ajuste a la descripción en 5 millas a la redonda, volverá hasta ti, mostrará su palma extendida (indicando que no ha encontrado a ninguna criatura) y desaparecerá.

La mano fantasmal carece de forma física y es invisible, excepto ante ti y los posibles receptores del conjuro. No puede enzarzarse en combate ni ejecutar una tarea distinta de localizar al receptor y dirigirlo hasta ti. La mano tampoco puede atravesar objetos sólidos, pero puede rezumar a través de pequeñas grietas o aberturas. Tampoco puede alejarse más de 5 millas del punto en que lances el conjuro.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$cinco millas$c$, target = $c$mano fantasmal$c$, duration = $c$1 h/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'mano auxiliadora';
update spells set school = $c$Transmutacion$c$, description = $c$Señalas un objeto con tu dedo y el conjuro te permite elevarlo y moverlo desde lejos. Usando una acción de movimiento puedes desplazarlo hasta 15' en cualquier dirección, aunque el efecto finalizará si el objeto en cuestión llega a exceder en cualquier momento el alcance del sortilegio.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$un objeto, desatendido y no mágico, de hasta 5 lb. de peso$c$, duration = $c$concentración$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'mano del mago';
update spells set school = $c$Nigromancia$c$, description = $c$Una mano, brillante, fantasmal y hecha con tu fuerza vital, se materializa y mueve según tus deseos, permitiéndote transmitir a distancia conjuros de toque de bajo nivel. Al ejecutar el sortilegio, pierdes 1d4 puntos de golpe que recuperarás al finalizar el conjuro (incluso aunque éste sea disipado). Si la mano es destruida, no recuperarás esos puntos de golpe, pero podrás curarlos del modo normal. Mientras dure el sortilegio, podrás usar la mano para transmitir los conjuros de toque que lances, siempre que sean de nivel 4.º o inferior. El conjuro te concede un bonificador +2 en los ataques de toque en cuerpo a cuerpo, y usar la mano de este modo contará normalmente como un ataque. La mano siempre golpea desde tu dirección, y no puede flanquear a sus objetivos, tal y como haría una auténtica criatura. Si excede el límite de alcance del conjuro o si tú dejas de dirigirla, la mano volverá hasta ti y se quedará flotando.

La mano es incorporal y, por tanto, no puede ser dañada por armas normales. Además tiene evasión mejorada (sufre la mitad de daño al fallar una salvación de Reflejos, y ningún daño en absoluto si la salvación tiene éxito), tus salvaciones base y una CA mínima de 22. Tu modificador de Inteligencia se aplicará a la CA de la mano como si se tratara de su modificador de Destreza, y ésta tendrá entre 1 y 4 puntos de golpe (la misma cantidad que hayas perdido al crearla).$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$una mano espectral$c$, duration = $c$1 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'mano espectral';
update spells set school = $c$Evocación$c$, descriptors = $c$Fuerza$c$, description = $c$Este conjuro funciona como mano interpuesta de Bigby, pero la mano forzuda persigue y empuja al oponente que designes. Considera que este ataque es una embestida con un bonificador +14 a la prueba de Fuerza (+8 por el 27 en Fuerza de la mano, +4 por ser Grande y +2 por el bonificador de carga que ésta siempre obtiene). La mano siempre se desplaza junto al oponente, empujándolo hasta cubrir toda la distancia permitida, y su velocidad no se ve limitada. Dirigir el conjuro a un nuevo objetivo es una acción de movimiento.

Una criatura muy fuerte no podrá apartar la mano de su camino (pues ésta volvería a colocarse instantáneamente entre ella y tú), pero sí podría empujarla hacia ti si lograra embestirla con éxito.

Foco: un guante resistente, hecho de cuero o tela gruesa.$c$, components = $c$V.S. F$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'mano forzuda de bigby';
update spells set school = $c$Evocación$c$, descriptors = $c$Fuerza$c$, description = $c$260

La mano interpuesta de Bigby crea una mano Grande de naturaleza mágica, que aparece entre tu oponente y tú. Esta mano, flotante y carente de cuerpo, se moverá para situarse en todo momento entre ambos contendientes, sin importar hasta dónde te desplaces o el modo en que tu enemigo intente rodearla; al actuar de este modo, la mano te concederá cobertura (+4 a la CA) contra ese oponente. Nada puede engañar a la mano: seguirá poniéndose delante de tu oponente a pesar de

la oscuridad, la invisibilidad, el polimorfismo o cualquier otro intento de esconderse o disfrazarse que el enemigo intente llevar a cabo. Sin embargo, la mano no perseguirá al oponente.

Una mano de Bigby tiene 10' de longitud y más o menos esa anchura con los dedos extendidos. Tendrá tantos puntos de golpe como tengas tú cuando estés indemne y su CA será 20 (-1 de tamaño, +11 natural). Sufre daño como una criatura normal, pero la mayoría de efectos mágicos que no causen daño no la afectarán en absoluto, y nunca provoca ataques de oportunidad por parte de los oponentes. La mano no podrá abrirse paso a través de un muro de fuerza ni entrar en un campo antimagia; además, sufrirá los efectos completos de un muro prismático o una esfera prismática. La mano realizará los TS igual que su lanzador, y podrá ser destruida con un conjuro de desintegrar o un disipar magia con éxito.

Toda criatura que pese menos de 2.000 lb. será ralentizada cuando intente abrirse paso empujando a la mano, moviéndose sólo a la mitad de su velocidad. Si el oponente pesa más de 2.000 lb., la mano no podrá reducir su velocidad, pero seguiría afectando a sus ataques.

Dirigir el conjuro hacia un nuevo oponente es una acción de movimiento.

Foco: un guante ligero.$c$, components = $c$V, S, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$mano de 10'$c$, duration = $c$1 asalto/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'mano interpuesta de bigby';
update spells set school = $c$Evocación$c$, description = $c$Una cono de llamas abrasadoras se extiende desde las yemas de tus dedos. Toda criatura que se encuentre en el área de las llamas sufrirá 1d4 puntos de daño por fuego por nivel de lanzador que poseas (máximo 5d4). Los objetos inflamables, como la tela, el papel, el pergamino o la madera delgada, empezarán a arder si entran en contacto con ella. Un personaje puede apagar los objetos que empiecen a arder como acción de asalto completo.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$15'$c$, target = $c$explosión en forma de cono$c$, duration = $c$instantánea$c$, saving_throw = $c$Reflejos mitad$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'manos ardientes';
update spells set school = $c$Conjuración$c$, subschool = $c$convocación$c$, description = $c$Cuando pronuncias el conjuro de marabunta, atraes a varias plagas de ciempiés (una por cada dos niveles de lanzador, hasta un máximo de diez plagas a nivel 20.º), las cuales no tienen por qué aparecer advacentes entre sí (consulta el Manual de monstruos para los detalles de las plagas de ciempiés).

Puedes convocar a las plagas de ciempiés para que ocupen el mismo espacio que otras criaturas. Las plagas permanecen estáticas, atacando a cualquier criatura en su zona, a no ser que ordenes a la marabunta que se mueva (una acción estándar). Como acción estándar, puedes ordenar a cualquier número de plagas que se mueva hacia cualquier presa dentro de un radio de 100' de ti. No puedes ordenar a ninguna plaga que se mueve a más de 100' de ti, y si eres tú el que se mueve a una distancia superior a esa de cualquier plaga, esta permanecerá estática, atacando a las criaturas en su zona (puedes darle órdenes de nuevo si te mueves hasta estar a menos de 100' de ella)$c$, components = $c$V, S$c$, casting_time = $c$1 asalto$c$, spell_range = $c$corto (25' + 5'/2 niveles)/100'; ver texto$c$, target = $c$una plaga de ciempiés por cada dos niveles$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'marabunta';
update spells set school = $c$Universal$c$, description = $c$Este conjuro te permite inscribir tu runa o marca personal, que no puede tener más de 6" de alto ni estar formada por más de 6 caracteres. La escritura puede ser visible o invisible. El conjuro de marca arcana te permite grabar tu runa sobre cualquier sustancia (incluso piedra o metal) sin causar daño al material. Si grabas una runa invisible, un conjuro de detectar magia la hará brillar y volverse visible (aunque no necesariamente comprensible). Así mismo, ver lo invisible, visión verdadera, una gema de visión o una túnica de los ojos permitirán a sus usuarios ver una marca arcana invisible. Un conjuro de leer magia revelará las palabras, en caso de haberlas. La marca no puede ser disipada, pero puede ser eliminada por su lanzador o por un conjuro de borrar. Si la marca es grabada sobre una criatura viva, el desgaste normal de la piel la hará desaparecer gradualmente, borrándola al cabo de un mes.

Una marca arcana debe ejecutarse sobre un objeto antes de lanzar sobre él las convocaciones instantáneas de Drawmij (consulta la descripción de este conjuro para obtener más detalles).$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$0'$c$, target = $c$una runa o marca personal, que debe ocupar como máximo 1 pie cuadrado$c$, duration = $c$permanente$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'marca arcana';
update spells set school = $c$Nigromancia$c$, description = $c$Cuando la persuasión moral no baste para hacer que un criminal se comporte correctamente, podrás recurrir a la marca de la justicia para animarlo a buscar el buen camino.

El conjuro te permite dibujar una marca indeleble sobre el receptor y elegir un comportamiento que, al ser seguido por éste, active inmediatamente la magia. Cuando esto ocurra, la marca maldecirá inmediatamente al receptor. Lo más normal es elegir un tipo de comportamiento criminal para que active la marca, pero puedes optar por cualquier acto que desees. El efecto de la marca es idéntico al del sortilegio lanzar maldición. Como el conjuro tarda 10 minutos en ser ejecutado e implica poder escribir sobre su receptor, sólo podrás lanzarlo sobre alguien que se ofrezca voluntariamente o esté retenido.

Al igual que lanzar maldición, la marca de la justicia no puede ser disipada, pero puede ser eliminada por un conjuro de deseo, deseo limitado, milagro, quitar maldición o romper encantamiento. Sin embargo, quitar maldición sólo funcionará si su lanzador tiene, como mínimo, el mismo nivel que el nivel de lanzador de tu marca de la justicia. Estas restricciones se aplican sin importar si la marca se ha activado o no.$c$, components = $c$V, S, FD$c$, casting_time = $c$10 minutos$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$permanente; ver texto$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'marca de la justicia';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, description = $c$Te permite conjurar a un perro guardián fantasmal que sólo podrá ser visto por ti y que se encargará de vigilar el área en que haya sido conjurado (no se mueve). El mastín empezará a ladrar ruidosamente en cuanto una criatura de tamaño Pequeño o mayor se acerque a 30' o menos de él (las que ya estuvieran a 30' o menos al conjurarse el mastín podrán moverse libremente por el área, pero el ladrido se activará si la abandonan y vuelven a entrar). El mastín puede ver a las criaturas invisibles y etéreas. No reacciona ante las quimeras, pero sí ante las ilusiones sombrías.

Si un intruso se acerca a 5' o menos del mastín, éste dejará de ladrar e intentará dar un violento mordisco (bonificador +10 al ataque, 2d6+3 puntos de daño perforante), una vez por asalto de combate. El perro obtendrá también los bonificadores correspondientes a las criaturas invisibles. Se considera que el mastín está preparado para morder a los intrusos, por lo que será el primero en atacar durante el turno del personaje que se le acerque. Su mordisco equivale a un arma mágica en lo que se refiere a la reducción del daño. El mastín no podrá ser atacado, pero sí disipado.

El conjuro dura 1 hora por nivel de lanzador hasta que el mastín empiece a ladrar; llegado ese momento, el efecto pasará a durar 1 asalto por nivel de lanzador. El conjuro finalizará en cuanto te alejes a más de 100' del perro guardián. Componente material: un diminuto silbato de plata, un fragmento de hueso y una correa.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$perro guardián fantasmal$c$, duration = $c$1 h/nivel de lanzador o hasta ser descargado, y a continuación 1 asalto/nivel de lanzador: ver texto$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'mastin fiel de mordenkainen';
update spells set school = $c$Nigromancia$c$, description = $c$Este conjuro funciona como círculo de muerte, salvo en que destruye criaturas muertas vivientes, tal y como se señala arriba.

Componente material: el polvo de un diamante triturado, con un valor de al menos 500 po.$c$, components = $c$V, S, M/FD$c$, target = $c$varias criaturas muertas vivientes dentro de una explosión de 40' de radio$c$, saving_throw = $c$Voluntad niega$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'matar muertos vivientes';
update spells set school = $c$Evocación$c$, descriptors = $c$legal, sonico$c$, description = $c$Toda criatura no legal dentro del área de un conjuro de máxima sufre los siguientes efectos nocivos:

| DG | Efecto |
| | |
| lguales al nivel del lanzador | Sordera |
| Hasta el nivel del lanzador -1 | Ralentización,<br>sordera |
| Hasta el nivel del lanzador -5 | Parálisis,<br>ralentización, sordera |
| Hasta el nivel del lanzador -10 | Muerte, |
| | parálisis, ralentización, sordera |

Los efectos son acumulativos y simultáneos. No se permite un TS contra estos efectos.

Sordera: la criatura se queda sorda durante 1d4 asaltos.

Ralentización: la criatura es ralentizada, como por el conjuro de ralentizar, durante 2d4 asaltos. Parálisis: la criatura queda paralizada e indefensa durante 1d10 minutos.

Muerte: una criatura viva moriría. Un muerto viviente sería destruido.

Además, si estás en tu plano natal cuando lanzas el conjuro, las criaturas extraplanares no legales que haya en el área serán desterradas inmediatamente y devueltas a sus planos de origen. Las criaturas desterradas de esta forma no podrán regresar durante 24 horas, como mínimo. Este efecto tendrá lugar independientemente de si las criaturas oven o no la máxima. El efecto de destierro puede ser negado mediante una salvación de Voluntad (con un penalizador -4).

Las criaturas cuyos DG excedan de tu nivel de lanzador no resultan afectadas por la máxima.$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$40'$c$, target = $c$criaturas no legales en una expansión de<br>40' de radio, centrada en ti$c$, duration = $c$instantanea$c$, saving_throw = $c$ninguno o Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'maxima';
update spells set school = $c$Ilusión$c$, subschool = $c$fantasmagoría$c$, descriptors = $c$enajenador$c$, description = $c$El conjuro te permite (a ti o a un mensajero tocado por ti) enviar un mensaje fantasmagórico que llegará a su destinatario en forma de sueño. Al comenzar el sortilegio, debes nombrar al destinatario o identificarlo mediante algún título que no deje lugar a dudas respecto a su identidad. A continuación, el mensajero entrará en trance y aparecerá en los sueños del receptor del conjuro, transmitiéndole el mensaje deseado. El mensaje puede tener cualquier extensión y el receptor lo recordará perfectamente cuando despierte. La comunicación será en un solo sentido. El receptor no podrá preguntar ni ofrecer información, ni el mensajero podrá averiguar nada observando los sueños del receptor. La mente del mensajero volverá a su cuerpo inmediatamente después de haber transmitido el mensaje. La duración del sortilegio indica el tiempo que el mensajero necesita para entrar en el sueño del receptor y hacer entrega del mensaje.

Si el receptor estuviera despierto al dar comienzo el conjuro, el mensajero podría optar por despertar (poniendo fin al sortilegio) o seguir con su trance, que podrá poolongar hasta que el receptor se duerma para penetrar en sus sueños y entregar el mensaje con total normalidad. Si el mensajero fuera perturbado durante su trance, despertaría de inmediato y el conjuro finalizaría.

Este conjuro no permite entrar en contacto con criaturas que no duerman ni sueñen (como los elfos, pero no los semielfos).

El mensajero no será consciente de las actividades que tengan lugar en su entorno mientras se encuentre en trance. Estará indefenso mientras se encuentre en tal estado, tanto física como mentalmente (fallará todos sus TS, por ejemplo).$c$, components = $c$V. S$c$, casting_time = $c$1 minuto$c$, spell_range = $c$ilimitado Section of the Barristics of the Barrison$c$, target = $c$una criatura viva tocada$c$, duration = $c$ver texto por a cara a para$c$, saving_throw = $c$ninguno marcare$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'mensaje onirico';
update spells set school = $c$Abjuracion$c$, description = $c$El receptor queda protegido contra todo objeto o conjuro que pueda detectar, influir o leer las emociones o los pensamientos. Este sortilegio protege contra todos los conjuros y efectos enajenadores, además de impedir la obtención de información mediante conjuros o efectos de adivinación. Mente en blanco engaña incluso a los conjuros de deseo, deseo limitado y milagro cuando se utilizan para afectar a la mente del receptor o para obtener información acerca de él. Cuando se trate de un escudriñamiento que examine el área en que se encuentre la criatura (como un ojo arcano), el conjuro funcionará, pero la criatura no será detectada. Los intentos de escudriñamiento que se dirijan contra el receptor de la mente en blanco no funcionarán.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estáno$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura$c$, duration = $c$24 horas$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'mente en blanco';
update spells set school = $c$Nigromancia$c$, descriptors = $c$enajenador, miedo$c$, description = $c$Un cono invisible de terror hace que todas las criaturas vivas en el área queden despavoridas si no tienen éxito en una salvación de Voluntad. Si está acorralada, una criatura despavorida queda aterrada (consulta la Guía del Dungeon Master para más información sobre las criaturas despavoridas por el miedo). Si la salvación de Voluntad tiene éxito, la criatura queda estremecida durante 1 asalto.

Componente material: un corazón de gallina o una pluma blanca.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$30'$c$, target = $c$explosión en forma de cono$c$, duration = $c$1 asalto/nivel o 1 asalto; ver texto$c$, saving_throw = $c$Voluntad parcial Dacictarcia a comitirac. C1$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'mieda';
update spells set school = $c$Evocación$c$, description = $c$Más que para realizar un milagro, este conjuro te sirve para pedir que tenga lugar uno. Para ello, tendrás que decir qué deseas que suceda y, a continuación, pedir a tu deidad (o al poder al que reces para obtener conjuros) que interceda por ti. Hecho esto, el DM determinará el efecto concreto del milagro.

Este conjuro puede hacer una de las siguientes cosas:

Duplicar cualquier conjuro de clérigo de hasta 8.º nivel (incluyendo aquellos sortilegios a los que tengas acceso gracias a tus dominios). Duplicar cualquier otro conjuro de hasta 7.º nivel.

Deshacer los efectos perjudiciales de ciertos

conjuros, como debilidad mental o locura. Producir cualquier otro efecto cuyo nivel de

poder no exceda lo dicho anteriormente.

Si el milagro produce cualquiera de los efectos citados más arriba, ejecutarlo no supone coste alguno en puntos de experiencia.

Por otro lado, el clérigo puede pedir algo muy poderoso; en ese caso, el milagro le costará 5.000 PX, dadas las poderosas energías divinas que se verán envueltas en el lanzamiento. Éstos son varios ejemplos de milagros poderosos:

· Cambiar el curso de una batalla en tu favor, haciendo que tus aliados caídos vuelvan a alzarse para continuar combatiendo.

- · Desplazarte junto con tus aliados (y todo vuestro equipo) a través de las barreras de los planos hasta un lugar concreto y sin posibilidad de error.
- · Proteger toda una ciudad de un terremoto, una erupción volcánica, una inundación u otro desastre natural de grandes dimensiones.

Sea como fuere, tu deidad rechazará toda petición que no se ajuste a su naturaleza (o a su alineamiento).

Todo conjuro duplicado permite los mismos TS y resistencia a conjuros que su versión normal (aunque la CD de la salvación será la de un conjuro de 9.º nivel). Cuando el milagro duplique los efectos de un conjuro con coste en PX, tendrás que pagar ese coste. Cuando el milagro duplique los efectos de un conjuro con un componente material que cueste más de 100 po, necesitarás disponer del componente en cuestión.

Coste en PX: 5.000 PX (sólo en algunos usos del conjuro de milagro; véase más arriba). == 11$c$, components = $c$V, S, PX; ver texto$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$ver texto
- Obietivo, efecto o á$c$, target = $c$ver texto$c$, duration = $c$ver texto$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'milagro';
update spells set school = $c$Nigromancia$c$, descriptors = $c$maligno$c$, description = $c$Cada asalto puedes elegir como objetivo a una única criatura viva, golpeándola con olas de poder maligno. Dependiendo de los DG del objetivo, este ataque puede tener hasta tres efectos:

| DG | Efecto |
| | |
| 10 o más | Indispuesto |
| 5-9 | Despavorido, indispuesto |
| 4 o menos | Comatoso, despavorido,<br>indispuesto |

Los efectos son acumulativos y concurrentes: Indispuesto: un dolor y fiebre repentinos sacuden el cuerpo del objetivo. Una criatura indispuesta recibe un penalizador -2 a las tiradas de ataque, las tiradas de daño con armas, los TS, las pruebas de habilidades y las pruebas de características. Una criatura afectada por este conjuro permanece indispuesta 10 minutos por nivel de lanzador. Estos efectos no pueden ser negado por un conjuro de quitar enfermedad o sanar, pero un quitar maldición es efectivo.

Despavorido: el objetivo queda despavorido durante 1d4 asaltos. Incluso después de que el pavor termine, la criatura permanece estremecida durante 10 minutos por nivel de lanzador, y vuelve a quedar despavorida de nuevo automáticamente si vuelve a verte durante este tiempo. Este es un efecto de miedo.

Comatoso: el objetivo cae en un coma catatónico durante 10 minutos por nivel de lanzador. Durante este tiempo no puede ser despertado por ningún medio que ni implique disipar el efecto. Este no es un efecto de dormir, y por lo tanto los elfos no son inmunes a él.

El conjuro dura 1 asalto por cada tres niveles de lanzador. Debes emplear una acción de movimiento cada asalto después del primero para dirigirlo a un enemigo.

| Mnemotecnia de Rary |
| |
| Transmutación |
| Nivel: Mag 4 |
| Componentes: V, S, M, F |
| Tiempo de lanzamiento: 10 minutos |
| Alcance: personal |
| Objetivo: tú |
| Duración: instantánea |
| |

Lanzar este conjuro te permite preparar sortilegios adicionales o retener conjuros que hayas lanzado recientemente.

Debes elegir una de las dos versiones cuando lances este sortilegio.

Preparación: puedes preparar hasta tres niveles de conjuro adicionales (como tres sortilegios de 1.ª nivel; uno de 2.º y otro de 1.º; o uno de 3.º). En lo que se refiere a este conjuro, un truco (nivel 0) contará como medio nivel de conjuro. Puedes preparar y lanzar estos conjuros con total normalidad.

Retención: te permite retener un conjuro cualquiera, de hasta 3.0 nivel, que hayas lanzado durante el asalto anterior a empezar la ejecución de la mnemotecnia. Haciendo esto, el conjuro recién lanzado volverá a tu mente.

Sea como fuere, el conjuro o conjuros preparados o retenidos desaparecerán al cabo de 24 horas (si no se ejecutan antes).

Componentes materiales: un fragmento de cordel y tinta hecha con tinta de calamar y sangre de dragón negro.

Foco: una placa de marfil por un valor mínimo de 50 po.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura viva$c$, duration = $c$1 asalto/tres niveles; ver texto$c$, saving_throw = $c$Fortaleza niega Resistencia a coniuros: sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'mirada penetrante';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Te permite entrar en la mente del receptor y modificar un máximo de 5 minutos de sus recuerdos, empleando uno de los siguientes métodos:

- Eliminar todos los recuerdos sobre un acontecimiento que el receptor haya experimentado. Esto no sirve para negar los conjuros de hechizar, sugestión, geas/empeño y otros efectos similares
- · Permite al receptor recordar con total claridad un acontecimiento que haya experimentado. Por ejemplo, podría acordarse de toda una conversación de 5 minutos de duración o
- de todos los detalles de un pasaje de un libro. · Cambiar los detalles de un acontecimiento
- que el receptor haya experimentado.
- Implantar el recuerdo de un acontecimiento que el receptor no haya experimentado en realidad.

Lanzar el conjuro requiere 1 asalto. Si el receptor fallara su TS, podrás proceder con el conjuro, empleando un máximo de 5 minutos (un periodo de tiempo equivalente a la cantidad de memoria a alterar) visualizando los recuerdos del receptor que desees modificar. El conjuro se romperá si tu concentración se interrumpe antes de completar tal visualización o si el receptor excede el alcance máximo del conjuro durante ese tiempo.

Un recuerdo modificado no tiene por qué afectar a las acciones del receptor, sobre todo cuando vaya en contra de sus inclinaciones naturales. Un recuerdo modificado de forma ilógica (como el receptor rememorando lo bien que se lo pasó ingiriendo veneno) será considerado por el receptor como una pesadilla o el producto de una borrachera. Las formas más útiles de usar este conjuro son implantar recuerdos de encuentros amistosos contigo (haciendo que el receptor reaccione de forma más favorable hacia

ti), cambiar detalles de las órdenes dadas al receptor por su superior o hacer que el receptor olvide haberte visto a ti o a tu grupo en el pasado. El DM podrá determinar cuándo un recuerdo modificado es demasiado absurdo como para afectar de manera significativa al receptor. -$c$, components = $c$V, S$c$, casting_time = $c$1 asalto; ver texto$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura viva$c$, duration = $c$permanente$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$si$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'modificar recuerdo a la';
update spells set school = $c$Conjuración$c$, subschool = $c$convocación$c$, description = $c$Convocas a un caballo ligero o un poni (según prefieras) para que te sirva de montura. El corcel se pondrá a tus órdenes de forma voluntaria y te servirá bien. El animal llegará hasta ti provisto de bocado, brida y silla de montar. Componente material: un poco de crin de caballo.$c$, components = $c$V, S, M$c$, casting_time = $c$1 asalto$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una montura$c$, duration = $c$2 h/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'montura';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, description = $c$Un muro de espinas crea una barrera de arbustos, flexibles, enmarañados y muy resistentes, provistos de espinas puntiagudas tan largas como el dedo de una persona. Toda criatura empujada contra el muro de espinas o que intente moverse a través de él sufrirá 25 puntos de daño menos su CA por asalto de movimiento. Los bonificadores de Destreza y los bonificadores de esquiva a la CA no se tendrán en cuenta para este cálculo (las criaturas con una CA de 25 o superior, sin tener en cuenta los bonificadores de Destreza y esquiva, no sufrirán daño por entrar en contacto con el muro).

El espesor mínimo del muro es de 5', lo cual te permitirá darle forma utilizando tantos bloques de 10×10× 5' como el doble de tu nivel de lanzador. Esto no afectará al daño infligido por las espinas, pero las criaturas que intenten atravesarlo tardarán menos en cruzar de un lado al otro.

Las criaturas pueden abrirse paso lentamente a través del muro realizando pruebas de Fuerza como acción de asalto completo. Por cada 5 puntos en que la prueba exceda una CD de 20, la criatura se mueve 5' (hasta una distancia máxima igual a su velocidad terrestre normal). Por ejemplo, una criatura que obtenga un 25 en su prueba de Fuerza podrá moverse 5' en un asalto. Obviamente, moverse a través de las espinas (o intentarlo) infligirá el daño indicado más arriba. Una criatura atrapada en las espinas podrá optar por quedarse quieta para evitar sufrir más daño.

Toda criatura que se encuentre en el área del conjuro cuando sea ejecutado sufrirá daño como si se hubiera movido por su interior y, además, quedará atrapada en él. Para poder escapar, tendrá que abrirse paso o bien esperar a que finalice el sortilegio. Las criaturas que dispongan de la aptitud para atravesar áreas cubiertas de maleza sin impedimento alguno podrán atravesar el muro de espinas a su velocidad normal y sin sufrir daño.

Un muro de espinas puede ser perforado lentamente utilizando armas cortantes. A base de tajos, puede crearse un pasillo de 1' de profundidad por cada 10 minutos de esfuerzo. El fuego normal no podrá dañar la barrera, pero el fuego mágico la calcinará en 10 minutos.

A pesar de su apariencia, un muro de espinas no es en realidad una planta viva, por lo que no resulta afectada por los conjuros que afectan a las plantas.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$muro de arbustos espinosos, de hasta un cubo de 10'/nivel (Mo)$c$, duration = $c$10 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'muro de espinas legado';
update spells set school = $c$Evocación$c$, descriptors = $c$fuego$c$, description = $c$Este conjuro crea una cortina, inmóvil y abrasadora, hecha de brillantes llamas violáceas. Una de las caras del muro (a tu elección) emitirá oleadas de calor, infligiendo 2d4 puntos de daño por fuego a las criaturas que haya a un máximo de 10' y 1d4 puntos de daño por fuego a las que estén a más de 10 y a un máximo de 20'. El muro infligirá este daño cuando aparezca y durante tu turno cada asalto en que una criatura entre en su área o permanezca en ella. Además, el muro infligirá 2d6 puntos de daño por fuego, +1 punto adicional de daño por fuego por nivel de lanzador (máximo +20) a toda criatura que lo atraviese. El muro infligirá el doble de daño a los muertos vivientes.

Si evocas el muro para que aparezca en un lugar ocupado por criaturas, cada una de ellas sufriría daño como si lo atravesara.

Un segmento cualquiera de 5' de muro desaparecerá de inmediato si sufre 20 o más puntos de daño por frío en un mismo asalto (no dividas este daño por frío entre 4, como suele hacerse con los objetos).

Muro de fuego puede ser hecho permanente con un conjuro de permanencia. Un muro de fuego permanente que sea extinguido mediante daño por frío queda inactivo durante 10 minutos, tras lo cual se reforma con su fuerza normal,

Componente material arcano: un pequeño fragmento de fósforo. En 1$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$una cortina opaca de llamas de hasta 20' de longitud/nivel, o un anillo de fuego con un radio de 5'/2 niveles; ambas formas tienen 20' de alto$c$, duration = $c$concentración +1 asalto/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'muro de fuego';
update spells set school = $c$Evocación$c$, descriptors = $c$fuerza$c$, description = $c$Este conjuro crea una pared invisible de fuerza. El muro no puede moverse, es inmune al daño de todo tipo y no resulta afectado lo más mínimo por la mayoría de conjuros, incluyendo disipar magia. Sin embargo, desintegrar lo destruiría por completo, igual que haría un cetro de cancelación, una esfera de aniquilación o una disyunción de Mordenkainen. Los conjuros y armas de aliento no podrán atravesar el muro en ninguna dirección, aunque puerta dimensional, teleportar y demás efectos similares sí pueden superarlo. El efecto bloquea tanto a las criaturas etéreas como a las materiales (aunque, por lo general, las etéreas podrán sortear el muro flotando por encima o por debajo de él, atravesando suelos y techos materiales). Los ataques de mirada funcionan perfectamente a través del muro de fuerza.

El lanzador puede dar al muro la forma de un plano, liso y vertical, con un área máxima de un cuadro de 10' de lado por nivel. El muro de fuerza debe ser continuo y no estar fragmentado en el momento de su creación; si su superficie se rompe en algún punto por culpa de un objeto o criatura, el conjuro fracasa sin más.

Muro de fuerza puede ser hecho permanente con un conjuro de permanencia.

Componente material: una pizca de polvo obtenido de una gema diáfana.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una pared con un área de hasta un cuadrado de 10'/nivel$c$, duration = $c$1 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'muro de fuerza';
update spells set description = $c$Dependiendo de la versión que elijas, este conjuro crea un plano de hielo anclado o un hemisferio de hielo. Un muro de hielo no puede formarse en ninguna área que esté ocupada por criaturas u objetos físicos. Al crearlo, su superficie ha de ser lisa y no estar fragmentada. Cualquier criatura adyacente al muro cuando este sea creado puede intentar una salvación de Reflejos para perturbarlo cuando está siendo formado. Una salvación con éxito indica que el conjuro falla automáticamente. El fuego (incluyendo una bola de fuego y el aliento de un dragón rojo) puede fundir un muro de hielo, infligiéndole daño completo (en lugar de la mitad de daño que normalmente sufren los objetos). Si el muro de hielo se funde de repente, se generará una gran nube de bruma vaporosa que durará 10 minutos.

Plano de hielo: esto hace aparecer una pared de hielo, fuerte y dura, de 1" de grosor por nivel de lanzador. El efecto cubrirá un área máxima de un cuadrado de 10'/nivel de lanzador (por tanto, un mago de 10.º nivel puede crear un muro de hielo de 100' de largo por 10' de alto, uno de 50' de largo por 20' de alto, o cualquier otra combinación de largo y ancho que no exceda los 1.000' cuadrados). El plano puede estar orientado en cualquier dirección, siempre y cuando esté anclado. Un muro vertical sólo necesita estar anclado al suelo, mientras que uno horizontal o inclinado tendrá que estar anclado a dos lados, situados uno frente al otro.

La naturaleza del muro será, ante todo, defensiva, pudiendo utilizarse para detener a quienes te estén persiguiendo y cosas así. Cada cuadro de 10' de lado del muro tendrá 3 puntos de golpe por pulgada de espesor. Las criaturas podrán golpear el muro automáticamente, rompiendo toda sección cuyos puntos de golpe logren reducir a 0. Si una criatura intentara atravesar el muro de un solo ataque, la CD de la prueba de Fuerza sería 15 + su nivel de lanzador.

Aun habiendo logrado atravesar el hielo, seguirá estando presente una cortina de aire frío. Toda criatura que la atraviese (la que haya roto la pared incluida) sufrirá 1d6 puntos de daño por frío +1 punto adicional por nivel de lanzador (sin salvación).

Hemisferio: el muro adopta la forma de un hemisferio cuyo radio máximo es igual a 3' +1 pie adicional por nivel de lanzador. Por tanto, un lanzador de 7.º nivel puede crear un hemisferio de 10' de radio. El hemisferio es igual de difícil de romper que el plano de hielo, pero no infligirá daño a quienes atraviesen la brecha.

Componente material: un pequeño fragmento de cuarzo u otro cristal de roca similar.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$plano de hielo anclado de hasta un
- cuadrado de 10'/nivel; o bien un hemisferio de hielo con un radio de hasta 3' + 1'/nivel$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Reflejos niega; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'muro de hielo';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, description = $c$Este conjuro te permite crear un muro de hierro, liso y vertical, que puede utilizarse para cerrar un pasillo o sellar una brecha, pues el efecto se insertará en el material inerte que lo rodee, siempre que su área lo permita. El efecto no puede conjurarse en un área que esté ocupada por una criatura u otro objeto. Siempre ha de ser un plano liso, aunque puedes dar forma a sus bordes para que se ajusten al espacio disponible. Un muro de hierro tiene 1" de grosor por cada

4 niveles de lanzador. Puedes doblar el área del muro reduciendo a la mitad su grosor. Cada cuadro de 5' de lado del muro tendrá 30 puntos de golpe por pulgada de espesor y una dureza de 10. Toda sección del muro cuyos puntos de golpe queden reducidos a 0 se romperá sin más. Si una criatura intentara atravesar el muro de un solo golpe, la CD de la prueba de Fuerza sería de 25 + 2 por cada pulgada de espesor.

Si lo deseas, puedes crear un muro vertical que descanse sobre una superficie plana pero que no esté sujeto a los lados, de modo que puedas volcarlo e intentar aplastar a las criaturas que haya debajo de él. Si nadie lo empuja, el muro tendrá un 50% de posibilidades de volcarse hacia un lado o hacia el otro. Es posible empujarlo en una dirección en lugar de dejarlo caer al azar, aunque quien lo intente deberá tener éxito en una prueba de Fuerza (CD 40). Las criaturas que tengan sitio para huir del muro cuando esté cayendo podrán realizar un TS de Reflejos. Las criaturas Grandes o más pequeñas que fallen sufrirán 10d6 puntos de daño; el muro no podrá aplastar a criaturas Enormes o mayores.

Al igual que toda pared de hierro, ésta también resultará afectada por la herrumbre, la perforación y demás fenómenos naturales.

Componentes materiales: un pequeño fragmento de lámina de hierro y polvo de oro por valor de 50 po (1 libra de polvo de oro).$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$muro de hierro con un área$c$, duration = $c$instantánea$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'muro de hierro';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, descriptors = $c$tierra$c$, description = $c$![](_page_264_Picture_37.jpeg)$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$muro de piedra con un área máxima de un cuadrado de 5'/nivel (Mo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'muro de piedra';
update spells set school = $c$Ilusión$c$, subschool = $c$quimera$c$, description = $c$Este conjuro crea la ilusión de una pared, suelo, techo u otra superficie similar. Parecerá absolutamente real al ser observada, pero los objetos físicos podrán atravesarla sin la menor dificultad. Cuando el conjuro se utilice para ocultar pozos, trampas o puertas normales, toda aptitud de detección que no haga uso de la vista funcionará con total normalidad. El contacto o la exploración con ayuda de un objeto revelará la verdadera naturaleza de la superficie, pero no hará desaparecer la ilusión.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$imagen de 1×10×10'$c$, duration = $c$permanente$c$, saving_throw = $c$Voluntad descree (si se interactúa con el conjuro)$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'muro ilusorio';
update spells set school = $c$Abjuración$c$, description = $c$Este conjuro crea una pared opaca y vertical, un plano de luz, brillante y multicolor, que te protege contra todas las formas de ataque. El muro despide luz de siete colores, cada uno de los cua-

![](_page_265_Picture_19.jpeg)

El muro prismático es una barrera eficaz.

![](_page_265_Picture_22.jpeg)

| MURO PRISMÁTICO | | | |
| | | | |
| Color | Orden | Efecto del color | Negado por |
| Rojo | 1.0 | Detiene las armas no mágicas de ataque a distancia.<br>Inflige 20 puntos de daño por fuego (Reflejos mitad). | Cono de frio |
| Naranja | 20: | Detiene las armas mágicas de ataque a distancia.<br>Inflige 40 puntos de daño por ácido (Reflejos mitad). | Ráfaga de<br>viento |
| Amarillo | | 3.º Detiene venenos, gases y petrificación. Inflige 80 puntos<br>de daño por electricidad (Reflejos mitad). | Desintegrar |
| Verde | | Detiene las armas de aliento. Envenena (mata; Fortaleza parcial<br>para sufrir solamente 1 d6 puntos de daño de Constitución). | Pasamiento |
| Azul | 5 . | Detiene la adivinación y los ataques mentales. Petrifica<br>(Fortaleza niega). | Proyectil<br>mágico |
| Añil | | Detiene todos los conjuros. Salvación de Voluntad para<br>no enloquecer (como con locura). | Luz del día |
| Violeta | 7.0 | Campo de energía que destruye todos los objetos y efectos .<br>Las criaturas son enviadas a otro plano (Voluntad niega). | Disipar magia |

1 El efecto violeta hace que los poderes especiales de los otros seis colores resulten redundantes, pero éstos se incluyen aquí porque ciertos objetos mágicos pueden generar efectos prismáticos de un solo color, y porque la RC podría inutilizar solamente algunos de los colores (consulta la explicación del conjuro).

les posee distinto poder y propósito. La pared es inmóvil, y tú podrás atravesarla y permanecer a su lado sin sufrir daño por ello. No obstante, las criaturas con menos de 8 DG que se encuentren a 20' o menos del efecto quedarán cegadas durante 2d4 asaltos si miran al muro.

Las proporciones máximas del muro son 4' de ancho por nivel de lanzador y 2' de alto por nivel de lanzador. Si el muro prismático se materializa en un espacio ocupado por una criatura, el conjuro será interrumpido y se perderá sin más.

Cada color del muro posee un efecto particular. La tabla de arriba muestra los siete colores de la pared, el orden en que aparece cada uno de ellos, los efectos sobre las criaturas que intenten atacarte o atravesar la barrera y la magia necesaria para negar cada color.

El muro puede ser destruido (color a color, por orden correlativo) mediante varios efectos mágicos; sin embargo, habrá que eliminar el primero antes de poder hacer lo mismo con el segundo, eliminar el segundo antes que el tercero, etc. Un cetro de cancelación o un conjuro de disyunción de Mordenkainen destruirán el muro prismático, pero un campo antimagia no podrá penetrar en él. Disipar magia y disipación mayor no podrán disipar ni el muro ni nada que haya detrás de él. La RC resulta eficaz contra el muro prismático, pero la prueba de nivel de lanzador deberá repetirse para cada color presente.

Muro prismático puede ser hecho permanente mediante un conjuro de permanencia.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$muro de 4' ancho/nivel x 2' alto/nivel$c$, duration = $c$10 min/nivel (D)$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'muro prismatico';
update spells set description = $c$Cualquier criatura dentro del área que falle una salvación de Voluntad se vuelve somnolienta y poco atenta, sufriendo un penalizador -5 en las pruebas de Avistar y Escuchar, y un penalizador -2 en las salvaciones de Voluntad contra dormir mientras la nana esté en efecto. Este conjuro dura mientras el lanzador se concentre, y tras ello hasta 1 asalto adicional por nivel de lanzador.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100'+10+/nivel)$c$, target = $c$criaturas vivas en una explosión de 10' de radio$c$, duration = $c$concentración + 1 asalto/nivel (D)$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'nana';
update spells set school = $c$Conjuración$c$, subschool = $c$curación$c$, description = $c$Eliminas todo veneno de la criatura u objeto que toques. Una criatura envenenada no sufrirá daño ni efectos adicionales como consecuencia del veneno, además de dejar de padecer los efectos que esté sufriendo temporalmente. Sin embargo, el conjuro no invertirá los efectos instantáneas, como el daño a los puntos de golpe, el daño temporal de característica o los efectos que no desaparezcan por sí solos. Si, por ejemplo, un veneno hubiera infligido 3 puntos de daño temporal a la Constitución de un personaje y amenazara con volver a infligirle daño más adelante, el sortilegio impediría el daño futuro pero no podría reparar el que ya estuviera hecho.

La criatura es inmune a cualquier veneno al que se vea expuesta durante la duración del conjuro. A diferencia de lentificar veneno, sus efectos no son retrasados hasta que concluya la duración (la criatura no necesita realizar ninguna salvación contra efectos de veneno que pueda recibir durante la duración del conjuro).

Este conjuro también puede, de modo alternativo, neutralizar el veneno de las criaturas y objetos venenosos durante su duración, a opción del lanzador.

Componente material arcano: un poco de carbón vegetal.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura u objeto tocado, de hasta 1 nie cúbico/nivel$c$, duration = $c$10 min/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo, objeto)$c$, spell_resistance = $c$sí (inofensivo, objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'neutralizar veneno';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, description = $c$Este conjuro hace que te rodee un vapor neblinoso que queda inmóvil una vez lo creas y enturbia por completo la visión (incluyendo la visión en la oscuridad) más allá de 5'. Las criaturas situadas a 5' de distancia dispondrán de ocultación (los ataques contra ellas tendrán un 20% de posibilidad de fallo) y las que estén a más de 5' tendrán ocultación total (50% de posibilidad de fallo, y los atacantes no podrán localizarlas recurriendo a la vista).

Un viento moderado (11 millas/h o más), como el de un conjuro de ráfaga de viento, dispersará la niebla en 4 asaltos. Un viento fuerte (21 millas/h o más) la dispersará en 1 solo asalto. Una bola de fuego, una descarga flamígera u otro conjuro similar consumirán la niebla en el área del conjuro explosivo o abrasador. Un sortilegio de muro de fuego consumirá la niebla en el área en que pueda infligir daño.

Este conjuro no funciona bajo el agua.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$20'$c$, target = $c$nube, de 20' de alto y centrada en ti, que se expande hasta los 20'$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'niebla de obscurecimiento';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, description = $c$Este conjuro crea un banco de niebla, similar al de la nube brumosa, salvo en que sus vapores son venenosos y tienen un mortecino color verdoso amarillento. Esta niebla mata a toda criatura viva con 3 DG o menos (sin TS alguno) y obliga a las criaturas que tengan entre 4 y 6 DG a realizar un TS de Fortaleza para evitar la muerte (en caso de tener éxito, siguen recibiendo 1d4 puntos de daño de Constitución durante tu turno en cada salto que permanezcan en la nube). Las criaturas vivas con 6 o más DG sufrirán 1d4 puntos de daño de Constitución durante tu turno por cada asalto que permanezcan en la nube (una salvación de Fortaleza con éxito reduce este daño a la mitad). Aguantar la respiración no sirve de nada, pero las criaturas inmunes al veneno no resultan afectadas por el conjuro.

Al contrario que nube brumosa, la nube aniquiladora se aleja de ti a 10' por asalto, avanzando sobre el terreno. Calcula cada asalto la nueva expansión de la nube basándote en su nuevo punto de origen, que estará a 10' más de distancia del punto de origen en el momento del lanzamiento. Como los vapores son más densos que el aire, tenderán hacia el nivel de terreno más bajo, colándose incluso en madrigueras y bocas de pozo; por tanto, el conjuro es ideal para acabar, por ejemplo, con una colonia de hormigas gigantes. Sin embargo, el efecto no es capaz de penetrar los líquidos ni puede ser ejecutado bajo el agua. agua.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$nube que se expande hasta 20' de radio$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Fortaleza parcial; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'nube aniquiladora';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, description = $c$Este conjuro crea un banco de niebla similar al generado por la nube brumosa, pero sus vapores producen náuseas. Las criaturas vivas que se encuentren dentro de la nube quedarán mareadas mientras permanezcan en ella y 1d4+1 asaltos después de dejarla (tira por separado para cada criatura mareada). Los que tengan éxito en su TS pero continúen dentro de la nube, deberán volver a salvarse cada asalto durante tu turno.

Nube apestosa puede ser hecho permanente con un conjuro de permanencia. Una nube apestosa permanente disipada por el viento se vuelve a formar en 10 minutos.

Componente material: un huevo podrido o varias hojas de col fermentada. Comunia en ano me$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$nube que se expande en un radio de 20 y con 20' de alto$c$, duration = $c$1 asalto/nivel$c$, saving_throw = $c$Voluntad niega; ver texto$c$, spell_resistance = $c$si$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'nube apestosa';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$bruma que se expande en un radio de 20' y 20' de altura$c$, duration = $c$10 min/nivel$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'nube brumosa a m';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, descriptors = $c$fuego$c$, description = $c$Este conjuro crea una nube de humo revuelto y lleno de ascuas al rojo blanco. La humareda entorpecerá la visión igual que haría un conjuro de nube brumosa. Además, las ascuas al rojo blanco del interior de la nube infligen 4d6 puntos de daño por fuego por asalto a todo lo que haya en su interior (los objetivos pueden realizar una salvación de Reflejos cada asalto para reducir el daño a la mitad).

Al igual que sucede con el sortilegio de nube aniquiladora, el humo se alejará de ti a 10' por asalto: calcula cada asalto la nueva expansión de la nube basándote en el nuevo punto de origen (que estará a 10' más de distancia del punto de origen en el momento del lanzamiento). Concentrándote, puedes hacer que la nube (para ser exactos, su punto de origen) se desplace hasta 60' por asalto. Toda porción de la nube que pudiera extenderse más allá del alcance máximo se disipará sin hacer daño alguno, reduciendo el resto de la expansión a partir de ese momento.

Al igual que sucede con la nube brumosa, el viento dispersará el humo, y el conjuro no puede ejecutarse bajo el agua.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$nube que se expande en un radio de 20', de 20' de alto$c$, duration = $c$1 asalto/nivel$c$, saving_throw = $c$Reflejos mitad; ver texto$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'nube incendiaria';
update spells set school = $c$Abjuración$c$, description = $c$Componente material arcano: un fragmento de piel de camaleón. En marca este la ma$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque = = = = =$c$, target = $c$un objeto tocado, de hasta 100 lb/nivel$c$, duration = $c$8 horas (D)$c$, saving_throw = $c$Voluntad niega (objeto)$c$, spell_resistance = $c$sí (objeto) Este sortilegio oculta a un objeto impidiendo que sea localizado por efectos de adivinación (escudriñamiento), como el conjuro de escudriñamiento o una bola de cristal. Un intento de este tipo falla automáticamente (si la adivinación está dirigida al objeto), o no logra percibir al objeto (si la adivinación está centrada en una zona, objeto o persona cercana).$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'obscurecer objeto some a';
update spells set school = $c$Ilusión$c$, subschool = $c$engaño$c$, description = $c$Cualquier conjuro de adivinación (escudriñamiento) utilizado para ver cualquier cosa en el interior del área de este conjuro recibe en su lugar una imagen falsa (como el conjuro de imagen mayor). Dentro de la duración del sortilegio, puedes concentrarte para cambiar la imagen del modo en que desee. Mientras no te concentres, la imagen permanece estática.

Componente material arcano: polvo de jade (valor mínimo de 250 po) molido que ha de espolvorearse por el aire al ejecutarse el sortilegio. 15 per all of the program and

Ojo arcano a comento per

Adivinación (escudriñamiento) Nivel: Hcr/Mag 4 Col Colliner Componentes: V, S, Museum Serva (Legard Tiempo de lanzamiento: 10 minutos Alcance: ilimitado | Se | La | La | | | | | | | Efecto: sensor mágico de 1 Duración: 1 min/nivel (D) Tiro de salvación: ninguno Resistencia a conjuros: no concere

Creas un sensor mágico invisible que te envía información visual. Puedes crear el sensor en cualquier lugar que puedas ver, tras lo cual podrá viajar más allá de tu línea de visión sin inconveniente alguno. Un ojo arcano se desplaza a 30' por asalto (300' por minuto) si se limita a explorar una zona como haría un ser humano (mirando sobre todo al suelo) o a 10' por asalto (100' por minuto) si, además, examina paredes y techos. El ojo arcano ve exactamente igual que verías tú si estuvieras en ese lugar. Mientras dure el conjuro, el sensor puede desplazarse en cualquier dirección. Las barreras sólidas bloquearán su paso, aunque el ojo podrá atravesar cualquier agujero o espacio de al menos 1" de diámetro. El ojo no puede entrar en otro plano de existencia, ni siquiera mediante un umbral u otro portal mágico similar. Elle mall

Debes concentrarte para poder usar el ojo. Si no lo haces, éste se quedará inmóvil hasta que vuelvas a concentrarte.

Componente material: un poco de grasa de murciélago.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción - - estándar 17 de 1 2 1 2 1 2 1 - 2 1 - 2 1 - 1 - 1 - 1$c$, spell_range = $c$toque$c$, target = $c$emanación de 40 pie de radio 1 - 1$c$, duration = $c$1 hora/nivel (D) ===================================================================================================================================================$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'ofuscar videncia';
update spells set school = $c$Adivinación$c$, description = $c$Creas 1d4 + tu nivel de lanzador orbes mágicos, visibles y semitangibles (llamados "ojos"), que pueden ir a un lugar, explorarlo y volver hasta ti, según les indiques al lanzar el conjuro. Cada ojo puede ver hasta 120' de distancia en todas direcciones (aunque sólo dispone de visión normal).

Aunque individualmente sean bastante frágiles, estos ojos son pequeños y difíciles de ver. Cada uno de éstos es un constructo Minúsculo, más o menos del tamaño de una manzana pequeña, con un 1 solo punto de golpe, CA 18 (bonificador +8 por su tamaño), que vuela a una velocidad de 30' con maniobrabilidad perfecta, y que tiene un modificador +16 en sus pruebas de Esconderse. Además, estos ojos tienen un modificador de Avistar igual a tu nivel de lanzador (máximo +15), y sufren los efectos normales de las ilusiones, la oscuridad, la niebla y cualquier otro factor que altere la capacidad de recibir información visual del entorno. Un ojo que se desplace en la oscuridad deberá guiarse mediante el tacto.

Al crear estos ojos, debes especificarles las instrucciones a seguir mediante una orden de 25 palabras como máximo. Los ojos compartirán contigo todos los conocimientos que poseas, así que si, por ejemplo, sabes qué aspecto tiene un mercader típico, los ojos también lo sabrán.

A continuación tienes algunos ejemplos de órdenes.

- · "Rodeadme a 400' de distancia y regresad si veis acercarse a criaturas peligrosas". La palabra "rodeadme" hará que los ojos formen un anillo horizontal en torno a ti, desplazándose contigo a la distancia que les indiques y equidistantes unos de otros. A medida que los ojos vayan regresando o siendo destruidos, los demás cambiarán su posición para compensar la pérdida. En el caso de esta orden, un ojo sólo regresaría si viera una criatura a la que tú consideres peligrosa. Un "campesino" que, en realidad, sea un dragón que haya cambiado de forma no haría regresar a uno de los ojos. Diez ojos pueden formar un anillo de 400' de radio y ser capaces de ver todo aquello que entre en él.
- "Dispersaos y buscad a Arweth por la ciudad. Seguidlo durante tres minutos, manteniéndoos fuera de la vista y luego volved hasta mí". La palabra "dispersaos" hará que los ojos se alejen de ti en todas direcciones. En este caso, cada ojo que se encontrara con Arweth lo seguiría por separado durante tres minutos.

Otras órdenes que podrían resultar de utilidad serían hacer que los ojos se pusieran en fila, hacer que avanzaran al azar desde un punto concreto o indicarles que siguieran a un tipo concreto de criatura. El DM será quien juzgue si tus indicaciones son aptas o no. -

Los ojos han de volver a tu mano para poder informarte de sus descubrimientos, y cada uno de ellos te informará de todo lo que haya visto durante su existencia (para transmitirte todas las imágenes de 1 hora necesitan sólo 1 asalto). Después de informarte de sus averiguaciones, el ojo desaparece.

Si uno de los ojos se aleja a más de una milla de ti, deja de existir de inmediato. No obstante, tu vínculo con el ojo es tan fuerte que sabrás si su destrucción se ha debido a alejarse demasiado o a alguna otra razón.

Los ojos existirán durante 1 hora por nivel de lanzador que poseas o hasta que regresen hasta ti. Pueden ser destruidos mediante el conjuro de disipar magia, pero tendrás que realizar una tirada por cada ojo que se encuentre en el área afectada por la disipación. Por supuesto, uno de estos ojos podría destruirse si lo enviaras hacia la oscuridad y chocase con una pared u otro obstáculo similar. Componente material: un puñado de canicas de cristal.$c$, components = $c$V, S, M$c$, casting_time = $c$1 minuto$c$, spell_range = $c$una milla$c$, target = $c$diez o más ojos levitantes$c$, duration = $c$1 h/nivel; ver texto (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'ojos fisgones';
update spells set school = $c$Nigromancia$c$, description = $c$Olas de energía negativa hacen que todas las criaturas vivas en el área del conjuro queden exhaustas. Este conjuro no tiene efecto sobre las criaturas que ya estén exhaustas. I 11 11 11 24

นที่ 2011 เมื่อ$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$60'$c$, target = $c$explosión en forma de cono$c$, duration = $c$instantánea a com a a la a l$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'olas de agotamiento';
update spells set school = $c$Nigromancia$c$, description = $c$Olas de energía negativa dejan fatigadas a todas las criaturas vivas en el área del conjuro. Este conjuro no tiene efecto sobre las criaturas que ya estén fatigadas. Consection de l$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$30' a na loro$c$, target = $c$explosión en forma de cono$c$, duration = $c$instantánea 1 School$c$, saving_throw = $c$ninguno che a de a de moll$c$, spell_resistance = $c$sí en se al mesta$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'olas de fatiga - la mar mais lega';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador, dependiente del idioma$c$, description = $c$Te permite dar al receptor una sola orden, que éste obedecerá lo mejor posible lo antes que pueda. Puedes elegir de entre las siguientes opciones:

· Acércate: durante su turno, el objetivo se mueve hacia ti del modo más rápido y directo posible durante 1 asalto. La criatura no puede hacer otra cosa que moverse durante su turno, y su movimiento provocará ataques de oportunidad del modo normal.

Suéltalo: en su turno, el objetivo deja caer cualquier cosa que esté sujetando. No puede recoger nada que haya soltado hasta su siguiente turno.

Tírate: en su turno, el objetivo se tira al suelo y

- permanece tumbado durante 1 asalto. Puede
- actuar de manera normal mientras esté tumba-
- do, pero recibe los penalizadores apropiados.
- · Huye: en su turno, el objetivo se aleja de ti tan
- rápido como le sea posible durante 1 asalto. No puede hacer otra cosa que no sea moverse
- durante su turno, y su movimiento provocará
- ataques de oportunidad del modo normal.
- · Detente: el objetivo se queda quieto donde es-
- té durante 1 asalto. No puede realizar ningu-

na acción, pero no se le considera indefenso.

Si el objetivo no puede llevar a cabo tu orden en su siguiente asalto, el conjuro falla automáticamente. In the Contractional of Children$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura viva$c$, duration = $c$1 asalto$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'orden imperiosa';
update spells set school = $c$Evocación$c$, descriptors = $c$oscuridad$c$, description = $c$Este conjuro hace que un objeto irradie oscuridad en un radio de 20'. Todas las criaturas en el área obtienen ocultación (20% de posibilidades de fallo). Incluso las criaturas capaces de ver normalmente en la oscuridad (como aquellas que posean visión en la oscuridad o visión en la penumbra) tienen la posibilidad de fallar en una zona cubierta por una oscuridad mágica. Las luces normales (antorchas, velas, linternas, etc.) no funcionarán, como tampoco lo harán los conjuro de luz de niveles inferiores (como luz o luces danzantes). Los conjuros de luz de niveles superiores (como luz del día) no resultan afectados por la oscuridad.

Si el conjuro es lanzado sobre un objeto pequeño y colocado después dentro o debajo de una cobertura capaz de contener la luz, sus efectos quedarán bloqueados hasta que se retire esta cobertura.

Oscuridad contrarresta o disipa todo conjuro de luz de nivel equivalente o inferior al suyo.

Componentes materiales arcanos: un poco de pelo de murciélago y una gota de brea o un trozo de carbón.$c$, components = $c$V, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$objeto tocado$c$, duration = $c$10 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'oscuridad';
update spells set school = $c$Transmutacion$c$, description = $c$Este conjuro altera el contenido de una página para que parezca algo totalmente diferente. Por tanto, podrías hacer que un mapa pareciera un tratado sobre el bruñido de bastones de madera de ébano. El texto de un conjuro podría ser alterado para parecer una página del libro mayor de un comercio o incluso un conjuro totalmente distinto. Sobre una página secreta pueden ejecutarse unas runas explosivas o una impronta de la serpiente sepia.

Un conjuro de comprensión idiomática no basta, de por sí, para revelar el contenido de una página secreta. Serás capaz de revelar su contenido original pronunciando una palabra especial. Luego podrás leer la página detenidamente y devolverla a voluntad a su forma de página secreta. También podrás anular el conjuro por completo pronunciando dos veces la palabra especial. Un sortilegio de detectar magia mostrará una tenue aura mágica en la página en cuestión, pero no sacará a relucir su verdadero contenido. Visión verdadera revelará la presencia de material oculto, pero no revelará el contenido en sí, a no ser que se ejecute junto a un conjuro de comprensión idiomática. Una página secreta puede ser disipada, y el escrito oculto puede ser destruido por medio de un conjuro de borrar.

Componentes materiales: polvo de escamas de arenque y esencia de fuego fatuo.$c$, components = $c$V, S, M$c$, casting_time = $c$10 minutos$c$, spell_range = $c$toque$c$, target = $c$página tocada, de hasta 3 cuadrados<br>de tamaño$c$, duration = $c$permanente$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'pagina secreta';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Pronuncias una única palabra de poder que hace que una criatura de tu elección quede aturdida, pueda o no escuchar la palabra. La duración del conjuro depende del total de puntos de golpe que tenga en ese momento el objetivo. Cualquier criatura con 151 o más puntos de golpe no resulta afectada por la palabra de poder aturdidor.

| Puntos de golpe | Duración | |
| | |--|
| Hasta 50 | 4d4 asaltos | |
| 51 a 100 | 2d4 asaltos | |
| 101 a 150 | 1d4 asaltos | |$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25 + 5'/2 niveles)$c$, target = $c$una criatura de hasta 150 pg$c$, duration = $c$ver texto$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'palabra de poder aturdidor';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Pronuncias una única palabra de poder que hace que una criatura de tu elección quede cegada, pueda o no escuchar la palabra. La duración del conjuro depende del total de puntos de golpe que tenga en ese momento el objetivo. Cualquier criatura con 201 o más puntos de golpe no resulta afectada por la palabra de poder cegador.

| Puntos de golpe | Duración | |
| | |--|
| Hasta 50 | Permanente | |
| 51 a 100 | 1d4+1 minutos | |
| 101 a 200 | 1d4+1 asaltos | |$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25 + 5'/2 niveles)$c$, target = $c$una criatura con hasta 200 pg$c$, duration = $c$ver texto$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'palabra de poder cegador';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, description = $c$Pronuncias una única palabra de poder que instantáneamente mata a una criatura de tu elección, pueda o no escuchar la palabra. Cualquier criatura que en ese momento tenga 101 o más puntos de golpe no resulta afectada por la palabra de poder mortal.$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles) Objetivo o á$c$, target = $c$una criatura viva con hasta 100 pg$c$, duration = $c$instantanea$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$si$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'palabra de poder mortal';
update spells set description = $c$Objeto)

Este conjuro te teleporta instantáneamente hasta tu santuario cuando pronuncias la palabra de regreso. Tienes que designar cuál es tu santuario al preparar el conjuro, y éste debe ser un lugar con el que estés muy familiarizado. El punto de llegada debe ser un área designada que no supere los 10×10'. Podrás cubrir cualquier distancia en un mismo plano, pero no podrás trasladarte de un plano a otro. Además de viajar tú mismo, podrás transportar todos los objetos que estés llevando, siempre que su peso no exceda tu carga máxima. También puedes llevar una criatura voluntaria Mediana o más pequeña adicional (que lleve equipo u objetos hasta su carga máxima) o su equivalente por cada tres niveles de lanzador. Una criatura Grande cuenta como dos Medianas, una Enorme como dos Grandes, etc. Todas las criaturas a transportar deben estar en contacto las unas con las otras, y al menos una debe estar en contacto contigo. Si se exceden estas limitaciones, el conjuro falla.

La palabra de regreso no podrá transportar a una criatura no voluntaria. Así mismo, un TS de Voluntad por parte de una criatura (o su RC) impedirá teleportar objetos que obren en su poder. Los objetos desatendidos que no sean mágicos no tendrán derecho a TS. In no$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$ilimitado$c$, target = $c$tú y objetos o criaturas voluntarias tocados$c$, duration = $c$instantanea$c$, saving_throw = $c$ninguno o Voluntad niega (inofensivo, objeto)$c$, spell_resistance = $c$no o sí (inofensivo,$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'palabra de regreso';
update spells set school = $c$Evocación$c$, descriptors = $c$bueno, sónico$c$, description = $c$Cualquier criatura que no sea buena dentro del área y que escuche la palabra sagrada sufre los siguientes efectos nocivos: ====================================================================================================================================================

| DG | Efecto |
| | |
| lgual al nivel de lanzador | Sordera |
| Hasta el nivel de lanzador -1 Ceguera, sordera | |
| Hasta el nivel de lanzador -5 | Parálisis, |
| | ceguera, sordera |
| Hasta el nivel de lanzador -10 | Muerte. |
| | parálisis, ceguera, sordera |
| | |

Los efectos son acumulativos y concurrentes. Sordera: la criatura se queda sorda durante 1d4 asaltos.

Ceguera: la criatura se queda ciega durante 2d4 asaltos.

Parálisis: la criatura queda paralizada e indefensa durante 1d10 minutos. - DI ITal

Muerte: una criatura viva muere. Un muerto viviente es destruido.

Además, si estás en tu plano natal, las criaturas extraplanarias no buenas que haya en el área serán desterradas inmediatamente y devueltas a sus planos de origen. Las criaturas desterradas de esta forma no podrán regresar durante 24 horas, como mínimo. Este efecto tendrá lugar independientemente de si las criaturas oyen o no la palabra sagrada. El efecto de destierro puede ser negado por una salvación de Voluntad (con un penalizador de -4).

Las criaturas cuyos DG excedan tu nivel de lanzador no resultan afectadas por una palabra sagrada.$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$40'$c$, target = $c$criaturas no buenas en una expansión de
- 40' de radio, centrada en ti$c$, duration = $c$instantánea$c$, saving_throw = $c$ninguno o Voluntad niega; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'palabra sagrada';
update spells set school = $c$Efecto$c$, description = $c$Este conjuro combina varios elementos que crean una poderosa protección contra el escudriñamiento y la observación directa. Al ejecutar el sortilegio, dictas qué podrá y no podrá ser observado en el área afectada, aunque la ilusión creada deberá ser definida en términos generales. Por tanto, puedes especificar que se te pueda ver jugando al ajedrez con otra criatura mientras dure el sortilegio, pero no podrás hacer que los jugadores ilusorios hagan una pausa, se vayan a comer y luego reanuden la partida. Podrás hacer que un cruce parezca vacío y tranquilo aunque, en realidad, haya un ejército pasando por él. En este último caso, podrías especificar que el efecto ocultase a todo el mundo (incluyendo a los transeúntes corrientes), que tus tropas no pudieran ser detectadas o que sólo pudiera verse uno de cada cinco soldados que pasara por el cruce. Las condiciones no podrán cambiarse una vez hayan sido establecidas.

Los intentos de escudriñar el área detectarán automáticamente la imagen que hayas decidido, sin TS que valga. La imagen y el sonido se corresponderán con la ilusión creada. Por ejemplo, un grupo de personas de pie en mitad de un prado podría ocultarse como un prado vacío en el que cantaran los pajarillos.

En caso de observación directa, se tendrá derecho a un TS (como si se tratara de una ilusión normal) cuando existan razones para descreer: ciertos observadores podrían empezar a "sospechar" si un ejército desapareciera en un lugar para aparecer de nuevo en otro. El hecho de entrar en el área no cancelará la ilusión ni tendrá por qué dar derecho a un TS, siempre y cuando las criaturas escondidas se aparten de las afectadas por el conjuro. 14,011$c$, components = $c$V, S V, S = 1 = 1 =$c$, casting_time = $c$10 minutos$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$un cubo de 30'/nivel (Mo)$c$, duration = $c$24 horas$c$, saving_throw = $c$ninguno o Voluntad descree (si se interactúa con el conjuro); ver texto$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'pantalla';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, description = $c$Una nube de partículas doradas cubre todo y a todos en el área, cegando a las criaturas y volviendo visible el contorno de las cosas invisibles durante la duración del conjuro. Todo lo que haya en el área quedará cubierto por el polvo, que será imposible de quitar y continuará brillando hasta desaparecer.

Cualquier criatura cubierta por el polvo sufre un penalizador -40 en las pruebas de Esconderse. Componente material: mica molida. And 1971$c$, components = $c$V, S, M = Component$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$criaturas y objetos en una expansión de 10' de radio$c$, duration = $c$1 asalto/nivel$c$, saving_throw = $c$Voluntad niega (sólo efecto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'particulas rutilantes';
update spells set school = $c$Transmutación$c$, description = $c$Te permite crear un pasadizo en una pared de madera, yeso o piedra, pero no en las que estén hechas de metal u otro material más duro. El pasaje tiene 10' de profundidad, más 5' adicionales por cada tres niveles de lanzador por encima del 9.º (15' a nivel 12.º, 20' a nivel 15.º, y un máximo de 25' a nivel 18.º). Cuando el grosor de la pared sea superior a la profundidad del pasaje creado, un único lanzamiento de este conjuro sólo creará un nicho o un corto túnel. Por lo tanto, varios lanzamientos de pasamiento pueden crear un pasadizo continuo, capaz de atravesar paredes más gruesas. Cuando finalice el sortilegio, las criaturas que se encuentren en el pasadizo serán expulsadas a través de la salida más cercana. Si alguien disipa el pasamiento o tú lo deshaces, las criaturas que haya en su interior serán expulsadas por la salida más alejada si hubiera más de una, y por la única existente si sólo hubiera una. Componente material: algunas semillas de sésamo.

Pasar sin dejar rastro Transmutación Nivel: Drd 1, Exp 1 Componentes: V, S, FD Tiempo de lanzamiento: 1 acción estándar Alcance: toque Objetivos: una criatura tocada/nivel Duración: 1 hora/nivel (D) Tiro de salvación: Voluntad niega (inofensivo) Resistencia a conjuros: sí (inofensivo)

Los receptores podrán desplazarse por cualquier tipo de terreno (barro, nieve, polvo, etc.) sin dejar tras de sí huellas ni rastros olorosos; seguirlos resultará imposible si no se utilizan medios mágicos.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$abertura de 5 × 8', y 10' de profundidad más 5' por cada tres niveles adicionales$c$, duration = $c$1 h/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'pasamiento';
update spells set school = $c$Ilusión$c$, subschool = $c$pauta$c$, descriptors = $c$enajenador$c$, description = $c$Una pauta arremolinada de colores discordantes y centelleantes se extiende en ondas por el aire, afectando a las criaturas en su interior. El conjuro afecta a un total de criaturas con un valor de DG igual a tu nivel de lanzador (máximo 20). Las criaturas con menos DG son afectadas primero; y entre criaturas con los mismos DG, son afectadas antes las más próximas al punto de origen. Los DG que no sean suficientes como para afectar a una criatura se desperdician. El conjuro afecta a cada objetivo dependiendo de sus DG.

6 o menos: inconsciente durante 1d4 asaltos. tras los que está aturdido otros 1d4 asaltos, y después confuso otros 1d4 asaltos más (para las criaturas que no estén vivas, considera un resultado de inconsciente como aturdido).

Entre 7 y 12: aturdido durante 1d4 asaltos, y después confundido durante otros 1d4 asaltos. 13 o más: confundido durante 1d4 asaltos. Las criaturas sin vista no resultan afectadas por la pauta centelleante.

Componente material: un pequeño prisma de cristal.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25 + 5 /2 niveles)$c$, target = $c$luces de gran colorido en una expansión de 20' de radio$c$, duration = $c$concentración + 2 asaltos$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'pauta centelleante';
update spells set school = $c$Ilusión$c$, subschool = $c$pauta$c$, descriptors = $c$enajenador$c$, description = $c$Una sinuosa urdimbre de sutiles colores serpenteará en el aire, fascinando a las criaturas que haya en el interior del efecto. Lanza 2d4 y suma tu nivel de lanzador (máximo 10) para determinar el total de DG de criaturas afectados. Las criaturas con menos DG serán las primeras en resultar afectadas, y cuando haya víctimas con los mismos DG, las más cercanas al punto de origen de la expansión serán las primeras afectadas. Los DG que no basten para afectar a una criatura se perderán sin más. Las criaturas afectadas quedarán fascinadas por la pauta de colores. Las criaturas sin vista no resultan afectadas por este conjuro. Los magos o hechiceros no necesitan pronunciar sonido alguno para ejecutar este sortile-

gio, pero los bardos tendrán que cantar, tocar un instrumento o recitar una rima como componente verbal.

Componente material: una vara de incienso encendida o una varilla de cristal llena de material fosforescente.$c$, components = $c$V (sólo Brd), S, M; ver texto$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$luces multicolores en una expansión de 10' de radio$c$, duration = $c$concentración + 2 asaltos$c$, saving_throw = $c$Voluntad niega 11 11$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'pauta hipnotica';
update spells set school = $c$Ilusión$c$, subschool = $c$pauta$c$, descriptors = $c$enajenador$c$, description = $c$Este conjuro crea una pauta de colores entrelazados, brillantes e iridiscentes que cautiva a aquellas criaturas que la ven, afectando a un máximo de 24 DG. Las criaturas con menos DG serán las primeras en ser afectadas; cuando haya varias con los mismos DG, el conjuro alcanzará en primer lugar a las que estén más cerca del punto de origen.

Las criaturas afectadas que fallen su salvación quedarán cautivadas por la pauta

Con un simple gesto (una acción gratuita) puedes hacer que la pauta iridiscente se desplace hasta 30' por asalto (lo cual desplazará su punto de origen efectivo). Todas las criaturas cautivadas seguirán el movimiento del arco iris luminoso, intentando alcanzarlo o estar cerca de él. Las criaturas cautivadas a las que se retenga o aleje de la pauta seguirán intentando acercarse a ella. Si el efecto Illeva a sus receptores hasta un lugar peligroso (una hoguera, un barranco, etc.), cada uno de ellos tendrá derecho a realizar un segundo TS. Si algo oculta las luces por completo (un conjuro de niebla de obscurecimiento, por ejemplo), las criaturas que no puedan verlas quedarán libres del efecto.

Este conjuro no afecta a las criaturas ciegas.

Componente verbal: los magos o hechiceros no necesitan pronunciar sonido alguno para ejecutar este sortilegio, pero los bardos tendrán que cantar, tocar un instrumento o recitar una rima como componente verbal.

Componente material: un poco de fósforo. Foco: un cristal con forma de prisma.$c$, components = $c$V (sólo Brd), S, M, F; ver texto$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$luces de colores en una expansión de 20' de radio$c$, duration = $c$concentración + 1 asalto/nivel (D)$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'pauta iridiscente';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$miedo, enajenador$c$, description = $c$Perdición infunde el miedo y la duda en tus enemigos, que sufrirán un penalizador -1 de moral tanto en las tiradas de ataque como en los TS contra efectos de miedo.

Perdición contrarresta y disipa bendecir.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$50'$c$, target = $c$todos los enemigos en radio de 50'$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'perdicion';
update spells set school = $c$Universal$c$, description = $c$Este conjuro hace que otros sortilegios se vuelvan permanentes.

Dependiendo del conjuro al que desees afectar, deberás tener un nivel de lanzador mínimo e invertir una cantidad de PX

Podrás hacer permanentes los siguientes conjuros para tu beneficio personal:

| | Nivel mín. | Coste |
| | | |
| Conjuro | lanzador | en PX |
| Comprensión idiomática | 9. | 500 PX |
| Detectar magia | go | 500 PX |
| Don de lenguas | 11.º | 1.500 PX |
| Leer magia | do | 500 PX |
| Ver lo invisible | 10° | 1.000 PX |
| Visión en la oscuridad | 10. | 1.000 PX |
| Vista arcana | 11:0 | 1.500 PX |

En primer lugar, deberás ejecutar el sortilegio deseado y, a continuación, deberás lanzar permanencia. No podrás ejecutar tales conjuros sobre otras criaturas y esta aplicación de permanencia sólo podrá ser disipada por un lanzador de nivel superior al que tuvieras en el momento de lanzar el conjuro.

Además de los de uso personal, este sortilegio puede emplearse para hacer permanentes los siguientes conjuros sobre ti, sobre otra criatura o sobre un objeto (según corresponda):

| | Nivel mín. | Coste |
| | | |
| Conjuro | lanzador | en PX |
| Agrandar persona | 9. | 500 PX |
| Colmillo mágico | do | 500 PX |
| Colmillo mágico mayor | 11:0 | 1.500 PX |
| Reducir persona | 90 | 500 PX |
| Resistencia | go | 500 PX |
| Vínculo telepático de Rary1 13.º | | 2.500 PX |
| 1 Sólo une a dos criaturas por lanzamiento de | | |
| permanencia. | | |

Los siguientes conjuros también podrán ser lanzados (solamente) sobre objetos o áreas y dotados de permanencia:

| | Nivel min. | Coste | |
| | | |--|
| Conjuro | lanzador | en PX | |
| Alarma | 9° | 500 PX | |
| Animar los objetos | 14.º | 3.000 PX | |
| Boca magica | 10. | 1.000 PX | |
| Bruma sólida | 12. | 2.000 PX | |
| Círculo de teletransporte | 17° | 4.500 PX | |
| Encoger objeto | 11 - | 1.500 PX | |
| Esfera prismática | 17° | 4.500 PX | |
| Invisibilidad | 10.º | 1.000 PX | |
| Luces danzantes | 9. | 500 PX | |
| Muro de fuego | 12. | 2.000 PX | |
| Muro de fuerza | 13. | 2.500 PX | |
| Muro prismático | 16 . | 4 000 PX | |
| Nube apestosa | 11: | 1.500 PX | |
| Puerta en fase | 15. | 3.500 PX | |
| Ráfaga de viento | 11: | 1.500 PX | |
| Sanctasanctorum | | | |
| privado de Mordenkainen | 13.º | 2.500 PX | |
| Símbolo de aturdimiento | 15. | 3.500 PX | |
| Símbolo de debilidad | 15. | 3.500 PX | |
| Símbolo de dolor | 13. | 2.500 PX | |
| Símbolo de locura | 16. | 4.000 PX | |
| Símbolo de miedo | 14:0 | 3 000 PX | |
| Símbolo de muerte | 16. | 4.000 PX | |
| Símbolo de persuasión | 14.º | 3,000 PX | |
| Símbolo de sueño | 16. | 4.000 PX | |
| Sonido fantasma | go | 500 PX | |
| Telaraña | 10. | 1.000 PX | |

Los conjuros lanzados sobre otras criaturas, obietos o lugares (distintos de ti) poseerán una vulnerabilidad normal al conjuro de disipar magia.

El DM puede permitir que otros conjuros sean dotados de permanencia; investigar esta posible aplicación de un conjuro costará el mismo tiempo y dinero que investigar personalmente el conjuro seleccionado (consulta la Guía del Dungeon Master). Si el DM ya hubiera decidido que tal aplicación no es posible, la investigación fracasará automáticamente. Un personaje sólo podrá saber si una aplicación es posible o imposible mediante el éxito o el fracaso de la citada investigación.

Coste en PX: consulta las tablas anteriores.$c$, components = $c$V, S, PX$c$, casting_time = $c$2 asaltos$c$, spell_range = $c$ver texto Objetivo, efecto o á$c$, target = $c$ver texto$c$, duration = $c$permanente; ver texto$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'permanencia';
update spells set school = $c$Nigromancia$c$, description = $c$Te permite lanzar un rayo de energía positiva. Debes efectuar un ataque de toque a distancia para impactar, y si el rayo golpea a una criatura muerta viviente le infligirá 1d6 puntos de daño$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$ravo$c$, duration = $c$instantánea$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'perturbar muertos vivientes';
update spells set school = $c$Ilusión$c$, subschool = $c$fantasmagoría$c$, descriptors = $c$enajenador, maligno$c$, description = $c$Te permite enviar una visión fantasmagórica, terrible y perturbadora, hasta una criatura a la que nombres o designes específicamente. La pesadilla impedirá un descanso reconfortante y, además, infligirá 1d10 puntos de daño. El receptor despertará cansado y será incapaz de recuperar conjuros arcanos durante las siguientes 24 horas.

La dificultad de la salvación depende de lo bien que conozcas al objetivo y de qué tipo de conexión física (si la hay) tengas con él.

| | Modificador a la | |
| | | |
| Conocimiento | salvación de Voluntad | |
| Ninguno | | +10 |
| De segunda mano | | +5 |
| (has oído hablar del objetivo) | | |
| De primera mano (conoces al objetivo) | | +0 |
| Familiar (conoces bien al objetivo) | | |
| | 1 Debes tener algún tipo de conexión con una | |
| criatura a la que no conozcas. | | |
| | | |

| | Modificador a la | |
| | |--|
| Conexión | salvación de voluntad | |
| mitación o dibujo | -2 | |
| Posesión o prenda de vestir | 1 | |
| Parte del cuerpo, mechón de pelo,<br>fragmento de uña, etc. | -1.0 | |

Un conjuro de disipar el mal lanzado sobre el receptor cuando estés ejecutando este sortilegio disipará pesadilla y te dejará aturdido durante 10 minutos por nivel de lanzador del disipar el mal.

Si el receptor está despierto al dar comienzo el conjuro, podrás optar por detener el lanzamiento (poniendo fin al conjuro) o por entrar en trance hasta que el receptor se vaya a dormir, momento en que volverás a estar alerta y podrás completar la ejecución del sortilegio. Si eres perturbado durante el trance, debes tener éxito en una prueba de Concentración tal y como si estuvieses en medio del lanzamiento de un conjuro (ver pág. 69), o perderás el conjuro.

Si eliges entrar en trance, dejarás de ser consciente de tu entorno y lo que suceda a tu alrededor mientras permanezcas en ese estado. Mientras estés en trance te encontrarás indefenso tanto física como mentalmente (por ejemplo, fallarás todos los TS que tengas que realizar).

Las criaturas que no duermen ni sueñan (como los elfos, pero no los semielfos) son inmunes a este coniuro.$c$, components = $c$V, S$c$, casting_time = $c$10 minutos$c$, spell_range = $c$ilimitado$c$, duration = $c$instantánea$c$, saving_throw = $c$Voluntad niega; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'pesadilla';
update spells set school = $c$Transmutación$c$, description = $c$Te permite transmutar 3 guijarros (de tamaño no superior al de los plomos de honda) para que golpeen con enorme fuerza cuando sean arrojados o lanzados con una honda. Si son arrojados con la mano, tendrán un incremento de distancia de 20'. Si son lanzados con honda. habrá que tratarlos igual que los proyectiles de esa arma (incremento de distancia de 50'). El conjuro les concede un bonificador +1 de mejora en las tiradas de ataque y daño. Para usar una piedra mágica, una criatura no tiene más que efectuar un ataque normal a distancia. Cada proyectil inflige 1d6+1 (incluyendo ya el bonificador de mejora) puntos de daño al alcanzar a un oponente, aunque el daño se duplicará (2d6+2 puntos) cuando el oponente en cuestión sea un muerto viviente.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque =$c$, target = $c$hasta 3 guijarros tocados$c$, duration = $c$30 minutos o hasta ser descargado$c$, saving_throw = $c$Voluntad niega (inofensivo, objeto)$c$, spell_resistance = $c$sí (inofensivo, objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'piedra magica';
update spells set school = $c$Adivinación$c$, description = $c$Obtienes la aptitud de hablar con las piedras, que te contarán qué o quién las ha tocado, además de revelarte lo que esté cubierto o escondido bajo ellas. Si se les pide, las piedras darán descripciones completas. Recuerda que la perspectiva, percepción y conocimientos de las piedras pueden impedir que éstas den los detalles que andas buscando (a discreción del DM). Puedes comunicarte tanto con la piedra natural como con la trabajada.$c$, components = $c$V, S, FD$c$, casting_time = $c$10 minutos$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$1 min/nivel$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'piedra parlante';
update spells set school = $c$Transmutación$c$, descriptors = $c$tierra$c$, description = $c$Los terrenos rocosos, suelos de piedra y otras superficies similares adoptan largas formas puntiagudas que se confunden con el entorno. Las piedras puntiagudas obstaculizarán el avance por el área e infligirán daño. Toda criatura que entre o atraviese a pie el área del conjuro se mueve a la mitad de su velocidad, y además sufrirá 1d8 puntos de daño perforante por cada 5' que se desplace por ella.

Las criaturas dañadas por este conjuro deberán realizar un TS de Reflejos o sufrirán heridas en los pies y piernas. Si fallan, su velocidad se verá reducida a la mitad de la normal durante 24 horas o hasta que la criatura herida reciba un conjuro de curar (que también le hará recuperar puntos de golpe). Otra criatura podría librarla de la penalización dedicando 10 minutos a vendar las heridas y teniendo éxito en una prueba de Sanar contra la CD de salvación del conjuro.

Las piedras puntiagudas son una trampa mágica que no puede ser desactivada mediante la habilidad de Inutilizar mecanismo.

Nota: las trampas mágicas, como las piedras puntiagudas, son difíciles de detectar e inutilizar. Un pícaro (y sólo un pícaro) puede usar la habilidad de Buscar para encontrar el efecto mágico; la CD sería 25 + el nivel de conjuro (CD 29 en el caso de las piedras puntiagudas).

| | lel pétrea |
|--| |
| | Abjuración |
| | Nivel: Drd 5, Fuerza 6, Hcr/Mag 4, Tierra 6 |
| | Componentes: V, S, M |
| | Tiempo de lanzamiento: 1 acción |
| | estándar |
| | Alcance: toque |
| | Objetivo: criatura tocada |
| | Duración: 10 min/nivel o hasta ser |
| | descargado |
| | Tiro de salvación: Voluntad niega |
| | (inotensivo) |
| | Resistencia a conjuros: sí (inofensivo) |

La criatura custodiada obtendrá resistencia frente a los golpes, tajos, apuñalamientos y cortes. El receptor obtiene una reducción del daño de 10/adamantina (ignora los primeros 10 puntos cada vez que sufra daño de un arma, aunque las armas adamantinas ignorarán esta reducción).

El conjuro se agotará una vez haya prevenido un total de 10 puntos de daño por nivel de lanzador (máximo 150 puntos).

Componentes materiales: granito y polvo de diamante (por valor de 250 po) para espolvorear sobre la piel del receptor.

A Land consideration$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$un cuadro de 20'/nivel$c$, duration = $c$1 h/nivel (D)$c$, saving_throw = $c$Reflejos parcial$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'piedras puntiaqudas';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro endurece la piel de una criatura. El efecto concede un bonificador +2 de mejora al bonificador de armadura natural que tenga la criatura. Este bonificador aumenta en +1 cada tres niveles de lanzador por encima del 3.º, hasta un máximo de +5 a 12.º nivel.

El bonificador de mejora proporcionado por piel robliza se apila con el bonificador de armadura natural del objetivo, pero no con otros bonificadores de mejora a la armadura natural. Una criatura sin armadura natural tiene a todos los efectos un bonificador de armadura natural de +0, del mismo modo que un personaje que sólo lleve ropa normal tiene un bonificador de armadura de +0$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura viva tocada$c$, duration = $c$10 min/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'piel robliza';
update spells set school = $c$Transmutación$c$, description = $c$Dependiendo de la versión que elijas, este conjuro convierte un fuego en una explosión de fuegos artificiales cegadores o en una densa nube de humo asfixiante.

Fuegos artificiales: los fuegos artificiales son una ardiente explosión momentánea de brillantes luces aéreas de colores. Este efecto ciega durante 1d4+1 asaltos a todas las criaturas que haya en un radio de 120' del fuego utilizado (Voluntad niega). Para resultar afectadas, tales criaturas han de tener línea de visión con el fuego afectado. La RC puede impedir la citada ceonera

Nube de humo: una sinuosa humareda surge del fuego utilizado por el conjuro, formando una nube asfixiante que se expande 20' en todas direcciones y dura 1 asalto por nivel de lanzador. Ningún tipo de visión (ni siquiera la visión en la oscuridad) resultará eficaz en medio de esta nube. Todos los que se encuentren en su interior sufren penalizadores -4 en sus puntuaciones de Fuerza y Destreza (Fortaleza niega). Estos efectos continúan durante 1d4+1 asaltos después de abandonar la nube o de que ésta sea disipada. La RC no se aplica en este caso.

Componente material: el conjuro hace uso de un fuego que se extinguirá inmediatamente. Un fuego lo bastante grande como para ocupar más de un cubo de 20' de lado sólo se apagará parcialmente. Los fuegos mágicos no se extinguirán, aunque una criatura basada en el fuego (como un elemental de fuego) sufriría 1 punto de daño por nivel de lanzador si fuera utilizada como componente material para este sortilegio.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estánda$c$, spell_range = $c$largo (400' + 40'/nivel)$c$, target = $c$un fuego (máximo un cubo de 20 de lado)$c$, duration = $c$1d4+1 asaltos o 1d4+1 asaltos después de que las criaturas hayan abandonado la nube de humo; ver texto$c$, saving_throw = $c$Voluntad niega o Fortale$c$, spell_resistance = $c$sí o no; ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'pirotecnia';
update spells set school = $c$Conjuración$c$, subschool = $c$convocación$c$, description = $c$Convocas un grupo de plagas de langostas (una por cada 3 niveles, hasta un máximo de 6 plagas a nivel 18.º). Las plagas deben ser convocadas de modo que cada una esté adyacente al menos a otra plaga (esto es, que las plagas deben formar una zona continua). Puedes convocar a las plagas de langostas de modo que compartan el área con otras criaturas. Cada plaga ataca a todas las criaturas que ocupen su área. Las plagas son estacionarias después de ser convocadas, y no persiguen a las criaturas que huyen.

Consulta el Manual de monstruos para los detalles sobre las plagas de langostas.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 asalto$c$, spell_range = $c$largo (400' + 40'/nivel)$c$, target = $c$una plaga de langostas por cada 3 niveles, cada una de las cuales debe estar adyacente a al menos otra de las plagas$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'plaga de insectos';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Atraes un favor o gracia especial sobre ti y sobre tus aliados al tiempo que traes la desgracia sobre tus enemigos. Tus aliados y tú obtenéis

un bonificador +1 de suerte en las tiradas de ataque, de daño por arma, en los TS y en las pruebas de habilidad; mientras que tus enemigos sufren un penalizador -1 en todas esas tiradas.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$40'$c$, target = $c$todos los aliados y enemigos en una explosión de 40' de radio, centrada en ti$c$, duration = $c$1 asalto/nivels no se change a se$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'plegaria';
update spells set school = $c$Transmutación$c$, description = $c$Creces hasta alcanzar el doble de tu altura y tu peso aumenta 8 veces. Este incremento aumenta tu categoría de tamaño hasta la inmediatamente superior, por lo que obtienes un bonificador +8 de tamaño a la Fuerza y un bonificador +4 de tamaño a la Constitución. Recibes un bonificador +4 de mejora a tu armadura natural, así como reducción del daño 5/maligno (si normalmente canalizas energía positiva) o 5/bueno (si normalmente canalizas energía negativa). A nivel 12.º esta reducción del daño pasa a ser 10/maligno o 10/bueno, y a 15.º nivel pasa a 15/maligno o 15/bueno (el máximo). Tu modificador de tamaño a la CA y los ataques cambian del modo apropiado a tu nueva categoría de tamaño (si tu tamaño original era Diminuto, Menudo, Pequeño, Mediano o Grande, el modificador disminuye en 1; en los demás casos consulta 'Modificadores de tamaño', pág. 134).

Utiliza la tabla 8-4: tamaño y escala de las criaturas, para determinar tu nuevo espacio y alcance. Este conjuro no cambia tu velocidad. Si no hay espacio suficiente en el recinto pa-

ra el tamaño deseado, alcanzas el tamaño máximo posible y debes realizar una prueba de Fuerza (utilizando su puntuación aumentada) para hacer reventar el recinto durante el proceso. Si fallas, quedas encerrado sin dañar al material que te rodea (el conjuro no puede ser utilizado para aplastar a una criatura aumentando su tamaño).

Todo el equipo que lleves puesto o transportes aumentará de modo similar mediante este conjuro. Las armas de cuerpo a cuerpo y de proyectil infligen más daño (consulta la tabla 2-2 en la Guía del Dungeon Master). Otras propiedades mágicas no resultan afectadas por este conjuro. Cualquier objeto agrandado que deje tu posesión (incluyendo un proyectil o un arma arrojadiza) regresa instantáneamente a su tamaño normal. Esto quiere decir que las armas arrojadizas infligen su daño normal (los proyectiles causan daño dependiendo del tamaño del arma que los disparó).

Varios efectos mágicos que aumenten el tamaño no se apilan, lo cual quiere decir (entre otras cosas) que no puedes utilizar un segundo lanzamiento de este conjuro para aumentar más tu tamaño mientras sigas bajo los efectos del primer lanzamiento.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$1 asalto/nivel (D)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'poder de la justicia';
update spells set school = $c$Evocación$c$, description = $c$Llamando al poder divino de tu patrón, infundes tu persona con fuerza y capacidad para el combate. Tu ataque base pasa a ser igual a tu nivel de personaje (lo cual puede darte ataques adicionales), obtienes un bonificador +6 de mejora a la Fuerza y ganas 1 pg temporal por nivel de lanzador.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$1 asalto/nivel$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'poder divino';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro funciona como alterar el propio aspecto, salvo en que puedes transformar a un sujeto voluntario en cualquier tipo de criatura viva. La nueva forma puede ser del mismo tipo que el objetivo o de cualquiera de los siguientes tipos: aberración, animal, bestia mágica, cieno, dragón, fata, gigante, humanoide, humanoide monstruoso, planta o sabandija. La forma asumida no puede tener más DG que tu nivel de lanzador (o que DG tenga el objetivo, lo que sea menor), hasta un máximo de 15 DG a nivel 15.º. No puedes hacer que un objetivo asuma una forma más pequeña que Minúsculo, ni que asuma forma incorporal o gaseosa. El tipo y subtipo de la criatura (si lo hay) cambia para adecuarse a la nueva forma (consulta el Manual de monstruos para más información).

Al realizarse el cambio, el objetivo recupera puntos de vida perdidos como si hubiese descansado durante una noche (aunque esta curación no restaura daño temporal de característica ni proporciona ningún otro de los beneficios de descansar; cambiar de nuevo a su forma original no proporciona más curación). Si es muerto, el objetivo vuelve a su forma original, aunque seguirá estando muerto.

El receptor obtiene las puntuaciones de Fuerza, Destreza y Constitución de su nueva forma, pero conserva sus propios valores de Inteligencia, Sabiduría y Carisma. También obtiene todos los ataques especiales extraordinarios de la nueva forma (como constreñir, agarrón mejorado y veneno), pero no obtiene sus cualidades especiales extraordinarias (como sentido ciego, curación rápida, regeneración y olfato) ni ninguna aptitud sobrenatural o sortílega.

Las criaturas incorporales o gaseosas son inmunes a ser polimorfadas, y una criatura con el subtipo de cambiaformas (como un licántropo o un doppelgánger) pueden volver a su forma natural mediante una acción estándar. Componente material: un capullo vacío.

| Polimorfar cualquier cosa | | |
| |--|--|

| Transmutación |
| |
| Nivel: Hcr/Mag 8, Supercheria 8 |
| Componentes: F, S, M/FD |
| Tiempo de lanzamiento: 1 acción |
| estándar |
| Alcance: corto (25' + 5'/2 niveles) |
| Objetivo: una criatura u objeto no mágico de |
| hasta 100 cúbicos/nivel |
| Duración: ver texto |
| Tiro de salvación: Voluntad niega (objeto); |
| ver texto |
| Resistencia a conjuros: sí (objeto) |
| |
| |

Este conjuro funciona igual que polimorfar, salvo en que hace que una criatura u objeto se convierta en otro. La duración del sortilegio dependerá de lo radical que sea el cambio desde el estado original hasta el estado encantado. El DM determinará la duración basándose en las siguientes directrices:

| El receptor | Incremento del |
| | |
| transformado es: | factor de duración1 |
| Del mismo reino (animal, vegetal, mineral) +5 | |
| De la misma clase (mamíferos, hongos, | +2 |
| metales, etc.) | |
| Del mismo tamaño | 42 |
| Parecido (como una rama a un árbol, | +2 |
| una piel de lobo a un lobo, etc.) | |
| lgual de inteligente (o menos) | +2 |
| Suma todos los que sean aplicables y consulta | |
| la siguiente tabla. | |

| Factor de | | |
| | | |
| duración | Ejemplo | Duración |
| 0 | Guijarro a humano | 20 minutos |
| 2 | Marioneta a humano | 1 hora |
| 4 | Humano a marioneta | 3 horas |
| 5 | Lagarto a mantícora | 12 horas |
| 6 | Oveja a abrigo de lana | 2 días |
| 7 | Musaraña a manticora | 1 semana |
| 94 | Mantícora a musaraña | Permanente |

Al contrario que polimorfar, este conjuro concede a la criatura la puntuación de Inteligencia de su nueva forma. Si la forma original no tuviera puntuaciones de Sabiduría o Carisma, las obtendría al adoptar su nueva forma.

El daño sufrido en la nueva forma puede producir heridas e incluso la muerte de la criatura afectada. Por ejemplo, podría transformarse en piedra al receptor y triturarlo hasta reducirlo a polvo, infligiéndole daño y llegando incluso a matarlo. Si la criatura fuera transformada en polvo desde un principio, haría falta recurrir a métodos más creativos para lograr infligirle daño (quizá pudieras utilizar un conjuro de ráfaga de viento para dispersarlo a los cuatro vientos). Por lo general, la criatura sufrirá daño siempre que su nueva forma sea alterada mediante la fuerza física, aunque es posible que el DM tenga que valorar muchas de estas situaciones.

Un objeto no mágico no puede ser transformado en un objeto mágico mediante este conjuro. Los objetos mágicos no resultan afectados por este sortilegio.

Este sortilegio no puede crear material que posea un gran valor intrínseco, como cobre, plata, gemas, seda, oro, platino o adamantina. Tampoco puede reproducir las propiedades especiales del hierro frío en lo que se refiere a superar la reducción el daño de ciertas criaturas. Este conjuro también puede utilizarse para duplicar los efectos de los conjuros de la carne a la piedra, de la piedra a la carne, polimorfar, transmutar agua en polvo, transmutar barro en roca o transmutar roca en harro.

Componentes materiales arcanos: mercurio, goma arábiga y humo.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$una criatura viva tocada curante$c$, duration = $c$1 min/nivel (D)$c$, saving_throw = $c$ninguno dua s$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'polimorfar';
update spells set school = $c$Transmutación$c$, description = $c$Como polimorfar, salvo en que transformas al objetivo en un animal Pequeño o de menor tamaño, de no más de 1 DG (como un perro, lagarto, mono o sapo). Si la nueva forma sería mortal para la criatura (por ejemplo, si polimorfas a un objetivo terrestre en un pez, o a un objetivo que esté volando en un sapo) la víctima recibe un bonificador +4 en su salvación.

Si el conjuro tiene éxito, el objetivo debe realizar también una salvación de Voluntad. Si esta segunda salvación falla, la criatura pierde sus aptitudes extraordinarias, sobrenaturales y sortilegas, así como su aptitud para lanzar conjuros (si la tenía), y obtiene el alineamiento, aptitudes especiales e Inteligencia, Sabiduría y Carisma de su nueva forma en lugar de los suyos. Sigue conservando su clase y nivel (o DG), así como todos los beneficios que derivan de ellos (tal y como ataque base, salvaciones base y puntos de golpe). Conserva cualquier rasgo de clase (con la excepción del lanzamiento de conjuros) que no sea una aptitud extraordinaria, sobrenatural o sortílega.

Las criaturas incorpóreas o gaseosas son inmunes a ser polimorfadas, y una criatura con el subtipo de cambiaformas (como un licántropo o un doppelgánguer) puede volver a su forma natural como acción estándar.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura$c$, duration = $c$permanente$c$, saving_throw = $c$Fortaleza niega, Voluntad<br>parcial; ver texto$c$, spell_resistance = $c$si$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'polimorfar funesto';
update spells set school = $c$Adivinación$c$, description = $c$Este sortilegio te concede un poderoso sexto sentido en relación contigo o con otra criatura. Una vez hayas lanzado el conjuro, serás advertido instantáneamente de todo peligro o perjuicio que vaya a afectar de forma inminente al receptor. Así, si eres el receptor del sortilegio, sabrás con antelación si un pícaro está a punto de atacarte furtivamente, si una criatura va a saltar sobre ti desde una posición inesperada o si eres el blanco específico del conjuro o ataque a distancia de un enemigo. Nunca podrán sorprenderte ni cogerte desprevenido. Además, el conjuro te dará una idea general de la acción que deberías llevar a cabo para protegerte mejor (agacharte, saltar a la derecha, cerrar los ojos, etc.) y te concederá un bonificador +2 introspectivo a la CA y las salvaciones de Reflejos. Este bonificador introspectivo se perderá en todas aquellas situaciones que priven del uso del bonificador de Destreza a la CA.

Cuando otra criatura sea el receptor del conjuro, tú serás quien reciba las advertencias del peligro que corra. Para que tal advertencia resulte de utilidad, deberás comunicársela al receptor, pues, de lo contrario, podría no estar preparado para la situación. Siempre y cuando no pierdas ni un momento, podrás decir a gritos la advertencia, empujar al receptor e incluso comunicársela telepáticamente (por medio del conjuro apropiado) antes de que tenga lugar la desgracia. Sin embargo, el receptor no obtendrá el bonificador introspectivo a la CA y la salvación de Reflejos. En en

Componente material arcano: una pluma de colibrí.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal o toque$c$, target = $c$ver texto$c$, duration = $c$10 min/nivel$c$, saving_throw = $c$ninguno o Voluntad niega (inofensivo)$c$, spell_resistance = $c$no o sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'presciencia';
update spells set school = $c$Evocación$c$, descriptors = $c$maligno$c$, description = $c$Este conjuro infunde energía negativa en un área. Todas las tiradas de Carisma que se lleven a cabo para expulsar muertos vivientes en ese lugar obtendrán un penalizador -3 profano. Los muertos vivientes que entren en el lugar obtendrán un bonificador +1 profano en las tiradas de ataque, las tiradas de daño y los TS. Los muertos vivientes creados o convocados dentro de un lugar profanado obtienen +1 pg por DG.

Si en el lugar profanado hay un altar, capilla u otro objeto permanente dedicado a tu deidad, panteón o poder superior con el que compartas alineamiento, los efectos indicados se duplicarán (penalizador -6 profano a la expulsión, bonificadores +2 profanos a las tiradas de los muertos vivientes, +2 pg por DG). Además, cualquiera que lance reanimar a los muertos dentro de esta zona puede crear el doble de la cantidad normal de muertos vivientes (esto es, 4 DG por nivel de lanzador en lugar de 2 DG por nivel de lanzador). Cuando el lugar incluya un objeto permanente de este tipo que esté dedicado a un dios, panteón o poder superior que no sea tu deidad tutelar, el conjuro de profanar lanzará una maldición sobre el área, poniendo fin a su comunicación con el poder o la deidad en cuestión. En caso de ser utilizada, esta función secundaria no concederá al mismo tiempo los bonificadores para muertos vivientes indicados más arriba. Profanar contrarresta y disipa el conjuro de

consagrar.

Componentes materiales: un vial de agua sacrílega y plata pulverizada, por valor de 25 po (unas 5 lb.), que ha de espolvorearse en su totalidad por el área.$c$, components = $c$V, S, M, FD manda a$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$emanación de 20' de radio$c$, duration = $c$2 h/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'profanar';
update spells set school = $c$Abjuración$c$, descriptors = $c$bueno$c$, description = $c$Este conjuro protege a una criatura contra los ataques y el control mental de las criaturas malignas y contra las propias criaturas de ese alineamiento que hayan sido convocadas o conjuradas. El sortilegio crea una barrera mágica que rodea al receptor a 1' de distancia, se desplaza con él y tiene tres efectos principales:

En primer lugar, el receptor obtiene un bonificador +2 de desvío a la CA y un bonificador +2 de resistencia en los TS. Ambos bonificadores se aplicarán a los ataques efectuados por criaturas malignas.

En segundo lugar, la barrera bloquea todo intento de poseer a la criatura custodiada (como un ataque del conjuro de transmigración) o de ejercer control mental sobre ella [incluyendo efectos de encantamiento (hechizo) y de encantamiento (compulsión) que proporcionan al lanzador un control continuo sobre el objetivo, como dominar persona]. La protección no evita que estos efectos sean dirigidos a la criatura protegida, pero elimina el efecto durante la duración de la protección contra el mal. Si el efecto de protección contra el mal finaliza antes que el efecto que otorga control mental, el controlador será capaz de dar órdenes mentales a la criatura controlada. Así mismo, la barrera evitará la posesión por parte de una fuerza vital, pero no expulsará a una que ya ocupe el cuerpo del receptor antes de ser ejecutado el sortilegio. Este segundo efecto funciona sin importar el alineamiento del receptor.

En tercer lugar, el conjuro impedirá que las criaturas convocadas o conjuradas entren en contacto físico con la criatura custodiada. Esto hará que fallen los ataques con armas naturales de tales criaturas y que éstas se vean obligadas a retroceder en caso de intentar tocar a la criatura custodiada por este efecto. Las criaturas convocadas buenas son inmunes a este efecto. La protección contra el contacto finalizará si el receptor ataca a la criatura convocada o conjurada o intenta forzar la barrera protectora contra ella. La resistencia a conjuros puede permitir a una criatura superar esta protección y tocar a la criatura custodiada.

Componente material arcano: un poco de plata pulverizada, con la que debes trazar en el suelo un círculo de 3' de diámetro en torno a la criatura a custodiar.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$1 min/nivel (D)$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$no (ver texto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'proteccion contra el mal';
update spells set school = $c$Abiuración$c$, description = $c$La criatura custodiada estará protegida contra las armas de ataque a distancia, obteniendo una reducción del daño de 10/magia contra ellas. Este conjuro no te otorga la aptitud de causar daño a criaturas con una reducción del daño similar. El conjuro se agotará una vez haya evitado un total de 10 puntos de daño por nivel de lanzador (máximo de 100 puntos).

Foco: un fragmento de caparazón de tortuga o galápago.$c$, components = $c$V, S, F F F . F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada - 2 - 11$c$, duration = $c$1 hora/nivel o hasta ser descargado$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'proteccion contra las flechas';
update spells set school = $c$Abjuración$c$, description = $c$El receptor obtiene un bonificador +8 de resistencia en los TS contra conjuros y aptitudes sortílegas (pero no contra las aptitudes sobrenaturales y extraordinarias).

Componente material: un diamante (por un valor mínimo de 500 po) que ha de ser triturado y espolvoreado sobre los receptores.

Foco: un diamante de 1.000 po por cada criatura a la que se desee conceder la protección. Cada receptor debe llevar su correspondiente piedra preciosa mientras dure el conjuro. Si alguno de ellos perdiera su gema, el conjuro dejaría de surtir efecto para él.$c$, components = $c$V, S, M, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$hasta una criatura tocada/4 niveles$c$, duration = $c$10 min/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo) = 1$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'proteccion contra los conjuros';
update spells set school = $c$Nigromancia$c$, description = $c$Al liberar tu espíritu de tu cuerpo físico, este conjuro te permite enviar tu forma astral hasta un plano distinto. Podrás llevar contigo las formas astrales de otras criaturas voluntarias, siempre y cuando sus cuerpos estuvieran formando un círculo contigo en el momento de lanzar el conjuro. Estos compañeros de viaje dependerán de ti y deberán acompañarte en todo momento. Si algo te sucediera durante el viaje, tus compañeros quedarían abandonados allá donde los dejaras.

Al lanzar el conjuro, proyectas tu "yo astral" hasta el plano Astral, dejando tu cuerpo físico en estado de animación suspendida en el pla-

no Material. El conjuro enviará al citado plano una copia astral de ti mismo y de todo lo que transportes o lleves puesto. Como el plano Astral está en contacto con otros planos, puedes viajar astralmente hasta el que prefieras. A continuación, abandonarás el plano Astral y formarás un nuevo cuerpo físico (equipo incluido) en el plano de existencia al que hayas decidido entrar.

Mientras estés en el plano Astral o en cualquier otro plano, tu cuerpo astral estará unido en todo momento al físico mediante un cordón plateado. Si este cordón se rompiera, morirías tanto astral como materialmente. Afortunadamente, existen muy pocas cosas capaces de romper un cordón plateado (consulta la Guía del Dungeon Master para más información). Cuando se forma un segundo cuerpo en un plano diferente, el cordón plateado incorporal permanece unido a él, aunque invisible. Si el segundo cuerpo o la forma astral murieran, el cordón volvería sin más hasta el lugar del plano Material en que se encuentre tu cuerpo, haciendo que abandonara su estado de animación suspendida. Aunque las proyecciones astrales funcionan en el plano Astral, sus acciones sólo afectan a las criaturas que existen en ese plano; en los demás planos, ha de materializarse un cuerpo físico. La co

Tus compañeros y tú podréis viajar indefinidamente por el plano Astral. Vuestros cuerpos esperarán sin más un en estado de animación suspendida hasta que decidáis devolverles sus espíritus. El conjuro durará hasta que desees que termine o hasta que se le ponga fin por medios ajenos a ti, como un disipar magia lanzado sobre tu cuerpo físico o tu forma astral, o la destrucción de tu cuerpo en el plano Material (cosa que te mataría).

Componentes materiales: un jacinto que valga, como mínimo, 1.000 po, más un lingote de plata por valor de 5 po por persona a la que haya de afectar el sortilegio.$c$, components = $c$V, S, M$c$, casting_time = $c$30 minutos$c$, spell_range = $c$toque$c$, target = $c$tú más una criatura voluntaria adicional/2 niveles (a la que has de tocar)$c$, duration = $c$ver texto$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'proyeccion astral';
update spells set school = $c$Ilusión$c$, subschool = $c$sombra$c$, description = $c$Moldeas energía del plano de la Sombra para crear una versión ilusoria cuasirreal de ti mismo. La imagen proyectada tiene el mismo aspecto, sonido y olor que tú, pero es intangible. La sombra imita tus acciones (incluyendo el habla), a no ser que te concentres para que actúe de forma distinta (lo cual requiere una acción de movimiento).

Podrás ver a través de sus ojos y oír a través de sus oídos como si estuvieras donde ella se encuentre y, cada vez que llegue tu turno durante un asalto de combate, podrás cambiar de sus ojos a los tuyos o viceversa, como acción gratuita. Mientras estés utilizando sus sentidos, tu cuerpo se considera ciego y sordo.

Si así lo deseas, todo conjuro que lances cuyo alcance sea 'toque' o mayor, podrá tener su origen en la imagen proyectada en lugar de tenerlo en tu persona. La imagen no puede lanzar sobre ella misma ningún conjuro, salvo los de ilusión. Los sortilegios afectan del modo normal a los demás objetivos, sin importar que se hayan originado en la imagen proyectada.

Los objetos resultan afectados por la imagen proyectada como si hubiesen tenido éxito en su salvación de Voluntad.

Debes mantener una línea de efecto con la sombra en todo momento. Si tal línea es obstruida, el conjuro finalizará. El sortilegio también terminará si usas un desplazamiento de plano, una puerta dimensional, un teleportar o algún otro conjuro que rompa tu línea de efecto, aunque sea sólo durante un momento.

Componente material: una pequeña réplica de ti mismo (un muñeco), que cuesta 5 po fabricar.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$un doble sombrio$c$, duration = $c$1 asalto/nivel (D)$c$, saving_throw = $c$Voluntad descree (si se interactua con el conjuro)$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'proyectar imagen';
update spells set school = $c$Evocación$c$, descriptors = $c$fuerza$c$, description = $c$Un proyectil de energía mágica surge de la punta de tu dedo y alcanza a su objetivo, sin posibilidad de fallo, infligiéndole 1d4+1 puntos de daño.

El proyectil no puede fallar, ni siquiera cuando su blanco esté enzarzado en combate cuerpo a cuerpo o disponga de cobertura u ocultación (a no ser que éstas sean totales). No podrás elegir la parte del cuerpo de la víctima que será alcanzada por el proyectil. Los objetos inanimados (cerraduras, etc.) no resultan afectados por este conjuro.

Obtendrás un proyectil adicional por cada dos niveles de lanzador por encima del 1.º. Tendrás dos en el 3.ª nivel, tres en el 5.º, cuatro en el 7.º y un máximo de cinco en el 9.º o superior. Cuando dispares varios proyectiles, puedes hacer que alcancen a la misma criatura o a varias. Un mismo proyectil sólo puede alcanzar a una criatura. Debes designar el objetivo de cada proyectil antes de que se realicen las tiradas de RC o de daño.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estánd$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$hasta 5 criaturas; dos receptore cualesquiera no pueden distar más de 1$c$, duration = $c$instantanea$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'proyectil magico';
update spells set school = $c$Conjuración$c$, descriptors = $c$teletransporte$c$, description = $c$Te trasladas instantáneamente desde el lugar en que te encuentres hasta cualquier otro lugar situado dentro del alcance. Siempre llegarás exactamente al punto deseado, ya sea por ver a simple vista el lugar o por declarar una dirección (como "900' más abajo en línea recta", o "arriba y al noroeste, con un ángulo de 45º y a 1.200' de altura"). Tras usar este conjuro, no podrás llevar a cabo ninguna otra acción hasta tu siguiente turno. Puedes llevar contigo objetos, siempre que su peso no exceda tu carga máxima. También puedes llevar a una criatura voluntaria Mediana o menor adicional (que lleve objetos hasta su carga máxima) o su equivalente por cada 3 niveles de lanzador. Una criatura Grande cuenta como dos criaturas Medianas, una enorme como dos Grandes, etc. Todas las criaturas que van a ser transportadas deben estar en contacto entre ellas, y al menos una debe estar en contacto contigo.

Si llegas a un lugar que ya esté ocupado por un cuerpo sólido, tú y todas las criaturas que viajen contigo sufris 1d6 puntos de daño y sois desplazadas hasta un espacio libre aleatorio que sea adecuado dentro de un radio de 100' de la localización elegida. Si no hay ningún lugar adecuado en 100', tú y toda criatura que viaje contigo sufrís 2d6 puntos de daño adicionales, y sois desplazados hasta un espacio libre en un radio de 1.000'. Si tampoco hay ningún espacio libre en 1.000', tú y las criaturas que te acompañen sufrís 4d6 puntos de daño adicionales y el conjuro simplemente falla.$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$largo (400' + 40'/nivel)$c$, target = $c$tú y los objetos tocados o las criaturas voluntarias tocadas$c$, duration = $c$instantánea$c$, saving_throw = $c$ninguno y Voluntad niega (objeto)$c$, spell_resistance = $c$no y sí (objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'puerta dimensional';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, description = $c$Este conjuro crea un pasadizo etéreo que atravesará paredes de madera, yeso o piedra, pero no de otros materiales. La puerta en fase es invisible e inaccesible para toda criatura excepto tú, y sólo tú podrás usarla. Cuando entres en la puerta en fase, desaparecerás y aparecerás en su salida. Si lo deseas, puedes traspasar la puerta llevando contigo a una criatura más (de tamaño Mediano o menor), aunque eso contará como dos usos del conjuro. La puerta no permite que la atraviesen la luz, el sonido ni los efectos de conjuro, y no podrás ver a través de ella sin utilizarla. Por tanto, el sortilegio podrá facilitar una vía de huida, pero ésta podrá ser seguida fácilmente por ciertas criaturas, como las arañas de fase. Una gema de visión verdadera y otros efectos mágicos similares revelan la presencia de la puerta en fase, pero no permiten usarla.

Las puertas en fase resultan afectadas por los conjuros de disipar magia. Si hay alguien dentro del pasadizo al ser éste disipado, será expulsado sin sufrir daño alguno, igual que si se tratara de un efecto de pasamiento.

Puedes permitir que otras criaturas utilicen la puerta imponiendo una condición desencadenante sobre ella. Esta condición puede ser tan sencilla o tan compleja como desees. Puede estar relacionada con el nombre, identidad o alineamiento de la criatura, pero por lo demás tendrá que estar basada en acciones o cualidades observables (las cosas intangibles, como el nivel, la clase, los DG y los puntos de golpe, no servirán como condiciones desencadenantes).

Una puerta en fase puede hacerse permanente por medio del conjuro de permanencia.$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$0'$c$, target = $c$abertura etérea de 5× 8', y 10' de profundidad más 5 /3 niveles$c$, duration = $c$un uso/dos niveles$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'puerta en fase';
update spells set school = $c$Evocación$c$, description = $c$Este conjuro funciona igual que mano interpuesta de Bigby, salvo en que la mano puede interponerse, empujar o golpear a un oponente de tu elección. La mano flotante puede moverse hasta 60' y atacar en el mismo asalto. Al estar dirigida por ti, su capacidad para localizar o atacar a las criaturas invisibles u ocultas no será mejor que la tuya.

La mano ataca una vez por asalto, y su bonificador de ataque será igual a tu nivel + tu modificador de Inteligencia, Sabiduría o Carisma (para magos, clérigos o hechiceros, respectivamente), +11 por la puntuación de Fuerza de la propia mano (33), -1 por ser Grande. El daño infligido por la mano es 1d8+11 en cada ataque, y toda criatura a la que golpee tendrá que realizar un TS de Fortaleza (contra la CD de salvación del conjuro) o quedará aturdida durante 1 asalto. Dirigir el conjuro a un nuevo objetivo es una acción de movimiento.

El puño cerrado también puede interponerse como hace la mano interpuesta de Bigby, o puede embestir a un oponente como la mano forzuda de Bigby, pero con un bonificador +15 a la prueba de Fuerza.

Los clérigos que posean este conjuro cambiarán el nombre de Bigby por el de la deidad que hayan elegido servir (por ejemplo, puño cerrado de Pelor).

Foco arcano: un guante de cuero.$c$, components = $c$V. S. F/FD$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'puno cerrado de bigby';
update spells set description = $c$Te rodeas con una esfera de poder, con un radio de 5' por nivel de lanzador, que niega toda forma de invisibilidad. Todo lo invisible se volverá visible mientras se halle en el área.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$1 min/nivel (D)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'purgar invisibilidad';
update spells set school = $c$Universal$c$, description = $c$Este conjuro hace que el agua y la comida sean aptas para el consumo aunque estén podridas, echadas a perder o envenenadas. El efecto no impide una descomposición posterior. El agua sacrílega y los alimentos o bebidas de naturaleza similar se echarán a perder al recibir este conjuro, que no surte efecto alguno sobre las criaturas (de ningún tipo) ni las pociones mágicas.

Nota: el agua pesa, más o menos, 8 lb. por galón. Un pie cúbico de agua contiene aproximadamente 8 galones y pesa en torno a 60 lb.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$10'$c$, target = $c$1 pie cúbico/nivel de comida y bebida contaminadas$c$, duration = $c$instantánea$c$, saving_throw = $c$Voluntad niega (objeto)$c$, spell_resistance = $c$sí (objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'purificar comida y bebida';
update spells set school = $c$guital$c$, description = $c$Este conjuro cura la ceguera o la sordera (a elección del lanzador), tanto normal como mágicas. El sortilegio no permite recuperar ojos u orejas perdidos, pero los curará si estuvieran dañados. Quitar ceguera/sordera contrarresta y disipa el

conjuro de ceguera/sordera. 310 = 11 = 1 = 1 = 1 =$c$, components = $c$V, S$c$, casting_time = $c$1 acción estánda$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$instantánea$c$, saving_throw = $c$Fortaleza niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'quitar cequera/sordera';
update spells set school = $c$Abjuración$c$, description = $c$Te permite infundir valor a un receptor, concediéndole un bonificador +4 de moral contra los efectos de miedo durante 10 minutos. Si la criatura ya estuviera sufriendo un efecto de miedo al recibir el conjuro, este efecto será suprimido durante la duración del conjuro.

Quitar el miedo contrarresta y disipa el conjuro de causar miedo.

Q

| uitar enfermedad |
| |
| Conjuración (curación) |
| Nivel: Clr 3, Drd 3, Exp 3 |
| Componentes: V, S |
| Tiempo de lanzamiento: 1 acción |
| estándar |
| Alcance: toque |
| Objetivo: criatura tocada |
| Duración: instantanea |
| Tiro de salvación: Fortaleza niega |
| (inofensivo) |
| Resistencia a conjuros: sí (inofensivo) |
| |

Este conjuro cura todas las enfermedades padecidas por el receptor. El sortilegio también mata a los parásitos, lo que incluye al limo verde, y demás seres que afectan de forma similar. Algunas enfermedades especiales no pueden ser eliminadas por este conjuro, o sólo pueden ser eliminadas por un lanzador que posea o supere un determinado nivel.

Nota: como la duración del conjuro es instantánea, el efecto no impide que el receptor vuelva a contagiarse por verse expuesto de nuevo a la misma enfermedad.$c$, components = $c$V, Samp$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura, más una criatura adicional/4 niveles; dos receptores$c$, duration = $c$10 minutos: ver texto =====$c$, saving_throw = $c$Fortaleza niega
- (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'quitar el miedo';
update spells set school = $c$Abjuración$c$, description = $c$Este conjuro elimina instantáneamente todas las maldiciones de un objeto o persona. El sortilegio no sirve para eliminar maldiciones de escudos, armas o armaduras, aunque, por lo general, sí permitirá a su dueño deshacerse de ellos. Ciertas maldiciones especiales no pueden ser contrarrestadas por este conjuro o sólo pueden serlo cuando el lanzador del contraconjuro posea o supere cierto nivel.

Quitar maldición contrarresta y disipa el conjuro de lanzar maldición.$c$, components = $c$V, Sales$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque los de last lesse costs and a list$c$, target = $c$criatura u objeto tocado$c$, duration = $c$instantánea - ($c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'quitar maldicion';
update spells set school = $c$Conjuración$c$, subschool = $c$curación$c$, description = $c$Puedes liberar a una o más criaturas de los efectos de la parálisis temporal u otros efectos mágicos relacionados, incluyendo el toque de los necrófagos y un conjuro de ralentizar. Si el sortilegio es lanzado sobre una criatura, la parálisis que le afectara será negada directamente. Si es lanzado sobre dos criaturas, cada una tendrá derecho a realizar un nuevo TS contra el efecto que la aflige, obteniendo un bonificador +4 de resistencia. Si es lanzado sobre cuatro criaturas, cada una tendrá derecho a realizar un nuevo TS contra el efecto, obteniendo un bonificador +2 de resistencia.

El conjuro no restablece puntuaciones de características que se hayan visto reducidas por penalizadores, daño o pérdida.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5 /2 niveles)$c$, target = $c$hasta 4 criaturas; dos receptores cualesquiera no pueden distar más de 30'$c$, duration = $c$instantánea$c$, saving_throw = $c$Voluntad niega (inotensivo) Resistencia a conjuros si (inotensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'quitar paralisis';
update spells set school = $c$Evocación$c$, description = $c$Este conjuro crea una fuerte ráfaga de aire (aproximadamente 50 millas/hora) que tiene su origen en ti y afecta a todas las criaturas en su camino.

Una criatura Menuda o más pequeña que se encuentre en el suelo es derribada y rueda 1d4×10', recibiendo 1d4 puntos de daño no letal por cada 10'. Si está volando, una criatura Menuda o más pequeña es arrastrada hacia atrás 2d6×10' y recibe 2d6 puntos de daño no letal al ser zarandeado y sacudido.

Las criaturas Pequeñas son derribadas y quedan tendidas por la fuerza del viento o, si están volando, son arrastradas 1 d6×10'.

Las criaturas Medianas son incapaces de moverse contra la fuerza del viento o, si están volando, son arrastradas 1d6×5' hacia atrás. >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Las criaturas Grandes o mayores pueden moverse de manera normal dentro de un efecto de ráfaga de viento.

Este sortilegio no puede desplazar a una criatura más allá de los límites de su alcance.

Cualquier criatura, independientemente de su tamaño, recibe un penalizador -4 en las tiradas de ataque a distancia y en las pruebas de Escuchar mientras esté en el interior del área de la ráfaga de viento.

La fuerza de la ráfaga apagará automáticamente las velas, antorchas y demás llamas desprotegidas. Además, agitará violentamente las llamas protegidas, como las de las linternas, existiendo un 50% de posibilidades de apagarlas.

Además de los efectos indicados, este conjuro puede hacer todo aquello que pueda esperarse de una ráfaga de viento natural: puede crear un doloroso chorro de arena o polvo, avivar un

gran fuego, volar toldos o colgantes pequeños, escorar un bote pequeño y empujar gases o vapores hasta el límite del alcance. Ráfaga de viento puede ser hecho permanente con un conjuro de permanencia. Concentr$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$60'$c$, target = $c$una potente ráfaga de viento en forma de línea que emana desde ti hasta el extremo del alcance$c$, duration = $c$1 asalto$c$, saving_throw = $c$Fortaleza niega$c$, spell_resistance = $c$sí Carrely Contraction Construction Company Confession of$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'rafaga de viento';
update spells set school = $c$Transmutación$c$, description = $c$Las criaturas afectadas se moverán y atacarán a un ritmo drásticamente refrenado. Las criaturas ralentizadas sólo podrán llevar a cabo una única acción de movimiento o acción estándar por turno, pero no ambas (ni podrán realizar acciones de asalto completo). Además, sufrirán un penalizador -1 a la CA, las tiradas de ataque y los TS de Reflejos. Una criatura ralentizada se mueve a la mitad de su velocidad normal (redondeando hacia abajo al incremento de 5' más próximo), lo cual afecta a su distancia de salto, como sucede con cualquier reducción de la velocidad

Varios efectos de ralentizar no se apilan. Ralentizar contrarresta y disipa el conjuro acelerar. Componente material: una gota de melaza.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura/nivel; dos receptores cualesquiera no pueden distar más de 30'$c$, duration = $c$1 asalto/nivel$c$, saving_throw = $c$Voluntad niega muracia l$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'ralentizar';
update spells set school = $c$Evocación$c$, descriptors = $c$fuego$c$, description = $c$Atacas a tus enemigos con ardientes rayos. Puedes disparar un rayo, más uno adicional por cada cuatro niveles más allá del 3.º (hasta un máximo de 3 rayos a nivel 11.º). Cada rayo requiere un ataque de toque a distancia para impactar, e inflige 4d6 puntos de daño por fuego. Los rayos pueden ser disparados al mismo o a diferentes objetivos, pero todos deben estar apuntados hacia blancos que no disten más de 30' entre sí, ya que se disparan simultáneamente.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$uno o más rayos$c$, duration = $c$instantánea$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'rayo abrasador';
update spells set school = $c$Nigromancia$c$, description = $c$Un rayo negro se proyecta desde tu dedo índice. Debes tener éxito en un ataque de toque a distancia para impactar con él a un objetivo. Este quedará exhausto instantáneamente y por toda la duración del conjuro. Una salvación de Fortaleza con éxito hace que la criatura quede sólo fatigada. Un personaje que ya esté fatigado quedará exhausto.

Este conjuro no tiene ningún efecto en una criatura que ya esté exhausta. A diferencia de los estados fatigado y exhausto normales, este efecto termina en cuanto expira la duración del conjuro.

Componente material: una gota de sudor.

| ayo de debilitamiento | |
| |--|
| Nigromancia | |
| Nivel: Hcr/Mag 1 | |
| Componentes: V, S | |
| Tiempo de lanzamiento: 1 acción<br>estándar | |
| Alcance: corto (25' + 5'/2 niveles) | |
| Efecto: rayo | |
| Duración: 1 min/nivel | |
| Tiro de salvación: ninguno | |
| Resistencia a conjuros: sí | |
| | |

De tu mano surge un rayo de gran fulgor con el que podrás alcanzar a un oponente si tienes éxito en un ataque de toque a distancia. El receptor sufrirá un penalizador en su puntuación de Fuerza igual a 1d6+1 por cada dos niveles de lanzador (máximo 1d6+5). La Fuerza del receptor no puede quedar reducida por debajo de 1. 1100.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$rayo$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Fortaleza parcial; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'rayo agotador';
update spells set school = $c$R$c$, description = $c$Un rayo de hielo y aire frío surge de tu dedo índice. Para que éste inflija daño a un oponente (1d3 puntos de daño por frío) deberás tener éxito en un ataque de toque a distancia.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$rayo$c$, duration = $c$instantanea$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'rayo de escarcha';
update spells set school = $c$Evocación$c$, description = $c$Un rayo blanco-azulado de aire gélido y hielo surge de tu mano. Debes tener éxito en un ata-

que de toque a distancia con el rayo para infligir daño a un objetivo. El rayo causa 1d6 puntos de daño por frío por nivel de lanzador (máximo 25d6).

Foco: un pequeño cono o prisma de cerámica.$c$, components = $c$V, S, F$c$, casting_time = $c$1 acción<br>estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$rayo$c$, duration = $c$instantanea$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$si$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'rayo polar';
update spells set school = $c$Evocación$c$, descriptors = $c$electricidad$c$, description = $c$Este conjuro te permite liberar una poderosa descarga de energía eléctrica que inflige 1d6 puntos de daño por nivel de lanzador (máximo 10d6) a cualquier criatura que se encuentre en su área. La descarga comienza en las yemas de tus dedos.

El rayo relampagueante incendia los materiales combustibles, daña los objetos que se encuentre en su camino y puede fundir los metales con un bajo punto de fusión, como el plomo, el oro, el cobre, la plata o el bronce. Si el daño causado a una barrera interpuesta es suficiente para romperla, el rayo puede continuar avanzando tras ella, siempre que su alcance se lo permita; de lo contrario, se detendrá al llegar a la barrera, igual que haría cualquier otro efecto de conjuro.

Componentes materiales: un poco de pelaje y un cetro de ámbar, vidrio o cristal.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$120'$c$, target = $c$línea de 120'$c$, duration = $c$instantanea$c$, saving_throw = $c$Reflejos mitad$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'rayo relampaqueante li ma';
update spells set school = $c$Company$c$, description = $c$Mientras dure este conjuro, podrás usar una acción estándar para evocar cada asalto un haz deslumbrante de luz intensamente caliente. Podrás generar un haz por cada 3 niveles de lanzador (máximo 6 haces en el nivel 18.º). El conjuro finalizará cuando expire su duración o se agote tu asignación de haces.

Todas las criaturas envueltas por el haz quedarán cegadas y sufrirán 4d6 punto de daño. Además, cualquier criatura para la cual la luz del sol sea dañina o antinatural, recibe doble daño. Tener éxito en un TS de Reflejos niega la ceguera y reduce el daño a la mitad.

Los muertos vivientes envueltos por la luz sufrirán 1 d6 puntos de daño por nivel de lanzador (máximo 20d6), o la mitad de daño si tienen éxito en su salvación de Reflejos. Además,

el rayo destruirá directamente a los muertos vivientes que resulten afectados por la luz solar (como un vampiro) si fallan su TS.

La luz ultravioleta generada por el sortilegio infligirá daño a los hongos, mohos, cienos, limos, gelatinas, pudines y criaturas fúngicas, igual que si fueran muertos vivientes.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$60'$c$, target = $c$línea desde tu mano$c$, duration = $c$1 asalto/nivel o hasta que se agoten los haces$c$, saving_throw = $c$Refleios niega v Refleios$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'rauo solar';
update spells set school = $c$Nigromancia$c$, descriptors = $c$maligno$c$, description = $c$Este conjuro convierte los huesos o cadáveres de las criaturas muertas en esqueletos o zombis muertos vivientes que siguen tus órdenes verbales. Los muertos vivientes pueden seguirte o quedarse en un lugar y atacar a cualquier criatura (o sólo a las de un tipo concreto) que entren en él. Los muertos vivientes continuarán reanimados hasta ser destruidos (un esqueleto o zombi destruido no puede volver a ser reanimado).

Con un solo lanzamiento de reanimar a los muertos no puedes crear más DG de muertos vivientes que tu nivel de lanzador, no importa de qué tipo sean las criaturas creadas. El conjuro de profanar dobla este límite (consulta la página 275).

Los muertos vivientes que crees permanecerán bajo tu control indefinidamente. No obstante, sin importar cuántas veces utilices el conjuro, sólo podrás controlar a 4 DG de criaturas muertas vivientes por nivel de lanzador que poseas. Si llegas a superar tal número, las criaturas recién creadas permanecerán bajo tu control y el exceso de muertos vivientes correspondientes a lanzamientos previos quedaría descontrolado (puedes elegir qué criaturas serán liberadas). Si eres clérigo, los muertos vivientes que puedas controlar por medio de tu poder de comandar o reprender no contarán para este límite.

Esqueletos: estas criaturas sólo pueden crearse usando esqueletos o cadáveres prácticamente intactos. El cadáver en cuestión debe tener huesos (no puede crearse un esqueleto a partir de un gusano púrpura, por ejemplo). Si el esqueleto se construye empleando un cadáver, la carne de éste se desprenderá de los huesos. Las estadísticas del esqueleto dependerán de su tamaño, no de las poseídas en vida por la criatura. Consulta el Manual de monstruos para obtener más detalles.

Zombis: los zombis sólo pueden crearse utilizando cadáveres intactos en su mayor parte. La criatura empleada debe tener una anatomía verdadera (no puede crearse un zombi a partir de un cubo gelatinoso, por ejemplo). Las estadísticas del zombi dependerán de su tamaño, no de las poseídas en vida por la criatura. Consulta el Manual de monstruos para obtener más detalles

Componente material: debes colocar un ónice negro (con un valor mínimo de 25 po) en la boca o en una de las cuencas oculares de cada cadáver. La magia del conjuro transformará estas gemas en cáscaras fundidas y sin valor.$c$, components = $c$V. S. M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$uno o más cadáveres tocados$c$, duration = $c$instantanea$c$, saving_throw = $c$ninguno = = =$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'reanimar a los muertos';
update spells set school = $c$Evocación$c$, description = $c$Te permite ponerte en contacto con una criatura concreta con la que estés familiarizado y enviarle un corto mensaje de 25 palabras como máximo. El receptor sabrá quién eres si te conocía de antes, y podrá responderte inmediatamente de forma parecida. Las criaturas podrán entender tu mensaje siempre que su Inteligencia no sea inferior a 1, aunque su capacidad de reacción puede verse limitada por su puntuación en esa característica. Aunque el recado sea recibido, su receptor no estará obligado a actuar de ninguna forma concreta en respuesta a él.

Si la criatura en cuestión no está en el mismo plano de existencia que tú, habrá un 5% de posibilidades de que no llegue a recibir el recado (a discreción del DM, las condiciones locales de los otros planos pueden incrementar estas posibilidades considerablemente).

Componente material arcano: un trozo corto de fino hilo de cobre. Cobre.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$10 minutos$c$, spell_range = $c$ver texto$c$, target = $c$una criatura$c$, duration = $c$1 asalto; ver texto$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'recado';
update spells set school = $c$Abjuración$c$, description = $c$Un campo, móvil e invisible, te rodea e impide que las criaturas se te acerquen. Podrás elegir el tamaño del campo en el momento de lanzar el conjuro (hasta el límite permitido por tu nivel). Las criaturas que estén dentro del campo o penetren en él tendrán que realizar TS. Si fallan, serán incapaces de acercarse a ti mientras dure el sortilegio, aunque sus acciones no se verán restringidas de ninguna otra forma; podrán combatir contra otras criaturas y dirigir contra ti sus ataques a distancia. Si te acercas a una criatura afectada, no pasará nada (no será empujada por el efecto) y ésta tendrá derecho a atacarte en cuerpo a cuerpo si te aproximas lo

suficiente. Si una criatura rechazada se alejara e intentara aproximarse de nuevo a ti, no podría acercarse lo más mínimo en caso de seguir dentro del área del conjuro.

Foco arcano: dos pequeñas barras de hierro, sujetas a dos pequeñas estatuillas de perros, una negra y otra blanca, con un valor total de 50 po.

| Recluir |
| |
| Abjuración |
| Nivel: Hcr/Mag 7 |
| Componentes: V, S, M |
| Tiempo de lanzamiento: 1 acción |
| estandar |
| Alcance: toque |
| Objetivo: una criatura voluntaria u objeto (de |
| hasta un cubo de 2'/nivel) tocado |
| Duración: 1 día/nivel (D) |
| Tiro de salvación: ninguno o Voluntad niega |
| (objeto) |
| Resistencia a conjuros: no o sí (objeto) |

Al ser ejecutado, este conjuro no sólo impide que los sortilegios de adivinación detecten o localicen a la criatura u objeto afectado por recluir, sino que vuelve invisible al receptor ante toda forma de vista o visión (como por el conjuro invisibilidad). Por tanto, este conjuro puede ocultar una puerta secreta, cámara del tesoro, etc. Recluir no impide que el receptor sea descubierto mediante el tacto o el uso de ciertos objetos (como una túnica de los ojos o una gema de visión). Las criaturas afectadas por este conjuro entran en coma y pasan a un estado de animación suspendida efectiva hasta que el efecto de recluir expire o sea disipado.

Nota: la salvación de Voluntad impide que un personaje u objeto mágico sea recluido. No se permite realizar un TS para ver a la criatura u objeto recluido ni para detectarlo por medio de un conjuro de adivinación.

Componentes materiales: una pestaña de basilisco, goma arábiga y una cucharada de apuacal.$c$, components = $c$V, S, F/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$hasta 10'/nivel$c$, target = $c$emanación de hasta 10' de radio/nivel, centrada en ti$c$, duration = $c$1 asalto/nivel (D)$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'rechazo';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro funciona como reducir persona, salvo en que afecta a un único animal voluntario (no a uno con el que estés combatiendo, por ejemplo). Esta disminución del tamaño permite al animal caber mejor en lugares estrechos, como el dungeon típico o un pasaje subterráneo. Reduce el daño infligido por los ataques naturales del animal tal y como se muestra en la Guía del Dungeon Master. 11 11

| educir persona | |
| |--|
| Transmutación | |
| Nivel: Hcr/Mag 1 | |
| Componentes: V, S, M | |
| Tiempo de lanzamiento: 1 asalto | |
| Alcance: corto (25' + 5'/2 niveles) | |
| Objetivo: una criatura humanoide | |
| Duración: 1 min/nivel (D) | |
| Tiro de salvación: Fortaleza niega | |
| Resistencia a conjuros: sí | |
| | |

Este conjuro hace disminuir instantáneamente a una criatura humanoide, reduciendo a la mitad su altura y su anchura, y dividiendo su peso entre 8. Esta disminución cambia la categoría de tamaño de la criatura a la inmediatamente inferior. El objetivo obtiene un bonificador +2 de tamaño a Destreza, un penalizador -2 de tamaño a Fuerza (hasta un mínimo de 1), y un bonificador +1 a las tiradas de ataque y la CA debido a su menor tamaño.

Un humanoide Pequeño que vea su tamaño disminuido hasta Menudo ocupa un espacio de 2 1/2' y tiene un alcance natural de 0' (lo cual quiere decir que debe entrar en la casilla de un oponente para atacarle). Un humanoide Grande cuyo tamaño disminuya hasta Mediano tiene un espacio de 5' y un alcance natural de 5'.

Este conjuro no cambia la velocidad del obietivo.

Todo equipo que lleve puesto o transporte una criatura es reducido de modo similar por este conjuro. Las armas de cuerpo a cuerpo y de proyectil infligen menos daño (consulta la Guía del Dungeon Master).

Otras propiedades mágicas no resultan afectadas por el sortilegio. Cualquier objeto reducido que deje de estar en posesión de la criatura reducida (incluyendo un proyectil o arma arrojadiza) regresa instantáneamente a su tamaño normal. Esto quiere decir que las armas arrojadizas infligen daño normal (los proyectiles causan daño acorde al tamaño el arma que los disparó).

Varios efectos mágicos que reduzcan el tamaño no se apilan, lo cual quiere decir (entre otras cosas) que no puedes utilizar un segundo lanzamiento de este conjuro para reducir aún más el tamaño de un humanoide que ya esté bajo los efectos de un primer lanzamiento.

Reducir persona contrarresta y disipa agrandar persona.

Reducir persona puede ser hecho permanente con un conjuro de permanencia.

Componente material: una pizca de hierro en polvo.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$un animal voluntario, de tamaño Pequeño, Mediano, Grande o Enorme$c$, duration = $c$1 hora/nivel (D) ===================================================================================================================================================$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'reducir animal';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro tiene dos versiones:

Podar: la primera versión tiene alcance largo (400' + 40'/nivel) y reduce la vegetación normal (hierba, brezos, arbustos, plantas rastreras, cardos, cepas, etc.) hasta 1/3 de su tamaño normal, desenmarañándola y evitando que sea tan tupida. La vegetación afectada parecerá haber sido cuidadosamente podada y arreglada.

Según elijas, el área puede ser un círculo de 100' de radio, un semicírculo de 150' de radio, o un cuarto de círculo con un radio de 200'. También puedes hacer que ciertas partes del área no resulten afectadas por la magia.

Atrofiar: la segunda versión afecta a las plantas normales en un radio de media milla, reduciendo a 1/3 de lo normal su potencial de productividad durante el siguiente año.

Reducir plantas contrarresta a crecimiento vegetal. Este conjuro no afecta a criaturas tipo planta.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$ver texto Objetivo o á$c$, target = $c$ver texto$c$, duration = $c$instantanea$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'reducir plantas';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro te permite devolver la vida a un muerto, aunque en el cuerpo de otra criatura, siempre y cuando la muerte no haya tenido lugar hace más de 1 semana (a contar desde el lanzamiento del conjuro) y el alma del receptor esté libre y dispuesta a regresar (consulta Devolver la vida a los muertos', en la pág. 171). Si el alma del receptor no quiere regresar, el conjuro no funcionará; por tanto, no ha lugar a TS en receptores que deseen volver.

Como el muerto regresa a la vida en otro cuerpo, todas sus enfermedades y aflicciones desaparecerán durante el proceso. El estado de los restos no es relevante. Mientras siga existiendo alguna pequeña porción del cuerpo de la criatura, esta puede ser reencarnada, siempre y cuando esta porción hubiese sido parte del cuerpo de la criatura en el momento de su muerte. La magia del conjuro usará los elementos naturales que tenga a mano para crear el cuerpo de un joven adulto, completamente nuevo, que pueda ser ocupado por el alma del muerto. Este proceso requiere una hora para completarse. El receptor se reencarnará en cuanto el cuerpo esté listo. Sommer

Una criatura reencarnada recordará la mayor parte de su vida anterior. Conservará cualquier aptitud de clase, dote o rangos en habilidades que poseyera anteriormente. La clase, los ataques y salvaciones base y los puntos de golpe tampoco cambiarán. Sin embargo, las puntuaciones de Fuerza, Destreza y Constitución dependerán en parte de su nuevo cuerpo. Primero habrá que eliminar los ajustes raciales del personaje (si ya no pertenece a su antigua especie) y, a continuación, aplicar los ajustes indicados más abajo. El nivel del objetivo (o sus DG) se reducirá en 1. Si el personaje fuera de 1.6 nivel, sería su puntuación de Constitución la que se reduciría en 2, y si esta reducción situaría su Con en 0 o menos, no podrá ser reencarnado. Esta pérdida de nivel/DG no puede ser restaurada por ningún medio.

Es posible que el cambio en las puntuaciones de características del personaje le haga difícil continuar con su anterior clase de personaje. Si así fuera, se recomienda al receptor que se convierta en personaje multiclase.

Para una criatura humanoide, la nueva encarnación es determinada utilizando la siguiente tabla. Para criaturas no humanoides, el DM debería crear una tabla similar de criaturas del mismo tipo, o simplemente elegir una nueva forma.

Una criatura que haya sido transformada en un muerto viviente o muerta por un efecto de muerte no puede ser devuelta a la vida mediante este conjuro. Los constructos, elementales, ajenos y muertos vivientes no pueden ser reencarnados. El conjuro no puede devolver la vida a una criatura que haya muerto por la edad.

| d% | Encarnación | | Fue Des Con | |
| | | | | |
| | | | | |
| 07 | Osgo | 44 | +2 | +2 |
| 02-13 | Enano | +0 | +0 | +2 |
| 14-24 | Ello | +0 | +2 | -2 |
| 26 | Gnoll | +4 | +0 | +2 |
| 27-38 | Gnomo | -2 | +0 | +2 |
| 39-42 | Trasgo | -2 | +2 | +0 |
| 43-52 | Semielfo | +0 | +0 | +0 |
| 53-62 | Semiorco | +2 | +0 | +0 |
| 63-74 | Mediano | -2 | +2 | +0 |
| 75-89 | Humano | +0 | +0 | +0 |
| 90-93 | Kobold | শ | +2 | -2 |
| 94 | Hombre lagarto | +2 | +0 | +2 |
| 95-98 | Orco | +4 | +0 | +0 |
| gg | Saurión | +0 | -2 | +4 |
| 100 | Otro | 2 | n | 2 |
| | (a elección del DM) | | | |

La criatura reencarnada obtendrá las aptitudes relacionadas con su nueva forma, incluyendo la velocidad y modalidad de movimiento, la armadura natural, los ataques naturales, las aptitudes extraordinarias, etc., pero no hablará automáticamente el idioma de su nueva forma. Consulta el Manual de monstruos para los detalles.

Un conjuro de deseo puede devolver a un personaje reencarnado a su forma original. Componente material: raros aceites y ungüentos por un valor total de al menos 1.000 po, que deben extenderse sobre los restos.$c$, components = $c$V, S, M, FD March in Champ$c$, casting_time = $c$10 minutos$c$, spell_range = $c$toque ===============================================================================================================================================================$c$, target = $c$criatura muerta tocada$c$, duration = $c$instantánea$c$, saving_throw = $c$ninguno; ver texto$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'reencarnar linke';
update spells set school = $c$Conjuración$c$, descriptors = $c$teletransporte$c$, description = $c$Este conjuro te permite almacenar un poderoso efecto mágico en un objeto preparado especialmente (una estatuilla, un cetro enjoyado, etc.). El objeto en cuestión contendrá el poder de transportar instantáneamente a su poseedor hasta tu morada, pudiendo cubrir éste cualquier distancia, pero siempre en el mismo plano. Una vez el objeto haya sido transformado, tendrás que entregárselo voluntariamente a un individuo, informándole en ese momento de la palabra de mando que habrá de pronunciar cuando desee utilizar el efecto. Para usar el objeto, el receptor tendrá que pronunciar la palabra de mando a la vez que rompe o desgarra el objeto en cuestión (una acción estándar). Hecho esto, el individuo y todo lo que lleve puesto o cargue (hasta un máximo igual a la carga pesada para ese personaje) será transportado instantáneamente hasta tu morada. Ninguna criatura más resultará afectada (aparte de un familiar, siempre y cuando esté tocando al receptor).

Al ejecutar este sortilegio, puedes alterarlo para que te transporte a 10' de quien posea el objeto cuando éste lo rompa y pronuncie la palabra de mando. Tendrás una idea general del lugar y el estado en que se encuentre el poseedor del objeto en el momento de descargar el conjuro de refugio, pero, una vez decidas alterar el sortilegio de este modo, no podrás evitar ser transportado por el efecto.

Componente material: el objeto preparado especialmente, cuya fabricación requiere gemas por valor de 1.500 po.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$objeto tocado$c$, duration = $c$permanente hasta ser descargado$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'refugio';
update spells set school = $c$Conjuración$c$, subschool = $c$curacion$c$, description = $c$Este conjuro regenera fragmentos perdidos del cuerpo del receptor, como miembros seccionados (dedos de manos y pies, manos, pies, brazos, piernas, colas e incluso cabezas si la criatura tiene varias cabezas), huesos rotos y órganos deteriorados. Una vez se haya ejecutado el sortilegio, la regeneración física estará completa al cabo de 1 asalto, siempre y cuando los miembros seccionados estén presentes y en contacto con la criatura. De lo contrario, la regeneración tardará 2d10 asaltos en completarse.

Este conjuro también cura 4d8 puntos de daño, +1 punto adicional por nivel de lanzador (máximo +35), hace que el objetivo deje de estar fatigado y/o exhausto y elimina todo daño no letal. No tiene efecto alguno sobre criaturas que no estén vivas (incluidos los muertos vivientes).$c$, components = $c$V, S, FD$c$, casting_time = $c$3 asaltos completos$c$, spell_range = $c$toque$c$, target = $c$criatura viva tocada$c$, duration = $c$instantanea$c$, saving_throw = $c$Fortaleza niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'regenerar';
update spells set school = $c$PARACTORY$c$, description = $c$Este conjuro crea un efecto eléctrico que comienza en las yemas de tus dedos en forma de una sola descarga. A diferencia de lo que sucede con el rayo relampagueante, el relámpago zigzagueante alcanza a un primer objeto o criatura y después describe un arco en dirección a nuevas víctimas.

El rayo inflige 1d6 puntos de daño por electricidad por nivel de lanzador (máximo 20d6) al objetivo principal. Después de golpear, el rayo podrá describir un arco en dirección a tantos objetivos secundarios como tu nivel de lanzador (máximo 20). Cada rayo secundario alcanzará a una víctima e infligirá la mitad de dados de daño (redondeando a la baja) que el principal. Por ejemplo, un hechicero de nivel 19.º genera un rayo principal (19d6 puntos de daño) y hasta 19 rayos secundarios (cada uno de los cuales inflige la mitad del daño del rayo principal). Todos los receptores tienen derecho a un TS de Reflejos para sufrir sólo la mitad del daño. Podrás elegir los blancos secundarios según prefieras, pero todos ellos han de estar situados en un radio de 30' del objetivo principal y ninguno de ellos puede ser alcanzado en más de una ocasión. Puedes optar por alcanzar a una cantidad de blancos secundarios inferior a la máxima (por ejemplo, para evitar que tus aliados resulten afectados).

Foco: un poco de piel de animal, un fragmento de ámbar o vidrio o un cetro de cristal, y un alfiler de plata por cada uno de tus niveles de lanzador.$c$, components = $c$V, S, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$largo (400' + 40'/nivel)$c$, target = $c$un objetivo principal más un objetivo secundario/nivel (dos receptores cualesquiera no pueden distar más de 30')$c$, duration = $c$instantánea$c$, saving_throw = $c$Reflejos mitad Resistencia a coniuros: si$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'relampago zigzaqueante';
update spells set school = $c$Nigromancia$c$, description = $c$Usando la terrible vista concedida por los poderes de la muerte en vida, podrás averiguar la situación física de las criaturas moribundas que se encuentren en el alcance del conjuro. Sabrás instantáneamente qué criaturas del área han muerto, están débiles (vivas y heridas, con 3 pg o menos), luchan contra la muerte (4 pg o más), son muertos vivientes o no están vivas ni muertas (como los constructos). Este conjuro frustrará todo sortilegio o aptitud que permita a una criatura fingir su muerte.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$30'$c$, target = $c$emanación en forma de cono$c$, duration = $c$10 min/nivel$c$, saving_throw = $c$ninguno Resistencia a coniuros: no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'reloj de la muerte';
update spells set school = $c$Nigromancia$c$, description = $c$Te permite matar a una criatura viva. Para alcanzar al receptor, debes realizar un ataque de toque en cuerpo a cuerpo. La víctima podrá evitar la muerte con un TS de Fortaleza; si tiene éxito, el receptor no morirá, sino que sufrirá 3d6 puntos de daño +1 un punto adicional por nivel de lanzador (aunque nada impide que el daño lo mate a pesar de haber tenido éxito en la salvación).

| | Remendar |
|--| |
| | Transmutacion |
| | Nivel: Brd 0, Clr 0, Drd 0, Hcr/Mag 0 |
| | Componentes: V, S |
| | Tiempo de lanzamiento: 1 acción estándar |
| | Alcance: 10' |
| | Objetivo: un objeto de 1 lb. como máximo |
| | Duración: instantanea |
| | Tiro de salvación: Voluntad niega |
| | (inotensivo, objeto) |
| | Resistencia a conjuros: sí (inofensivo, |
| | objeto) |

Este conjuro repara pequeños desperfectos y roturas en los objetos (no así sus deformidades, como las causadas por un conjuro de deformar madera). En lo que se refiere a objetos metálicos, soldará un anillo roto, un eslabón de una cadena, un medallón o una daga ligera, siempre y cuando sólo tengan una rotura. La cerámica o los objetos de madera con varios desperfectos volverán a unirse y serán tan resistentes como si fueran nuevos. Un agujero en un saco u odre de cuero desaparecerá sin dejar rastro al lanzar este conjuro. Aunque remendar es capaz de reparar un objeto mágico, no puede devolverle cualquier aptitud especial de la que dispusiera (para averiguar cómo devolver sus capacidades a un objeto mágico roto, consulta las dotes de creación de objetos en el Capítulo 5). El conjuro no puede remendar varitas, bastones ni cetros mágicos que se hayan roto, y no afecta a criaturas (ni siquiera a constructos).$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura viva tocada$c$, duration = $c$instantanea$c$, saving_throw = $c$Fortaleza parcial$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'rematar a los vivos';
update spells set school = $c$Transmutación$c$, descriptors = $c$tierra$c$, description = $c$Este conjuro remueve la tierra (arcilla, marga y arena) y puede llegar a derrumbar terraplenes, desplazar montículos, cambiar la forma a las dunas, etc. Sin embargo, no podrá derrumbar ni desplazar formaciones rocosas bajo ningún concepto. El área a la que se desee afectar determinará el tiempo de lanzamiento. La ejecución del sortilegio requiere 10 minutos por cada cuadrado de 150' de lado (y hasta 10' de profundidad). El área máxima, es decir, 750×750', tardaría 4 horas y 10 minutos en ser removida.

Este conjuro no rompe violentamente la superficie del terreno. En su lugar, crea crestas y canales que recuerdan a las olas y la tierra reacciona con la misma fluidez que un glaciar hasta alcanzar el resultado deseado. Los árboles, edificios, formaciones rocosas, etc., sólo resultarán afectados en lo que se refiere a la elevación y su topografía relativa.

Este sortilegio no puede utilizarse para excavar túneles y, por lo general, es demasiado lento como para poder atrapar o enterrar a criaturas. Se utiliza principalmente para excavar y llenar fosos o para ajustar el contorno del terreno antes de una batalla.

Este conjuro no tiene efecto sobre las criaturas de tierra.

Componente material: una mezcla de distintas tierras (arcilla, marga y arena) en una bolsa pequeña y una hoja de hierro.$c$, components = $c$V, S, M$c$, casting_time = $c$ver texto$c$, spell_range = $c$largo (400' + 40'/nivel)$c$, target = $c$tierra en un área cuadrada de hasta 750° de lado y 10' de profundidad (Mo)$c$, duration = $c$instantánea - 1 1 seine$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'remover tierra';
update spells set school = $c$Transmutación$c$, description = $c$Una oleada de energía avanza desde ti, moviéndose en la dirección que elijas y empujando hasta el límite del conjuro a todo objeto de madera que halle en su camino. Los objetos de madera que midan más de 3" de diámetro y estén firmemente sujetos no resultarán afectados, pero los que estén sueltos (barriles, torres de asedio, etc.) sí lo serán. Los objetos con hasta un diámetro máximo de 3" que estén sujetos se astillarán y romperán y sus fragmentos serán arrastrados por la oleada de energía. Los objetos

afectados por el conjuro serán repelidos a una velocidad de 40' por asalto.

Ciertos objetos de madera (como escudos, lanzas, los mangos y astas de algunas armas, y las flechas y virotes) arrastrarán consigo a quienes los porten (una criatura arrastrada por un objeto que porte puede soltarlo; una que sea arrastrada por su escudo podrá quitárselo como acción de movimiento y soltarlo como acción gratuita). Si se planta (coloca) una lanza en el suelo para impedir este movimiento forzoso, se partirá. Incluso los objetos mágicos que tengan partes de madera serán repelidos, aunque un campo antimagia bloqueará tales efectos.

Las ondas de energía seguirán cubriendo la senda elegida mientras dure el conjuro. Esta senda quedará fijada al ejecutar el sortilegio y podrás dedicarte a otras cosas sin afectar al poder del conjuro.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$60'$c$, target = $c$emanación en forma de línea de 60' a partir de ti$c$, duration = $c$1 min/nivel (D)$c$, saving_throw = $c$ninguno RACICLARCIA 2 COMSITIFOC. DO$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'repeler madera';
update spells set school = $c$Abjuración$c$, descriptors = $c$tierra$c$, description = $c$Al igual que repeler madera, este conjuro crea olas de energía invisible e intangible que avanzan desde ti. Todos los objetos metálicos o de piedra que se encuentren en el camino del sortilegio serán apartados de ti hasta el límite del alcance. Los objetos fijos de esos materiales que tengan más de 3" de diámetro y los objetos sueltos que pesen más de 500 lb. no resultarán afectados. Todo lo demás será empujado, incluyendo los objetos animados, los cantos rodados pequeños y las criaturas que lleven armadura metálica. Los objetos fijos de hasta un diámetro máximo de 3" se doblarán o romperán y los fragmentos que se desprendan de ellos serán arrastrados por la ola de energía. Los objetos afectados por el conjuro serán repelidos a una velocidad de 40' por asalto.

Los objetos como armaduras metálicas, espadas, etc., serán empujados, arrastrando consigo a sus portadores. Incluso los objetos mágicos que tengan partes metálicas serán repelidos, aunque un campo antimagia bloqueará tales efectos.

Las ondas de energía continuarán cubriendo la senda elegida mientras dure el conjuro. Esta senda quedará establecida nada más ejecutes el sortilegio y podrás dedicarte a otras cosas sin que ello afecte al poder del conjuro.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$60'$c$, target = $c$línea de 60' que emana de ti$c$, duration = $c$1 asalto/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'repeler piedra o metal';
update spells set school = $c$Abjuración$c$, description = $c$Una barrera invisible mantiene a raya a las sabandijas. Las criaturas de este tipo que tengan menos DG que 1/3 de tu nivel no podrán atravesar la barrera. Las sabandijas cuyos DG igualen o superen 1/3 de tu nivel podrán atravesar la barrera si logran tener éxito en un TS de Voluntad. Aun así, la barrera infligirá 2d6 puntos de daño a cada sabandija que la atraviese; de hecho, su mero contacto hace que estas criatura sientan dolor, lo cual suele disuadir a la mavoría de las sabandijas.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$10' 1 18$c$, target = $c$emanación de 10' de radio, centrada en ti$c$, duration = $c$10 min/nivel (D)$c$, saving_throw = $c$ninguno o Voluntad niega; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'repeler sabandijas';
update spells set school = $c$AD$c$, description = $c$Protegerá contra el daño, otorgándole un bonificador +1 de resistencia en sus TS.

Resistencia puede ser hecho permanente con un conjuro de permanencia. Componente material arcano: una capa en mi-$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$1 minuto$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo) Infundes al receptor con energia magica que l a proven so la concellent survey and service of career in$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'resistencia';
update spells set school = $c$niatura$c$, description = $c$La criatura obtiene una RC igual a 12 + tu nivel de lanzador.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'resistencia a conjuros';
update spells set school = $c$Transmutación$c$, description = $c$La criatura afectada obtiene mayor vitalidad y resistencia física. El conjuro concede al receptor un bonificador +4 de mejora a la Constitución, que añadirá a los beneficios usuales en forma de puntos de golpe, TS de Fortaleza, pruebas de Constitución, etc.

Los pg obtenidos por un incremento temporal de la puntuación de Constitución no son puntos de golpe temporales, sino que desaparecen tan pronto como la Constitución del personaje vuelve a su nivel normal; además, tampoco son los primeros en desaparecer, como sucede con los pg temporales (consulta la pag. 146).$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'resistencia de oso';
update spells set school = $c$Abjuracion$c$, description = $c$Esta abjuración otorga a una criatura una protección limitada contra el daño de uno de los cinco tipos de energía: ácido, electricidad, frío, fuego o sonido. El objetivo obtiene resistencia a la energía 10 contra el tipo seleccionado, lo cual quiere decir que cada vez que reciba este tipo de daño (sea de una fuente natural o mágica), ese daño se reducirá en 10 puntos antes de aplicarse a los puntos de golpe de la criatura. El valor de la resistencia a la energía proporcionada aumenta a 20 puntos a nivel 7.º y hasta un máximo de 30 puntos a nivel 11.º. El conjuro protege también al equipo del receptor.

Resistir energía sólo absorbe daño, pero el receptor sigue pudiendo sufrir otros efectos nocivos adicionales, como ahogarse en ácido (ya que la asfixia viene de la falta de oxígeno) o quedar atrapado en el hielo.

Nota: resistir energía se solapa (y, por tanto, no se apila) con protección contra la energia. Si un personaje esta bajo los efectos de protección contra la energía y resistir energía, el conjuro de protección absorbe daño hasta que su poder quede agotado.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$10 min/nivel$c$, saving_throw = $c$Fortaleza niega (inotensivo)$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'resistir energia - - minuteli';
update spells set school = $c$Transmutación$c$, description = $c$Las criaturas transmutadas podrán respirar bajo el agua con total libertad. Divide la duración de forma equitativa entre todas las criaturas a las que toques.

Este conjuro no impide respirar aire a las criaturas tocadas.

Componente material arcano: una caña corta o un tallo de paja.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criaturas vivas tocadas$c$, duration = $c$2 h/nivel; ver texto$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'respiracion acuatica - com';
update spells set school = $c$Conjuración$c$, subschool = $c$curación$c$, description = $c$Este conjuro funciona igual que restablecimiento menor, pero también disipa niveles negativos y restablece un nivel de experiencia a una criatura a la que le haya sido consumido. El nivel consumido sólo será recuperado si el tiempo transcurrido desde que la criatura lo perdiera no es superior a 1 día por nivel de lanzador. Así, si un personaje de 10.º nivel ha sido alcanzado por un tumulario y, por tanto, pasa a ser de 9.º nivel; al recibir un conjuro de restablecimiento sus puntos de experiencia pasarían a ser exactamente los mínimos necesarios para devolverlo al 10.º nivel (45.000 PX), obteniendo un DG adicional y los beneficios de nivel que le correspondan.

Este conjuro cura todo el daño temporal de característica y restablece todos los puntos consumidos permanentemente en una sola puntuación (si más de una característica hubiera sido consumida, el lanzador elegiría cuál resulta afectada).

Este conjuro no restablece los niveles ni puntos de Constitución que se hayan perdido a causa de la muerte.

Componente material: polvo de diamante, por valor de 100 po, que ha de espolvorearse sobre el receptor.$c$, components = $c$V, S, M$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'restablecimiento';
update spells set school = $c$Conjuración$c$, subschool = $c$curación$c$, description = $c$Este conjuro disipa todo efecto mágico que reduzca una de las puntuaciones de característica del receptor (como rayo de debilitamiento) o cura 1d4 puntos de daño temporal de característica en una de sus puntuaciones de característica (como los infligidos por el veneno o el toque de una sombra). También elimina cualquier fatiga del personaje, y mejora su estado de exhausto a fatigado. Sin embargo, el conjuro no restablece la consunción permanente de características.$c$, components = $c$V, S$c$, casting_time = $c$3 asaltos$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$instantanea$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'restablecimiento menor';
update spells set school = $c$Conjuración$c$, subschool = $c$curación$c$, description = $c$Este conjuro funciona igual que revivir a los muertos, pero puedes devolver la vida y toda su fuerza a una criatura muerta. El estado de los restos no es importante. La criatura podrá ser resucitada mientras siga existiendo una pequeña porción de su cadáver, aunque es obligatorio que tal porción formara parte de su cuerpo en el momento de la muerte (los restos de una criatura alcanzada por un conjuro de desintegrar contarán como porción pequeña de un cadáver). La criatura en cuestión no puede llevar muerta más de 10 años por nivel de lanzador.

Al completarse el conjuro, la criatura volverá a la vida con todos sus puntos de golpe, vigor y salud y sin haber perdido ninguno de los conjuros que tuviera preparados. Sin embargo, el receptor perderá un nivel, o 2 puntos de Constitución, si fuera de 1.ª nivel (si esta reducción situara su Constitución en 0 o menos, no podría ser resucitado). Esta pérdida de nivel o Constitución no puede ser restaurada por ningún medio.

También puedes revivir a alguien que haya muerto por culpa de un efecto de muerte o que haya sido transformado en muerto viviente y destruido posteriormente. Sin embargo,

no podrás resucitar a nadie que haya muerto de viejo. Los constructos, elementales, ajenos y criaturas muertas vivientes no pueden ser resucitadas.

Componentes materiales: agua bendita (para rociar) y diamantes por un valor total de 10.000 po.$c$, casting_time = $c$10 minutos$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'resurreccion';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro aumenta tu velocidad terrestre en 30' (este ajuste es considerado como un bonificador de mejora). No tiene efecto sobre las otras formas de movimiento, como excavar, trepar, volar o nadar. Como cualquier otro efecto que aumente tu velocidad, este conjuro afecta a la distancia que puedes saltar (consulta la habilidad Saltar, en la pág. 77).

Este conjuro no tiene por qué utilizarse como parte de una retirada; el nombre del sortilegio sólo indica la actitud típica de los magos en lo que se refiere al combate. I part$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$1 min/nivel (D)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'retirada expeditiva';
update spells set school = $c$Abiuración$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'retorno de conjuros';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro convierte a un árbol en un protector o guardián. El sortilegio sólo puede lanzarse sobre un árbol cada vez; mientras un roble guardián esté activo, no podrás ejecutar el conjuro

sobre ningún otro árbol. El árbol sobre el que lances el conjuro debe estar en un radio de 10' del lugar en que vivas, dentro de un lugar que sea sagrado para ti o en un radio de 300' de algo que quieras vigilar o proteger.

El sortilegio debe lanzarse sobre un roble sano y de tamaño Enorme, al que podrás asignar una frase desencadenante de hasta una palabra por nivel de lanzador; por ejemplo, "Ataca a toda persona que se acerque sin decir muérdago sagrado", es una frase desencadenante de once palabras que podrías utilizar a partir de nivel 11.º. El conjuro roble guardián desencadena el efecto de animar el árbol, que se considera equivalente a un ent (consulta el Manual de monstruos). A discreción del DM, podrías usar las estadísticas del ent para calcular proporcionalmente las de un árbol pequeño, si tuvieras que lanzar el conjuro sobre un roble de menor tamaño.

Si el conjuro es disipado, el árbol plantará sus raíces de inmediato allá donde esté. Si eres tú quien lo libera, intentará regresar a su posición original antes de enraizarse. I rel e aller$c$, components = $c$V, S$c$, casting_time = $c$10 minutos$c$, spell_range = $c$toque$c$, target = $c$árbol tocado$c$, duration = $c$1 día/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'roble quardian';
update spells set school = $c$Ilusión$c$, subschool = $c$pauta$c$, descriptors = $c$enajenador$c$, description = $c$Un cono de colores vivos, entrelazados y desentonados, surge de tu mano aturdiendo a las criaturas, cegándolas o incluso dejándolas inconscientes. Cada criatura dentro del cono resulta afectada de acuerdo a sus DG.

Hasta 2 DG: la criatura queda inconsciente, cegada y aturdida durante 2d4 asaltos; tras los que estará cegada y aturdida durante 1d4 asaltos más, y finalmente solamente aturdida 1 asalto adicional. Sólo las criaturas vivas pueden quedar inconscientes.

3 ó 4 DG: la criatura queda cegada y aturdida durante 1d4 asaltos, y tras ello aturdida 1 asalto más.

5 o más DG: la criatura queda aturdida 1 asalto. Las criaturas ciegas no resultan afectadas por la rociada de color.

Componente material: tres pizcas de polvo (o de arena), coloreadas una de rojo, otra de amarillo y otra de azul.$c$, components = $c$V, S, M = = = = = =$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$15'$c$, target = $c$explosión en forma de cono 14 17 1$c$, duration = $c$instantánea (ver texto) - 1 1 1 1$c$, saving_throw = $c$Voluntad niega a con de$c$, spell_resistance = $c$sí properfuma a no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'rociada de color';
update spells set school = $c$Evocación$c$, description = $c$Este conjuro crea 7 haces de luz, brillantes y de muchos colores, que surgen y se entrelazan desde tu mano. Cada haz posee un poder diferente. Las criaturas del área del conjuro que tengan 8 DG o menos quedarán cegadas automáticamente durante 2d4 asaltos. Todas las criaturas del área serán alcanzadas al azar por uno o más haces, que generarán efectos adicionales. E

| | Color | |
| | | |
| 148 | del haz | Efecto |
| 1 | Rojo | 20 puntos de daño por |
| | | tuego (Reflejos mitad) |
| 2 | Naranja | 40 puntos de daño por |
| | | ácido (Reflejos mitad) |
| 3 | Amarillo | 80 puntos de daño por |
| | | electricidad (Reflejos mitad) |
| য | Verde | Veneno (mata; Fortaleza |
| | | parcial, sufres 1d6 puntos |
| | | de daño de Constitución en |
| | | su lugar) |
| 5 | Azul | Petrificación (Fortaleza |
| | | niega) |
| 6 | Añil | Locura (igual que el conjuro |
| | | locura; Voluntad niega) |
| 7 | Violeta | Envío a otro plano (Voluntad |
| | | niega) |
| 8 | | Alcanzado por dos rayos; |
| | | lanza los dados dos veces |
| | | más, ignorando todo |
| | | resultado de "8" |$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$60'$c$, target = $c$explosión en forma de cono$c$, duration = $c$instantánea$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$sí list. Por por series$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'rociada prismatica';
update spells set school = $c$Abjuración$c$, description = $c$Este conjuro libera a las criaturas de encantamientos, transmutaciones y maldiciones. Romper encantamiento puede invertir incluso un efecto instantáneo, como de la carne a la piedra. Por cada efecto de este tipo, deberás realizar una prueba de nivel de lanzador (1d20 + tu nivel de lanzador, máximo +15) contra una CD de 11 + el nivel de lanzador del efecto. Un éxito indica que la víctima queda libre del conjuro, maldición o efecto. En el caso de los objetos mágicos malditos, la CD será 25.

Si el conjuro es uno que no puede ser disipado mediante disipar magia, el conjuro de romper encantamiento sólo funcionaría si el conjuro a eliminar fuera de nivel 5.º o inferior. Por ejemplo, lanzar maldición no podría ser eliminado mediante disipar magia, pero romper encantamiento sí podría hacerlo desaparecer.

Si el efecto procede de un objeto mágico permanente, como una espada maldita, romper encantamiento no eliminará la maldición, sino que se limitará a liberar de sus efectos a la víctima, dejando que el objeto conserve su maldición. Por ejemplo, un objeto maldito podría cambiar el alineamiento de su usuario. Romper encantamiento libraría a la víctima del objeto y negaría el cambio producido en su alineamiento, pero la maldición seguiría presente y afectaría a la siguiente persona que lo cogiera (aunque se trate del receptor del conjuro de romper encantamiento).$c$, components = $c$V. S$c$, casting_time = $c$1 minuto$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$hasta una criatura por nivel (dos$c$, duration = $c$instantánea$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$no no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'romper encantamiento';
update spells set school = $c$Abjuración$c$, descriptors = $c$fuerza$c$, description = $c$Puedes trazar estas runas místicas en un libro, mapa, rollo de pergamino u otro objeto similar que incluya información escrita. Las runas detonan al ser leídas, infligiendo 6d6 puntos de daño por fuerza. Todo el que se encuentre cerca de ellas (lo bastante como para poder leerlas) sufrirá este daño sin TS. Todas las demás criaturas que estén en un radio de 10' de las runas tienen derecho a una salvación de Reflejos para medio daño. El objeto sobre el que estuvieran escritas las runas también sufrirá el daño completo (sin TS).

Tanto tú como las criaturas que indiques específicamente podréis leer el escrito protegido sin desencadenar las runas. Así mismo, podrás eliminarlas cuando lo desees. Las demás personas que quieran hacerlo deberán emplear un conjuro de disipar magia o de borrar, pero fallar en su intento de eliminar las runas desencadenará la explosión.

Nota: las trampas mágicas, como las runas explosivas, son difíciles de detectar e inutilizar. Un pícaro (y sólo un pícaro) puede usar la habilidad de Buscar para hallar las runas y la de Inutilizar mecanismo para desbaratarlas. En ambos casos, la CD será 25 + el nivel de conjuro (CD 28 para las runas explosivas).

| | abandijas gigantes |
|--| |
| | Transmutacion |
| | Nivel: Clr 4, Drd 4 |
| | Componentes: V, S, FD |
| | Tiempo de lanzamiento: 1 acción estándar |
| | Alcance: corto (25' + 5'/2 niveles) |
| | Objetivos: hasta 3 sabandijas (dos receptores |
| | cualesquiera no pueden distar más de 30') |
| | Duración: 1 min/nivel |
| | Tiro de salvación: ninguno |
| | Resistencia a conjuros: sí |
| | |

Conviertes a tres ciempiés, dos arañas o un escorpión, todos ellos de tamaño normal, en ver-

siones grandes de los mismos. Sólo puedes transmutar a un tipo de sabandijas (por lo que un mismo lanzamiento no podrá afectar tanto a un ciempiés como a una araña) y todas las afectadas deben crecer hasta adquirir el mismo tamaño. El tamaño al que la sabandija puede ser aumentada depende de tu nivel; consulta la tabla que hay más adelante. El Manual de monstruos tiene las características de los ciempiés, arañas y escorpiones, así como de otros tipos de sabandijas.

Ninguna de las sabandijas gigantes creadas por este conjuro intentará hacerte daño, pero tu control sobre ellas estará limitado a dar órdenes sencillas ("ataca", "defiende", "alto", etc.). Las órdenes de atacar a cierta criatura en cuanto aparezca o de impedir que suceda algo concreto son demasiado complicadas para ser entendidas por las sabandijas.

Si no se les ordena lo contrario, las sabandijas gigantes atacarán a toda cosa o criatura que esté cerca de ellas.

El DM puede ampliar los efectos de este conjuro a otros tipos de insectos, arácnidos u otras sabandijas, como hormigas, abejas, escarabajos, mantis religiosa y avispas, si así lo decide.

| | Tamaño de la |
| | |
| Nivel de lanzador | sabandija |
| 9.º o menos | Mediano |
| 10°-13.º | Grande |
| 14-17. | Enorme |
| 18.219.º | Gargantuesco |
| 20.º o superior | Colosal |$c$, components = $c$V, S$c$, casting_time = $c$1 acción estandar$c$, spell_range = $c$toque$c$, target = $c$un objeto tocado que no pese más de 10 lb$c$, duration = $c$permanente hasta ser descargado (D)$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$si$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'runas explosivas';
update spells set school = $c$Transmutación$c$, description = $c$La criatura transmutada por este conjuro se vuelve más sabia. El conjuro otorga un bonificador +4 de mejora a la Sabiduría, proporcionando los beneficios usuales a las habilidades relacionadas con la Sabiduría. Los clérigos, druidas, exploradores y paladines (y otros lanzadores de conjuros que se basen en la Sabiduría) que reciban este conjuro no obtiene conjuros adicionales por el aumento de la Sabiduría, pero sí ven aumentada la CD de sus conjuros.

Componente material arcano: Unas cuantas plumas o una pizca de heces de un búho.$c$, components = $c$V,S,M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega (inotensivo)$c$, spell_resistance = $c$si (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'sabiduria de buho';
update spells set school = $c$Evocación$c$, descriptors = $c$bueno$c$, description = $c$Este conjuro hace que un sitio, edificio o construcción determinado se convierta en lugar sagrado. Esto tiene cuatro efectos principales.

El primero es que la construcción queda protegida por un efecto de círculo mágico contra el mal.

El segundo es que todas las pruebas de Carisma para expulsar muertos vivientes obtienen un bonificador +4 sagrado y las de comandar a este tipo de criaturas sufren un penalizador -4. La RC no se aplica a este efecto (esta condición no se aplica a la versión druídica del conjuro).

El tercer efecto es que todo cuerpo que sea enterrado en el lugar sacralizado no podrá convertirse en una criatura muerta viviente.

Por último, tendrás la posibilidad de unir un único efecto de conjuro al lugar sacralizado. Este efecto de conjuro durará un año y funcionará en todo el lugar consagrado, sin importar cuál sea su duración normal o qué área o efecto tenga. Podrás decidir si el efecto se aplicará a todas las criaturas, a aquellas que compartan tu misma religión o alineamiento o a las que profesen otra fe o tengan un alineamiento distinto. Por ejemplo, podrías crear un efecto de bendecir que ayudara a todas las criaturas de tu fe o alineamiento que se encuentren en el área, o uno de maldición que entorpezca a las de una religión o alineamiento contrario al tuyo. Al terminar el año, el efecto elegido finalizará, aunque podrá ser renovado o vuelto a colocar en el lugar lanzando un nuevo conjuro de sacralizar.

Entre los efectos de conjuro que pueden unirse a un sortilegio de sacralizar se encuentran: ancla dimensional, auxilio divino, bendecir, causar miedo, custodia contra la muerte, detectar el mal, detectar magia, discernir mentiras, disipar magia, don de lenguas, libertad de movimiento, luz del día, oscuridad, oscuridad profunda, perdición, protección contra la energía, purgar invisibilidad, quitar el miedo, resistir energía, silencio, soportar los elementos y zona de verdad. Los TS y la RC pueden aplicarse a estos efectos (consulta la descripción individual de cada conjuro para encontrar los detalles).

Un área sólo puede recibir un sortilegio de sacralizar (y su correspondiente efecto de conjuro) al mismo tiempo. Popular

Sacralizar contrarresta pero no disipa el conjuro desacralizar.

Componentes materiales: hierbas, aceite e incienso por un valor mínimo de 1.000 po, más 1.000 po por nivel del conjuro que quiera unirse al área sacralizada.$c$, components = $c$V, S, M, FD$c$, casting_time = $c$24 horas$c$, spell_range = $c$toque punto tocado$c$, target = $c$emanación de 40' de radio que surge del$c$, duration = $c$instantánea$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'sacralizar';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, descriptors = $c$ácido$c$, description = $c$Disparas un pequeño orbe de ácido al objetivo. Debes tener éxito en un ataque de toque a distancia para impactarle. El orbe inflige 1d3 puntos de daño por ácido. En a$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$un proyectil de ácido$c$, duration = $c$instantánea$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'salpicadura de acido';
update spells set school = $c$Transmutacion$c$, description = $c$El receptor obtiene un bonificador +10 de mejora en sus pruebas de Saltar. El bonificador de mejora aumenta a +20 a nivel de lanzador 5.º, y a +30 (el máximo) a nivel de lanzador 9.º.

Componente material: la pata trasera de un saltamontes, que tendrás que romper al ejecutar el sortilegio. «$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estánd$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$1 min/nivel (D)$c$, saving_throw = $c$Voluntad niega (inofensivo) Rocictoria a comitiros, si$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'salto';
update spells set school = $c$Conjuración$c$, subschool = $c$curación$c$, description = $c$Este conjuro te permite canalizar energía positiva hacia una criatura para librarla de la enfermedad y las heridas. El efecto cura inmediatamente cualquiera o todas las condiciones adversas siguientes que afecten al objetivo: atontado, aturdido, ciego, confuso, daño de característica, debilidad mental, deslumbrado, enfermo, envenenado, exhausto, fatigado, indispuesto, locura, nauseado, sordo. También cura 10 puntos de daño por nivel de lanzador, hasta un máximo de 150 puntos a nivel 15.º.

Sanar no elimina niveles negativos, y no restaura niveles ni puntos de característica consumidos permanentemente. En E = [] + = [4]

Cuando se utiliza contra una criatura muerta viviente, este conjuro funciona igual que uno de dañar.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$instantanea$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'sanar';
update spells set school = $c$Conjuracion$c$, subschool = $c$curacion$c$, description = $c$Este conjuro funciona como sanar, pero sólo afecta a la montura especial del paladín (habitualmente un caballo de guerra). 110$c$, components = $c$V, S = 1 ========================================================================================================================================================$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$montura propia tocada$c$, duration = $c$instantánea$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'sanar a una montura un partura';
update spells set school = $c$Abjuración$c$, description = $c$Este conjuro asegura la intimidad. Cualquiera que mire al interior del área desde fuera sólo ve una oscura masa brumosa. La visión en la oscuridad no puede atravesarla. Ningún sonido, no importa lo estridente que sea, puede salir del área, por lo que nadie puede escuchar furtivamente desde el exterior. Los que están dentro ven con normalidad.

Los conjuros de adivinación (escudriñamiento) no pueden percibir nada en el área protegida, y los que estén en su interior son inmunes a detectar pensamientos. La custodia impide la conversación entre los que están dentro y los que estén fuera (debido a que bloquea el sonido), pero no impide otras formas de comunicación, como los conjuros de recado y cuchichear mensaje, o la comunicación telepática, como la que se da entre un amo y su familiar. Ve a milia

Este conjuro no impide que las criaturas u objetos puedan entrar o salir del área afectada. Sanctasanctórum privado de Mordenkainen puede ser hecho permanente con un conjuro de permanencia.

Componentes materiales: una delgada lámina de plomo, un trozo de cristal opaco, un fajo de algodón o de tela, y crisolita en polvo. 40 [$c$, components = $c$V, S, M$c$, casting_time = $c$10 minutos$c$, spell_range = $c$corto (25 + 5/2 niveles) ============================================================================================================================================$c$, target = $c$cubo de 30' de lado/nivel (Mo)$c$, duration = $c$24 horas (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'sanctasanctorum privado de mordenkainen';
update spells set school = $c$Allegario$c$, description = $c$Todo oponente que intente golpear (o atacar directamente del modo que sea, incluso mediante un conjuro dirigido) a la criatura custodiada por este sortilegio tendrá que realizar un TS de Voluntad. Si el tiro tiene éxito, el oponente podrá atacar a la criatura custodiada del modo normal y no resultará afectado por ese lanzamiento de santuario. Si el TS falla, el oponente no podrá concluir su ataque, perderá esa parte de su acción y no podrá atacar directamente a la criatura custodiada mientras dure el conjuro. Los que no intenten atacar al receptor no resultarán afectados. Este sortilegio no impide que la criatura custodiada sea atacada o afectada por conjuros de área o de efecto. Mientras esté protegido por el santuario, el receptor no podrá atacar sin romper el conjuro, aunque podrá lanzar conjuros no ofensivos o llevar a cabo otras acciones. Esto permite, por ejemplo, que un clérigo custodiado pueda curar heridas, bendecir, augurar, convocar criaturas, etc.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$1 asalto/nivel$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'santuario';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, descriptors = $c$fuego$c$, description = $c$Dependiendo de la versión que elijas, convertirás bellotas en armas deflagradoras que tú u otro personaje podéis tirar, o bayas de acebo en objetos incendiarios que podrás hacer explotar a una orden.

Bayas de acebo incendiarias: conviertes en objetos incendiarios hasta un máximo de ocho bavas de acebo. Estas bayas suelen colocarse manualmente, pues son demasiado ligeras para poder lanzarlas de forma eficaz (sólo llegan a 5' de distancia). Estallan en llamas cuando pronuncias su palabra de mando en un radio de 200' de ellas; se incendian al instante, causando 1 d8 puntos de daño por fuego (+1 punto por nivel de lanzador) a toda criatura en una explosión de 5', y prendiendo fuego a todo material combustible en un radio de 5'. Las criaturas que tengan éxito en su TS de Reflejos sólo sufrirán la mitad del daño.

Bellotas deflagradoras: hasta cuatro bellotas se transforman en armas deflagradoras especiales que pueden llegar lanzarse a un máximo de 100' de distancia. Para alcanzar el blanco deseado, es necesario tener éxito en una ataque de toque a distancia. Juntos, estos proyectiles son capaces de infligir un total de 1d6 puntos de daño por fuego por nivel de lanzador (máximo 20d6), que puedes dividir como desees entre las distintas bellotas. Por ejemplo, un druida de 20.º nivel podría crear un proyectil de 20d6, dos proyectiles de 10d6 cada uno, uno de 11d6 y tres de 3d6 o cualquier otra combinación con la que cuatro bellotas inflijan un total de 20d6 puntos de daño.

Cada bellota explotará nada más golpear contra una superficie dura. Además del daño normal por fuego, la explosión infligirá 1 punto de daño por salpicadura por dado e incendiará cualquier material combustible que haya en un radio de 10'. Las criaturas si-

tuadas en el área de la explosión que tengan éxito en sus TS de Reflejos sufrirán solamente la mitad del daño; las que reciban un impacto directo sufrirán siempre el daño completo, sin que se les permita un TS.

Componente material: las bellotas o las bayas de acebo.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$hasta 4 bellotas tocadas o hasta 8 bayas de acebo tocadas$c$, duration = $c$10 min/nivel o hasta ser utilizadas$c$, saving_throw = $c$ninguna o Reflejos mitad; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'semillas de fuego';
update spells set school = $c$Ilusión$c$, subschool = $c$engaño$c$, description = $c$El área afectada. Todos los sonidos desaparecerán: será imposible conversar, los conjuros con componente verbal no podrán ser lanzados y ningún T sonido surgirá del área, entrará en ella ni podrá atravesarla. El conjuro ZOO puede lanzarse en un punto en el espacio, pero el efecto se quedará quieto a no ser que se ejecute sobre un objeto móvil. El

Jozan lanza un símbolo de dolor.

conjuro puede centrarse en una criatura, en cuyo caso el efecto irrada de ella y la acompaña al desplazarse. Para negar el efecto, una criatura no voluntaria podrá realizar un TS de Voluntad o usar su RC (si la tiene). Los objetos en poder de una criatura y los objetos mágicos capaces de emitir sonido podrán intentar salvarse y usar su RC, pero los objetos desatendidos y los puntos en el espacio no tendrán derecho a ello. Este conjuro proporciona una defensa contra los ataques sónicos o dependientes del idioma, como el conjuro de orden imperiosa, el canto de las arpías, un cuerno detonante, etc.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$largo (400' + 40'/nivel)$c$, target = $c$emanación de 20' de radio, centrada en una criatura, objeto o punto en el espacio$c$, duration = $c$1 min/nivel (D)$c$, saving_throw = $c$Voluntad niega; ver texto o ninguno (objeto)$c$, spell_resistance = $c$sí; ver texto o no (objeto) Al ejecutarse este conjuro, el silencio más absoluto reinará en$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'silencio';
update spells set school = $c$Ilusión$c$, subschool = $c$engaño$c$, description = $c$Este conjuro funciona igual que disfrazarse, pero también puedes cambiar la apariencia de otras personas. Las criaturas recuperarán su aspecto normal si mueren. Ille

Los objetivos involuntarios pueden negar el efecto del conjuro mediante un TS con éxito de Voluntad o la RC. In west resident from area$c$, components = $c$V, S = 1 = 1 = 1 = 1 = 1 = 1 =$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una persona/2 niveles; dos$c$, duration = $c$12 horas (D)$c$, saving_throw = $c$Voluntad niega o Voluntad descree (si se interactúa con el conjuro)$c$, spell_resistance = $c$sí o no; ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'similitud';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Puedes hacer que de un lugar u objeto empiecen a emanar unas vibraciones mágicas capaces de atraer, según elijas, a un tipo concreto de criatura inteligente o a criaturas de un alineamiento concreto. El tipo concreto de criatura ha de nombrarse específicamente, por ejemplo, dragones rojos, gigantes de las colinas, hombres-rata, lamasu, o vampiros. Los subtipos de criatura (como "trasgoides") no son lo bastante concretos. También tendrás que nombrar el alineamiento concreto si optas por ello, por ejemplo, caótico maligno, caótico bueno, legal neutral o neutral.

Las criaturas del alineamiento o tipo concreto se sentirán eufóricas o contentas estando en el lugar elegido, o querrán tocar o poseer el objeto en cuestión. El impulso de quedarse en el lugar o tocar el objeto será abrumador. Si la salvación tiene éxito, la criatura quedará libre del encantamiento, pero tendrá que volver a salvarse 1d6×10 minutos más tarde. Si esta salvación falla, la criatura afectada intentará volver al lugar o hasta el objeto.

Simpatía contrarresta y disipa el conjuro de antivatía. Componentes materiales: perlas machacadas por valor de 1.500 po y una gota de miel.

Administration of the comments of the re-$c$, components = $c$V, S, M$c$, casting_time = $c$1 hora$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$un lugar (de hasta un cubo de 10'/nivel) o un objeto$c$, duration = $c$2 h/nivel (D)$c$, saving_throw = $c$Voluntad niega; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'simpatia';
update spells set school = $c$Ilusión$c$, subschool = $c$sombra$c$, description = $c$Este conjuro crea un doble ilusorio de cualquier criatura, que será parcialmente real pero también tendrá parte de hielo o nieve. El doble parecerá ser exactamente igual que el original, pero existirán varias diferencias: el simulacro sólo tendrá la mitad de los DG (y los correspondientes puntos de golpe, dotes, rangos de habilidades y aptitudes especiales para una criatura

de ese nivel o DG). No puedes crear un simulacro de una criatura cuyos DG excedan el doble de tu nivel de lanzador. Debes realizar una prueba de Disfrazarse cuando lances el conjuro, para determinar lo bueno que es el parecido. Una criatura familiar con el original puede detectar el engaño con una prueba de Avistar con éxito (enfrentada a la prueba de Disfrazarse del lanzador) o con una prueba de Averiguar intenciones (CD 20).

El simulacro estará bajo tu control absoluto en todo momento. Sin embargo, al no existir vínculo telepático alguno, deberás ejercer este control de alguna otra forma. El simulacro no podrá hacerse más poderoso, por lo que no puede aumentar su nivel o aptitudes. Si es reducido a 0 puntos de golpe o destruido de algún otro modo, revierte a nieve y se derrite instantáneamente sin que quede nada. Un complicado procedimiento (que exigirá, como mínimo, 24 horas de trabajo, 100 po por punto de golpe y un laboratorio mágico completamente equipado) podrá reparar el daño sufrido por el simulacro.

Componente material: el conjuro se lanza sobre el hielo o la nieve, en cuvo interior debe colocarse algún fragmento de la criatura a duplicar (cabello, uñas, etc.). Además, el conjuro requerirá polvo de rubí por valor de 100 po por DG del simulacro que se vaya a crear.

Coste en PX: 100 PX por DG del simulacro que se vaya a crear (mínimo 1.000 PX). --

A-Smininin mas$c$, components = $c$V, S, M, PX = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =$c$, casting_time = $c$12 horas$c$, spell_range = $c$0' = 10 == ==========================================================================================================================================================$c$, target = $c$una criatura duplicada$c$, duration = $c$instantánea monuscent so other$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no 1 mingree de$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'simulacro';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, description = $c$Este sirviente es una fuerza amorfa, invisible y sin mente, que realiza tareas sencillas a tus órdenes. Puede correr y buscar cosas, abrir puertas que no estén atascadas y sujetar sillas, además de limpiar y remendar. El sirviente sólo puede realizar una actividad a la vez, pero repetirá la misma una y otra vez si se lo pides, lo cual te permitirá ordenarle que barra el suelo mientras prestas atención a otras cuestiones, siempre y cuando permanezcas dentro del alcance. Sólo puede abrir puertas, cajones, tapas y demás cierres normales. Su Fuerza efectiva es 2 (sólo puede levantar 20 lb. o arrastrar 100). El sirviente puede disparar trampas y demás, pero sólo puede ejercer 20 lb. de fuerza, lo cual es insuficiente para activar ciertas placas de presión y otros aparatos similares. No puede realizar ninguna tarea que requiera una prueba de habilidad con una CD superior a 10 o que requiera una prueba de una habilidad que

no pueda usarse sin entrenamiento. Su velocidad es de 15'.

El sirviente no puede efectuar ataque alguno; nunca se le permite efectuar tiradas de ataque. No se le puede matar, pero es disipado cuando sufre 6 puntos de daño infligido por ataques de área (no tiene derecho a salvarse contra tales ataques). Si trataras de enviarlo más allá de los límites del conjuro (midiendo tu alcance desde el punto en que te encuentres en ese momento), el sirviente dejaría de existir. Componentes materiales: un cordel y una astilla de madera.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$un sirviente invisible, amorfo y sin mente$c$, duration = $c$1 h/nivel$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'sirviente invisible';
update spells set school = $c$Adivinacion$c$, description = $c$Cuando necesites conocer la situación de compañeros que puedan haberse separado, este conjuro te permitirá situar mentalmente su posición relativa y conocer su condición general. Serás consciente de la dirección y distancia a la que se encuentran las criaturas, así como de su estado: indemne, herida, incapacitada, grogui, inconsciente, moribunda, mareada, despavorida, aturdida, envenenada, enferma, confusa, etc. Una vez se ha lanzado el conjuro sobre sus receptores, la distancia entre ellos y el lanzador deja de tener importancia, siempre y cuando sigan estando en el mismo plano de existencia que el clérigo.

El conjuro terminará para aquellos receptores que se trasladen a otro plano o mueran.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$una criatura tocada/3 niveles$c$, duration = $c$1 h/nivel$c$, saving_throw = $c$Voluntad niega (inotensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'situacion';
update spells set school = $c$Thusion$c$, subschool = $c$quimera$c$, description = $c$Sonido fantasma te permite crear un volumen de sonido que se eleve, disminuya, se acerque o se quede quieto en un sitio. Debes elegir el tipo de sonido creado en el momento de ejecutar el sortilegio, y después no podrás cambiar el carácter básico del mismo. El volumen del sonido creado depende de tu nivel: podrás generar el mismo ruido que 4 humanos normales por nivel de lanzador que poseas (con un máximo equivalente a 20 humanos). Por tanto, podrás crear sonidos de charla, canto, gritos, pasos, marcha o carrera. El sonido pro-

ducido por este conjuro puede ser prácticamente de cualquier tipo, sin exceder nunca el límite de volumen. Una horda de ratas corriendo y chillando equivaldría, más o menos, al ruido de 8 humanos corriendo y gritando. El rugido de un león equivaldría al ruido de 16 humanos, mientras que el de un tigre terrible equivaldría al de 20.

Nótese que el conjuro de sonido fantasma puede incrementar la eficacia del conjuro de imagen silenciosa.

Sonido fantasma puede ser hecho permanente con un conjuro de permanencia.

Componente material: un trozo de lana y un poco de cera. I un a viv rom on Real$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$sonidos ilusorios$c$, duration = $c$1 asalto/nivel (D)$c$, saving_throw = $c$Voluntad descree (si se$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'sonido fantasma';
update spells set description = $c$Una criatura protegida por soportar los elementos no sufre daño por estar expuesta a un entorno caluroso o frío. Puede estar de manera confortable en cualquier condición entre -50 y 140 grados Fahrenheit [-10 y 60 ℃] sin tener que realizar salvaciones de Fortaleza (tal y como se describe en la Guía del Dungeon Master). El equipo de la criatura está protegido de manera similar.

Soportar los elementos no proporciona ninguna protección frente al daño por fuego o por frío, ni protege contra otros peligros del entorno, como el humo, la falta de aire, etc.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque 100 C T 10 L L C 1 G B 2 C 1 2 C 1 2 C 1 2 C 1 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1$c$, target = $c$criatura tocada$c$, duration = $c$24 horas$c$, saving_throw = $c$ninguno - no la com de si$c$, spell_resistance = $c$sí sí con cola m$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'soportar los elementos';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador, dependiente del idioma$c$, description = $c$Te permite influir en las acciones de la criatura objetivo sugiriéndole un curso de acción (limitado a una o dos frases). La sugestión debe pronunciarse de manera que la actividad suene razonable. Pedir a alguien que se clave un puñal, que se arroje sobre una lanza o que haga algo a todas luces peligroso negará automáticamente el efecto del conjuro. No obstante, sí funcionarían sugestiones como hacer creer a alguien que un estanque de ácido está lleno en realidad de agua y que un chapuzón sería muy refrescante. Otro uso razonable del conjuro sería hacer que un dragón rojo deje de atacar a tu grupo, uniéndoos todos para saquear un tesoro en algún otro lugar.

El curso de acción 'sugestionado' puede continuar hasta expirar la duración, como sucedería en el citado caso del dragón rojo. Si la acción sugerida pudiera completarse en un menor tiempo, el conjuro finalizaría en cuanto el receptor completara lo que le hubieran pedido. En lugar de esto, podrías especificar unas condiciones que desencadenen una actividad especial hasta expirar la duración. Por ejemplo, podrías sugerir a un noble que le diera su caballo de guerra al primer mendigo con que se encuentre. Si la condición no se diera antes de expirar la duración del conjuro, la actividad tampoco se llevaría a cabo.

A discreción del DM, una sugestión muy razonable hará que el TS se realice con un penalizador (como -1 o -2). 1911

Componentes materiales: una lengua de serpiente y un fragmento de panal o una gota de iarabe. Morber 10 (0) 2011 -$c$, components = $c$V, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$una criatura viva$c$, duration = $c$1 h/nivel o hasta ser completada$c$, saving_throw = $c$Voluntad niega I Taliyal$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'sugestion';
update spells set school = $c$Conjuración$c$, subschool = $c$creación$c$, description = $c$Este conjuro crea una masa, provista de numerosas capas, de hebras fuertes y pegajosas que atrapan a las criaturas con las que entran en contacto. Las hebras son similares a las que forman las telas de araña, pero mucho mayores y más gruesas. Esta masa ha de estar anclada a dos o más puntos sólidos y enteramente opuestos (suelo y techo, paredes situadas una frente a la otra, etc.), o caerá sobre sí misma y desaparecerá. Las criaturas atrapadas en el interior de la telaraña (o que simplemente la toquen) quedarán enmarañadas entre sus fibras pegajosas. Atacar a una criatura en la telaraña no hace que quedes enmarañado.

Todo el que se encuentre en el área del efecto en el momento de ejecutarse el conjuro tendrá que realizar un TS de Reflejos. Si éste tiene éxito, la criatura estará enmarañada, pero podrá moverse, aunque este movimiento será más difícil de lo habitual (ver más adelante). Si la salvación falla, la criatura quedará enmarañada y no podrá moverse de su sitio, aunque podrá liberarse dedicando a ello 1 asalto y teniendo éxito en una prueba de Fuerza (CD 20) o de Escapismo (CD 25). Una vez logre soltarse (ya sea teniendo éxito en la salvación inicial o más tarde en su prueba de Fuerza o Escapismo), una criatura podrá avanzar muy lentamente a través de la telaraña. Cada asalto dedicado a moverse permitirá a la criatura realizar una nueva prueba de Fuerza o Escapismo, pudiendo ésta desplazarse 5' por cada 5 puntos (completos, no fracciones) en que el resultado de su prueba supere 10

Si tienes al menos 5' de telaraña entre tú y tu oponente, esta te proporcionará cobertura. Si hav al menos 20' de telaraña entre ambos, la cobertura será total (consulta 'Cobertura', en la pág. 150).

Las hebras de un conjuro de telaraña son inflamables. Una espada flamígera mágica podrá cortarlas con la misma facilidad con que una mano aparta las telarañas normales. Todo fuego que actúe sobre ellas (una antorcha, aceite ardiente, una espada flamígera, etc.) podrá incendiar y quemar 5' cuadrados en 1 asalto. Todas las criaturas que estén atrapadas por las telarañas incendiadas sufrirán 2d4 puntos de daño a causa de las llamas.

Telaraña puede ser hecho permanente con un conjuro de permanencia. Una telaraña permanente que sea dañada (pero no destruida) vuelve a crecer en 10 minutos.

Componente material: un poco de tela de araña.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$telarañas en una expansión de 20' de radio$c$, duration = $c$10 min/nivel (D)$c$, saving_throw = $c$Reflejos niega; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'telarana';
update spells set school = $c$Transmutación$c$, description = $c$Te permite mover criaturas u objetos concentrándote en ellos. Dependiendo de la versión elegida, el conjuro permite generar una fuerza suave y continua, realizar una serie de maniobras de combate, o ejercer un solo golpe, corto y violento.

Empujón violento: la fuerza del conjuro puede utilizarse en un solo asalto. El efecto te permitirá empujar a una criatura u objeto por nivel de lanzador (máximo 15) que se encuentren den-

tro del alcance y a 10', como máximo, unos de otros; arrojándolos contra cualquier objetivo que se encuentre a 10'/nivel de todos los objetos movidos. Podrás arrojar de este modo un máximo de 25 lb. por nivel de conjuro (máximo 375 lb. a nivel 15.º).

Para alcanzar a tu objetivo con los objetos movidos, debes tener éxito en tiradas de ataque (una por cada criatura u objeto lanzado) usando tu ataque base + tu modificador de Inteligencia (si eres un mago) o de Carisma (si eres un hechicero). Las armas lanzadas infligirán daño normal (sin bonificador de Fuerza; ten en cuenta que las flechas y virotes causan el mismo daño que una daga de su tamaño cuando se utilizan de este modo). Otros objetos infligirán desde 1 punto de daño por cada 25 lb. de peso (en el caso de objetos poco peligrosos, como barriles) hasta 1d6 por cada 25 lb. (en el caso de objetos densos y peligrosos, como cantos rodados).

Las criaturas que no excedan la capacidad de peso del conjuro también podrán ser lanzadas, pero tendrán derecho a realizar un TS de Voluntad (y RC) para negar el efecto, igual que las criaturas cuyas posesiones intentes lanzar de este modo. Una criatura afectada que sea lanzada contra una superficie sólida sufrirá daño igual que si hubiera caído desde 10' de altura (1d6 puntos).

Fuerza continua: una fuerza continua desplaza 20' por asalto a una criatura u objeto que pese, como mucho, 25 lb. por nivel de lanzador (máximo 375 lb. a nivel 15.º). Una criatura puede negar este efecto en sí misma o en un objeto que posea teniendo éxito en su salvación de Voluntad o empleando su RC.

Esta versión del conjuro dura, como máximo, un asalto por nivel de conjuro, pero termina en cuanto dejes de concentrarte. El peso puede moverse verticalmente, horizontalmente o en ambas direcciones. Ningún objeto podrá superar tu alcance, y el conjuro terminaría si intentas llevar dicho objeto más allá. Si dejas de concentrarte por cualquier razón, el objeto caerá o se detendrá

Un objeto puede manipularse mediante telecinesía igual que si se hiciera con una mano. Por ejemplo, podrás tirar de una cuerda o una palanca, girar una llave o un objeto, etc., siempre y cuando la fuerza requerida se encuentren dentro de tu límite de peso. Incluso podrías desatar nudos sencillos, aunque las actividad delicadas de este tipo requieren una prueba de Inteligencia contra la CD que decida el DM.

Maniobras de combate: como alternativa a lo dicho, una vez por asalto puedes utilizar telecinesia para realizar una embestida, un desarme, una presa (incluyendo sujetar) o un derribo. Resuelve estos intentos de forma normal, salvo en que no provocan ataques de oportunidad, utilizas tu nivel de lanzador en lugar de tu ataque base (para los desarmes y las presas), utilizas tu modificador de Inteligencia (si eres un mago) o de Carisma (si eres un hechicero) en lugar de tu modificador de Fuerza o Destreza, y en que un intento fallido no permite un intento reactivo por parte del objetivo (como sucede en los desarmes y derribos). No se permite una salvación contra estos intentos, pero la RC sigue aplicándose del modo normal. Esta versión del conjuro dura 1 asalto por nivel del lanzador, pero termina si dejas de concentrarte.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$largo (400' + 40'/nivel) Objetivo u objetivos: ver texto$c$, duration = $c$concentración (hasta 1 asalto/nivel) o instantánea (ver texto)$c$, saving_throw = $c$Voluntad niega (objeto) o ninguno; ver texto$c$, spell_resistance = $c$sí (objeto); ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'telecinesia';
update spells set school = $c$Conjuración$c$, subschool = $c$teletransporte$c$, description = $c$Este conjuro te transporta instantáneamente hasta el lugar designado, que puede estar a un máximo de 100 millas por nivel de lanzador. No es posible el viaje entre planos. Podrás llevar contigo objetos, siempre que su peso no exceda tu carga máxima. También puedes llevar una criatura adicional voluntaria Mediana o más pequeña (que lleve equipo u objetos hasta su carga máxima) o su equivalente (ver más abajo) por cada tres niveles de lanzador. Una criatura Grande cuenta como dos criaturas Medianas, una criatura Enorme cuenta como dos Grandes, etc. Todas las criaturas que van a ser transportadas deben estar en contacto entre sí, y al menos una de ellas debe estar en contacto contigo. Al igual que sucede con todos los conjuros con alcance personal en que el objetivo seas tú, no tendrás que realizar TS ni se aplicará tu RC. Sólo los objetos asidos o utilizados (atendidos) por otra persona tendrán derecho a TS y RC.

Debes tener una idea clara del lugar de destino y su disposición. No puedes teleportarte sin más hasta la tienda del señor de la guerra si no sabes dónde está, qué aspecto tiene o qué hay en su interior. Cuanto más clara sea tu imagen mental, más posibilidades habrá de que funcione el teletransporte. Los lugares en los que haya una poderosa energía física o mágica pueden hacer que el teletransporte resulte peligroso o incluso imposible.

Para averiguar lo bien que funciona el teletransporte, lanza un d% y consulta la tabla de Teleportar. Consulta la siguiente información para interpretar las definiciones de los términos de la tabla.

Familiaridad: "Muy familiar" es un lugar en el que has estado muy a menudo y en el que te sientes como en casa. "Estudiado minuciosamente" es un lugar que conoces bien, ya sea porque lo estás viendo en ese momento, por haberlo visitado a menudo o por haber usado otros métodos para estudiarlo (como el escudriñamiento) durante al menos una hora. "Visto alguna vez" es un lugar que has visto más de una vez sin llegar a estar familiarizado con él. "Visto una vez" es un lugar que sólo has visto una vez, posiblemente mediante la magia.

"Destino falso" es un lugar que no existe en realidad; por ejemplo, si hubieras escudriñado el sanctasantórum de un enemigo pero en realidad hubieses visto el resultado de un conjuro de ofuscar videncia, o si te estás teleportando a un lugar familiar que sin embargo ya no existe o ha sido alterado tan completamente que ya no te resulta familiar (por ejemplo, una casa que se ha quemado hasta los cimientos). Al viajar a un destino falso, debes lanzar 1d20+80 en lugar del d% para obtener resultados en la tabla, pues no tendrás esperanza alguna de llegar a un destino real o aparecer siquiera lejos de él. 2790111111

En el objetivo: apareces donde querías. mo

Lejos del objetivo: apareces sano y salvo en un lugar situado a una distancia aleatoria de tu destino, en una dirección también aleatoria. La distancia hasta tu destino equivaldrá a 1d10×1d10% de la distancia que fuera a ser recorrida. Si, por ejemplo, hubieras intentado recorrer 120 millas, aparecido lejos de tu destino y obtenido unos resultados de 5 y 3 en los d10, te encontrarías a un 15% de tu objetivo, que, en este caso, equivaldría a 18 millas. El DM determinará al azar la dirección en la que apareces lanzando 1d8 y asignando el 1 al norte, el 2 al noreste, etc. Si intentaras teleportarte hasta una ciudad costera y aparecieras a 18 millas en alta mar, tendrías un verdadero problema.

Area similar: apareces en un lugar que se asemeja visual o temáticamente al que deseabas alcanzar. Un mago que intentara llegar a su laboratorio podría aparecer en el de otro mago o bien en una tienda de suministros alquímicos en la que estuvieran las mismas herramientas e instrumentos que en su laboratorio. Por lo general, aparecerás en el lugar parecido que se encuentre más cerca dentro del alcance. Si el DM determina que no existe ningún lugar así, el conjuro simplemente falla.

Percance: tú y todo aquel teleportado junto a ti la habéis "fastidiado". Cada uno de vosotros sufrirá 1d10 puntos de daño y, además, tendrás que volver a tirar en la tabla para ver dónde terminas. Al efectuar estas tiradas repetidas, debes lanzar 1d20+80. Cada vez que obtengas un nuevo "Percance", los personajes sufrirán 1d10 puntos de daño adicionales y deberás tirar de nuevo.$c$, components = $c$V I ura$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal y toque$c$, target = $c$tú y las criaturas voluntarias y objetos tocados$c$, duration = $c$instantanea$c$, saving_throw = $c$ninguno y Voluntad niega (objeto) Resistencia a conturos: no v sí (objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'teleportar';
update spells set description = $c$Este sortilegio conjura una masa de tentáculos, correosos y de color negro, cada uno de 10' de longitud. Las ondulantes extremidades parecen surgir de la tierra, el suelo o cualquier otra superficie, incluyendo el agua, y se aferran y enrollan en torno a las criaturas que entren en el área, inmovilizándolas rápidamente y aplastándolas con enorme fuerza.

Toda criatura dentro del área del conjuro debe realizar una prueba de presa, enfrentada a la prueba de presa de los tentáculos. Considera a los tentáculos que ataquen a un determinado

| Lejos del | Area | |
| | | |
| objetivo | Similar | Percance |
| 98-99 | 100 | |
| 95-97 | 98-99 | 100 |
| 89-94 | 95-98 | 99-100 |
| 77-88 | 89-96 | 97-100 |
| | 81-92 | 93-100 |

objetivo como una criatura Grande con un ataque base igual a tu nivel de lanzador y una puntuación de Fuerza de 19. Así, su modificador a las pruebas de presa será igual a tu nivel de lanzador +8. Los tentáculos son inmunes a todos los tipos de daño.

Una vez que los tentáculos apresan a un oponente, realizan una prueba de presa cada asalto durante tu turno para infligir 1d6+4 puntos de daño contundente. Los tentáculos continúan aplastando a los oponentes hasta que termina el conjuro o la víctima escapa.

Cualquier criatura que entre en el área del conjuro es atacada inmediatamente por los tentáculos. Incluso las criaturas que no estén apresadas sólo podrán moverse a la mitad de su velocidad mientras atraviesen el área.

Componente material: un fragmento de tentáculo de un pulpo o calamar gigante.$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel) =======================================================================================================================================$c$, target = $c$expansión de 20' de radio a comento de a$c$, duration = $c$1 asalto/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'tentaculos negros de evard';
update spells set school = $c$Ilusión$c$, subschool = $c$engaño$c$, description = $c$Haces que un terreno natural parezca, suene y huela como otro tipo de terreno natural. Por

tanto, puedes hacer que un campo abierto o un camino parezca un pantano, una colina, una grieta o cualquier otro terreno intransitable. Puedes hacer que un estanque parezca un prado cubierto de hierba, que un precipicio parezca una suave pendiente o que un barranco cubierto de rocas parezca un camino, ancho y allanado. La apariencia de las construcciones, equipo y criaturas que haya en el área no será disimulada por el conjuro.

Componente material: una piedra, una ramita y un fragmento de una planta de color verde.$c$, components = $c$V, S, M$c$, casting_time = $c$10 minutos$c$, spell_range = $c$largo (400' + 40'/nivel) = 10 ==$c$, target = $c$un cubo de 30'/nivel (Mo)$c$, duration = $c$2 h/nivel (D) 0-1784- 111$c$, saving_throw = $c$Voluntad descree (si se interactúa con el conjuro) en la con$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'terreno alucinatorio';
update spells set school = $c$Evocación$c$, descriptors = $c$tierra$c$, description = $c$Cuando lanzas un conjuro de terremoto, un temblor intenso pero localizado desgarra la tierra. haciendo caer a las criaturas, derrumbando edificios, abriendo grietas en el suelo y mucho más. El temblor dura 1 asalto, tiempo durante el cual las criaturas que estén sobre el suelo no podrán moverse ni atacar. Los lanzadores de conjuros que estén sobre el suelo deberán realizar pruebas de Concentración (CD 20 + el nivel del conjuro) o perderán el conjuro que intenten ejecutar. El terremoto afecta a todo lo que haya en su área (tierra, vegetación, edificios, criaturas, etc.). Los efectos exactos dependerán del tipo de terreno en que sea lanzado:

Cueva, caverna o túnel: el conjuro derrumbará el techo, infligiendo 8d6 puntos de daño contundente a toda criatura a la que atrape bajo el peso (Reflejos CD 15 mitad), y dejándola atrapada bajo los escombros (ver más adelante). Si el sortilegio se lanzara sobre el techo de una gran caverna, incluso las criaturas que hubiera fuera de su área correrían peligro por culpa de la caída de escombros.

Precipicio: éste se desmoronaría, provocando un desprendimiento de tierras que avanzaría horizontalmente la misma distancia que hubiera caído verticalmente. Un terremoto lanzado desde lo alto de un barranco de 100' de altura produciría un desprendimiento que llegaría hasta 100' de la base de éste. Toda criatura que se encuentre en el camino del desprendimiento sufrirá 8d6 puntos de daño (Reflejos mitad CD 15) y quedará atrapada bajo los escombros (ver más adelante).

Campo abierto: todas las criaturas que se encuentren en el área deberán realizar un TS de Reflejos (CD 15) para evitar caer. En el suelo se abrirán varias grietas y toda criatura sobre él tendrá un 25% de posibilidades de caer en una (Reflejos CD 20 para apartarse de la grieta). Al finalizar el conjuro, todas las grietas se cerrarán matando a las criaturas atrapadas en su interior.

Edificio: todos los edificios que estén en campo abierto recibirán 100 puntos de daño, lo cual es suficiente para derrumbar una construcción normal de madera o mampostería, pero no un edificio hecho de roca o reforzado. La dureza no reduce este daño, ni se reduce a la mitad, como suele hacerse con el daño infligido a los objetos (consulta la Guía del Dungeon Master para información sobre los puntos de golpes sobre muros y otras estructuras). Cualquier criatura atrapada dentro de un edificio que se derrumbe sufre 8d6 puntos de daño (Reflejos CD 15 mitad) y queda atrapada bajo los escombros (ver más ade ante).

Río, lago o pantano: varias grietas se abrirán bajo el agua, haciendo que ésta se filtre bajo tierra y deje tras de sí un suelo lleno de fango. Los pantanos y marismas se convertirán en arenas movedizas mientras dure el conjuro, tragándose tanto criaturas como edificios. Las criaturas tendrán derecho a un TS de Reflejos (CD 15) para evitar hundirse en el fango y las arenas movedizas. Al finalizar el conjuro, el resto de la masa de agua volverá a ocupar el lugar en que estaba antes de filtrarse, pudiendo ahogar a quienes queden atrapados en el fango.

Atrapado bajo los escombros: cualquier criatura sujeta bajo los escombros recibe 1d6 puntos de daño no letal por minuto que pase en ese estado. Si un personaje sujeto queda inconsciente, debe realizar una prueba de Constitución a CD 15 o recibir 1d6 puntos de daño letal cada minuto subsiguiente, hasta que sea liberado o muera. - Alaxis

Terribles carcajadas de Tasha Encantamiento (compulsión) [enajenador] Nivel: Brd 1, Hcr/Mag 2 | | | | | | | | | | | Componentes: V, S, Mala moticylat shi Tiempo de lanzamiento: 1 acción estándar Alcance: corto (25' + 5'/2 niveles) Objetivo: una criatura; ver texto Duración: 1 asalto/nivel Tiro de salvación: Voluntad niega Resistencia a conjuros: sí

Este conjuro contagia una risa incontrolable al receptor, que caerá al suelo (quedando tumbado) entre risotadas histéricas. El objetivo no puede llevar a cabo acción alguna mientras se esté riendo, pero no se le considera indefenso. Al finalizar el conjuro, podrá actuar con normalidad.

Las criaturas con 2 o menos en Inteligencia no resultarán afectadas. Una criatura que sea de tipo diferente al del lanzador (como humanoide o dragón) obtendrá un bonificador +4 en su TS, ya que el humor no siempre se consigue "traducir".

Componente material: unas tartas diminutas que se lanzan contra el objetivo y una pluma que ha de agitarse en el aire.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$largo (400' + 40'/nivel)$c$, target = $c$expansión de 80' de radio (Mo)$c$, duration = $c$1 asalto$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'terremoto';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Con un toque, reduces las facultades mentales del objetivo. Un ataque de toque en cuerpo a cuerpo con éxito aplica un penalizador de 1d6 a la Inteligencia, Sabiduría y Carisma del Objetivo. Este penalizador no puede reducir ninguna de estas puntuaciones por debajo de 1.

El efecto de este conjuro puede hacer imposible para el objetivo lanzar algunos o todos sus conjuros, si el valor de la característica requisito cae por debajo del mínimo requerido para lanzar un coniuro de ese nivel.

Toque de necrófago Nigromancia Nivel: Hcr/Mag 2 Componentes: V, S, M Tiempo de lanzamiento: 1 acción estándar Alcance: toque Objetivo: humanoide vivo tocado Duración: 1d6+2 asaltos ====================================================================================================================================================== Tiro de salvación: Fortaleza niega Resistencia a conjuros: sí

Infundiéndote energía negativa, este conjuro te permite paralizar a un solo humanoide vivo durante la duración del conjuro si logras tener éxito en un ataque de toque en cuerpo a cuerpo. Además, el receptor paralizado exudará un hedor a carroña que dejará indispuestas (Fortaleza niega) a todas las criaturas vivas (salvo tú) en una expansión de 10' de radio. Un neutralizar veneno elimina el efecto de una criatura indispuesta, y una criatura inmune al veneno no resultará afectada por el hedor.

Componente material: un jirón de ropa vestida por un necrófago o un poco de tierra tomada de la guarida de una de esas criaturas.

Toque gélido Nigromancia Nivel: Hcr/Mag 1 Componentes: V, S Tiempo de lanzamiento: 1 acción estándar Alcance: toque a police Objetivos: criatura o criaturas tocadas (hasta 1/nivel) Duración: instantánea Tiro de salvación: Fortaleza parcial o Voluntad niega; ver texto = orzilled dis Resistencia a conjuros: sí

Un toque de tu mano, que brillará con una energía azulada, causará una perturbación en la fuerza vital de las criaturas vivas. Cada uno de tus toques canaliza energía negativa por valor de 1d6 puntos de daño. La criatura tocada también recibe 1 punto de daño temporal en Fuerza salvo que tenga éxito en un TS de Fortaleza. Puedes usar este ataque de toque en cuerpo a cuerpo un máximo de veces igual a tu nivel.

Una criatura muerta viviente a las que toques no sufrirá daño de ningún tipo, pero deberá realizar un TS de Voluntad o huirá despavorida durante 1d4 asaltos + 1 asalto por nivel de lanzador.

Toque vampírico Nigromancia Nivel: Hcr/Mag 3$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura viva tocada$c$, duration = $c$10 min/nivel$c$, saving_throw = $c$no$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'toque de idiotez';
update spells set school = $c$Evocacion$c$, descriptors = $c$aire$c$, description = $c$Este conjuro crea un poderoso ciclón que se mueve por el aire, a lo largo del suelo o sobre el agua a una velocidad de 60' por asalto. Podrás concentrarte en controlar cada movimiento del ciclón o bien especificar una sencilla secuencia, como avanzar en línea recta, zigzagueando, en círculo, etc. Dirigir el movimiento del ciclón o cambiar su secuencia supondrá una acción estándar para ti. El torbellino siempre se moverá durante tu turno. Si el ciclón llega a superar el alcance del conjuro, se moverá sin control durante 1d3 asaltos en una dirección al azar (puede que incluso poniéndoos en peligro a ti o a tus aliados) y, a continuación, se disipará (no podrás recuperar el control sobre él ni aunque vuelva a estar dentro de tu alcance).

Toda criatura Grande o menor que entre en contacto con el torbellino debe tener éxito en su salvación de Reflejos o sufrirá 3d6 puntos de daño. Las criaturas Medianas o menores que fallen su primer TS deberán tener éxito en un segundo tiro o será atrapados por el torbellino y arrastrados por los fuertes vientos, sufriendo 1d8 puntos de daño cada asalto en tu turno sin TS que valga. Puedes dirigir el ciclón para que libere a las criaturas en el momento que desees, dejándolas allá donde se encuentre el efecto en el momento de liberarlas.

Tormenta de aquanieve Coniuración (creación) [frío]

Nivel: Drd 3, Hcr/Mag 3

Componentes: V, S, M/FD Tiempo de lanzamiento: 1 acción a co estándar Alcance: largo (400' + 40'/nivel) = 40'/nivel) = 11

Efecto: cilindro (40' de radio, 20' de altura) Duración: 1 asalto/nivel - 1 - 1 - 1 Javil Tiro de salvación: ninguno Resistencia a conjuros: no el 1 3 - 1

El aguanieve del conjuro bloquea la visión (incluso la visión en la oscuridad) en el interior de su área de efecto y hace que el suelo de esa zona se congele. Una criatura puede caminar dentro o a través de la zona de aguanieve a la mitad de su velocidad normal con una prueba de Equilibrio (CD 10). El fallo implica que no puede moverse en ese asalto, y si falla por 5 o más, se caerá (consulta la habilidad de Equilibrio para los detalles).

El aguanieve apagará antorchas y fogatas. Componentes materiales arcanos: una pizca de polvo y unas gotas de agua. A a popula a l

a striam more concerner and

Schooler Ho$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estandar$c$, spell_range = $c$largo (400' + 40'/nivel)$c$, target = $c$ciclón de 10' de ancho en la base, 30 de ancho en la cúspide y 30' de alto$c$, duration = $c$1 asalto/nivel (D)$c$, saving_throw = $c$Reflejos niega; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'torbellino';
update spells set school = $c$Evocación$c$, descriptors = $c$fuego$c$, description = $c$Cuando se lanza un conjuro de tormenta de fuego, toda el área del conjuro queda cubierta por una cortina de llamas crepitantes. Las llamas abrasadoras no harán ningún daño a la vegetación natural, al mantillo ni a las criaturas vegetales del área, si así lo deseas. Las demás criaturas (y los vegetales a las que desees afectar) dentro del área sufrirán 1d6 de daño por fuego por nivel de lanzador (máximo 20d6).$c$, components = $c$V, S = = = = = = = = = = = = = = = = = = = = = = = = =$c$, casting_time = $c$1 asalto$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$dos cubos de 10'/nivel (Mo) mon mi non$c$, duration = $c$instantánea$c$, saving_throw = $c$Reflejos mitad$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'tormenta de fuego la los mullosos';
update spells set school = $c$Evocación$c$, descriptors = $c$frío$c$, description = $c$Unos enormes granizos mágicos caen durante 1 asalto completo, infligiendo 3d6 puntos de daño contundente y 2d6 puntos de daño por frío a todas las criaturas en el área. Dentro del efecto de la tormenta de hielo se aplica un penalizador -4 a las pruebas de Escuchar, y todo el movimiento se realiza a la mitad de la velocidad. Al final de la duración, el granizo desaparece, sin dejar ningún efecto secundario (salvo el daño infligido).

Componentes materiales arcanos: una pizca de polvo y unas cuantas gotas de agua. -

| ormenta de venganza | |
| |--|
| Conjuración (convocación) | |
| Nivel: Clr 9, Drd 9 | |
| Componentes: V, S | |
| Tiempo de lanzamiento: 1 asalto | |
| Alcance: largo (400 + 40'/nivel) | |
| Efecto: nube de tormenta de 360' de radio | |
| Duración: concentración (maximo 10 | |
| asaltos) (D) | |
| Tiro de salvación: ver texto | |
| Resistencia a conjuros: sí | |

Este conjuro crea una enorme nube negra de tormenta, en cuyo interior se generarán rayos y truenos. Toda criatura que se encuentre bajo la nube deberá tener éxito en un TS de Fortaleza o quedará ensordecida durante 1d4y10 minutos.

El conjuro finalizará si, una vez ejecutado, dejas de concentrarte en él. Si continuas concentrándote, el sortilegio generará efectos adicionales en los asaltos subsiguientes (tal y como se indica más abajo). Todo efecto generado tendrá lugar durante tu turno.

Segundo asalto: una lluvia ácida cae sobre el área, infligiendo 1d6 puntos de daño por ácido. No se permite salvación.

Tercer asalto: haces que la nube descargue 6 rayos, pudiendo decidir dónde golpea cada uno. Dos rayos no pueden dirigirse al mismo objetivo. Cada uno infligirá 10d6 de daño por electricidad. Las criaturas alcanzadas pueden realizar un TS de Reflejos para sufrir la mitad del daño. In luces

Cuarto asalto: una granizada cae sobre el área, infligiendo 5d6 puntos de daño (no se permite salvación).

Asaltos quinto al décimo: la intensa lluvia y las fuertes ráfagas de viendo reducen la visibilidad. La lluvia obstaculiza la visión, incluida la visión en la oscuridad, más allá de 5'. Las criaturas que estén a 5' o menos de quien mire dispondrán de ocultación (los ataques contra ellas tendrán un 20% de posibilidad de fallo). Las criaturas que estén más allá de esa distancia tendrán ocultación total (50% de posibilidad de fallo y además quienes les ataquen no podrán usar la vista para localizarlas). La velocidad quedará reducida a 3/4. Dentro del área de la tormenta será imposible efectuar ataques a distancia. Los sortilegios que se intenten ejecutar bajo la tormenta quedarán interrumpidos a no ser que el lanzador tenga éxito en una tirada de Concentración contra una CD igual a la salvación de la tormenta de venganza + el nivel del conjuro que esté intentando lanzar.$c$, components = $c$V, S, M/FD ======================================================================================================================================================$c$, casting_time = $c$1 acción la contram estándar$c$, spell_range = $c$largo (400' + 40'/nivel) = = = = = = = = = = = =$c$, target = $c$cilindro (20' de radio, 40' de altura)$c$, duration = $c$1 asalto completo$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí Tranum n$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'tormenta de hielo';
update spells set school = $c$Abjuración$c$, description = $c$Este conjuro bloquea mágicamente una entrada (puerta, portal, ventana o contraventana) construida de madera, metal o piedra. La magia mantiene la entrada como si estuviera asegurada y cerrada con llave. Un conjuro de apertura o un disipar magia con éxito pueden negar el sortilegio de trabar portal. Añade 5 a la CD normal para forzar un portal afectado por este conjuro.

STATE CONSULTION COLLECTION COLLECTION COLLECTION COLLECTION COLLECTION COLLECTION COLLECTION COLLECTION COLLECTION COLLECTION COLLECTION CONTRACTOR COLLECTION CONTRACTOR COL$c$, components = $c$V$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$un portal, de hasta 20' Lasta 20' cuadrados/nivel$c$, duration = $c$1 min/nivel (D)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'trabar portal';
update spells set school = $c$Abjuración$c$, descriptors = $c$fuego$c$, description = $c$Este conjuro genera una ardiente explosión cuando alguien abre el objeto custodiado por la trampa. Una trampa de fuego puede proteger cualquier objeto que pueda cerrarse (arcón, ataúd, botella, caja, cajón, cofre, libro, puerta, etc.).

Al ejecutar una trampa de fuego, debes elegir un punto del objeto como centro del conjuro. Cuando alguien que no seas tú abra el objeto, una ardiente explosión invadirá un área de 5' de radio en torno al centro del conjuro. Las llamas infligirán 1d4 puntos de daño por fuego, +1 punto adicional por nivel de lanzador (máximo +20). El objeto protegido por la trampa no resultará afectado por esta explosión.

Un objeto con una trampa de fuego no puede portar un segundo conjuro de cierre o custodia. El sortilegio de apertura no afecta en absoluto a una trampa de fuego. Un disipar magia fallido no provocará la detonación de este conjuro protector.

Bajo el agua, este conjuro inflige la mitad de daño y genera una gran nube de vapor.

Como lanzador, podrás usar el objeto portador de la trampa sin temor a dispararla, igual que sucederá con un individuo que ajustes específicamente al conjuro en el momento de lanzarlo. "Ajustar" una trampa de fuego a un individuo suele implicar la utilización de una contraseña que puedes compartir con tus amigos.

Nota: las trampas mágicas, como la trampa de fuego, son difíciles de detectar e inutilizar. Un pícaro (y sólo un pícaro) puede usar la habilidad de Buscar para encontrar las runas y la de Inutilizar mecanismo para desbaratarlas. En ambos casos, la CD será 25 + el nivel de conjuro (CD 27 para la trampa de fuego druídica y CD 29 para la versión arcana).

Componente material: media libra de polvo de oro (coste de 25 po) que ha de espolvorearse sobre el objeto custodiado.$c$, components = $c$V, S, M$c$, casting_time = $c$10 minutos$c$, spell_range = $c$toque$c$, target = $c$objeto tocado$c$, duration = $c$permanente hasta ser descargada (D)$c$, saving_throw = $c$Reflejos mitad; ver texto Resistencia a cominros ei$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'trampa de fuego';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Tus fascinantes movimientos y música (o canciones, cánticos, etc.) obligan a los animales y bestias mágicas a no hacer otra cosa que observarte. Sólo las criaturas con Inteligencia 1 ó 2 resultarán afectadas por este conjuro. Lanza 2d6 para determinar la cantidad total de DG de criaturas a las que fascinas. Los objetivos más cercanos se convertirán en los primeros receptores hasta que no se pueda afectar a más criaturas situadas dentro del alcance. Por ejemplo, si Vadania pudiera afectar a 7 DG de animales y hubiera varios lobos de 2 DG a su alcance, sólo los tres más cercanos a ella experimentarían el trance.

Los animales entrenados para atacar o guardar, los animales terribles y las bestias mágicas tendrán derecho a realizar TS; los animales no adiestrados para el ataque o la vigilancia no podrán realizarlos.

| l ransformación de Tenser |
| |
| Transmutacion |
| Nivel: Hct/Mag 6 |
| Componentes: V, S, M |
| Tiempo de lanzamiento: 1 acción estándar |
| Alcance: personal |
| Objetivo: tú |
| Duración: 1 asalto/nivel |
| |

Este conjuro te convierte en una máquina de combate, haciéndote más fuerte, más resistente, más rápido y más hábil en la lucha. Tu mentalidad cambia, permitiéndote disfrutar del combate e impidiéndote lanzar conjuros, incluyendo los ejecutados desde objetos mágicos.

Obtienes un bonificador +4 de mejora a Fuerza, Destreza y Constitución, un bonificador +4 de armadura natural a la CA, un bonificador +5 de competencia en las salvaciones de Fortaleza, y competencia con todas las armas simples y marciales. Tu ataque base será igual a tu nivel de personaje (lo cual puede concederte ataques múltiples).

Pierdes tu aptitud para el lanzamiento de conjuros, incluyendo tu aptitud para utilizar objetos mágicos de activación de conjuro o de finalización de conjuro, tal y como si los conjuros ya no estuviesen en tu lista de clase.

Componente material: una poción de fuerza de toro que tendrás que ingerir (y cuyos efectos serán subsumidos por los del propio conjuro).$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$animales o bestias mágicas de Inteligencia 1 ó 2$c$, duration = $c$concentración$c$, saving_throw = $c$Voluntad niega; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'trance animal';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro te permite dar a un fragmento de madera existente la forma que se ajuste a tus necesidades. Por ejemplo, podrías fabricar un arma de madera, diseñar una trampilla especial o esculpir un tosco ídolo. Este conjuro también te permite cambiar la forma de una puerta de madera para crear una salida donde no hubiera una o condenar la puerta en cuestión. Aunque es posible construir toscos cofres, puertas, etc., el sortilegio no permite obtener detalles finos. Toda forma que incluya partes móviles tendrá un 30% de posibilidades de no funcionar.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$un trozo de madera tocado que no supere 10' cúbicos + 1 pie cúbico/nivel$c$, duration = $c$instantánea$c$, saving_throw = $c$Voluntad niega (objeto)$c$, spell_resistance = $c$sí (objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'transformar madera';
update spells set school = $c$Transmutación$c$, descriptors = $c$tierra$c$, description = $c$Al ejecutar este sortilegio, colocas tu alma en el interior de un receptáculo especial (una gema o un gran cristal) y dejas tu cuerpo exánime. A continuación, puedes intentar apoderarte de un cuerpo cercano (por medio de un intercambio conocido como "transmigración"), obligando a su alma a meterse en el citado receptáculo. El efecto también te permite volver al receptáculo (devolviendo el alma atrapada a su cuerpo) e intentar poseer a otra criatura. El conjuro finalizará cuando envíes tu alma de vuelta hasta tu propio cuerpo (dejando vacío el receptáculo).

Para lanzar el conjuro, el receptáculo debe estar dentro del alcance y debes saber en qué lugar se halla (aunque no necesitarás tener línea de visión hasta él). Una vez ejecutado el conjuro y llevada a cabo la transmigración de tu alma, tu cuerpo estará muerto a ojos de todo el que lo observe.

Mientras estés en el receptáculo, podrás presentir y atacar a toda fuerza vital que haya en un radio de 10' por nivel de lanzador (siempre y cuando se encuentre en el mismo plano que tú). No necesitarás que haya una línea de efecto entre el receptáculo y tales criaturas. Sin embargo, no podrás saber de qué tipo son las criaturas o cuál es su posición exacta. Si se tratara de un grupo de fuerzas vitales, podrás discernir diferencias de 4 DG o más y saber si están hechas de energía positiva o negativa (los muertos vivientes son impulsados por energía negativa, y de ellos sólo los inteligentes tienen, o son, almas).

Por ejemplo, si dos personajes de 10.º nivel estuvieran atacando a un gigante de las colinas (12 DG) y cuatro ogros (4 DG), sabrías que dentro de tu alcance hay tres fuerzas vitales más potentes y otras cuatro más débiles, todas ellas hechas de energía positiva. Podrías intentar apoderarte de una criatura potente o de una débil, pero, una vez te decidieras por un grupo u otro, la criatura concreta a la que poseyeras sería determinada al azar.

Intentar poseer un cuerpo es una acción de asalto completo que sería bloqueada por un conjuro de protección contra el mal u otra custodia similar. Al apoderarte de un cuerpo ajeno, encierras el alma de la criatura en cuestión dentro del receptáculo, siempre y cuando el recep-

tor falle su TS de Voluntad. Si fracasas en el intento de poseer un cuerpo, tu fuerza vital se queda dentro del receptáculo y la víctima tendrá éxito de forma automática en los posteriores TS si intentas poseerla de nuevo.

Si tienes éxito, tu fuerza vital pasa a ocupar el cuerpo del (involuntario) anfitrión y la fuerza vital de este queda encerrada en el receptáculo. Al poseer el cuerpo de otro, conservas tu clase, nivel, Inteligencia, Sabiduría, Carisma, ataque base, salvaciones base, alineamiento y aptitudes mentales; el cuerpo conserva su Fuerza, Destreza, Constitución, pg, aptitudes naturales y aptitudes automáticas. Por ejemplo, el cuerpo de un pez respira bajo el agua y el de un troll regenera. Un cuerpo con más extremidades no te permite hacer más ataques (o tener más ventajas de ataques con dos armas). No puedes optar por activar las aptitudes extraordinarias o sobrenaturales de ese cuerpo. Los conjuros y aptitudes sortílegas de una criatura no se quedan en su cuerpo.

Usando una acción estándar, puedes "saltar" libremente del huésped hasta el receptáculo (siempre que esté dentro del alcance), devolviendo a su cuerpo el alma atrapada. El conjuro finaliza al enviar tu alma desde el receptáculo hasta tu propio cuerpo.

Si el cuerpo del huésped muere, vuelves al receptáculo (siempre que esté dentro del alcance) y el alma del huésped se marchará (es decir, que morirá). Si el cuerpo del hospedador muere más allá del alcance del conjuro, moriréis tanto tú como el huésped. Toda fuerza vital que no tenga dónde ir se considerará muerta.

Si el conjuro termina mientras estás dentro del receptáculo, volverás inmediatamente a tu cuerpo (o morirás, si éste se halla más allá del alcance del conjuro o ha sido destruido). Si el conjuro finaliza mientras estás en el cuerpo de un huésped, volverás directamente a tu cuerpo (o morirás, si éste se halla fuera del alcance desde tu posición actual) y el alma del huésped regresará al suyo desde el receptáculo (o morirá, si está más allá del alcance). Destruir el receptáculo pondrá fin al sortilegio, que puede ser disipado tanto desde el receptáculo como desde el huésped.

Foco: un cristal o una gema valoradas en un mínimo de 100 po.

Transmutar barro en roca Transmutación [tierra] Nivel: Drd 5, Hcr/Mag 5 Componentes: V, S, M/FD Tiempo de lanzamiento: 1 acción estándar Alcance: intermedio (100' + 10'/nivel) Área: hasta dos cubos de 10'/nivel (Mo) Duración: permanente Tiro de salvación: ver texto Resistencia a coniuros: no

Este conjuro transforma permanentemente el barro normal o las arenas movedizas de cualquier profundidad en piedra blanda (arenisca u otro mineral similar). Las criaturas que se encuentren en el barro tendra derecho a un TS de Reflejos para escapar antes de que el área se endurezca y convierta en piedra.

- Transmutar barro en roca contrarresta y disipa el conjuro de transmutar roca en barro.
- Componente material arcano: arena, cal y agua.

| Transmutar metal en madera |
| |
| Transmutacion |
| Nivel: Drd 7 |
| Componentes: V, S, FD |
| Tiempo de lanzamiento: 1 acción estándar |
| Alcance: largo (400' + 40'/nivel) |
| Area: todos los objetos metálicos en una |
| explosion de 40' de radio |
| Duración: instantanea |
| Tiro de salvación: ninguno |
| Resistencia a conjuros: sí (objeto; ver texto) |

Este conjuro te permite transformar en madera todos los objetos metálicos del área. Las armas, armaduras y demás objetos metálicos portados por criaturas también resultarán afectados. Contra este sortilegio, los objetos mágicos hechos de metal tendrán una RC efectiva de 20 + su nivel de lanzador. Los artefactos no podrán ser transmutados. Las armas transformadas de metal en madera sufrirán un penalizador -2 en todas sus tiradas de ataque y daño. Las armaduras metálicas que pasen a ser de madera perderán 2 puntos de bonificador a la CA. Las armas transformadas se astillarán y romperán con todo resultado natural de 1 ó 2 y las armaduras afectadas por el conjuro perderán 1 punto adicional de bonificador a la CA con todo resultado natural de 19 ó 20 en una tirada de ataque contra ellas.

Sólo un deseo, un deseo limitado, un milagro u otro efecto similar podrá devolver un objeto transformado a su estado metálico. De no ser así, una puerta metálica transformada en madera seguirá siendo de madera para siempre.$c$, components = $c$V, S, M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$piedra u objeto de piedra tocado, de hasta 10' cúbicos +1 pie cúbico/nivel$c$, duration = $c$instantanea$c$, saving_throw = $c$ninguno Rocistencia 2 comunitos, no$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'transformar piedra';
update spells set description = $c$Este conjuro transforma todo tipo de piedra natural (sin cortar ni trabajar) en un volumen equivalente de barro. Si, por ejemplo, el coniuro se lanza sobre un canto rodado, este se deshará en lodo. La piedra mágica o encantada no resulta afectada por este conjuro y la profundidad del barro creado no puede superar los 10'. Las criaturas incapaces de levitar, volar o librarse del barro de alguna otra forma se hundirán hasta la altura de la cadera o del pecho, quedando su velocidad reducida a 5' y sufriendo sendos penalizadores -2 en las tiradas de ataque y la CA. La maleza que se lance

sobre el barro podrá soportar a las criaturas capaces de trepar por ella. Las criaturas lo bastante grandes como para llegar hasta el fondo podrán caminar por el barro a una velocidad de 5

Si el conjuro es lanzado sobre el techo de una caverna o túnel, el barro caerá al suelo y se expandirá hasta crear un charco de 5' de profundidad. Por ejemplo, un lanzador de 10.º nivel puede transformar 20 cubos de 10' de lado en barro. Al caer al suelo, este barro cubriría un área de 40 cubos de 10' de lado hasta una profundidad de 5'. La caída del barro y el hundimiento resultante infligirán 8d6 puntos de daño contundente a todo el que se encuentre directamente debajo del área, o bien la mitad del daño a quien tenga éxito en su salvación de Reflejos.

Por lo general, los castillos y edificios grandes de piedra son inmunes a los efectos de este conjuro, pues éste no puede afectar a la roca trabajada y no alcanza la profundidad necesaria como para socavar los cimientos de la construcción. Sin embargo, las construcciones o edificios pequeños suelen descansar sobre cimientos poco profundos que podrían resultar dañados o quedar parcialmente derruidos por culpa de este sortilegio.

El barro permanecerá hasta que le sea devuelta su sustancia normal (pero no necesariamente su forma) por medio de un disipar magia con éxito o un transmutar barro en roca. La evaporación transformará el barro en tierra normal y corriente con el paso de los días, aunque el tiempo exacto dependerá de la exposición al sol, el viento o la desecación normal. Componente material arcano: arcilla y agua.

Trepar cual arácnido Transmutación Nivel: Drd 2, Hcr/Mag 2 Componentes: V, S, M | | | | | | Tiempo de lanzamiento: 1 acción estándar Alcance: toque Objetivo: criatura tocada Duración: 10 min/nivel Tiro de salvación: Voluntad niega | | | | | (inofensivo) Resistencia a conjuros: sí (inofensivo)

El receptor podrá escalar y recorrer superficies verticales, e incluso moverse por el techo, igual que si fuera una araña. La criatura afectada deberá tener las manos libres para poder escalar de este modo, obteniendo una velocidad de trepar de 20; además, no necesita realizar pruebas de Trepar para cruzar una superficie vertical u horizontal (ni siquiera boca abajo). Una criatura que trepe cual arácnido retiene su bonificador de Destreza a la CA (en caso de tenerlo) al trepar, y sus oponentes no reciben bonificadores especiales a sus ataques contra él. No obstante, no puede utilizar la acción de correr mientras esté trepando.

Componentes materiales: una gota de betún y una araña viva (que deberán ser ingeridos por el receptor del conjuro).

Tromba de meteoritos

| Evocación [fuego] |
| |
| Nivel: Hcr/Mag 9 |
| Componentes: V, S |
| Tiempo de lanzamiento: 1 acción estándar |
| Alcance: largo (400' + 40'/nivel) |
| Area: cuatro expansiones de 40' de radio; ver |
| texto |
| Duración: instantanea |
| Tiro de salvación: ninguno o Reflejos mitad; |
| ver texto |
| Dacictancia a comunero. ci |

La tromba de meteoritos es un conjuro, muy poderoso y espectacular, que se parece al de bola de fuego en muchos aspectos. Al lanzarlo, cuatro esferas de 2' de diámetro surgen de tu mano extendida y avanzan en línea recta hasta el punto elegido. Los meteoritos esféricos dejan tras de sí un rastro de chispas ardientes.

Si apuntas una esfera a una criatura concreta, debes realizar un ataque de toque a distancia para impactarla con el meteorito. Cualquier criatura golpeada por estas esferas sufre 2d6 puntos de daño contundente (sin salvación) y no tiene derecho a un TS contra el daño por fuego de la esfera (ver más adelante). Si una esfera dirigida a un objetivo falla, simplemente explota en la esquina más próxima del espacio del blanco. Puede apuntar más de un meteorito al mismo objetivo.

Una vez que una esfera ha llegado a su destino, explota en una expansión de 40' de radio, infligiendo 6d6 puntos de daño por fuego a cada criatura en la zona. Si una criatura está dentro del área de más de una esfera, debe realizar salvaciones separadas para cada una (la resistencia al fuego se aplica al daño individual de cada esfera). I a le mont my more uning

barrante with wells af and

Truco de la cuerda plana asgraina Transmutación Nivel: Hcr/Mag 2 - 10 al Componentes: V, S, M = = = = = = = = = = Tiempo de lanzamiento: 1 acción estándar a mint - de sesmentaba Alcance: toque a come disibili Objetivo: fragmento de cuerda tocado, de entre 5 y 30' de longitud ( 1 1 1 1 1 1 1 Duración: 1 h/nivel (D) ant Propertie Tiro de salvación: ninguno | | | | | Resistencia a conjuros: no 11 =

Cuando este conjuro se lanza sobre un fragmento de cuerda de entre 5 y 30' de longitud, uno de sus extremos se eleva en el aire hasta que la cuerda cuelga completamente perpendicular al suelo, como si estuviera sujeta por el extremo superior. De hecho, su extremo superior está sujeto a un espacio de otra dimensión, ajeno al multiverso de espacios extradimensionales ("planos"). Las criaturas en el espacio extradimensional están escondidas, más allá del alcance de los conjuros (adivinaciones incluidas), a no ser que los conjuros funcionen a través de los planos. El espacio contendrá hasta 8 criaturas de cualquier tamaño); las criaturas en el espacio extradimensional pueden tirar de la cuerda hacia sí, haciéndola "desaparecer" (en tal caso, la cuerda cuenta como una de las 8 criaturas que caben en el espacio). La cuerda resistirá un peso de hasta 16.000 lb .; una fuerza mayor puede hacer que la cuerda se desprenda.

El vínculo entre dimensiones no podrá ser atravesado por conjuros ni por efectos de área, pero los que se encuentren en el espacio extradimensional podrán ver a través de él como si fuera una ventana de 3'x5' con la cuerda situada en su centro. La ventana está presente en el plano Material, pero es invisible, e incluso las criaturas capaces de verla no son capaces de ver a través de ella. Al terminar el conjuro, todo lo que se encuentre dentro del espacio extradimensional caerá sin más. La cuerda sólo puede ser escalada por una persona a la vez y quienes suban por ella podrán alcanzar un lugar normal al que deseen llegar, siempre y cuando esté antes del espacio extradimensional.

Nota: crear un espacio extradimensional dentro de otro, o trasladar uno de ellos al interior de otro, es una práctica que puede resultar muy peligrosa.

Componentes materiales: extracto de trigo en polvo y un lazo de pergamino retorcido.$c$, components = $c$V. S. M/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$hasta dos cubos de 10'/nivel (Mo)$c$, duration = $c$permanente; ver texto e man de$c$, saving_throw = $c$ver texto$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'transmutar roca en barro';
update spells set school = $c$Conjuración$c$, subschool = $c$creación o llamada$c$, description = $c$Ejecutar un conjuro de umbral tiene dos efectos. En primer lugar, crea una conexión interdimensional entre tu plano y el plano deseado, permitiendo viajar entre ellos en una dirección o en otra. En segundo lugar, y una vez hecho lo primero, te permite llamar a través del umbral a un individuo particular o a un tipo de criatura. El umbral en sí es un aro o disco que mide entre 5' y 20' de diámetro (a elección del lanzador) y está orientado en la dirección que elijas en el momento de crearlo (lo más normal es que sea vertical y que mire hacia ti). Es una ventana bidimensional que se abre al plano elegido y todo objeto o criatura que lo atraviese será empujado instantáneamente hasta el otro lado. El umbral tiene parte anterior y posterior. Las criaturas que lo atraviesen desde la anterior serán transportadas al otro plano; las que lo hagan desde la posterior no lo serán.

Viaje entre los planos: como modalidad de viaje entre los planos, el umbral funciona de forma muy parecida al conjuro de desplazamiento de plano, exceptuando que el umbral se abre justo en el punto que desees (un efecto de creación). Nótese que, de así quererlo, las deidades y demás criaturas que gobiernen sobre un reino planario podrán impedir que un umbral se abra en su presencia o en sus dominios. Los demás viajeros no tendrán que unir sus manos contigo: todo el que quiera atravesar el portal será transportado al otro lado. No puede abrirse un umbral hasta un punto del mismo plano; el conjuro sólo sirve para viajar entre planos diferentes.

Puedes ocupar todo un pasillo con la abertura del umbral para absorber prácticamente todos los ataques o fuerzas que se le aproximen, enviándolas a otro plano; que esta táctica agrade o no a los habitantes del lugar de destino ya es otra cuestión.

Sólo puedes mantener abierto el umbral durante un breve periodo de tiempo (no más de 1 asalto por nivel de lanzador) y deberás concentrarte mientras lo hagas o se romperá la comunicación interplanaria.

Llamar a criaturas: el segundo efecto del conjuro de umbral es llamar a una criatura de otro plano para que te ayude (efecto de llamada). Nombrando a una criatura concreta o tipo de criatura al lanzar el conjuro, puedes hacer que el umbral se abra junto a la criatura deseada y la haga atravesar la abertura, quiera o no quiera hacerlo. Las deidades y criaturas únicas no están obligadas a atravesarlo, aunque pueden hacerlo si lo desean. Este uso del sortilegio crea un umbral que sólo permanece abierto el tiempo necesario para transportar a las criaturas llamadas. Este uso del conjuro tiene un coste en PX (ver más adelante).

Si eliges llamar a un tipo de criatura en lugar de a un individuo conocido (como, por ejemplo, a un diablo barbado o un ghaele (eladrin) podrás elegir entre traer a una criatura (con cualquier cantidad de DG) o a varias. Si optaras por varias criaturas, podrías llamarlas y controlarlas siempre y cuando su total de DG no supere tu nivel de lanzador. Cuando se trate de una sola criatura, podrás controlarla sí sus DG no superan el doble de tu nivel de lanzador, pero, en el caso de que lo superen, no podrás dominarla. Las deidades y criaturas únicas no pueden ser controladas bajo ningún concepto. Las criaturas no controladas actuarán a su antojo, por lo que llamarlas resulta bastante peligroso; además, las criaturas de ese tipo puede regresar a su plano natal cuando deseen.

El conjuro te permite ordenar a una criatura controlada que lleve a cabo un servicio de una de estas dos categorías: tareas inmediatas o servicio contractual. Luchar por ti en una batalla o realizar cualquier otra tarea que pueda cumplirse en 1 asalto por nivel de lanzador contará como tarea inmediata: en estos casos, no necesitarás llegar a ningún acuerdo ni pagar recompensa alguna para obtener la ayuda de la criatura, que se marchará al finalizar el sortilegio.

Si optas por un servicio más duradero o que exija una mayor implicación por parte de la criatura, tendrás que llegar con ella a un acuerdo justo para ambas partes. El servicio exigido deberá ser razonable con respecto al favor o recompensa prometido (consulta el conjuro de aliado menor de los planos para ver algunas recompensas apropiadas). Algunas criaturas exigen su pago en forma de "ganado" en lugar de moneda, lo que puede dar lugar a complicaciones. Nada más completar el servicio, la criatura será transportada junto a tí, y tendrás que entregarle la recompensa prometida allí mismo y en ese preciso instante. Hecho esto, la criatura será libre para volver a su propio plano.

Si no lograras cumplir con el pago prometido, lo mejor que podría pasarte sería que la criatura o su señor te obligaran a llevar a cabo un servicio para ellos. En el peor de los casos, la criatura podría llegar a atacarte.

Nota: cuando se lanza un conjuro de llamada (como umbral) para traer a criaturas de agua, aire, bien, caos, fuego, ley, mal o tierra, éste se convierte en un sortilegio de ese tipo en cuestión. Es decir, que el umbral será un conjuro caótico y maligno cuando lo utilices para llamar a un demonio.

Coste de PX: 1.000 PX (sólo para la función de llamar criaturas).$c$, components = $c$V, S, PX; ver texto$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$intermedio (100' + 10'/nivel)$c$, target = $c$ver texto$c$, duration = $c$instantánea o concentración (hasta 1 asalto/nivel); ver texto$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'umbral';
update spells set school = $c$Ilusión$c$, subschool = $c$engaño$c$, description = $c$Cambias instantáneamente la apariencia de los receptores y mantienes la nueva apariencia mientras dure el conjuro. Puedes hacer que los receptores adopten el aspecto que desees. Puedes, por ejemplo, hacer que un grupo parezca estar formado por una banda de varios tipos de duendes dirigidos por un ent. Los receptores resultarán iguales que las criaturas que aparenten ser, tanto a la vista como al tacto y al olfato. Las criaturas afectadas adoptarán de nuevo su apariencia normal cuando alguien las mate. Para duplicar la apariencia de un individuo concreto, has de tener éxito en una prueba de Disfrazarse (aunque este conjuro te concede un bonificador +10 en la prueba).

Los receptores involuntarios pueden negar el efecto del conjuro realizando un TS de Voluntad o mediante su RC. Quienes interactúen con los receptores podrán realizar TS de Voluntad para descreer y ver a través del engaño, pero la RC que puedan tener no les ayudará en nada.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$largo (400' + 40'/nivel)$c$, target = $c$una o más criaturas; dos receptores cualesquiera no pueden distar más de 30'$c$, duration = $c$concentración + 1 h/nivel (D)$c$, saving_throw = $c$Voluntad niega; ver texto$c$, spell_resistance = $c$sí; ver texto$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'velo';
update spells set school = $c$Nigromancia$c$, description = $c$Apelando a los poderes ponzoñosos y nocivos de los depredadores naturales, puedes inocular un terrible veneno al receptor mediante un ataque de toque en cuerpo a cuerpo. El veneno inflige 1d10 puntos de daño temporal de Constitución inmediatamente y 1d10 puntos más un minuto después. Cada posibilidad de daño podrá ser negada mediante un TS de Fortaleza (CD 10 + la mitad de tu nivel de lanzador + tu modificador de Sabiduría).$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque =$c$, target = $c$criatura viva tocada$c$, duration = $c$instantánea; ver texto$c$, saving_throw = $c$Fortaleza niega; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'veneno';
update spells set school = $c$Ilusión$c$, subschool = $c$quimera$c$, description = $c$Puedes hacer que tu voz (o cualquier sonido que seas capaz de vocalizar normalmente) parezca surgir de otro lugar, como otra criatura, una estatua, de detrás de una puerta, del final de un pasillo, etc. Puedes hablar en cualquier idioma que conozcas. En lo que se refiere a esas voces y sonidos, todo el que los oiga y tenga éxito en su salvación se dará cuenta de que los sonidos son ilusorios (aunque los oirá igualmente).

Foco: un pergamino enrollado en forma de cucurucho.$c$, components = $c$V, F$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$sonido inteligible, normalmente habla$c$, duration = $c$1 min/nivel (D)$c$, saving_throw = $c$Voluntad descree (si se interactúa con el conjuro)$c$, spell_resistance = $c$no Dame Children Sportson ser$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'ventriloquia';
update spells set school = $c$Adivinación$c$, description = $c$Puedes ver cualquier objeto o ser invisible dentro del alcance de tu visión, así como los que sean etéreos, si normalmente son visibles. Verás a estas criaturas como formas translúcidas, permitiéndote distinguir fácilmente entre los seres visibles, invisibles o etéreos.

Este conjuro te permite ver con total normalidad los objetos o criaturas invisibles, así como las cosas astrales o etéreas.

El sortilegio no revela el método empleado para conseguir la invisibilidad. El efecto no revela las ilusiones ni te permitirá ver a través de los objetos opacos. Tampoco revela a las criaturas que simplemente estén escondidas, ocultas o resultan difíciles de ver por alguna otra razón.

Ver lo invisible puede ser hecho permanente mediante un conjuro de permanencia.

Componentes materiales: una pizca de talco y un poco de polvo de plata para espolvorear.$c$, components = $c$V, S, M =========================================================================================================================================================$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal Obietivo: tú$c$, duration = $c$10 min/nivel (D)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'ver lo invisible';
update spells set school = $c$Transmutación$c$, description = $c$Este conjuro infunde a un escudo o armadura con un bonificador +1 de mejora por cada cuatro niveles de lanzador (hasta un máximo de +5 en el 20.º nivel). En lo que se refiere a este conjuro, una indumentaria normal será tratada como una armadura que no concede bonificador alguno a la CA.

| Viajar mediante plantas |
| |
| Transmutación |
| Nivel: Drd 6 |
| Componentes: V, S |
| Tiempo de lanzamiento: 1 acción estáno |
| Alcance: ilimitado |
| Objetivo: tú y los objetos o criaturas |
| voluntarias tocados |
| Duración: 1 asalto |
| Tiro de salvación: ninguno |
| Resistencia a conjuros: no |
| |

Te permite meterte en cualquier planta normal (de tamaño Mediano o superior) y atravesar en un solo asalto cualquier distancia hasta otra planta de la misma especie (sin importar lo lejos que se encuentre una de la otra). La planta "de entrada" ha de estar viva. La planta de destino no tiene por qué resultarte familiar, pero también habrá de estar con vida. Si no estuvieras seguro de la situación exacta de un tipo concreto de planta de destino, no tendrás más que designar una dirección y una distancia ("un roble situado a cien millas al norte de aquí") y el conjuro de viajar mediante plantas te llevará lo más cerca posible del lugar deseado. Si optas por una planta de destino concreta (por ejemplo, el roble que hubiera al lado de tu arboleda druídica) pero ésta hubiera muerto, el conjuro fallará y serás expulsado de la planta de entrada.

Podrás llevar contigo objetos, siempre que su peso no exceda tu carga máxima. También puedes llevar una criatura adicional voluntaria Mediana o más pequeña (que lleve equipo u objetos hasta su carga máxima) por cada tres niveles de lanzador. Utiliza las siguientes equivalencias para determinar la cantidad máxima de criaturas de mayor tamaño que puedes llevar contigo: una criatura Grande cuenta como dos criaturas Medianas, una criatura Enorme cuenta como dos Grandes, etc. Todas las criaturas que van a ser transportadas deben estar en contacto entre sí, y al menos una de ellas debe estar en contacto contigo.

No puedes utilizar este conjuro para viajar mediante criaturas vegetales, como las brozas movedizas o los ents.

La destrucción de una planta que estuvieras ocupando también te matara a ti y a cualquier criatura que lleves contigo, y expulsará fuera del árbol los cuerpos y todos los objetos transportados.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$armadura o escudo tocado$c$, duration = $c$1 h/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo, objeto)$c$, spell_resistance = $c$sí (inofensivo,<br>objeto)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'vestidura magica';
update spells set school = $c$Evocación$c$, descriptors = $c$sónico$c$, description = $c$Poniéndote en sintonía con una estructura no empotrada, como un edificio, puente o presa, puedes crear un vibración destructiva en él. Una vez que comienza, la vibración causa 2d10 puntos de daño por asalto a la estructura objetivo (la Dureza no se tiene en cuenta para el daño del conjuro). En el momento del lanzamiento puedes elegir limitar la duración del conjuro; de otro modo este dura 1 asalto/nivel. Si se lanza sobre un objetivo que esté empotrado, como la ladera de una colina, la roca que la rodea disipa el efecto y no se produce daño.

Vibración sintonizada no puede afectar a criaturas vivas (incluidos constructos). Ya que una estructura es un objeto no atendido, no recibe TS para resistir los efectos.

Foco: un diapasón. A la pr$c$, components = $c$V, S, F$c$, casting_time = $c$10 minutos$c$, spell_range = $c$toque$c$, target = $c$una estructura no empotrada$c$, duration = $c$hasta 1 asalto por nivel$c$, saving_throw = $c$ninguno; ver texto$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'vibracion sintonizada';
update spells set school = $c$Transmutación$c$, descriptors = $c$aire$c$, description = $c$Te permite transmitir un mensaje o sonido a través del viento hasta el lugar designado. El viento susurrante viajará hasta un lugar concreto, conocido por ti y situado dentro del alcance, siempre y cuando pueda encontrar un camino para llegar hasta allí (no podrá atravesar paredes, por ejemplo). El viento susurrante es tan suave y pasa tan inadvertido como el céfiro hasta llegar a su destino, momento en que susurrará el mensaje o sonido deseado. Ten en cuenta que el mensaje será transmitido aunque no haya nadie presente para oírlo. A continuación, el viento se disipará. Puedes preparar el conjuro para que transmita un mensaje con un máximo de 25 palabras, hacer que el conjuro transmita

otros sonidos durante 1 asalto, o simplemente hacer que el viento susurrante parezca una leve agitación del aire. También puedes hacer que el viento se mueva a un mínimo de una milla por hora o a un máximo de una milla cada 10 minutos. Cuando el conjuro llegue hasta su objetivo, se arremolinará y permanecerá allí hasta transmitir el mensaje. Al igual que sucede con la boca mágica, este conjuro no puede pronunciar componentes verbales, palabras de mando ni activar efectos mágicos.$c$, components = $c$V, San Jan Chun oller$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$1 milla/nivel Amin$c$, target = $c$expansión de 10' de radio$c$, duration = $c$un máximo de 1 h/nivel o hasta ser descargado (alcanza su destino)$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'viento susurrante';
update spells set description = $c$Te permite forjar un vínculo telepático entre ti y un grupo de criaturas voluntarias, cada una de las cuales debe tener una Inteligencia de 3 o mayor. Cada criatura incluida en el vínculo estará unida a todas las demás. Las criaturas podrán comunicarse telepáticamente a través del vínculo, sin importar qué idioma hablen normalmente. La unión mágica no establece ningún poder ni influencia especial por sí misma. Una vez se ha formado el vínculo, éste funcionará sin importar la distancia que separe a los receptores (aunque éstos han de encontrarse en el mismo plano).

Si así lo deseas, puedes quedar excluido del vínculo telepático que se forje. Esta decisión debe ser tomada en el momento del lanzamiento. Un vínculo telepático de Rary puede ser hecho permanente con un conjuro de permanencia, aunque sólo unirá a dos criaturas por cada lanzamiento de permanencia. 15 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 - 10 -

Componentes materiales: dos trozos de cáscara de huevo, cada trozo debe pertenecer a una especie distinta. che Tals cross province the Children

... . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$tú más una criatura voluntaria por cada 3 niveles; dos cualesquiera no pueden distar más de 30'$c$, duration = $c$10 min/nivel (D)$c$, saving_throw = $c$ninguno Dacictancis a consimos, no$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'vinculo telepatico de rary';
update spells set school = $c$Transmutacion$c$, description = $c$El receptor obtiene 1 punto de golpe temporal.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$1 minuto$c$, saving_throw = $c$Fortaleza niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'virtud';
update spells set school = $c$Transmutación$c$, description = $c$El receptor obtiene la aptitud de poder ver hasta 60' de distancia incluso en la oscuridad total. La visión en la oscuridad sólo permite ver en blanco y negro, pero, por lo demás, es igual que la vista normal. Este tipo de visión no concede la aptitud de ver en la oscuridad mágica.

Visión en la oscuridad puede ser hecho permanente con un conjuro de permanencia. E

Componente material: una pizca de zanahoria seca o una ágata. A parte a ma a ma alle le man$c$, components = $c$V, S, M =$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada ====================================================================================================================================================$c$, duration = $c$1 h/nivel 8 % comment de m$c$, saving_throw = $c$ninguno$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'vision en la oscuridad a maniguram';
update spells set school = $c$Adivinación$c$, description = $c$Confieres al receptor la aptitud de ver todas las cosas como son en realidad. Éste podrá ver en la oscuridad normal y mágica, advertirá la presencia de puertas secretas escondidas mágicamente, verá la situación exacta de las criaturas bajo los efectos de contorno borroso o desplazamiento, percibirá con normalidad a las criaturas y objetos invisibles, verá a través de las ilusiones y percibirá la verdadera forma de las cosas polimorfadas, cambiadas o transmutadas. Es más, el receptor podrá enfocar su vista para ver el plano Etéreo (pero no los espacios extradimensionales). El alcance de visibilidad concedido por el conjuro es de 120'.

No obstante, la visión verdadera no puede atravesar los objetos sólidos y no conferirá "visión de rayos X" u otra cosa equivalente. Tampoco cancela la ocultación, ni siquiera la producida por la niebla u otros efectos similares. Este conjuro no permite al espectador ver a través de disfraces mundanos, vislumbrar a criaturas que simplemente estén escondidas ni advertir la presencia de puertas secretas escondidas por medios mundanos. Además, los efectos del conjuro no pueden mejorarse por ningún medio mágico conocido; por tanto, no será posible usar la visión verdadera a través de una bola de cristal ni a la vez que clariaudiencia/clarividencia.

Componente material: un ungüento para los ojos que cuesta 250 po y está hecho con grasa, azafrán y polvo de setas muy raras. The progra

Lection Leagues (11) (1$c$, components = $c$V, S, M$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque shown and the mobile my 1944.$c$, target = $c$criatura tocada La La La vil uma$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega niega ma id (inofensivo) 117-11-11$c$, spell_resistance = $c$sí (inofensivo) doda$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'vision verdadera';
update spells set description = $c$Este conjuro hace que tus ojos brillen con un color azulado y te permite ver auras mágicas a menos de 120' de ti. El efecto es similar al del conjuro de detectar magia, pero vista arcana no requiere concentración y discierne la localización y el poder de las auras más rápido.

Sabes dónde se encuentran las auras que tienes a la vista, y la fuerza de cada una de ellas. La fuerza de un aura depende del nivel del conjuro en funcionamiento o del nivel de lanzador del objeto, tal como se indica en la descripción del conjuro detectar magia (pág. 230). Si los objetos o criaturas que poseen las auras están en tu línea de visión, puedes realizar pruebas de la habilidad de Conocimiento de conjuros para determinar la escuela de magia de cada una (realiza una prueba por aura; CD 15 + nivel del conjuro, o 15 + la mitad del nivel del lanzador para un efecto que no sea un conjuro).

Si te concentras en una criatura concreta que esté a menos de 120' de ti mediante una acción estándar, podrás determinar si posee alguna aptitud sortílega o de lanzamiento de conjuros, si son arcanos o divinos (las aptitudes sortílegas aparecen como arcanas), y la fuerza de la aptitud más poderosa que la criatura tenga a su disposición para utilizar en ese momento. En algunos casos, el sortilegio puede dar una lectura engañosamente baja, como cuando lo utilizas sobre un lanzador de conjuros que ya haya empleado la mayor parte de su límite diario de sortilegios.

Vista arcana puede ser hecho permanente con un conjuro de permanencia.$c$, components = $c$V, S$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$personal$c$, target = $c$tú$c$, duration = $c$1 minuto/nivel$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'vista arcana inic';
update spells set school = $c$Transmutacion$c$, description = $c$El receptor del conjuro podrá volar a una velocidad de 60' (40' si la criatura lleva puesta armadura intermedia o pesada o lleva carga mediana o pesada). El efecto permite elevarse a la mitad de la velocidad normal y descender al doble; además, la criatura tendrá una maniobrabilidad buena. Usar un conjuro de volar requiere la misma concentración que caminar; por tanto, su receptor podrá atacar o lanzar conjuros con total normalidad. Éste podrá realizar cargas, pero no correr, y no podrá llevar consigo un peso superior a su carga máxima, además de la armadura que lleve puesta.

Si la duración del conjuro expira mientras el receptor está aún en las alturas, el efecto mágico desaparecerá lentamente y el receptor caerá a una velocidad de 60' por asalto durante 1d6 asaltos. Si lograr aterrizar en ese tiempo, no correrá peligro alguno. Si no, caerá de forma normal toda la distancia que le quede, sufriendo 1d6 puntos de daño por cada 10' de caída. Como disipar un conjuro equivale a ponerle fin, el receptor también caerá de este modo si su conjuro de volar es disipado, pero no si es negado por un campo antimagia.

Foco arcano: una pluma del ala de cualquier ave

Vuelo de largo recorrido Transmutación Nivel: Hch/Mag 5 Componentes: V, S Alcance: personal Objetivo: tú Duración: 1 hora/nivel

Este conjuro funciona como volar, salvo en que puedes desplazarte a una velocidad de 40' (o 30' si llevas armadura intermedia o pesada, o si

transportas una carga mediana o pesada) con maniobrabilidad regular. Cuando utilices este conjuro para moverte largas distancias, puedes aligerar tu movimiento sin sufrir daño no letal (una marcha forzada sigue requiriendo pruebas de Constitución). Esto quiere decir que puedes cubrir 64 millas en 8 horas de vuelo (o 48 millas a una velocidad de 30'). Consulta la pág. 164 para más información sobre el movimiento terrestre.

Zancada arbórea Conjuración (teletransporte) Nivel: Drd 5, Exp 4 Componentes: V, S, FD Tiempo de lanzamiento: 1 acción estándar Alcance: personal Objetivo: tú Duración: 1 h/nivel o hasta agotarse; ver texto

Ganas la aptitud de entrar en los árboles y moverte dentro de uno hasta otro. El primer árbol en el que entres y todos los demás por los que pases han de ser del mismo tipo, deben estar vivos y ser, al menos, tan gruesos como tú. Al entrar en un roble (por ejemplo), sabrás instantáneamente la situación exacta de todos los demás robles que se encuentren dentro del alcance de transporte (véase más abajo), pudiendo elegir a qué árbol pasar o bien limitarte a salir del árbol al que hayas entrado. Puedes trasladarte a cualquier árbol del tipo adecuado que se encuentre dentro del alcance del transporte indicado en la siguiente tabla:

| Tipo de árbol | Alcance del | | |
| | |--|--|
| | transporte | | |
| Roble, fresno, tejo | 3.000' | | |
| Olmo, tilo | 2.000' | | |
| Otros de hoja caduca | 1.500' | | |
| Cualquier conífera | 1.000' | | |
| Resto de árboles | 500' | | |

Podrás entrar en un árbol hasta un máximo de una vez por nivel (pasar de un árbol a otro contará como entrar en un solo árbol). El conjuro durará hasta que expire su duración o salgas de un árbol. En un bosque espeso de robles, esto significa que un druida de 10.º nivel podría llevar a cabo 10 transportes, tardando 10 asaltos y cubriendo una distancia de 30.000' (unas 6 millas). Cada transporte requerirá una acción de asalto completo.

Si lo prefieres, puedes quedarte dentro de un árbol sin transportarte hasta otro, aunque serás expulsado de él cuando finalice el conjuro. Si el árbol en que estés escondido es talado o quemado, tendrás que salir de él antes de completarse el proceso o morirás.

Zancada prodigiosa

Transmutación Nivel: Drd 1, Exp 1, Viaje 1 Componentes: V, S, M

Tiempo de lanzamiento: 1 acción estándar Alcance: personal Objetivo: tú Duración: 1 hora/nivel (D)

Este conjuro aumenta tu velocidad base terrestre en 10' (este ajuste cuenta como un bonificador de mejora). No tiene efecto sobre otros métodos de movimiento, como excavar, trepar, nadar o nadar.

Componente material: una pizca de tierra.$c$, components = $c$V, S, F/FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$toque$c$, target = $c$criatura tocada$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega (inofensivo)$c$, spell_resistance = $c$sí (inofensivo)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'volar';
update spells set school = $c$Ilusión$c$, subschool = $c$engaño$c$, description = $c$Lanzando zona de silencio, puedes manipular las ondas de sonido en tu entorno inmediato para que tú y aquellos dentro del área del conjuro podáis conversar normalmente, y que nadie fuera pueda escuchar vuestras voces ni ningún otro sonido del interior, incluyendo efectos de conjuro dependientes del lenguaje o sónicos (como alarido u orden imperiosa). Este efecto está centrado en ti y se mueve contigo. Cualquiera que entre en la zona se encuentra inmediatamente sujeto a sus efectos, pero los que la dejan no siguen estando afectados. Ten en cuenta, sin embargo, que tener éxito en una prueba de Avistar para leer los labios sigue pudiendo revelar lo que se ha dicho en el interior de una zona de silencio.$c$, components = $c$V, S$c$, casting_time = $c$1 asalto$c$, spell_range = $c$personal$c$, target = $c$emanación de 5' de radio centrada en ti$c$, duration = $c$1 hora/nivel (D)$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'zona de silencio';
update spells set school = $c$Encantamiento$c$, subschool = $c$compulsión$c$, descriptors = $c$enajenador$c$, description = $c$Las criaturas que haya dentro del área de la emanación (o las que entren en ella) no podrán decir mentiras intencionadas ni deliberadas. Toda criatura potencialmente afectada tendrá derecho a un TS para evitar los efectos cuando el conjuro sea ejecutado o nada más entrar en el área de la emanación.

Los afectados serán conscientes de la presencia del encantamiento. Por tanto, podrán evitar responder a aquellas preguntas a las que en condiciones normales contestarían con una mentira, o podrán andarse con evasivas siempre y cuando se mantengan dentro de los límites de la verdad. Las criaturas que abandonen el área serán libres de expresarse como les venga en gana.$c$, components = $c$V, S, FD$c$, casting_time = $c$1 acción estándar$c$, spell_range = $c$corto (25' + 5'/2 niveles)$c$, target = $c$emanación de 20' de radio$c$, duration = $c$1 min/nivel$c$, saving_throw = $c$Voluntad niega$c$, spell_resistance = $c$sí$c$, source = $c$Manual del Jugador 3.5$c$ where lower(translate(name, 'áéíóúüñ', 'aeiouun')) = 'zona de verdad';
