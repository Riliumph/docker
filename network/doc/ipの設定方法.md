# IPアドレスの設定方法

`docker-compose.yaml`としてネットワークを構築して、コンテナに割り当てた。

```yaml
version: '3.8'
services:
  s1_in_nw1:
    container_name: client_in_nw1
    hostname: client
    networks:
      seg3nw:
        ipv4_address: 10.10.10.10
```

```console
$ docker compose exec -it vm1-1 /bin/bash
root@client:/# ip address
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
100: eth0@if101: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:0a:0a:0a:0a brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.10.10.10/24 brd 10.10.10.255 scope global eth0
       valid_lft forever preferred_lft forever
```

期待通り`eth0`のNICに`10.10.10.10/24`が割り当てられていることがわかる。  

## IPアドレスを付与するのは誤り

サブネットを指定して、その中であればDocker側にIPアドレスの管理を任せるべきだ。  
なぜなら、IPアドレスの競合などを`docker-compose.yaml`で管理したくないからだ。  
システムが勝手に競合管理して自動で付与してくれるなら、これほど便利なのものはない。

しかし、`hostname`に値を入れてホスト名は固定化されるべきである。  
そして、ホスト名を使ってネットワーク間のやり取りが行われた方が人間にとって分かりやすい。
