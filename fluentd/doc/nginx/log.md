# nginxのログ

## logrotateの設定

`/etc/logrotate.d/nginx`に以下のローテーション設定が書かれている。  
nginxの処理としてローテーションしているのではなく、Linuxのlogrotate機能を使っている。

```conf
/var/log/nginx/*.log {
        daily
        missingok
        rotate 52
        compress
        delaycompress
        notifempty
        create 640 nginx adm
        sharedscripts
        postrotate
                if [ -f /var/run/nginx.pid ]; then
                        kill -USR1 `cat /var/run/nginx.pid`
                fi
        endscript
}
```

## 構造化ログがすべて文字列なのは意図的？

- [NginxのアクセスログをJSON形式で出力する](https://qiita.com/progrhyme/items/c85d28eb18359f3f50d9)

```conf
log_format structured_log escape=json '{'
'"remote_addr": "$remote_addr",'
'"remote_user": "$remote_user",'
'"time_local": "$time_local",'
'"request": "$request",'
'"status": "$status",'
'"body_bytes_sent": "$body_bytes_sent",'
'"http_referer": "$http_referer",'
'"http_user_agent": "$http_user_agent",'
'"http_x_forwarded_for": "$http_x_forwarded_for"'
'}'
access_log /var/log/nginx/access.log structured_log
```

`"$time_local"`など、本来はUTCの数値で管理されるデータがある。  
しかし、すべての項目が文字列としてログになっている。

これは値が取れなかった際にパースエラーとなってしまい、他の項目すらログに残らないことをケアするためである。

## ログ内容に「"」が含まれる

- [nginx でアクセスログを JSON フォーマットにする場合は「escape=json」を設定する](https://kakakakakku.hatenablog.com/entry/2019/11/25/134646)

```conf
log_format structured_log escape=json '{'
...
```

このjsonのように文字コード出力になる問題が

```json
{
   "http_user_agent": "hoge\x22hoge",
}
```

エスケープされて見やすくなる。

```json
{
   "http_user_agent": "hoge\"hoge",
}
```

## syslogを使う

> [syslog](https://ja.wikipedia.org/wiki/Syslog)  
> syslogとは、ログメッセージをIPネットワーク上で転送する標準規格のこと。  
> System Logging Protocolの略称とされており、プロトコルからシステムに対してまで幅広い文脈で使用される。  
> `Facility`はログの種類、`Severity`はログの重要度を示すことが大きな構成要素として存在する。

NginxでFluentdサーバーへの転送を行う場合に使用する。  
Dockerを使っているとマウントが簡単なのでお世話にならなかったりもする。

```conf
server {
    listen       80;
    listen  [::]:80;
    server_name  service-b;
    # "log_type" "destination" "log_format_name"の書式を取る。
    # "destination"にファイルを使う場合は、"/xxx"の書式を取る。
    # access_log /var/log/nginx/access.log main;
    # "destination"にsyslogを使う場合は、"syslog:server=HOST:PORT"の書式を取る。
    access_log syslog:server=logger:24224,tag=service_b_access main;
    ... ... ...
    ... ...
    ...
}
```

### syslogのタグには文字制約がある

> nginx: [emerg] syslog "tag" only allows alphanumeric characters and underscore in /etc/nginx/conf.d/default.conf:21

syslogタグはアルファベットとアンダースコアしか認められていない。  
ドットでつなぐなどはできないので注意
