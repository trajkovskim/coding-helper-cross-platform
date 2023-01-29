create table file
(
    id   serial primary key,
    uid  uuid default gen_random_uuid() not null unique,
    data bytea,
    type varchar(32)
);

create table "user"
(
    id       serial primary key,
    username varchar(32) unique      not null,
    password varchar(128)            not null,
    email    varchar(128) unique     not null,
    image    integer references file (id),
    created  timestamp default now() not null
);

create table community
(
    id          serial primary key,
    name        varchar(32)             not null unique,
    description varchar(128)            not null unique,
    user_id     integer                 not null references "user" (id),
    image       integer references file (id),
    created     timestamp default now() not null,
    modified    timestamp default now() not null
);

create table post
(
    id           serial primary key,
    uid          uuid      default gen_random_uuid() not null unique,
    title        varchar(255)                        not null,
    content      text                                not null,
    community_id integer                             not null references community (id),
    user_id      integer                             not null references "user" (id),
    created      timestamp default now()             not null,
    modified     timestamp default now()             not null
);

create table comment
(
    id        serial primary key,
    uid       uuid      default gen_random_uuid() not null unique,
    content   text                                not null,
    parent_id integer references comment (id),
    post_id   integer                             not null references post (id),
    user_id   integer                             not null references "user" (id),
    created   timestamp default now()             not null,
    modified  timestamp default now()             not null,

    unique (id, post_id),
    unique (id, parent_id)
);

create table category
(
    id      serial primary key,
    uid     uuid      default gen_random_uuid() not null unique,
    name    varchar(32)                         not null unique,
    created timestamp default now()             not null
);

create table community_category
(
    uid          uuid default gen_random_uuid() primary key,
    category_id  integer not null references category (id),
    community_id integer not null references community (id),

    unique (category_id, community_id)

);

create table community_user
(
    uid          uuid default gen_random_uuid() primary key,
    user_id      integer not null references "user" (id),
    community_id integer not null references community (id),

    unique (user_id, community_id)
);

create table community_moderator
(
    uid          uuid default gen_random_uuid() primary key,
    user_id      integer not null references "user" (id),
    community_id integer not null references community (id),

    unique (user_id, community_id)
);

