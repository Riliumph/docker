# bind root コンテナの使い方

## 接続方法

```console
$ docker compose exec -it bind-root-service /bin/bash
root@ae897fe51bf8:/mnt/bind# 
```

## 実験

```teminal
root@ae897fe51bf8:/mnt/bind# touch bind_root.txt
```

```terminal
(host)$ ll
total 24K
drwxr-xr-x 3 riliumph riliumph 4.0K 23-06-19 00:10:59 doc/
drwxr-xr-x 2 riliumph riliumph 4.0K 23-06-18 23:47:54 dockerfiles/
-rw-r--r-- 1 riliumph riliumph   38 23-06-18 23:10:39 .env
-rw-r--r-- 1 riliumph riliumph 6.2K 23-06-19 00:10:13 README.md
-rw-r--r-- 1 root     root        0 23-06-19 00:18:23 bind_root.txt
-rw-r--r-- 1 riliumph riliumph 1.2K 23-06-18 23:30:47 docker-compose.yaml
```

ホストから見てもuid=0のrootユーザで作られていることが確認できる。
