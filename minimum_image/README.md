# 小さなイメージは何がいい？

- [Alpine Linux](https://hub.docker.com/_/alpine)
- [Debian Slim](https://hub.docker.com/_/debian/)
- [Distroless Debian11](gcr.io/distroless/static-debian11)

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

### 停止

```console
$ docker compose down
[+] Running 2/2
 ⠿ Container sample        Removed                                  10.4s
 ⠿ Network volume_default  Removed                                   0.3s
```

## 結果

かなり軽量のイメージが作られている。

```console
$ docker images
REPOSITORY                   TAG             IMAGE ID       CREATED        SIZE
alpine_vs_slim-debian-slim   latest          66a4e8250ca3   12 days ago    80.5MB
alpine_vs_slim-busybox       latest          f16ad373a391   2 weeks ago    4.86MB
alpine_vs_slim-alpine        latest          54ad2d79d2d3   3 years ago    5.55MB
alpine_vs_slim-distroless    latest          bbf1fcf4fc9f   53 years ago   20.4MB
```
