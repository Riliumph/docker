# TOCTOU問題

Time-of-Check to Time-of-Useのことである。

## やり方

PostgreSQLのデフォルトである`READ COMMITTED`を使おう。  
まずは前提条件の確認として、`alice`というユーザーが登録されていることを確認しよう。

```sql
postgres=# SELECT * FROM text1.users WHERE user_name = 'alice';
 user_id | user_name |          created_at           |          updated_at           
---------+-----------+-------------------------------+-------------------------------
       1 | alice     | 2026-10-05 09:25:35.34994+00  | 2026-10-05 09:25:35.34994+00
(1 rows)
```

では、TOCTOU攻撃をしてみよう。

（セッションA）

```sql
postgres=# BEGIN;
BEGIN
postgres=*# SELECT user_name FROM text1.users WHERE user_id = 1;
 user_name 
-----------
 alice
(1 row)
```

セッションAとしては、「`alice`が存在しているので、更新しよう」となる。  
まだUPDATEしないこと。

（セッションB）

別接続で状態を更新してみる。  

> もう存在していることは確定しているのでチェックは省く。

```sql
postgres=# BEGIN;
BEGIN
postgres=*# UPDATE text1.users SET user_name = 'bob' WHERE user_id = 1;
UPDATE 1
postgres=*# COMMIT;
COMMIT
```

`alice`を`bob`に変更できた。

（セッションA）
またセッションAに戻り、ユーザー名を更新してみよう。

```sql
postgres=*# UPDATE text1.users SET user_name = 'charlie' WHERE user_id = 1;
UPDATE 1
postgres=*# COMMIT;
COMMIT
```

なんと、コミットが成功してしまったではないか！？  
セッションAのユーザーは`bob`になったユーザーを`alice`と誤認して`charlie`に変更できてしまった。  
では、これはいつまで`alice`であることをチェックし続けたらいいだろうか？  
次確認したら解決するか？また同じ事が起きたら？
次の次確認する？いつまでやればいい？

答えはない。これがTOCTOU問題である。

> 勘違いしたくないのは、あくまでセッションBでコミットしたらセッションAで読めるということだ。  
> 決して、Dirty Readが発生しているわけではない。

## 原理

```
Session A                     Session B
------------------------------------------------
SELECT id=1
→ alice

                              UPDATE id=1
                              alice → bob
                              COMMIT

「aliceだと確認済み」
という前提で処理続行
実はbobになっている。

UPDATE id=1
bob → charlie
COMMIT
```

問題なのは、チェックから実行までにタイムラグがあったことである。

## 対策

> 問題なのは、チェックから実行までにタイムラグがあったことである。

つまり、チェックと実行を同時に行えば良いのである。

```sql
UPDATE text1.users
SET updated_at = CURRENT_TIMESTAMP
WHERE user_id = 1
  AND user_name = 'alice';
```

ユーザーIDが1かつ`alice`なら変更するということにした。  
これはテーブルが複数にまたがっていてもサブクエリを使うことでいくらでも対処ができる。
