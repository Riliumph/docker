# create database

## if not exists

postgresの`create database`は`if not exists`をサポートしない。

代わりに、システムテーブルを検索して存在するかどうかを確認する必要がある。  
一つのSQLで行う場合はサブクエリを使用して確認する。

```sql
SELECT 'CREATE DATABASE <db_name>'
  WHERE NOT EXISTS (
    SELECT FROM pg_database
      WHERE  datname =  '<db_name>'  )\gexec
```

> `\gexec`パラメータは、入力したばかりのステートメントを実行し、出力を印刷する代わりに、各フィールドをSQLコマンドとしてサーバーに送信する。
