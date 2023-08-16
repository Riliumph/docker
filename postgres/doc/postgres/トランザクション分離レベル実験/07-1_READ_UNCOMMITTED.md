# READ UNCOMMITTED

最も分離性が低い。

COMMITされていないトランザクションAの変更をトランザクションBが参照できる。  
しかし、トランザクションの実行制御を行わないため性能は良い。

> PostgreSQLにおいて、`READ COMMITTED`=`READ UNCOMMITTED`である
> [SET TRANSACTION](https://www.postgresql.jp/document/15/html/sql-set-transaction.html)

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

コンソールを二つ用いる。  
分かりにくければ、ユーザを二つ用意してもよい。

以下のタイムテーブルで実行していく。

手順|A|B
:--:|:--|:--
1|1.トランザクション開始|2.トランザクション開始|
2||3.データ更新|
3|4.Dirty Read確認||
4|トランザクション終了|4.コミット＆トランザクション終了|

#### トランザクション開始

```console
tran_test=# BEGIN;
BEGIN
tran_test=*# SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET
```

> 次回以降は`BEGIN`にトランザクション分離レベルを設定する

#### データ更新

```console
tran_test=*# UPDATE player_coin SET quantity=quantity+500 WHERE id = 1;
UPDATE 1
```

クライアントBが張ったトランザクションの中でクライアントBがデータを確認する。  
当然ながら、正しくデータが見れる。

```console
tran_test=*# select* from player_coin;
 id | player_id | quantity
----+-----------+----------
  2 |         2 |     1000
  1 |         1 |     1500 <- 正常に1000から1500に更新された
(2 rows)
```

#### Dirty Read確認

クライアントAも既にトランザクション中である。  
この状態でデータを確認すると、なぜかトランザクションB中で更新したデータが見れてしまうDirty Readが発生する。

ただし、PostgreSQLでは`READ UNCOMMITTED`と`READ COMMITTED`が同じ扱いである。  
よって、トランザクションBでの変更は見れない。

```console
tran_test=*# select * from player_coin;
 id | player_id | quantity
----+-----------+----------
  1 |         1 |     1000
  2 |         2 |     1000 <- 1000のまま保持されている
(2 rows)
```
