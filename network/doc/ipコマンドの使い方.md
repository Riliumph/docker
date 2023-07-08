# ipコマンドの使い方

```console
root@client:/$ ip address
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
237: eth0@if238: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:ac:13:00:03 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.19.0.3/16 brd 172.19.255.255 scope global eth0
       valid_lft forever preferred_lft forever
```

## IFステータス

- LOOPBACK: ループバックIFであることを示す
- BROADCAST: ブロードキャストアドレスにパケットを送ることができる
- MULTICAST: マルチキャストアドレスにパケットを送ることができる
- UP: IFがアクティブであることを示す
- LOWER_UP: IFの物理的な接続が確立されていることを示す

## プロパティ

- mtu バイト数: 最大パケットサイズのバイト数を示す
- ddisc 状態: qdiscのスケジューラ。色々ある
- state UP: IFが作動中であることを示す
- group default: グループIF
- qlen バイト数: キューの長さ
- link: macアドレスの表示
  - ether macアドレス
  - loopback macアドレス
- brd アドレス: ブロードキャストアドレス
- inet/inet6: IPv4/6のアドレスを示す
- scope:
  - global: 送信先はグローバル
  - link: ローカルネットワーク内
  - host: 自身のみ
- valid_lft: IPアドレスの有効期限
  - forever
  - xxx sec
- preferred_lft: 適切なIPアドレスの有効期限
