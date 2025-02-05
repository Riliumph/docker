# home-gwサービスの使い方

home-gwサービスは、以下の要件でアクセスログを送信する

- ログ記録方式：json構造化ログ
- ログ送信方法：fluentdコンテナへvolumeマウントによるファイル共有
- ログ変更有無：fluentdでの変更なし

## ルーティングルール

```yaml
http:
  routers:
    for-home-gw:
      service: home-gw
      entryPoints:
        - web
      rule: Host(`gw.local`)
  services:
    home-gw:
      loadBalancer:
        servers:
          - url: "http://192.168.0.1"
```

リクエストURLに`gw.local`が含まれること。  
`127.0.0.1`を直接指定したり、同じ意味を持つ`localhost`を指定しても`traefik`は`gw.local`宛てのルーティングは行わない。

## 使い方

```console
$ curl http://gw.local
```

## ログ確認

### traefikログ

ログの妥当性は不明だが、空ファイルにリクエストが来て以下のログが出力された。  

> ファイルはvolumeマウントで共有しているため、どちらのコンテナに入ってもよい。

```console
$ docker compose exec -it reverse_proxy tail -1 /var/log/traefik/access.log
```

```console
$ docker compose exec -it logger tail -1 /fluentd/log/traefik/access.log
```

ログの内容

```json
{"ClientAddr":"10.10.10.1:40084","ClientHost":"10.10.10.1","ClientPort":"40084","ClientUsername":"-","DownstreamContentSize":10699,"DownstreamStatus":200,"Duration":31482552,"OriginContentSize":10699,"OriginDuration":31403291,"OriginStatus":200,"Overhead":79261,"RequestAddr":"gw.local","RequestContentSize":0,"RequestCount":41,"RequestHost":"gw.local","RequestMethod":"GET","RequestPath":"/webpages/themes/green/img/icons2.1589161109426.png","RequestPort":"-","RequestProtocol":"HTTP/1.1","RequestScheme":"http","RetryAttempts":0,"RouterName":"for-home-gw@file","ServiceAddr":"192.168.0.1","ServiceName":"home-gw@file","ServiceURL":"http://192.168.0.1","StartLocal":"2025-01-08T13:27:03.200888017Z","StartUTC":"2025-01-08T13:27:03.200888017Z","entryPointName":"web","level":"info","msg":"","time":"2025-01-08T13:27:03Z"}
```

### kibanaでの確認

|アクション|フィールド|値|
|:--:|:--|:--|
||_id|CxAYRpQBBW3uy26Y7bRD|
||_index|traefik-access-log-1970.01.01|
||_score| -|
||@timestamp|Jan 1, 1970 @ 09:33:45.000|
||ClientAddr|10.10.10.1:40084|
||ClientHost|10.10.10.1|
||ClientPort|40084|
||ClientUsername|-|
||DownstreamContentSize|10,699|
||DownstreamStatus|200|
||Duration|31,482,552|
||entryPointName|web|
||level|info|
||msg|（空）|
||OriginContentSize|10,699|
||OriginDuration|31,403,291|
||OriginStatus|200|
||Overhead|79,261|
||RequestAddr|gw.local|
||RequestContentSize|0|
||RequestCount|41|
||RequestHost|gw.local|
||RequestMethod|GET|
||RequestPath|/webpages/themes/green/img/icons2.1589161109426.png|
||RequestPort|-|
||RequestProtocol|HTTP/1.1|
||RequestScheme|http|
||RetryAttempts|0|
||RouterName|for-home-gw@file|
||ServiceAddr|192.168.0.1|
||ServiceName|home-gw@file|
||ServiceURL|<http://192.168.0.1>|
||StartLocal|Jan 8, 2025 @ 22:27:03.200|
||StartUTC|Jan 8, 2025 @ 22:27:03.200|
||tag|traefik.access|
