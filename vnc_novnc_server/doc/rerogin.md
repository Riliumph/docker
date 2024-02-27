# vncserverのリログイン

`vncserver`へ`novnc`を経由して接続する場合に、`ctrl+d`でログアウトすると`vncserver`が落ちてしまう。  
リログインを実装するにはどうするべきか？

## suppervisorを使ってプロセスを再起動する

supervisorに以下の設定を適用する。

```conf
[program:vncserver]
command=/root/start.sh
autostart=true
autorestart=true
```

`autorestart`設定により、プロセスへのシグナルを検知して再起動を行うようになる。
