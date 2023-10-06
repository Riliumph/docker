# デフォルト制約

テーブルを作成するときにデフォルト制約を用いると、**レコードを追加する**ときにかってに値を入れてくれて便利である。

たとえば、以下のような面倒なケース。

- `timestamptz`は今の時刻でいいんだよ！！

## テーブル定義を確認する

```console
postgres=# \d docker.users
                               Table "docker.users"
   Column   |           Type           | Collation | Nullable |      Default       
------------+--------------------------+-----------+----------+--------------------
 user_id    | uuid                     |           | not null | uuid_generate_v4()
 user_name  | text                     |           | not null | 
 created_at | timestamp with time zone |           |          | CURRENT_TIMESTAMP
 updated_at | timestamp with time zone |           |          | CURRENT_TIMESTAMP
Indexes:
    "users_pkey" PRIMARY KEY, btree (user_id)
```

## serial型

serial型については自動でつけられるが、それに関してはserial型で解説する。
