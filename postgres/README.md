# postgresの遊び場

## ビルド方法

```console
 docker compose up -d --build
[+] Building 3.0s (7/7) FINISHED
 => [internal] load build definition from db.dockerfile                     0.0s
 => => transferring dockerfile: 227B                                        0.0s
 => [internal] load .dockerignore                                           0.0s
 => => transferring context: 2B                                             0.0s
 => [internal] load metadata for docker.io/library/postgres:15-alpine       2.9s
 => [auth] library/postgres:pull token for registry-1.docker.io             0.0s
 => [1/2] FROM docker.io/library/postgres:15-alpine@sha256:xxx              0.0s
 => CACHED [2/2] RUN echo "PS1='\u@\h($(hostname -i)):\w \$ '" >> ~/.bashrc 0.0s
 => exporting to image                                                      0.0s
 => => exporting layers                                                     0.0s
 => => writing image sha256:xxx                                             0.0s
 => => naming to docker.io/library/postgres-db                              0.0s
[+] Running 2/2
 ✔ Network postgres_db_nw   Created                                        0.0s
 ✔ Container postgres-db-1  Started                                        0.5s
 ```

## コンテナへ入る方法

```console
$ docker compose exec -it db /bin/bash
root@db_server(10.10.10.2):/ #
```

## DBへの接続

```console
$ docker compose exec -it db psql -U postgres -d postgres
```

### スキーマの確認

```console
postgres=# \dn
```
