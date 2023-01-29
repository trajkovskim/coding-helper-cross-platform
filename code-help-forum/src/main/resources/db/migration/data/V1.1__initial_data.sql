create extension if not exists pgcrypto;

insert into "user" (username, password, email)
values ('admin', crypt('password', gen_salt('bf')), 'admin@gmail.com');
