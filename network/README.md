# Volumeのサンプル

## 使い方

### ビルド

```console
$ docker compose build
[+] Building 0.0s (0/2)
[+] Building 0.0s (0/0)
[+] Building 2.9s (7/7) FINISHED
[+] Building 0.1s (2/3)
[+] Building 0.5s (6/6) FINISHED
[+] Building 0.5s (6/6) FINISHED
```

起動コマンドに`--build`オプションも存在する。
ただし、その場合、起動・停止を繰り返すたびにビルドを行うことになる。
そのため、今回は別途ビルドを行うこととした。

### 起動

```console
$ docker compose up -d
[+] Running 5/5
 ✔ Network network_nw1  Created         0.0s
 ✔ Network network_nw2  Created         0.0s
 ✔ Container vm2        Started         0.8s
 ✔ Container vm1        Started         1.0s
 ✔ Container vm3        Started         0.7s
```

> - `-d`/`--detach`
>   デタッチモード（バックグラウンド実行）での起動

### 停止

```console
$ docker compose down
```

### 再起動に失敗した場合

yamlなどの修正を行って再起動する場合に、IPアドレスが競合してビルドに失敗することがある。  
その場合、以下のコマンドで

```console
$ docker system prune
WARNING! This will remove:
  - all stopped containers
  - all networks not used by at least one container
  - all dangling images
  - all dangling build cache

Are you sure you want to continue? [y/N] y
Deleted build cache objects:
aaa
bbb
ccc
ddd

Total reclaimed space: 324B
```
