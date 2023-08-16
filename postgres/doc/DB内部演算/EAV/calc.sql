with data_1 as (
    select
        d.data_id,
        d.type_id,
        t.type_name,
        t.left_table,
        t.right_table,
        d.left_value_id,
        d.operator_id,
        o.operator,
        d.right_value_id
    from
        data as d,
        types as t,
        operators as o
    where
        d.type_id = t.type_id
        and d.operator_id = o.operator_id
        and d.type_id = 1
);
