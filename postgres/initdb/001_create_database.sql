CREATE SCHEMA docker;
CREATE TABLE docker.users (
    user_id serial not null primary key,
    name text not null,
    created_at timestamptz default current_timestamp,
    updated_at timestamptz default current_timestamp
);
INSERT INTO docker.users (name) values ('user1');
