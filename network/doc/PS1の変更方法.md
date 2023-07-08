# PS1

## IPアドレスをPS1に表示するには

### hostnameを使う方法

```console
$ hostname -i
```

ただし、ホストに複数のNIC（ループバックを除く）が設定されている場合は`awk`で任意の場所を取る必要がある。

### ipを使う方法

```console
$ ip -4 route show default | awk '{print \$3}'
```

`ip`コマンドの部分を解説する。  
まず、`ip`コマンドとは`iproute2`でインストールされるネットワークコマンドである。従来の`ifconfig`を代替する。

- `ip`
  - `-4`: ipv4情報を表示する
  - `route show default`: デフォルトゲートウェイの情報を表示する
- `awk {print $3}`: スペースで区切られた3番目の情報を抽出する。

## 注意点

dockerfile内で以下のような記述をするとうまく動かない

```dockefile
FROM ubuntu

RUN apt-get update && apt-get install -y iproute2
RUN "export CONTAINER_IP=$(ip -4 route show default | awk '{print $3}')" >> ~/.bashrc
```

これは、コンテナイメージをビルドする際に`bashrc`へ書き込む処理である。  
しかし、IPアドレスはcomposeによって立ち上げられる際に割り振られる。  
まだ決まってもいないIPアドレスを`bashrc`へ書き込んでしまっている。

静的な処理ではなく、動的な処理としてPS1へ書き込む必要がある。
