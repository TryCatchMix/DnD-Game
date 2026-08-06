-- =====================================================================
-- Los Archivos — esquema mínimo del bucle de juego.
-- Flyway manda en el esquema; Hibernate no lo toca (ddl-auto: none).
-- =====================================================================

create table users (
    id            uuid primary key,
    email         text not null unique,
    password_hash text not null,
    display_name  text not null,
    role          text not null
);

create table refresh_tokens (
    id         uuid primary key,
    user_id    uuid not null references users(id),
    token      text not null unique,
    expires_at timestamptz not null,
    revoked    boolean not null default false
);
create index idx_refresh_user on refresh_tokens(user_id);

create table characters (
    id        uuid primary key,
    user_id   uuid not null references users(id),
    name      text not null,
    clazz     text not null,
    city      text not null,
    level     int  not null default 1,
    vigor     int  not null,
    max_vigor int  not null,
    pg        int  not null,
    ca        int  not null,
    bolsa     text not null default '',
    carga     text not null default ''
);
create index idx_char_user on characters(user_id);

create table character_skills (
    id           uuid primary key,
    character_id uuid not null references characters(id),
    name         text not null,
    code         text not null,
    modifier     int  not null
);
create index idx_skill_char on character_skills(character_id);

create table quests (
    id                  uuid primary key,
    code                text not null unique,
    title               text not null,
    hook                text not null,
    location            text not null,
    faction             text,
    vigor_cost          int  not null default 1,
    duration            text not null default '',
    scene_count         int  not null,
    reward_note         text,
    min_level           int  not null default 1,
    published           boolean not null default false,
    required_flag       text,
    required_flag_state boolean,
    requirement_label   text,
    skill_tags          text
);
create index idx_quest_location on quests(location);

create table scenes (
    id          uuid primary key,
    quest_id    uuid not null references quests(id),
    ordinal     int  not null,
    title       text not null,
    body        text not null,
    final_scene boolean not null default false
);
create index idx_scene_quest on scenes(quest_id);

create table scene_options (
    id         uuid primary key,
    scene_id   uuid not null references scenes(id),
    ordinal    int  not null,
    label      text not null,
    skill      text,
    dc         int,
    vigor_cost int  not null default 0,
    risk       text,
    note       text
);
create index idx_option_scene on scene_options(scene_id);

create table option_modifiers (
    id        uuid primary key,
    option_id uuid not null references scene_options(id),
    label     text not null,
    value     int  not null
);
create index idx_mod_option on option_modifiers(option_id);

create table outcomes (
    id            uuid primary key,
    option_id     uuid not null references scene_options(id),
    grade         int  not null,
    narrative     text not null,
    next_scene_id uuid references scenes(id),
    ends_quest    boolean not null default false
);
create index idx_outcome_option on outcomes(option_id);

create table world_flags (
    flag_key text primary key,
    state    boolean not null
);

create table quest_runs (
    id               uuid primary key,
    character_id     uuid not null references characters(id),
    quest_id         uuid not null references quests(id),
    current_scene_id uuid references scenes(id),
    status           text not null
);
create index idx_run_char on quest_runs(character_id);
