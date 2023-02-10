# CMDの挙動

## ビルド

```console
$ docker build ./ --tag cmd
[+] Building 2.5s (5/5) FINISHED
（省略）
```

## 実行

### オプション無しで実行

CMDに指定した`/bin/bash`がPID1で起動していることが確認できる。  
これはENTRYPOINTでの挙動と同じである。

```console
$ docker container run -it --rm cmd
root@e04d68fa45c5:/# ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  1.0  0.0   4088  3392 pts/0    Ss   23:01   0:00 /bin/bash
root         9  0.0  0.0   5856  2868 pts/0    R+   23:01   0:00 ps aux
```

### オプション有りで実行

dockerのオプションに`/bin/sh`を指定する。  
ENTRYPOINTでは、ENTRYPOINTを結合され`/bin/bash /bin/sh`が実行された。  
CMDでは、CMDの内容が上書きされ`/bin/sh`が実行される。

`/bin/sh`がPID1で起動していることが確認できる。

```console
$ docker container run -it --rm cmd /bin/sh
# ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0   2604   724 pts/0    Ss   23:05   0:00 /bin/sh
root         7  0.0  0.0   5856  2968 pts/0    R+   23:06   0:00 ps aux
```

## 削除

```console
$ docker image rm cmd
```
