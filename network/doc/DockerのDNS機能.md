# DockerのDNS機能

Dockerはhostnameによってホスト名をつけられる。  
このホスト名によって通信もできるわけだが、ホスト名で通信できるということは必ずDNSサーバーが存在しなければならない。  
では、DNSサーバーはどこに存在するのか？

## Service Discovery機能

DockerにおけるDNSサーバー機能をService Discovery機能と呼ぶらしい。  
簡単に言うと、Docker Daemon内でDNSを代替する機能がある。  
そして、コンテナネットワークでは、この機能がDNSとして振舞って名前解決をしてくれる。

## nameserverの在処

`client`の中にログインして、`resolve.conf`を見てみよう。

```console
root@client(10.10.0.2):/ # cat /etc/resolv.conf
nameserver 127.0.0.11
options ndots:0
```

`nameserver`が`127.0.0.11`であることが示されている。

## ホスト名で相手を調べてみる

本題のホスト名`server`を調べてみる。

```console
root@client(10.10.0.2):/ # nslookup server
Server:         127.0.0.11
Address:        127.0.0.11#53

Non-authoritative answer:
Name:   server
Address: 10.10.0.3
```

nameserverを使った結果、非権威サーバーから応答があった。  
`server`というホストのアドレスは`10.10.0.3`であるという回答だ。

> `Non-authoritative answer`：非権威的応答

## 参考

- [Dockerのコンテナ間の名前解決方法が気になったので確認してみた](https://dev.classmethod.jp/articles/docker-service-discovery/)
