delete from "user";

alter table "user" drop column password;
alter table "user" drop column email;
alter table "user" drop column image;
alter table "user" drop column created;

alter table post drop column user_id;
alter table community drop column user_id;
alter table comment drop column user_id;
alter table community_user drop column user_id;
alter table community_moderator drop column user_id;
alter table "user" drop column id;


alter table "user" add id uuid primary key;
alter table post add user_id uuid not null references "user" (id);
alter table community add user_id uuid not null references "user" (id);
alter table comment add user_id uuid not null references "user" (id);
alter table community_user add user_id uuid not null references "user" (id);
alter table community_moderator add user_id uuid not null references "user" (id);