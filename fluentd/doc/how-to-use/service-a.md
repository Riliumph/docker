# 使い方

## ルーティングルール

```yaml
      labels:
        - "traefik.enable=true"
        - "traefik.http.routers.for-service-a.rule=PathPrefix(`/service-a`)"
        - "traefik.http.routers.for-service-a.entrypoints=web"
```

リクエストURLに`/service-a`が含まれていること

## サービスAへのアクセス

```console
$ curl http://localhost/service-a.html
```

## traefikログの確認

```console
$ trafik/log/access.log
```

```json
{
  "ClientAddr": "10.10.10.1:36530",
  "ClientHost": "10.10.10.1",
  "ClientPort": "36530",
  "ClientUsername": "-",
  "DownstreamContentSize": 19,
  "DownstreamStatus": 404,
  "Duration": 66095,
  "GzipRatio": 0,
  "OriginContentSize": 0,
  "OriginDuration": 0,
  "OriginStatus": 0,
  "Overhead": 66095,
  "RequestAddr": "localhost",
  "RequestContentSize": 0,
  "RequestCount": 3,
  "RequestHost": "localhost",
  "RequestMethod": "GET",
  "RequestPath": "/favicon.ico",
  "RequestPort": "-",
  "RequestProtocol": "HTTP/1.1",
  "RequestScheme": "http",
  "RetryAttempts": 0,
  "StartLocal": "2024-10-26T08:48:42.285915864Z",
  "StartUTC": "2024-10-26T08:48:42.285915864Z",
  "entryPointName": "web",
  "level": "info",
  "msg": "",
  "time": "2024-10-26T08:48:42Z"
}
```

> Weight Round Robin (wrr)

特定のサービスが呼び出されたことが分かる。

## nginxログの確認

Docker Desktopの`service-a`サービスに以下のログが表示される。

```log
2024-10-26 17:48:42 10.10.10.3 - - [26/Oct/2024:08:48:42 +0000] "GET /service-a.html HTTP/1.1" 200 9 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:131.0) Gecko/20100101 Firefox/131.0" "10.10.10.1"
```

このログが`fluentd`によって成形されて、`logger`サービスに以下のログが表示される。

### loggerサービス

Docker Desktopの`logger`サービスに以下のログが表示される。

```json
2024-10-26 17:48:42 2024-10-26 08:48:42.000000000 +0000 service.a.access:
{
  "container_name": "/fluentd-service_a-1",
  "source": "stdout",
  "log": "10.10.10.3 - - [26/Oct/2024:08:48:42 +0000] \"GET /service-a.html HTTP/1.1\" 200 9 \"-\" \"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:131.0) Gecko/20100101 Firefox/131.0\" \"10.10.10.1\"",
  "container_id": "51a5f3f11410ec104593b3b3c3d30a62e64ebd96fa0b4e7a3abca759038ef514"
}
```

> 時刻が一致していることが分かる。また、json部分をフォーマットした。

`logger`サービスの`fluentd`が、`analyzer`サービスの`elasticsearch`へ転送する。  
ただし、`elasticsearch`のログは自身に関するログのみ取り扱うため、ログファイルで見ることはできない。  

### log-analyzerサービス

この`elasticsearch`がため込んだログを`visualizer`サービスの`kibana`が取得してブラウザに表示してくれる。

```json
{
  "@log_name": [
    "service.a.access"
  ],
  "@log_name.keyword": [
    "service.a.access"
  ],
  "@timestamp": [
    "2024-10-26T08:48:42.000Z"
  ],
  "container_id": [
    "51a5f3f11410ec104593b3b3c3d30a62e64ebd96fa0b4e7a3abca759038ef514"
  ],
  "container_id.keyword": [
    "51a5f3f11410ec104593b3b3c3d30a62e64ebd96fa0b4e7a3abca759038ef514"
  ],
  "container_name": [
    "/fluentd-service_a-1"
  ],
  "container_name.keyword": [
    "/fluentd-service_a-1"
  ],
  "log": [
    "10.10.10.3 - - [26/Oct/2024:08:48:42 +0000] \"GET /service-a.html HTTP/1.1\" 200 9 \"-\" \"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:131.0) Gecko/20100101 Firefox/131.0\" \"10.10.10.1\""
  ],
  "log.keyword": [
    "10.10.10.3 - - [26/Oct/2024:08:48:42 +0000] \"GET /service-a.html HTTP/1.1\" 200 9 \"-\" \"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:131.0) Gecko/20100101 Firefox/131.0\" \"10.10.10.1\""
  ],
  "source": [
    "stdout"
  ],
  "source.keyword": [
    "stdout"
  ],
  "_id": "7ZMDyJIB8x7kXa9sdwAi",
  "_index": "nginx-a-log-20241026",
  "_score": null
}
```
