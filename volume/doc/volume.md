# Volume

Dockerにおけるファイル永続化は２種類

- bind mount
- volume mount

![](./img/volume.drawio.png)

---

## Bind Mount

Dockerホストのファイルシステムの一部に直接ファイルを保存方法。  
Dockerfileでは制御できないので、docker-composeファイルもしくはコマンドオプションで対応する。

```console
$ docker container run --name test -it --rm --mount type=bind,src=$HOME,dst=/usr/share/host ubuntu:latest bash
```

> `--mount`オプションはDocker17からサポートされた  
> `-v`オプションは極力使わないように書いていく

### Bindマウントの特徴

ホストにファイルとして保存されることである。  

- コンテナが破棄されても維持されてほしい
- ホストで共有しているファイルを操作したい場合
- 変更されたファイルを、ホスト・コンテナ間でリアルタイム同期したい場合

具体的には、`httpd`や`postgres`などの設定ファイルがそれにあたる。  
ホストのgitで管理したいがために、ホストにファイルとして保存されてほしいし、ホストで編集した内容がコンテナに同時に反映されてほしい。

---

## Volume Mount

Dockerのデータ領域の中にファイルを保存する方法。  

別途、docker volumeの構築する場合

```console
$ docker volume create test-volume
test-volume
```

docker containerにマウント指示

```console
$ docker container run --name test -it --rm --mount type=volume,src=test-volume,dst=/usr/share/host ubuntu:latest bash
```

### Volumeマウントの特徴

コンテナ外からファイルを操作出来ないことに尽きる。

> 下記でVolumeも結局はホストのどこかに保存される旨が示される。  
> しかし、そのファイルはDocker Engineによって守られているため、外部からは何のファイルか分かったものではない。

- コンテナが破棄されても維持されてほしい
- ホストから切り離してコンテナ専用の空間を作りたい
- しかし、オーケストレーションなどの新規コンテナには反映されてほしい

具体的には、`postgres`などのDBデータなどがそれにあたる。

### Dockerのデータ領域とは？

「Dockerのデータ領域の中に」などと大袈裟に言っているが、結局はホストのファイルシステムのどこかに保存しないと永続化できない。  
コマンドでパスを確認すると、`/var/lib/docker/volumes`下にボリューム名のディレクトリが切られていて中に保存されているのが確認できる。

```console
$ docker volume inspect test-volume
[
    {
        "CreatedAt": "2023-01-05T09:19:19Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/test-volume/_data",
        "Name": "test-volume",
        "Options": {},
        "Scope": "local"
    }
]
```

#### Windowsの場合

WindowsのDocker Desktop(WSL2)の場合、`/var/lib/docker`なるパスは存在しない。

```console
$ ll /var/lib | grep docker
drwxr-xr-x  2 root      root      4.0K 22-10-10 21:06:48 docker-desktop/
```

Windowsのファイルシステムから`/var/lib/docker/`は`\\wsl.localhost\docker-desktop-data\data\docker\volumes`にマップされている。  
WSL2上のLinuxから見る方法はない模様。  
DockerDesktopはWSL上のLinuxからはdockerとして見えているので、docker経由では確認出来る。

```console
$ docker volume ls
DRIVER    VOLUME NAME
local     test-volume
```
