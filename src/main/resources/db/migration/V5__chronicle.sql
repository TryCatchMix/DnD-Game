-- =====================================================================
-- La crónica del clan (pantalla 07).
-- La Orden del Velo (religiosos) sella la verdad del Cataclismo;
-- el clan de Los Archivos la destapa.
-- =====================================================================

create table chronicle_entries (
    id           uuid primary key,
    year         int  not null,
    era          text not null default '',
    title        text not null,
    body         text not null,
    category     text not null default 'MUNDO',
    faction      text,
    sealed       boolean not null default false,
    revealed     boolean not null default false,
    sort_ordinal int  not null default 0
);
create index idx_chronicle_order on chronicle_entries(year, sort_ordinal);

insert into chronicle_entries (id, year, era, title, body, category, faction, sealed, revealed, sort_ordinal) values
(gen_random_uuid(), 0, 'El Cataclismo', 'El día en que el cielo se agrietó',
 'Los reyes-magos de Antaria alzaron torres para tocar el trono de los dioses. El Cielo respondió: el suelo se abrió, el mar hirvió y la magia enloqueció durante tres días. Fue un castigo justo a la soberbia de los hombres. Arrepentíos, y no volváis a mirar arriba.',
 'CATACLISMO', 'La Orden del Velo', false, false, 1),

(gen_random_uuid(), 0, 'El Cataclismo', 'Lo que la Orden del Velo no deja recordar',
 'No hubo castigo divino. Fue el propio Concilio de la Luz —hoy llamado la Orden del Velo— quien abrió la Grieta al intentar encadenar a un dios que ya agonizaba. Para esconder su culpa inventaron el castigo del Cielo, sellaron los registros y llevaron a la pira a todo el que recordaba otra cosa.',
 'VERDAD', 'La Orden del Velo', true, false, 2),

(gen_random_uuid(), 3, 'Año 3', 'Nacen las Ciudades Libres',
 'De entre las ruinas, siete ciudades se declararon libres de reyes y de templos. Dorakan fue la primera en colgar su campana y jurar que ninguna corona ni ningún altar mandarían tras sus muros.',
 'MUNDO', null, false, false, 1),

(gen_random_uuid(), 412, 'Año 412', 'Se funda el clan de Los Archivos',
 'Un puñado de escribas juró una sola cosa: cotejar, registrar y no preguntar dos veces. Donde la Orden sella, Los Archivos copian. Donde la Orden quema, Los Archivos recuerdan. No buscan poder; buscan que quede constancia.',
 'CLAN', 'Los Archivos', false, false, 1),

(gen_random_uuid(), 780, 'Año 780', 'La Orden prohíbe los archivos del Cataclismo',
 'Por decreto, todo texto que hable del año cero debe entregarse a la Orden del Velo para su custodia. Los que no arden, se sellan. Desde entonces, recordar el Cataclismo de más es delito.',
 'MUNDO', 'La Orden del Velo', false, false, 1),

(gen_random_uuid(), 1103, 'Año 1103', 'Un folio sale de las bóvedas de la Orden',
 'Una copista de Los Archivos sacó, cosido bajo su hábito, un único folio del viejo Concilio de la Luz: la confesión firmada de quien abrió la Grieta. Ese folio es la razón de que la Orden del Velo vigile Dorakan de cerca.',
 'VERDAD', 'Los Archivos', true, false, 1),

(gen_random_uuid(), 1127, 'Año 1127 · Dorakan', 'Cae el Puente Norte',
 'El Puente Norte amaneció en el fondo del río. Nadie firma el encargo de reconstruirlo, pero el arrabal ha quedado incomunicado y la procesión del Farolero no puede cruzar. El mundo cambió para todos a la vez.',
 'MUNDO', null, false, false, 1),

(gen_random_uuid(), 1127, 'Año 1127 · Dorakan', 'Silencio en el pozo tercero',
 'Once días sin que suba nadie de la mina. El Gremio de Mineros ofrece plata y favores a quien baje a mirar. Del capataz, ni una palabra.',
 'RUMOR', 'Gremio de Mineros', false, false, 2),

(gen_random_uuid(), 1127, 'Año 1127', 'La Orden reclama la campana de Dorakan',
 'La Orden del Velo pide colgar su símbolo junto a la campana de la ciudad libre, «para velar por las almas». El concejo aún lo debate, pero cada semana hay más túnicas grises en la plaza.',
 'MUNDO', 'La Orden del Velo', false, false, 3);
