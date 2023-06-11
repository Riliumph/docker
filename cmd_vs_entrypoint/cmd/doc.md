# Docker CMDの書き方

[shellの-cオプションについてUbuntuのsh(dash)、bash、zshはそれぞれ違う挙動をする](https://qiita.com/ukinau/items/410f56b6d777ad1e4e90)

## CMDの書き方（落とし穴）

正しい書式は以下のいずれかである。

```Dockerfile
CMD ["echo", "-n", "Hello,CMD"]
```

```Dockerfile
CMD "echo -n Hello,CMD"
```

次の書式は間違っているので注意。

```Dockerfile
CMD ["echo -n Hello,CMD"]
```

しかも、エラーから原因がわかりにくいので注意。

```bash
$ docker run -it --rm sample:0.1
docker: Error response from daemon: DCI runtime create failed: container_linux.go:349: starting container process caused "exec: \"echo -n Hello,CMD\": executable file not found in $PATH": unknown.
```

## 書式1 CMD ["echo", "-n", "Hello,CMD"]

この書式は、`shell`を介さずに直接コマンドを実行する。  
以下と同義である。

```bash
$ exec echo -n Hello,CMD
```

`ENTRYPOINT`と同じく、PID1として実行されることになる。  
Docker daemonは`docker kill`コマンドを使用した場合、CMDで実行されたプロセスに対してsignalを送信する。  

- SIGTERM
- (10sec後)SIGKILL

> AWSのECSのscale in/outと似た挙動  
> というか、ECSはあくまでDockerなので同じ。  
> ただし、AWSはSIGTERMからSIGKILLまで30sec設定の模様（AWSサポート）

よって、正しく終了することができる。

## 書式2 CMD "echo -n Hello,CMD"

CMD 文字列の書式は内部的にはサブシェルで実行される。  
以下と同義である。

```bash
$ sh -c "echo -n Hello,CMD"
```

この場合、signalをハンドルするプロセスは`sh`になってしまう。  
加えて、`sh`コマンドはsignalを伝搬しないため、`echo`を外部から制御することができない。

> `logrotate`はSIGHUPを受け取ることで、開いているfile descriptorをcloseしてreopenする挙動が実装されている。これによりfile descriptorを更新しログファイルをローテーションする仕組み。
