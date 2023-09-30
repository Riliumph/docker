# postgresの実行について

> 実行確認は`compose`せずに単体で確かめる

## 公式イメージの実行命令について

Postgres公式イメージの実行コマンドは以下である。

- `ENTRYPOINT ["docker-entrypoint.sh"]`
- `CMD ["postgres"]`

`postgres`コマンドがデフォルトで実行されることでpostgresサーバーは実行される。

以下のようなログが出てターミナルは返ってこない。

つまり、そもそもターミナルに接続できるような物ではない。  
この設定が有効になるのは、以下のようにCMDの内容を対話シェルで上書きした場合のみである。  

> この`run`ではpostgresは当然動かない。

```console
$ docker run -it --rm postgres-db /bin/bash
```

## postgresサーバーを実行するには

デフォルト実行により`postgres`コマンドが実行されることでサーバーは立ち上がる。

```console
$ docker run --rm postgres-db
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.

fixing permissions on existing directory /var/lib/postgresql/data ... ok
creating subdirectories ... ok
selecting dynamic shared memory implementation ... posix
selecting default max_connections ... 100
selecting default shared_buffers ... 128MB
selecting default time zone ... UTC
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... sh: locale: not found
ok
syncing data to disk ... ok
```

### プロセスの確認

別のターミナルでログインしてプロセスを確認してみる。

```console
$ docker exec -it <container-name> /bin/bash
root@db-server(172.17.0.2):/ # ps aux
PID   USER     TIME  COMMAND
    1 postgres  0:00 postgres
   49 postgres  0:00 postgres: checkpointer
   50 postgres  0:00 postgres: background writer
   52 postgres  0:00 postgres: walwriter
   53 postgres  0:00 postgres: autovacuum launcher
   54 postgres  0:00 postgres: logical replication launcher
   57 root      0:00 /bin/bash
   65 root      0:00 ps aux
```

PID=1が`postgres`であることが確認できる。

### docker runの-itオプションの有無について

`run`時のターミナルは`postgres`が占有する。  
そもそも対話シェルが実行されないため、`it`オプションが意味を持たない。  

以下のように、PID=1に`bash`を実行したい時ぐらいしか意味がない。

```console
$ docker run -it --rm postgres-db /bin/bash
root@9198afc79494(172.17.0.2):/ # ps aux
PID   USER     TIME  COMMAND
    1 root      0:00 /bin/bash
    8 root      0:00 ps aux
```

> そして、この実行では当然`postgres`が実行されていないのでDBは動き出さない
