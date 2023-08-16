create database variant_data_db;

-- master
create table types(
    type_id serial primary key,
    type_name text not null
);

create table int_values(
    value_id serial primary key,
    value int not null
);

create table time_values(
    value_id serial primary key,
    value timestamp not null
);

create table variant(
    variant_id serial primary key,
    type_id int,
    value_id int,
    foreign key (type_id) references types(type_id) on
    delete
        cascade on
    update
        cascade
);

create table data (
    data_id serial primary key,
    variant_id int not null,
    foreign key (variant_id) references variant(variant_id) on
    delete
        cascade on
    update
        cascade
);
