CREATE DATABASE tran_test;

CREATE TABLE player_coin(
    id serial primary key,
    player_id int not null,
    quantity int
);

insert into
    player_coin (player_id, quantity)
values
    (1, 1000);

insert into
    player_coin(player_id, quantity)
values
    (2, 1000);
