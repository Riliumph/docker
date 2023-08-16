create database flexible_calc;

-- master
create table types(
    type_id serial primary key,
    type_name text not null,
    left_table text not null,
    right_table text not null
);

create table operators(
    operator_id serial primary key,
    operator text not null
);

create table left_int_values(
    value_id serial primary key,
    value int not null
);

create table right_int_values(
    value_id serial primary key,
    value int not null
);

create table left_time_values(
    value_id serial primary key,
    value timestamp not null
);

create table right_time_values(
    value_id serial primary key,
    value timestamp not null
);

create table data (
    data_id serial primary key,
    type_id int not null,
    left_value_id int not null,
    operator_id int not null,
    right_value_id int not null,
    foreign key (operator_id) references operators(operator_id) on
    delete
        cascade on
    update
        cascade,
        foreign key(type_id) references types(type_id) on
    delete
        cascade on
    update
        cascade
);
