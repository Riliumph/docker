create table simple_data (
    data_id serial primary key,
    left_operand int not null,
    operator text not null,
    right_operand int not null
);
