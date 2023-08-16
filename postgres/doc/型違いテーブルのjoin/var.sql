-- condition_types
insert into
    types (type_name)
values
    ('整数型');

insert into
    types (type_name)
values
    ('時刻型');

-- condition_int_values
insert into
    int_values (value)
values
    (1);

-- condition_time values
insert into
    time_values (value)
values
    (current_timestamp);

-- variant column data
insert into
    variant (type_id, value_id)
values
    (1, 1);

insert into
    variant (type_id, value_id)
values
    (2, 2);

-- data
insert into
    data (variant_id)
values
    (1);
