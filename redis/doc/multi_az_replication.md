# Multi AZ Replication

マルチAZのレプリケーションはRedisの機能ではなく、AWSの機能。  
おそらく、Redisの監視エージェントとコントロールプレーンで実現されているオリジナル。

まぁ、AZなんていう概念はAWSの物だし想像は付く。

## yaml

無理にやろうとしてみたらこんな感じ？  
すべてのRedisがすべてのNWを知ってることになってるので、AZを分けるということが実現できていないけど。

```yaml
x-redis-definition: &redis_definition
  build:
    context: .
    dockerfile: Dockerfile
  restart: always


services:
  redis-0:
    <<: *redis_definition
    entrypoint: redis-cli --cluster create redis-1:6379 redis-2:6379 redis-3:6379 redis-4:6379 redis-5:6379 redis-6:6379 --cluster-replicas 1 --cluster-yes
    hostname: redis-0
    stdin_open: true
    tty: true
    networks:
      - cache_nw_a
      - cache_nw_b
      - cache_nw_c
    depends_on:
      - redis_1
      - redis_2
      - redis_3
      - redis_4
      - redis_5
      - redis_6
  redis_1:
    <<: *redis_definition
    hostname: redis-1
    networks:
      - cache_nw_a
      - cache_nw_b
      - cache_nw_c
  redis_2:
    <<: *redis_definition
    hostname: redis-2
    networks:
      - cache_nw_a
      - cache_nw_b
      - cache_nw_c
  redis_3:
    <<: *redis_definition
    hostname: redis-3
    networks:
      - cache_nw_a
      - cache_nw_b
      - cache_nw_c
  redis_4:
    <<: *redis_definition
    hostname: redis-4
    networks:
      - cache_nw_a
      - cache_nw_b
      - cache_nw_c
  redis_5:
    <<: *redis_definition
    hostname: redis-5
    networks:
      - cache_nw_a
      - cache_nw_b
      - cache_nw_c
  redis_6:
    <<: *redis_definition
    hostname: redis-6
    networks:
      - cache_nw_a
      - cache_nw_b
      - cache_nw_c
networks:
  cache_nw_a:
  cache_nw_b:
  cache_nw_c:
```
