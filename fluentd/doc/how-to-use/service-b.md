# サービスBの使い方

サービスBは、以下の要件でアクセスログを送信する。

- ログ記録形式：Common Log Format
- ログ送信方法：nginxによる転送設定
- ログ変更有無：fluentdでのjson形式ログへ変更

## ルーティングルール

```yaml
      labels:
        - "traefik.enable=true"
        - "traefik.http.routers.for-service-a.rule=PathPrefix(`/service-b`)"
        - "traefik.http.routers.for-service-a.entrypoints=web"
```

リクエストURLに`/service-b`が含まれていること

## サービスAへのアクセス

```console
$ curl http://localhost/service-b.html
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

```json
{"time_local":"2024-10-29T21:01:31+00:00","remote_addr":"10.10.10.3","request":"GET /service-a.html HTTP/1.1","status":"304","body_bytes_sent":"0","http_referer":"","http_user_agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:131.0) Gecko/20100101 Firefox/131.0","request_time":"0.000","upstream_response_time":"","host":"localhost"}
```

このログが`fluentd`によって成形されて、`logger`サービスに以下のログが表示される。

### loggerサービス

Docker Desktopの`logger`サービスに以下のログが表示される。

```json
2024-10-30 06:01:31.000000000 +0900 service.a.access: {"container_name":"/fluentd-service_a-1","source":"stdout","log":"{\"time_local\":\"2024-10-29T21:01:31+00:00\",\"remote_addr\":\"10.10.10.3\",\"request\":\"GET /service-a.html HTTP/1.1\",\"status\":\"304\",\"body_bytes_sent\":\"0\",\"http_referer\":\"\",\"http_user_agent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:131.0) Gecko/20100101 Firefox/131.0\",\"request_time\":\"0.000\",\"upstream_response_time\":\"\",\"host\":\"localhost\"}","container_id":"ccf036ba96ce5d03f8428001c3675cc8d97f4115714cce276e1edf60a98c9b7d"}
```

> 時刻が一致していることが分かる。  
> nginxではiso8601表記か西洋表記しかないので前者を選択（JSTにはならないので脳内で9時間補正する）

`logger`サービスの`fluentd`が、`analyzer`サービスの`elasticsearch`へ転送する。  
ただし、`elasticsearch`のログは自身に関するログのみ取り扱うため、ログファイルで見ることはできない。  

### log-analyzerサービス

この`elasticsearch`がため込んだログを`visualizer`サービスの`kibana`が取得してブラウザに表示してくれる。

```json
{
  "_index": "nginx-a-log-20241029",
  "_id": "KQYV2pIBCgnkn1Z3dAWm",
  "_version": 1,
  "_score": null,
  "_ignored": [
    "log.keyword"
  ],
  "fields": {
    "@timestamp": [
      "2024-10-29T21:01:31.000Z"
    ],
    "container_name": [
      "/fluentd-service_a-1"
    ],
    "log": [
      "{\"time_local\":\"2024-10-29T21:01:31+00:00\",\"remote_addr\":\"10.10.10.3\",\"request\":\"GET /service-a.html HTTP/1.1\",\"status\":\"304\",\"body_bytes_sent\":\"0\",\"http_referer\":\"\",\"http_user_agent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:131.0) Gecko/20100101 Firefox/131.0\",\"request_time\":\"0.000\",\"upstream_response_time\":\"\",\"host\":\"localhost\"}"
    ],
    "@log_name": [
      "service.a.access"
    ],
    "container_id.keyword": [
      "ccf036ba96ce5d03f8428001c3675cc8d97f4115714cce276e1edf60a98c9b7d"
    ],
    "source": [
      "stdout"
    ],
    "@log_name.keyword": [
      "service.a.access"
    ],
    "container_name.keyword": [
      "/fluentd-service_a-1"
    ],
    "source.keyword": [
      "stdout"
    ],
    "container_id": [
      "ccf036ba96ce5d03f8428001c3675cc8d97f4115714cce276e1edf60a98c9b7d"
    ]
  },
  "ignored_field_values": {
    "log.keyword": [
      "{\"time_local\":\"2024-10-29T21:01:31+00:00\",\"remote_addr\":\"10.10.10.3\",\"request\":\"GET /service-a.html HTTP/1.1\",\"status\":\"304\",\"body_bytes_sent\":\"0\",\"http_referer\":\"\",\"http_user_agent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:131.0) Gecko/20100101 Firefox/131.0\",\"request_time\":\"0.000\",\"upstream_response_time\":\"\",\"host\":\"localhost\"}"
    ]
  },
  "sort": [
    "2024-10-29T21:01:31.000Z",
    18
  ]
}
```
