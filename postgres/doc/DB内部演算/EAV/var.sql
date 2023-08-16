-- type table
insert into
    types (type_name, left_table, right_table)
values
    ('整数同士', 'left_int_values', 'right_int_values');

insert into
    types (type_name, left_table, right_table)
values
    ('時刻同士', 'left_time_values', 'right_time_values');

-- operator table
insert into
    operators (operator)
values
    ('==');

insert into
    operators (operator)
values
    ('!=');

insert into
    operators (operator)
values
    ('<');

insert into
    operators (operator)
values
    ('<=');

insert into
    operators (operator)
values
    ('>');

insert into
    operators (operator)
values
    ('>=');

-- values
insert into
    left_int_values (value)
values
    (5);

insert into
    right_int_values (value)
values
    (2);

insert into
    left_time_values (value)
values
    ('2022/01/01T00:00:00.000');

insert into
    right_time_values (value)
values
    ('2022/01/02T00:00:00.000');

-- data
insert into
    data(
        type_id,
        left_value_id,
        operator_id,
        right_value_id
    )
values
    (1, 1, 1, 1);

insert into
    data(
        type_id,
        left_value_id,
        operator_id,
        right_value_id
    )
values
    (2, 1, 1, 1);
