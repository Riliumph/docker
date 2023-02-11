# Volumeのサンプル

## 使い方

### ビルド

```console
$ docker compose build
[+] Building 3.1s (5/5) FINISHED
 => [internal] load build definition from Dockerfile                 0.0s
 => => transferring dockerfile: 79B                                  0.0s
 => [internal] load .dockerignore                                    0.0s
 => => transferring context: 2B                                      0.0s
 => [internal] load metadata for docker.io/library/alpine:3.9.6      2.9s
 => CACHED [1/1] FROM docker.io/library/alpine:3.9.6@sha256:xxx      0.0s
 => exporting to image                                               0.0s
 => => exporting layers                                              0.0s
 => => writing image sha256:yyy                                      0.0s
 => => naming to docker.io/library/volume-sample-container           0.0s
```

起動コマンドに`--build`オプションも存在する。  
ただし、その場合、起動・停止を繰り返すたびにビルドを行うことになる。  
そのため、今回は別途ビルドを行うこととした。

### 起動

```console
$ docker compose up -d
[+] Running 2/2
 ⠿ Network volume_default  Created                                   0.0s
 ⠿ Container sample        Started                                   0.7s
```

> - `-d`/`--detach`  
>   デタッチモード（バックグラウンド実行）での起動

ファイルの生成

```console
$ docker attach sample
/ #
or
$ docker exec -it sample /bin/sh
/ #
# cd /mnt/share
/mnt/share # touch a
(ctrl+p,ctrl+q)
```

### 停止

```console
$ docker compose down
[+] Running 2/2
 ⠿ Container sample        Removed                                  10.4s
 ⠿ Network volume_default  Removed                                   0.3s
```
