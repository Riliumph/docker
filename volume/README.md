# Volumeのサンプル

## 使い方

### ビルド

```console
$ docker compose build
[+] Building 0.0s (0/2)
[+] Building 0.0s (0/1)
[+] Building 0.2s (2/3)
 => [internal] load .dockerignore                                                                                                                 0.0s
 => => transferring context: 2B                                                                                                                   0.0s
 => [internal] load build definition from bind_user.Dockerfile                                                                                    0.0s
 => => transferring dockerfile: 299B                                                                                                              0.0s
[+] Building 0.8s (6/6) FINISHED
 => [internal] load build definition from volume.Dockerfile                                                                                       0.0s
 => => transferring dockerfile: 113B                                                                                                              0.0s
 => [internal] load .dockerignore                                                                                                                 0.0s
 => => transferring context: 2B                                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/debian:stable-slim                                                                             0.8s
[+] Building 0.8s (7/7) FINISHED
 => [internal] load .dockerignore                                                                                                                 0.0s
 => => transferring context: 2B                                                                                                                   0.0s
 => [internal] load build definition from bind_user.Dockerfile                                                                                    0.0s
 => => transferring dockerfile: 299B                                                                                                              0.0s
 => [internal] load metadata for docker.io/library/debian:stable-slim                                                                             0.8s
 => [1/2] FROM docker.io/library/debian:stable-slim@sha256:xxx                                                                                    0.0s
 => CACHED [2/3] WORKDIR /mnt/bind                                                                                                                0.0s
 => CACHED [3/3] RUN groupadd -g "1001" "dockeruser" &&    useradd -l -u "1001" -g "1001" "dockeruser" &&    chown -R "dockeruser" "/mnt/bind"    0.0s
 => exporting to image                                                                                                                            0.0s
 => => exporting layers                                                                                                                           0.0s
 => => writing image sha256:xx                                                                                                                    0.0s
[+] Building 0.3s (6/6) FINISHED
 => [internal] load build definition from bind_root.Dockerfile                                                                                    0.0s
 => => transferring dockerfile: 114B                                                                                                              0.0s
 => [internal] load .dockerignore                                                                                                                 0.0s
 => => transferring context: 2B                                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/debian:stable-slim                                                                             0.3s
 => [1/2] FROM docker.io/library/debian:stable-slim@sha256:xxx                                                                                    0.0s
 => CACHED [2/2] WORKDIR /mnt/bind                                                                                                                0.0s
 => exporting to image                                                                                                                            0.0s
 => => exporting layers                                                                                                                           0.0s
 => => writing image sha256:xxx                                                                                                                   0.0s
 => => naming to docker.io/library/volume-bind-root-service                                                                                       0.0s
```

起動コマンドに`--build`オプションも存在する。
ただし、その場合、起動・停止を繰り返すたびにビルドを行うことになる。
そのため、今回は別途ビルドを行うこととした。

### 起動

```console
$ docker compose up -d
[+] Running 5/5
 ✔ Network volume_default  Created                                                                                                               0.0s
 ✔ Volume "ex-storage"     Created                                                                                                               0.0s
 ✔ Container b-user-c      Started                                                                                                               0.8s
 ✔ Container v-root-c      Started                                                                                                               0.8s
 ✔ Container b-root-c      Started                                                                                                               0.8s
```

> - `-d`/`--detach`
>   デタッチモード（バックグラウンド実行）での起動

### 停止

```console
$ docker compose down
[+] Running 2/2
 ⠿ Container sample        Removed                                  10.4s
 ⠿ Network volume_default  Removed                                   0.3s
```
