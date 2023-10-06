# create schema

postgresは以下の階層を持っている

- Database
  - Schema
    - Table

MySQLなどと階層構造が違うので`create schema`は使わないようにする。  
デフォルトスキーマは`public`になっている。

MySQLなどは

- Database(Schema)
  - Table

で、`create schema` = `create database`である。
