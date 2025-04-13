# Redis

Redisを試してみるリポジトリ

## NW

```console
$ docker compose exec -it redis-0 /bin/bash
$ traceroute redis-1
```

|instance|nw|IP|
|:--|:--|--:|
|redis-1|cache_nw_a|172.18.0.2|
|redis-2|cache_nw_b|172.19.0.2|
|redis-3|cache_nw_c|172.20.0.3|
|redis-4|cache_nw_a|172.18.0.3|
|redis-5|cache_nw_b|172.19.0.3|
|redis-6|cache_nw_c|172.20.0.2|

## redisへの接続

```console
$ docker compose exec -it redis-0 redis-cli -c -p 6379
```

## [Introduction to Redis Cluster](https://www.squash.io/tutorial-on-redis-docker-compose/)
