# Display Manager

複数のディスプレイマネージャがインストールされていると、デスクトップ環境をインストールした際にデフォルト設定を尋ねられてしまう。  
これは`DEBIAN_FRONTEND=noninteractive`を定義することで回避できる。  
しかし、これは何の設定を変更しているのか、またDockerのような独話的IFで設定を変更したい場合はどうするのか？

> Display Managerは別名Login Managerである。
> 最も分かり易い例はログイン画面を構成するIFである。  
> 他にもX Window SystemとXsessionを張ったり色んなことをする。

## エラーの詳細

```console
A display manager is a program that provides graphical login capabilities for the X Window System.

Only one display manager can manage a given X server, but multiple display manager packages are installed. Please select which display manager should run by default.

Multiple display managers can run simultaneously if they are configured to manage different servers; to achieve this, configure the display managers accordingly, edit each of their init scripts in /etc/init.d, and disable the check for a default display manager.

  1. gdm3  2. lightdm
Default display manager: 
```

## 変更されるファイル

デフォルトのディスプレイマネージャは`gdm3`だが、選択によっては別な記述に変わる。

```console
ros_dev@dev:~$ cat /etc/X11/default-display-manager 
/usr/sbin/gdm3
```

また、systemdが採用されている環境ではサービス設定もシンボリックリンクで設定されているので張り替わる。

```console
ros_dev@dev:/etc/systemd/system$ ll display-manager.service 
lrwxrwxrwx 1 root root 32 Feb 26 14:10 display-manager.service -> /lib/systemd/system/gdm3.service
```

```bash
[Unit]
Description=GNOME Display Manager

# replaces the getty
Conflicts=getty@tty1.service
After=getty@tty1.service

# replaces plymouth-quit since it quits plymouth on its own
Conflicts=plymouth-quit.service
After=plymouth-quit.service

# Needs all the dependencies of the services it's replacing
# pulled from getty@.service and plymouth-quit.service
# (except for plymouth-quit-wait.service since it waits until
# plymouth is quit, which we do)
After=rc-local.service plymouth-start.service systemd-user-sessions.service

# GDM takes responsibility for stopping plymouth, so if it fails
# for any reason, make sure plymouth still stops
OnFailure=plymouth-quit.service

[Service]
ExecStartPre=/usr/share/gdm/generate-config
ExecStart=/usr/sbin/gdm3
KillMode=mixed
Restart=always
RestartSec=1s
IgnoreSIGPIPE=no
BusName=org.gnome.DisplayManager
StandardOutput=syslog
StandardError=inherit
EnvironmentFile=-/etc/default/locale
ExecReload=/usr/share/gdm/generate-config
ExecReload=/bin/kill -SIGHUP $MAINPID
KeyringMode=shared
ExecStartPre=/usr/lib/gdm3/gdm-wait-for-drm
```

## 変更方法

色んなファイルを色々な方法で書き換えたり張り替えたりする必要が出てくる。  
これだけシステムに根付いた設定を変えることを`sed`などではやりきれない。

以下の設定変更コマンドで書き換えることができる。

```console
# DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true dpkg-reconfigure lightdm
# DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true dpkg-reconfigure gdm3
```
