# config

- [fluentdメモ - (4) 設定ファイル調査 Buffer編](https://qiita.com/tomotagwork/items/ef51fc60adbb2ca8db92)

## system

### worker

最大129らしい

```conf
<system>
  workers 4
</system>

<worker 0>
@include metrics.conf
</worker>
```

```console
/$ ps ux | awk 'NR==1 || /[f]luentd/'
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
fluent       1  0.0  0.0  16604  8996 ?        Ss   01:23   0:00 tini -- /bin/entrypoint.sh fluentd
fluent       7  0.0  0.5 161340 56540 ?        Sl   01:23   0:01 /usr/local/bin/ruby /usr/local/bundle/bin/fluentd --config /fluentd/etc/fluent.conf --plugin /fluentd/plugins
fluent      16  0.0  0.4 131812 41436 ?        Sl   01:23   0:00 /usr/local/bin/ruby -Eascii-8bit:ascii-8bit /usr/local/bundle/bin/fluentd --config /fluentd/etc/fluent.conf --plugin /fluentd/plugins --under-supervisor
fluent      96  0.0  0.5 161340 55520 ?        Sl   01:23   0:01 /usr/local/bin/ruby -Eascii-8bit:ascii-8bit /usr/local/bundle/bin/fluentd --config /fluentd/etc/fluent.conf --plugin /fluentd/plugins --under-supervisor
fluent      97  0.1  0.5 182344 55444 ?        Sl   01:23   0:01 /usr/local/bin/ruby -Eascii-8bit:ascii-8bit /usr/local/bundle/bin/fluentd --config /fluentd/etc/fluent.conf --plugin /fluentd/plugins --under-supervisor
fluent      98  0.1  0.5 188488 55532 ?        Sl   01:23   0:01 /usr/local/bin/ruby -Eascii-8bit:ascii-8bit /usr/local/bundle/bin/fluentd --config /fluentd/etc/fluent.conf --plugin /fluentd/plugins --under-supervisor
```

PIDが16,96,97,98で動いていることが分かる。  
PID1はfluentdイメージのエントリポイントで、PID7が親プロセスである。

## match

### buffer

#### flush系

##### path xxx

このパスはバッファファイル群を書き出すためのディレクトリの設定  
F5連打をすればどんどんファイルサイズが大きくなることが確認できる。

```console
fluent@logger:/fluentd/tmp/traefik/access_buffer$ ls -la
total 16
drwxr-xr-x 2 fluent fluent 4096 Oct 28 02:59 .
drwxr-xr-x 3 fluent fluent 4096 Oct 28 02:57 ..
-rw-r--r-- 1 fluent fluent  904 Oct 28 02:59 buffer.b625791df3861fc2d8b279ee602825ef4.log
-rw-r--r-- 1 fluent fluent   89 Oct 28 02:59 buffer.b625791df3861fc2d8b279ee602825ef4.log.meta
```

#### retry系

##### retry_type

デフォルトは`exponential_backoff`

`exponential_backoff`とは以下の表のようにバックオフ係数によって徐々にリトライ感覚が増える方式のこと

|N-th retry|Elapsed|
|:--:|:--:|
|1|1s|
|2|3s|
|3|7s|
|4|15s|
|5|31s|
|6|63s|
|6|100s|

#### chunk系

##### chunk_keys tag

chunkファイルを識別するPKのようなもの。  
この値で、各種のチャンクファイルを分けることが出来る。  
チャンクファイルが分かれることで、チャンク毎に処理の時間などを異なる設定にすることができる。

##### timekey 1h

時間ごとに新しいチャンクを作成する

##### timekey_wait 10m

timekeyが経過したあと、この値の分だけ待機してフラッシュする。  
これにより遅延して到着したログも同じチャンクに含められる。
