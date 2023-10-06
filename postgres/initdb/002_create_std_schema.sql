CREATE SCHEMA std;

CREATE TABLE std.users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    user_name TEXT NOT NULL,
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO
    std.users (user_name)
VALUES
    ('docker');
