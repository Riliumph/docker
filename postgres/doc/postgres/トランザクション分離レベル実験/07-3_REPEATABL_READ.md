# REPEATABLE READ

COMMITされたトランザクションAの追加をトランザクションBが参照できる。

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

コンソールを二つ用いる。  
分かりにくければ、ユーザを二つ用意してもよい。

以下のタイムテーブルで実行していく。

手順|A|B
:--:|:--|:--
1|1.トランザクション開始|2.トランザクション開始|
2||3.データ更新|
3|4.Dirty Read確認|
4||5.コミット
5|4.Fuzzy Read確認|
6|5.Phantom Read確認1
7||6.トランザクション開始＆データ追加＆コミット|
8|7.Phantom Read確認2|
9|トランザクション終了|トランザクション終了|

#### トランザクション開始

```console
tran_test=*# BEGIN　ISOLATION LEVEL READ COMMITTED;
BEGIN
```

#### データ更新

```console
tran_test=*# UPDATE player_coin SET quantity=quantity+500 WHERE id = 1;
UPDATE 1
```

続いてデータを確認する。  
当然、同じトランザクションの中なのでデータは反映されている。

```console
tran_test=*# SELECT * FROM player_coin;
 id | player_id | quantity
----+-----------+----------
  2 |         2 |     1000
  1 |         1 |     1500 <- 1000 から 1500 に変化
(2 rows)
```

#### Dirty Read確認

トランザクションBの処理は未コミットである。  
トランザクションA側で未コミット処理が読み込まれているかを確認する。

Dirty Readは発生していない。

```console
tran_test=*# SELECT * FROM player_coin;
 id | player_id | quantity
----+-----------+----------
  1 |         1 |     1000
  2 |         2 |     1000 <- 1000のまま保持されている
(2 rows)
```

#### コミット

トランザクションBのデータ変更を確定させる。

```console
tran_test=*# commit;
COMMIT
```

#### Fuzzy Read確認

未コミットのデータが見えてしまうDirty Readは発生していなかった。  
コミット済のデータが見えてしまうFuzzy Readは発生しているのか？

トランザクションAで再度データの確認を行うと、コミット結果が反映されていることが確認できる。

Fuzzy Readは発生している。

```console
tran_test=*# select* from player_coin;
 id | player_id | quantity
----+-----------+----------
  2 |         2 |     1000
  1 |         1 |     1500 <- トランザクションBのコミット結果が反映されている
(2 rows)
```

#### Phantom Read確認1

データを追加する前のプレイヤー数と所持金の合計を確認する。

```console
tran_test=*# SELECT COUNT(id), SUM(quantity) FROM player_coin;
 count | sum
-------+------
     2 | 2500
(1 row)
```

#### データ追加＆コミット

```console
tran_test=# BEGIN ISOLATION LEVEL READ COMMITTED;
BEGIN
tran_test=*# INSERT INTO player_coin (player_id, quantity) VALUES (3, 1000);
INSERT 0 1
tran_test=*# SELECT * FROM player_coin;
 id | player_id | quantity
----+-----------+----------
  2 |         2 |     1000
  1 |         1 |     1500
  3 |         3 |     1000
(3 rows)
tran_test=*# COMMIT;
COMMIT
```

#### Phantom Read確認2

データを追加したトランザクションBがコミットした後、再度プレイヤー数と所持金の合計を確認する。

```console
tran_test=*# select count(id), sum(quantity) from player_coin;
 count | sum  
-------+------
     3 | 3500
(1 row)
```

変わっている。  
Phantom Readが確認できた。

### MySQLでは

MySQLでは、MultiVersion Concurrency Controlという技術でPhantom Readを防止している。
