# Redis

Redisを試してみるリポジトリ

## redisへの接続

```console
$ docker exec -it redis-redis-master-1 redis-cli -c -p 6379
```

## [Introduction to Redis Cluster](https://www.squash.io/tutorial-on-redis-docker-compose/)

## Clusterへ指定するIPアドレスの確認

```console
$ docker network inspect redis_cache_nw | jq '.[0].Containers | .[].IPv4Address'
"10.20.1.2/24"
"10.20.1.3/24"
"10.20.1.4/24"
"10.20.1.5/24"
"10.20.1.6/24"
"10.20.1.7/24"
```

## Clusterの立ち上げ方

`reids-master`サービスにクラスター構築コマンドを投入

> サービスじゃなくて、コンテナ指定だったらクラスターのどのコンテナを指定しても実施されるのか要確認

```console
$ docker compose exec redis_master redis-cli --cluster create \
10.20.1.2:6379 \
10.20.1.3:6379 \
10.20.1.4:6379 \
10.20.1.5:6379 \
10.20.1.6:6379 \
10.20.1.7:6379 \
--cluster-replicas 1 \
--cluster-yes
>>> Performing hash slots allocation on 6 nodes...
Master[0] -> Slots 0 - 5460
Master[1] -> Slots 5461 - 10922
Master[2] -> Slots 10923 - 16383
Adding replica 10.20.1.6:6379 to 10.20.1.2:6379
Adding replica 10.20.1.7:6379 to 10.20.1.3:6379
Adding replica 10.20.1.5:6379 to 10.20.1.4:6379
M: 743ffa3d38026f9698cf9f3fe33f5d35bb7abb29 10.20.1.2:6379
   slots:[0-5460] (5461 slots) master
M: 0ccd58efeebbd79774229da9d94824e0d28ee1a0 10.20.1.3:6379
   slots:[5461-10922] (5462 slots) master
M: 84e5b5f80d6962d9e6d6b80010cf050104906336 10.20.1.4:6379
   slots:[10923-16383] (5461 slots) master
S: 6a8376f5b6ca14689f25892de16c15aff54c737c 10.20.1.5:6379
   replicates 84e5b5f80d6962d9e6d6b80010cf050104906336
S: d547428bda478bc3b6550402c350309cfa910a29 10.20.1.6:6379
   replicates 743ffa3d38026f9698cf9f3fe33f5d35bb7abb29
S: 0c0a056178a30e99ecfabd90b99ccb1fe1174869 10.20.1.7:6379
   replicates 0ccd58efeebbd79774229da9d94824e0d28ee1a0
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join
...
>>> Performing Cluster Check (using node 10.20.1.2:6379)
M: 743ffa3d38026f9698cf9f3fe33f5d35bb7abb29 10.20.1.2:6379
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
M: 84e5b5f80d6962d9e6d6b80010cf050104906336 10.20.1.4:6379
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
S: 0c0a056178a30e99ecfabd90b99ccb1fe1174869 10.20.1.7:6379
   slots: (0 slots) slave
   replicates 0ccd58efeebbd79774229da9d94824e0d28ee1a0
M: 0ccd58efeebbd79774229da9d94824e0d28ee1a0 10.20.1.3:6379
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
S: 6a8376f5b6ca14689f25892de16c15aff54c737c 10.20.1.5:6379
   slots: (0 slots) slave
   replicates 84e5b5f80d6962d9e6d6b80010cf050104906336
S: d547428bda478bc3b6550402c350309cfa910a29 10.20.1.6:6379
   slots: (0 slots) slave
   replicates 743ffa3d38026f9698cf9f3fe33f5d35bb7abb29
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```

> `--cluster-yes`オプションを付けないと対話式プロンプトでyesを入力する必要がある。  
> 自動化の邪魔なので、このオプションは忘れないように
