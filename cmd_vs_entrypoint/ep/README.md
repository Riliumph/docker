# ENTRYPOINTの挙動

ENTRYPOINTは、コンテナを**実行ファイル**として処理するように設定される。

`docker run <image-name> xxx`の`xxx`以降の引数は、ENTRYPOINTの全要素の後に追加される。  
DockerfileのENTRYPOINTを上書きする場合には`docker run --entrypoint`を使う。

## build

```console
$ docker build ./ --tag ep
[+] Building 7.9s (5/5) FINISHED
（省略）
```

## 実行

### オプション無しで実行

ENTRYPOINTに指定した`/bin/bash`がPID1で起動していることが確認できる。  
これはCMDでの挙動と同じである。

```console
$ docker container run -it --rm ep
root@2591810fa658:/# ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.2  0.0   4088  3412 pts/0    Ss   22:57   0:00 /bin/bash
root         9  0.0  0.0   5856  3024 pts/0    R+   22:57   0:00 ps aux
```

### オプション有りで実行

dockerのオプションに`/bin/sh`を指定すると、ENTRYPOINTと結合され`/bin/bash /bin/sh`が実行される。  
CMDでは、CMDの内容そのものが上書きされるが、ENTRYPOINTでは引数として追加される違いがある。

```console
$ docker container run -it --rm ep /bin/sh
/bin/sh: /bin/sh: cannot execute binary file
```

## 削除

```console
$ docker image rm ep
```

## 参考

- [ENTRYPOINT](https://docs.docker.jp/engine/reference/builder.html#entrypoint)  
