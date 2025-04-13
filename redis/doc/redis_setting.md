# Redisをクラスタ化する際に必要な設定一覧

- 参考
  - [Redis Cluster configuration parameters](https://redis.io/docs/management/scaling/)
  - [日本語版](http://mogile.web.fc2.com/redis/docs/manual/scaling/index.html)

> Note  
> Note that the minimal cluster that works as expected must contain at least three master nodes. For deployment, we strongly recommend a six-node cluster, with three masters and three replicas.  
> 期待通りに機能するminimal cluster は、少なくとも3つのマスタノードを含む必要があることに注意してください。デプロイには、3つのマスタと3つのレプリカを持つ、6ノードをクラスタを強くお勧めします。

## bind <ip address:port number>

Redisへ接続する制限を施す設定。

ex)

- bind 192.168.1.100 10.0.0.1  
  192.168.1.100 or 10.0.0.1からのみ接続を許可する
- bind 127.0.0.1 ::1  
  redisサーバー内からのみ接続を許可する
- bind *-::*  
  すべてのアドレスから接続を許可する

デフォルトは`bind *-::*`で全開放されているはずだが、以下のような接続エラーの時には確認すること。

```console
$ docker compose exec redis_master redis-cli --cluster create \
10.20.1.2:6379 \
10.20.1.3:6379 \
10.20.1.4:6379 \
10.20.1.5:6379 \
10.20.1.6:6379 \
10.20.1.7:6379 \
--cluster-replicas 1
Could not connect to Redis at 10.20.1.2:6379: Connection refused
```

## protected-mode <yes/no>

以下のエラーが発生したときに設定する項目。  
本当はパスワードを有効化するべきだが、個人開発なので無効化で対応する。

```
[ERR] Node 10.20.1.2:6379 DENIED Redis is running in protected mode because protected mode is enabled and no password is set for the default user. In this mode connections are only accepted from the loopback interface. If you want to connect from external computers to Redis you may adopt one of the following solutions:
1) Just disable protected mode sending the command 'CONFIG SET protected-mode no' from the loopback interface by connecting to Redis from the same host the server is running, however MAKE SURE Redis is not publicly accessible from internet if you do so. Use CONFIG REWRITE to make this change permanent.
2) Alternatively you can just disable the protected mode by editing the Redis configuration file, and setting the protected mode option to 'no', and then restarting the server.
3) If you started the server manually just for testing, restart it with the '--protected-mode no' option.
4) Setup a an authentication password for the default user. NOTE: You only need to do one of the above things in order for the server to start accepting connections from the outside.
```

## cluster-enabled <yes/no>

クラスタモードにするための根本の設定。  
yesにするとクラスタのノードとして扱われる。

## cluster-config-file <filename>

このオプションの名前にもかかわらず、これは**ユーザーが編集可能な設定ファイル**ではない。  
Redis Clusterノードがクラスター構成（基本的には状態）を変更するたびに、その構成を自動的に永続化するためのファイル。  

以下のような内容が記録される

- クラスター内の他のノード
- クラスターノードの状態
- 永続変数
- etc

このファイルは、何らかのメッセージの受信によってリライトされてディスクにフラッシュされることがよくある。

## cluster-node-timeout <milliseconds>

Redis Clusterノードが利用できなくなる最大時間。

マスターノードが指定された時間以上利用できない場合、そのノードはレプリカによってフェイルオーバーされる。  
指定された時間の大部分のマスターノードに到達できない場合、クエリを受け入れなくなる。

## cluster-replica-validity-factor <factor>

> 公式ドキュメントでは`cluster-slave-validity-factor`と書かれているが、gitのslave問題と同じで改定さている模様

レプリカのマスタ昇格係数。  
`cluster-node-timeout`と掛け合わせた時間が最大切断時間となり、その時間が経過したらレプリカがマスタに昇格する。

### 0

レプリカは常に自身を有効とみなし、即座にフェイルオーバーを実行する。

### 1以上

計算された最大切断時間が過ぎた場合に、レプリカがマスタに昇格する。  
その最大接続時間までは、仮にマスタの接続が確認できなかったとしても昇格しない。

## cluster-migration-barrier <count>

マスターが接続されたままになるレプリカの最小数。  
別のレプリカがどのレプリカでも対象にされなくなったマスタに移行する。

## cluster-require-full-coverage <yes/no>

yesに設定されている場合、クラスターはキースペースの一部がどのノードにもカバーされていない場合、書き込みを受け入れなくなります。  
オプションがnoに設定されている場合、クラスターは、キーのサブセットに関するリクエストのみが処理される場合でも、クエリを提供し続けます。

## cluster-allow-reads-when-down <yes/no>

 noに設定された場合、以下の条件を満たした場合にRedisクラスタ内のノードは全てのトラフィックの処理を停止する。

- クラスタが障害とマークされた
- ノードがマスタの定足数に足りない
- 完全なカバレッジが満たされない

これはノードがクラスター内の変更を認識していない可能性のある不整合なデータを読み取るのを防ぐ機能である。  
このオプションは、読み取りの可用性を優先し、同時に一貫性のない書き込みを防ぎたいアプリケーションにとって便利です。  
また、Redis Clusterを1つまたは2つのシャードで使用する場合にも使用できます。マスターが失敗した場合でも、ノードが書き込みを続行できるようになりますが、自動フェイルオーバーが不可能です。

## Append Only File - AOF -

Redisのデータの耐久性を保証する機能。  

### [ElastiCache](https://docs.aws.amazon.com/ja_jp/AmazonElastiCache/latest/red-ug/WhatIs.html)について

ElastiCacheを使う場合にこの機能を有効にする場合は以下の設定が必要である。

- cluster mode：Disable
- multi az mode: Disable

AOFはRedis2.8.22以降はサポートされていない。  
そのため、マルチAZは有効化した方が良い。

> - [ElastiCache for Redisのクラスターモードについて調べてみた](https://dev.classmethod.jp/articles/elasticache-cluster-mode/)
> - [イラストで理解するElastiCacheのスケーリング](https://zenn.dev/fdnsy/articles/727864f43d9e67)

## cluster-announce-port

```console
>>> Performing hash slots allocation on 6 nodes...
Master[0] -> Slots 0 - 5460
Master[1] -> Slots 5461 - 10922
Master[2] -> Slots 10923 - 16383
Adding replica redis-5:6379 to redis-1:6379
Adding replica redis-6:6379 to redis-2:6379
Adding replica redis-4:6379 to redis-3:6379
M: a46a4c9368a70bbdb0e841e776a355b82bf27587 redis-1:6379
   slots:[0-5460] (5461 slots) master
M: c981bd05662a69123ed007c075b6fb92042a2c54 redis-2:6379
   slots:[5461-10922] (5462 slots) master
M: 804d65112a69909eb997399b0f90a804febf7621 redis-3:6379
   slots:[10923-16383] (5461 slots) master
S: f4a31a380461b6c7579a2963b3c43754d4f32eeb redis-4:6379
   replicates 804d65112a69909eb997399b0f90a804febf7621
S: 2a204b45377db43ac10d58289a5a9f45ee716421 redis-5:6379
   replicates a46a4c9368a70bbdb0e841e776a355b82bf27587
S: ab139050f0d1524200da07760e7bd53521e1a938 redis-6:6379
   replicates c981bd05662a69123ed007c075b6fb92042a2c54
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join
```
