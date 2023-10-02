# apt-get

## apt-get cleanで容量が節約されないワケ

Dockerはコンテナを軽量化するにあたって`apt-get`のお作法がある。

```dockerfile
FROM debian:bookworm-slim

RUN apt-get update &&\
    apt-get install -y postgresql &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*
```

||イメージサイズ|
|:--|:--:|
|両方あり|136.72MB|
|apt-get cleanのみ|176.54MB|
|rm -rf /var/lib/apt/lists/*のみ|136.72MB|
|両方なし|176.54MB|

どんな差があるのだろうか？

### apt-get clean

`apt-get clean`は`apt`がダウンロードしてきたDebianパッケージファイルを削除するためのコマンド。  
ダウンロードされたファイルは`/var/cache/apt`以下に一時的に保存され、再インストール時に参照される。

では、なぜこのコマンドがディスク容量に影響を与えなかったのか？

以下の、`docker-clean`というapt-clean用のapt設定に秘密が隠されている。

```terminal
root@846504c88466:/etc/apt/apt.conf.d# ls -la
total 32
drwxr-xr-x 2 root root 4096 Jun 12 00:00 .
drwxr-xr-x 8 root root 4096 Jun 12 00:00 ..
-rw-r--r-- 1 root root  399 May 25 14:11 01autoremove
-rw-r--r-- 1 root root  182 Jan  8 21:50 70debconf
-rw-r--r-- 1 root root  754 Jun 12 00:00 docker-autoremove-suggests
-rw-r--r-- 1 root root 1175 Jun 12 00:00 docker-clean
-rw-r--r-- 1 root root  481 Jun 12 00:00 docker-gzip-indexes
-rw-r--r-- 1 root root  269 Jun 12 00:00 docker-no-languages
```

内容は以下。

`APT::Update::Post-Invoke`とは、`apt update`呼出し後に実行される内容を設定している。  
`apt-get clean`相当の処理が走ることが確認できる。

```conf
# Since for most Docker users, package installs happen in "docker build" steps,
# they essentially become individual layers due to the way Docker handles
# layering, especially using CoW filesystems.  What this means for us is that
# the caches that APT keeps end up just wasting space in those layers, making
# our layers unnecessarily large (especially since we'll normally never use
# these caches again and will instead just "docker build" again and make a brand
# new image).

# Ideally, these would just be invoking "apt-get clean", but in our testing,
# that ended up being cyclic and we got stuck on APT's lock, so we get this fun
# creation that's essentially just "apt-get clean".
DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };
APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };

Dir::Cache::pkgcache "";
Dir::Cache::srcpkgcache "";

# Note that we do realize this isn't the ideal way to do this, and are always
# open to better suggestions (https://github.com/debuerreotype/debuerreotype/issues).
```
