CREATE SCHEMA text1;

CREATE TABLE text1.users (
    user_id serial PRIMARY KEY,
    user_name text NOT NULL,
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE text1.books(
    book_id serial PRIMARY KEY,
    title text NOT NULL,
    author text NOT NULL,
    publisher text NOT NULL,
    publication_date timestamptz,
    pages int NOT NULL,
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE text1.genres(
    genre_id serial PRIMARY KEY,
    genre_name text NOT NULL,
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE text1.books_genres(
    book_id int NOT NULL,
    genre_id int NOT NULL,
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES text1.books (book_id),
    FOREIGN KEY (genre_id) REFERENCES text1.genres (genre_id),
    UNIQUE (book_id, genre_id)
);

CREATE TABLE text1.inventories(
    inventory_id serial PRIMARY KEY,
    book_id int,
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES text1.books (book_id)
);

CREATE TABLE text1.issue_histories(
    checkout_history_id serial PRIMARY KEY,
    user_id int,
    inventory_id int,
    issue_date timestamptz,
    return_date timestamptz,
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES text1.users (user_id),
    FOREIGN KEY (inventory_id) REFERENCES text1.inventories (inventory_id)
);

CREATE TABLE text1.issue_items(
    user_id int,
    inventory_id int,
    issue_date timestamptz,
    due_date timestamptz,
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES text1.users (user_id),
    FOREIGN KEY (inventory_id) REFERENCES text1.inventories (inventory_id)
);

-- INSERT INTO
--     text1.users(user_name)
-- VALUES
--     ('渋谷ユウト'),
--     ('大崎トシコ'),
--     ('大塚ミチオ'),
--     ('品川マコト');
-- INSERT INTO
--     text1.books(
--         title,
--         author,
--         publisher,
--         publication_date,
--         pages
--     )
-- VALUES
--     (
--         'わたしとぼくのPL/pgSQL',
--         '目黒聖',
--         'インプレスR&D',
--         '2019-02-22',
--         10
--     ),
--     (
--         'あるマグロの一生',
--         '目黒聖',
--         'めぐろ社',
--         '2010-04-19',
--         300
--     ),
--     (
--         'マグロの生態',
--         '目黒聖',
--         'めぐろ社',
--         '2015-08-01',
--         500
--     ),
--     (
--         'マグロの歴史',
--         '目黒聖',
--         'めぐろ社',
--         '2017-01-19',
--         230
--     );
-- INSERT INTO
--     text1.genres(genre_name)
-- VALUES
--     ('IT'),
--     ('データベース'),
--     ('SF'),
--     ('ラブストーリー');
-- INSERT INTO
--     text1.books_genres
-- VALUES
--     (1, 1),
--     (1, 2),
--     (2, 3),
--     (3, 3),
--     (3, 4),
--     (4, 3);
-- INSERT INTO
--     text1.inventories (book_id)
-- VALUES
--     (1),
--     (2),
--     (3),
--     (4),
--     (2);
-- INSERT INTO
--     text1.issue_histories(
--         user_id,
--         inventory_id,
--         issue_date,
--         return_date
--     )
-- VALUES
--     (2, 2, '2020-01-05', '2020-01-15');
-- INSERT INTO
--     text1.issue_items(
--         user_id,
--         inventory_id,
--         issue_date,
--         due_date
--     )
-- VALUES
--     (1, 1, '2020-01-06', '2020-01-20'),
--     (2, 2, '2020-01-06', '2020-01-20'),
--     (3, 2, '2020-01-06', '2020-01-20'),
--     (1, 4, '2020-01-06', '2020-01-20');
