# fluentd-logging-driver

## 設定の確認

まず、`fluentd-logging-driver`を使ってログを転送する設定を見てみよう。  
サービスAは、service-a.htmlを返すだけの単純なコンテナである。

```yaml
    service_a:
      build: ./nginx
      hostname: service-a
      volumes:
        - type: bind
          source: nginx/service-a.html
          target: /usr/share/nginx/html/service-a.html
      labels:
        - "traefik.enable=true"
        - "traefik.http.routers.service-a.rule=PathPrefix(`/service-a`)"
        - "traefik.http.routers.service-a.entrypoints=web"
      depends_on:
        - logger
      logging:
        driver: "fluentd"
        options:
          # localhostはservice_aのことではなく、host OSのこと
          fluentd-address: 10.10.10.10:24224
          tag: service.a.access
          # workaround: 起動時に接続失敗してコンテナが立ち上がらない問題を回避
          fluentd-async-connect: "true"
      networks:
        efk_stack_network:
```

### fluentd-address

これは`fluentd`が稼働しているコンテナを指す。

```yaml
    logger:
      build: ./fluentd
      hostname: logger
      restart: always
      # ports:
      #   - target: 24224
      #     published: 24224
      #   - target: 24220
      #     published: 24220
      #   - target: 24224
      #     published: 24224
      #     protocol: udp
      volumes:
        - type: bind
          source: fluentd
          target: /fluentd/etc
          read_only: true
        - type: volume
          source: log_storage
          target: /fluentd/log
      networks:
        efk_stack_network:
          ipv4_address: 10.10.10.10
```

この設定が特殊なので注意しよう。

#### docker0ネットワークを使う

自前でdocker-networkを使わずに、docker0ネットワークを使う場合はポートフォワードが必要になる。

``` yaml
    service_a:
      build: ./nginx
      hostname: service-a
      volumes:
        - type: bind
          source: nginx/service-a.html
          target: /usr/share/nginx/html/service-a.html
      labels:
        - "traefik.enable=true"
        - "traefik.http.routers.service-a.rule=PathPrefix(`/service-a`)"
        - "traefik.http.routers.service-a.entrypoints=web"
      depends_on:
        - logger
      logging:
        driver: "fluentd"
        options:
          # localhost = host OS
          fluentd-address: localhost:24224
          tag: service.a.access
          fluentd-async-connect: "true"
    logger:
      build: ./fluentd
      hostname: logger
      restart: always
      ports:
        - target: 24224
          published: 24224
        - target: 24220
          published: 24220
        - target: 24224
          published: 24224
          protocol: udp
      volumes:
        - type: bind
          source: fluentd
          target: /fluentd/etc
          read_only: true
        - type: volume
          source: log_storage
          target: /fluentd/log
```

コメントで`localhost = host OS`と書いているように、`localhost`は`service-a`と一致しない。  
この設定は、突き詰めるとコンテナそのものの設定ではなく、コンテナが使うドライバの設定なので、ここの`localhost`はdockerを起動するOSのことを指す。

このことから分かるように、localhostの24224ポートを使う以上は、そのポートを`fluentd`コンテナと連携させる必要がある。  
そのための`ports`設定である。

#### 新規ネットワークを使う

では、docker0ネットワークではなく新規のdocker-networkを定義してみようではないか。

```yaml
networks:
  efk_stack_network:
    ipam:
      driver: default
      config:
        - subnet: 10.10.10.0/24
```

では、改めて設定を見てみよう。

```yaml
    service_a:
      build: ./nginx
      hostname: service-a
      volumes:
        - type: bind
          source: nginx/service-a.html
          target: /usr/share/nginx/html/service-a.html
      labels:
        - "traefik.enable=true"
        - "traefik.http.routers.service-a.rule=PathPrefix(`/service-a`)"
        - "traefik.http.routers.service-a.entrypoints=web"
      depends_on:
        - logger
      logging:
        driver: "fluentd"
        options:
          fluentd-address: 10.10.10.10:24224
          tag: service.a.access
          fluentd-async-connect: "true"
      networks:
        efk_stack_network:

    logger:
      build: ./fluentd
      hostname: logger
      restart: always
      volumes:
        - type: bind
          source: fluentd
          target: /fluentd/etc
          read_only: true
        - type: volume
          source: log_storage
          target: /fluentd/log
      networks:
        efk_stack_network:
          ipv4_address: 10.10.10.10
```

各種コンテナは`networks`設定によって定義したネットワークに配置されていることが分かる。  
加えて、`fluentd`を擁する`logger`コンテナは`10.10.10.10`のIPアドレスが固定的に割り当てられている。

`service-a`コンテナは`localhost:24224`の記述から`10.10.10.10:24224`の記述へ変わった。  
これは、host OSの24224ポートではfluentdにつながらなくなったためである。

ここで気になるのは、`10.10.10.10`をホスト名にできないか？ということだ。  
仕様確認できていないので想像ではある。  
`localhost`がhost OSであるということからも、このドライバ設定はdockerの世界の設定ではないことが伺える。  
ホスト名前解決はdockerの世界では、DNSではなくdockerのService Discoveryが代替して行うことになっている。  
しかし、ここにホスト名が管理されるのは、イメージがビルドされた後なのも容易に想像できる。  
つまり、この設定にホスト名を書いても正しく設定できないのではないか？  

> いや、ホスト名のまま設定投入して、runの時に名前解決しろよと言われればそれはそうなのだが。。。  
> しかし、その名前解決はやはりコンテナの中での名前解決になってしまう。  
> localhost = host OSの関係から、その名前解決では不十分なのも明らかである。

結局、ここにはdocker networkで割り当てたIPアドレスか、host OSでも分かるホスト名を入れるしかない……？？

#### 違いは？

localhost:24224にポートフォワードする場合、このdockerだけではなく、全く関係ないdockerサービスも24224にポートフォワードすればログをfluentdで転送できる。

つまり、このマシンで動くすべてのdockerを１つのfluentdで１つのelasticsearchに転送し、１つのKibanaで閲覧することができる。  
確かに、それは楽で面白い試みである。

ただ、今回は、このdocker用にfluentd+elasticsearch+kibanaをやりたかったので、コードとしてはdocker-networkを構築する方でコミットしておく。

### fluentd-async-connect

fluentdが機能していない場合、何度か再接続してくれる機能っぽい。  
これをOFFにしているとfluentdが立ち上がる前に接続しに行ってしまい、接続失敗でコンテナが死ぬ。  

`depends_on`設定していても死ぬ。  
原因らしきなのは、公式のfluentdイメージは、コンテナが立ち上がったあとにfluentdが起動するからか？  

> depends_onはあくまでコンテナの起動順序の制御であり、コンテナ内部のソフトがすべて起動したことを確認してくれるわけではない。  
> コンテナ起動完了とコンテナ内部のソフトすべて起動が同値だったらよかったのにね。
> なんで違うん？？？Docker分からん
