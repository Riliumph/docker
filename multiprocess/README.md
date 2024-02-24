# Docker Multi Process

Dockerは原則として、１コンテナ１プロセスである。  
なぜならば、`docker stop`コマンドからSIGTERMを送信されたときに、そのシグナルを受け取るプロセスが正しく設定されないからである。

例えば、バックグラウンドプロセスを生成するようなstartup.shを用意しても、shがシグナルを受け取ってしまい、その他のプロセスがgraceful shutdownを実装していても実行されることはない。

## supervisor daemon

そこで、`supervisord`を使ってみる。  
これは複数のプロセス（デーモン含む）を管理し、起動・停止・再起動など監視する機能を提供するソフトウェアである。

このソフトウェアはイベント通知機能も持っており、シグナルを渡すこともできる。

今回、本来ならば、sshdサーバー、apacheサーバーと複数コンテナ構成とするべきところを、１つのコンテナで２プロセス動かしてみる。

## apache2へのアクセス

```console
$ curl localhost:80
(HTML レスポンスは省略)
```

## sshdへのアクセス

```console
$ ssh root@localhost
root@localhost's password: 
```

別にログインまでする必要はない。

## 設定解説

```conf
[supervisord]
# supervisordがdaemonではなくforegroundプロセスとして振舞い、docker containerの終了を防ぐ
nodaemon=true

[program:sshd]
command=/usr/sbin/sshd -D

[program:apache2]
command=/bin/bash -c "source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND"
```

## 注意事項

Supervisorは Default設定では 、各プロセスからの標準出力を受け取りfileに書き出す設定になっている。
そのため、Supervisorを経由して各プロセスを動かす場合に、各プロセスの標準出力の内容を見る事が出来ない。
fileではなく標準出力に書き出したい場合は、stdout_logfileを/dev/fd/1に設定する必要がある。

```conf
[supervisord]
nodaemon=true

[program:elasticsearch]
command=/opt/elasticsearch/bin/elasticsearch

[program:td-agent]
command=/usr/sbin/td-agent
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
```

## 参考

- [Docker視点で見るSupervisorの使い方](https://qiita.com/taka4sato/items/1f59371ead748d88635a)
