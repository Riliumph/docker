# ENTRYPOINTとCMDを併用する場合

参考には以下にこう書かれている。

- `ENTRYPOINT`は、コンテナを 実行バイナリ のように扱いたい場合に定義すべきです。
- `CMD`は、`ENTRYPOINT`コマンドに対するデフォルトの引数を定義するためか、コンテナ内でその場その場でコマンドを実行するために使うべきです

## dockerのビルド

```console
$ docker build ./ --tag ep_with_cmd
[+] Building 7.9s (5/5) FINISHED
 => [internal] load build definition from Dockerfile               0.0s
 => => transferring dockerfile: 108B                               0.0s
 => [internal] load .dockerignore                                  0.0s
 => => transferring context: 2B                                    0.0s
 => [internal] load metadata for docker.io/library/ubuntu:19.10    3.6s
 => [1/1] FROM docker.io/library/ubuntu:19.10@sha256:xxx           4.1s
 => => resolve docker.io/library/ubuntu:19.10@sha256:xxx           0.0s
（省略）
 => exporting to image                                             0.0s
 => => exporting layers                                            0.0s
 => => writing image sha256:yyy                                    0.0s
 => => naming to docker.io/library/ep_with_cmd                     0.0s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them
```

## dockerの実行

### オプション無し実行

CMDに入力していた`--help`がENTRYPOINTに付与されて`/bin/bash --help`が実行される。

```console
$ docker container run -it --rm ep_with_cmd
GNU bash, version 5.0.3(1)-release-(x86_64-pc-linux-gnu)
（省略）
bash home page: <http://www.gnu.org/software/bash>
General help using GNU software: <http://www.gnu.org/gethelp/>
```

### オプション有り実行

オプションを付与すると、CMDに指定したものが上書きされ`/bin/bash --version`が実行される。

```console
$ docker container run -it --rm ep_with_cmd --version
GNU bash, version 5.0.3(1)-release (x86_64-pc-linux-gnu)
Copyright (C) 2019 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
```

## 削除

```console
$ docker image rm ep_with_cmd
```

## 参考

- [CMD と ENTRYPOINT の連携を理解](https://docs.docker.jp/engine/reference/builder.html#cmd-entrypoint)
