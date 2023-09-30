# docker-entrypoint.sh

## 場所について

```console
root@db_server(10.10.10.2):/ # find / -name "docker-entrypoint.sh"
/usr/local/bin/docker-entrypoint.sh
```

## 何をするファイル？

初回起動時のみに処理したい内容を記述するヘルパースクリプトである。  
`docker-entrypoint-initdb.d`ディレクトリに番号をつけたsqlやbashのファイルを入れると順番に実行されるらしい。

```console
docker-entrypoint-initdb.d/
├── 001_create_database.sql
├── 002_create_table.sql
└── 003_insert_data.sql
```

## Docker Desktopのログを見てみる

確かに実行されている！！！！！

```console
2023-10-01 05:18:34 ********************************************************************************
2023-10-01 05:18:34 WARNING: POSTGRES_HOST_AUTH_METHOD has been set to "trust". This will allow
（省略）
2023-10-01 05:18:35 
2023-10-01 05:18:35 /usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initdb.d/001_create_database.sql
2023-10-01 05:18:35 CREATE DATABASE
2023-10-01 05:18:35 You are now connected to database "docker" as user "postgres".
2023-10-01 05:18:35 CREATE TABLE
2023-10-01 05:18:35 INSERT 0 1
2023-10-01 05:18:35 
2023-10-01 05:18:35 
2023-10-01 05:18:35 waiting for server to shut down...2023-09-30 20:18:35.555 UTC [37] LOG:  received fast shutdown request
2023-10-01 05:18:35 .2023-09-30 20:18:35.556 UTC [37] LOG:  aborting any active transactions
2023-10-01 05:18:35 2023-09-30 20:18:35.557 UTC [37] LOG:  background worker "logical replication launcher" (PID 43) exited with exit code 1
2023-10-01 05:18:35 2023-09-30 20:18:35.557 UTC [38] LOG:  shutting down
2023-10-01 05:18:35 2023-09-30 20:18:35.558 UTC [38] LOG:  checkpoint starting: shutdown immediate
2023-10-01 05:18:35 2023-09-30 20:18:35.636 UTC [38] LOG:  checkpoint complete: wrote 928 buffers (5.7%); 0 WAL file(s) added, 0 removed, 0 recycled; write=0.010 s, sync=0.064 s, total=0.079 s; sync files=306, longest=0.009 s, average=0.001 s; distance=4245 kB, estimate=4245 kB
2023-10-01 05:18:35 2023-09-30 20:18:35.640 UTC [37] LOG:  database system is shut down
2023-10-01 05:18:35  done
2023-10-01 05:18:35 server stopped
2023-10-01 05:18:35 
2023-10-01 05:18:35 PostgreSQL init process complete; ready for start up.
2023-10-01 05:18:35

```

## psqlで確認してみる

データベース（`docker`）が出来てる！！！

```console
$ docker compose exec -it db psql -U postgres
psql (15.4)
Type "help" for help.

postgres=# \l
                                                List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    | ICU Locale | Locale Provider |   Access privileges   
-----------+----------+----------+------------+------------+------------+-----------------+-----------------------
 docker    | postgres | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            | 
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            | =c/postgres          +
           |          |          |            |            |            |                 | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            | =c/postgres          +
           |          |          |            |            |            |                 | postgres=CTc/postgres
(4 rows)
```

テーブルもある！！

```console
postgres=# \c docker 
You are now connected to database "docker" as user "postgres".
docker=# \dt
         List of relations
 Schema | Name  | Type  |  Owner   
--------+-------+-------+----------
 public | users | table | postgres
(1 row)
```

当然、データも入ってる！！

```console
docker=# select * from users;
 user_id | name  |          created_at           |          updated_at           
---------+-------+-------------------------------+-------------------------------
       1 | user1 | 2023-09-30 20:23:32.966542+00 | 2023-09-30 20:23:32.966542+00
(1 row)


```
