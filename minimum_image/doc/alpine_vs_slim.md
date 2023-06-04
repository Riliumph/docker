
# 注意事項

## glibc vs musl-libc

alpineは`glibc`ではなく`musl libc`だということを忘れてはならない。  
`musl libc`は、`glibc`と互換性のある標準Cライブラリである。

しかし、この互換性、かなり怪しい。  
Ruby、Python、Node.jsなどのNativeモジュールをバンドルしているアプリのパフォーマンスが落ちているなどという報告が上がっている。  

### [Why is the Alpine Docker image over 50% slower than the Ubuntu image?](https://superuser.com/questions/1219609/why-is-the-alpine-docker-image-over-50-slower-than-the-ubuntu-image)

どうやら、Python3.6を使ってAlpineとDebian-Slimで比較を取ったらしい。  
結果、Slimの方がAlpineに比べて2秒以上速かった模様。  

```terminal
$ docker run python:3-slim python -c "$BENCHMARK"
3.6475560404360294
$ docker run python:3-alpine3.6 python -c "$BENCHMARK"
5.834922112524509
```

この原因として、glibcとmusl-libcでの違いを上げている。  
この部分が致命的に違うという意味ではなく、少なくともこういった違いがあるとのこと。
ライブラリをロードする部分だが、一気にロードするglibcと細かくロードするmuslでI/Oの差が顕著に出る可能性がある。

```c
// ライブラリをロードするコードの差
// glibc
openat(AT_FDCWD, "/usr/local/lib/python3.6", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 3
getdents(3, /* 205 entries */, 32768)   = 6824
getdents(3, /* 0 entries */, 32768)     = 0
// musl
open("/usr/local/lib/python3.6", O_RDONLY|O_DIRECTORY|O_CLOEXEC) = 3
fcntl(3, F_SETFD, FD_CLOEXEC)           = 0
getdents64(3, /* 62 entries */, 2048)   = 2040
getdents64(3, /* 61 entries */, 2048)   = 2024
getdents64(3, /* 60 entries */, 2048)   = 2032
getdents64(3, /* 22 entries */, 2048)   = 728
getdents64(3, /* 0 entries */, 2048)    = 0
```

たとえば、JSONのインポートのみで比較するとさほど差はない模様。

```terminal
$ BENCHMARK="import timeit; print(timeit.timeit('import json;', number=5000))"
$ docker run python:3-slim python -c "$BENCHMARK"
0.03683806210756302
$ docker run python:3-alpine3.6 python -c "$BENCHMARK"
0.038280246779322624
```

`list()`を使ってリストを生成すると差が開く模様。

```terminal
$ BENCHMARK="import timeit; print(timeit.timeit('list(range(10000))', number=5000))"
$ docker run python:3-slim python -c "$BENCHMARK"
0.5666235145181417
$ docker run python:3-alpine3.6 python -c "$BENCHMARK"
0.6885563563555479
```

`json.jumps()`はもっと差が大きい。  
メモリの割り当て処理で大きく差があることが分かった。

||glibc|musl|
|--:|:--:|:--:|
|小さいメモリ割り当て|0.002|0.005|
|大きいメモリ割り当て|0.016|0.027|
