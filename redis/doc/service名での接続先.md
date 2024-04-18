# service名を用いた接続の接続先

`docker swarm`機能の`deploy::replicas`オプションを有効にする。  
この状態での`docker compose exec <service_name>`は冪等性があるかを調べる。

まず、各コンテナは同じイメージを使っているのでほとんど同じ情報が表示されてしまいかねない。  
IPアドレスは被ることが無いので、それを表示させてみる。

```console
$ docker compose exec redis_master hostname -I
10.20.0.2
```

では、上記コマンドを100回実行してみて、答えが一致すれば冪等性があるとする。

```console
$ for i in {1..100}; do docker compose exec redis_master hostname -I ; done
10.20.0.2
10.20.0.2
... ... ...
... ...
...
10.20.0.2
```

同じであることから、`docker compose exec <service_name>`は、接続先コンテナに優先度を持って実行していることが分かる。
