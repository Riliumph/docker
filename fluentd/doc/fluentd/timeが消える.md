# timeが消える

```json
# 生ログ
{"level":"debug","time":"2024-10-27T20:57:09Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: 9521481a639cb9b5"}
# fluentd
{"level":"debug","time":"2024-10-27T20:57:09Z","caller":"github.com/traefik/traefik/v3/pkg/server/service/loadbalancer/wrr/wrr.go:196","message":"Service selected by WRR: 9521481a639cb9b5"}
# fluentd filter
{"level":"debug","providerName":"docker","time":"2024-10-27T22:15:02Z","caller":"github.com/traefik/traefik/v3/pkg/server/configurationwatcher.go:127","message":"Skipping unchanged configuration"}
```

ログの内容が若干違うが、そこは重要なことではない。  
元々のログはtimeセクションを持っているのに、fluentdに食わせるだけでtimeセクションが消える。  
fluentdのfilterプラグインで元ログのtimeをリライトしてみたが、null判定されている。

## 原因

まず、flunetdのtimeキーの扱い方を知らなければならない。

fluentdはsourceイベントからルーティングされる際に以下のエンティティに分類される。

- tag
- time
- record

そう、filterに流れてくる情報はrecordだけである。  
そのためtimeはnullとなってしまう。

## 対策

レコードの中に時間がかかれていないとelasticsearchでの検索も大変だ。

そこで、Parse Parameterとして用意されている[keep_time_key](https://docs.fluentd.org/configuration/parse-section#parse-parameters)を使って解決する。

## 参考

- [fluentdでapacheのログに時間が出力されなくて苦労したので解決策と原理をまとめてみた](https://dev.classmethod.jp/articles/fluentd-cant-output-time-with-apache-format/)
- [Config File Syntax](https://docs.fluentd.org/configuration/config-file)
