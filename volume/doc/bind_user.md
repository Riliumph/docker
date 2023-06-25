# bind user コンテナの使い方

## 接続方法

```console
$ docker compose exec -it bind-user-service /bin/bash
dockeruser@84aa3683ca24:/mnt/bind$ 
```

## 環境変数を変えたら？

UID/GIDを1001にしてみる。  

```.env
UID=1001
GID=1001
USERNAME=dockeruser
```

基本的にホストは1000だと思うので、それだとファイルは作れるのか？

```bash
# bindの権限は1000で作られている。
dockeruser@84aa3683ca24:/mnt$ ls -la
total 16
drwxr-xr-x 1 root root 4096 Jun 18 14:28 .
drwxr-xr-x 1 root root 4096 Jun 18 15:09 ..
drwxr-xr-x 4 1000 1000 4096 Jun 18 15:18 bind

dockeruser@84aa3683ca24:/mnt/bind$ touch bind_user.txt
touch: cannot touch 'bind_user.txt': Permission denied
```

残念ながら作れない。
