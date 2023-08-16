# SERIALIZABLE

同時に最大1つまでのトランザクションしか存在しないのと等価であるレベル。

> MySQLでのデフォルトのトランザクション分離レベルらしい。

## 実験

### 初期状態

```console
$ docker compose up -d
[+] Running 1/1
 ✔ Container postgres-db-1  Started
```

```console
postgres=# \c tran_test
You are now connected to database "tran_test" as user "postgres".
```

[init.sql](./init.sql)を実行してDBを初期化する。

今のトランザクション分離レベルを確認する。  

```console
tran_test=# SHOW TRANSACTION ISOLATION LEVEL;
 transaction_isolation 
-----------------------
 read committed
(1 row)
```

デフォルトは`read committed`の模様。  

### 実験開始
