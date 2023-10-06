CREATE SCHEMA calc_in_db;

CREATE TABLE calc_in_db.simple_data (
    data_id SERIAL PRIMARY KEY,
    left_operand INT NOT NULL,
    calc_operator TEXT NOT NULL,
    right_operand INT NOT NULL
);

INSERT INTO
    calc_in_db.simple_data (left_operand, calc_operator, right_operand)
VALUES
    (1, '=', 1);
