SELECT
    d.data_id,
    CASE
        WHEN d.calc_operator = '=' THEN d.left_operand = d.right_operand
        WHEN d.calc_operator = '<>' THEN d.left_operand <> d.right_operand
        WHEN d.calc_operator = '<' THEN d.left_operand < d.right_operand
        WHEN d.calc_operator = '<=' THEN d.left_operand <= d.right_operand
        WHEN d.calc_operator = '>' THEN d.left_operand > d.right_operand
        WHEN d.calc_operator = '>=' THEN d.left_operand >= d.right_operand
        ELSE FALSE
    END
FROM
    calc_in_db.simple_data AS d;
