# supervisord

## supervisord エラー

### ソケットエラー

```console
ros_dev@dev:~/.vnc$ /usr/bin/supervisord
2024-02-25 01:06:02,204 INFO Included extra file "/etc/supervisor/conf.d/vncserver.conf" during parsing
Error: Cannot open an HTTP server: socket.error reported errno.EACCES (13)
For help, use /usr/bin/supervisord -h
```

設定(`/etc/supervisor/supervisord.conf`)を確認すると、以下のソケットを使用している。

```conf
[unix_http_server]
file=/var/run/supervisor.sock   ; (the path to the socket file)
chmod=0700                       ; sockef file mode (default 0700)
```

`/var/run/supervisor.sock`に対して実行ユーザーが権限を持っていない。  
このソケットを権限があるところに生成する必要がある。
