# home-gw

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

```console
# less /logs/traefik.log
{"level":"debug","time":"2024-10-25T17:26:11Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: d498ec906c3b4e51"}
{"level":"debug","time":"2024-10-25T17:26:11Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: d498ec906c3b4e51"}
{"level":"debug","time":"2024-10-25T17:26:11Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: d498ec906c3b4e51"}
{"level":"debug","time":"2024-10-25T17:26:11Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: d498ec906c3b4e51"}
{"level":"debug","time":"2024-10-25T17:26:11Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: d498ec906c3b4e51"}
{"level":"debug","time":"2024-10-25T17:26:11Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: d498ec906c3b4e51"}
{"level":"debug","time":"2024-10-25T17:26:11Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: d498ec906c3b4e51"}
{"level":"debug","time":"2024-10-25T17:26:12Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: d498ec906c3b4e51"}
{"level":"debug","time":"2024-10-25T17:26:12Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: d498ec906c3b4e51"}
{"level":"debug","time":"2024-10-25T17:26:12Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: d498ec906c3b4e51"}
{"level":"debug","time":"2024-10-25T17:26:12Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: d498ec906c3b4e51"}
{"level":"debug","time":"2024-10-25T17:26:12Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: d498ec906c3b4e51"}
{"level":"debug","time":"2024-10-25T17:26:12Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: d498ec906c3b4e51"}
{"level":"debug","time":"2024-10-25T17:26:12Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: d498ec906c3b4e51"}
{"level":"debug","time":"2024-10-25T17:26:12Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: d498ec906c3b4e51"}
{"level":"debug","time":"2024-10-25T17:26:12Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: d498ec906c3b4e51"}
{"level":"debug","error":"context canceled","time":"2024-10-25T17:26:12Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/proxy.go:100","message":"499 Client Closed Request"}
{"level":"debug","time":"2024-10-25T17:26:12Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: d498ec906c3b4e51"}
```
