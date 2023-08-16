insert into
    simple_data (left_operand, operator, right_operand)
values
    (1, '=', 1);

select
    d.data_id,
    case
        when d.operator = '=' then d.left_operand = d.right_operand
        when d.operator = '<>' then d.left_operand <> d.right_operand
        when d.operator = '<' then d.left_operand < d.right_operand
        when d.operator = '<=' then d.left_operand <= d.right_operand
        when d.operator = '>' then d.left_operand > d.right_operand
        when d.operator = '>=' then d.left_operand >= d.right_operand
        else false
    end
from
    simple_data as d
