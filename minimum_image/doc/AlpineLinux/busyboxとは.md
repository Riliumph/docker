# BusyBoxとは

Alpine Linuxの中核的なプログラムの一つ。  
たくさんのUnixコマンドが詰め込まれた鍋のようなコマンド。  

> 十徳ナイフ（スミスアーミーナイフ）に例えられたりもする。  
> 内包されるコマンド一覧は[ここ](https://boxmatrix.info/wiki/BusyBox-Commands)

通常、`bash`や`ls`と言ったコマンドは`/bin/ls`など、`/bin`下にあることが多い。  
対して、BusyBox環境では、`/bin/busybox`が実行される。

>　distrolessのイメージで見てみよう。
>
> ```terminal
> ~ $ ls -la /busybox/ | grep sh
> lrwxrwxrwx    1 root     root             7 Jan  1  1970 ash -> busybox
> lrwxrwxrwx    1 root     root             7 Jan  1  1970 hush -> busybox
> lrwxrwxrwx    1 root     root             7 Jan  1  1970 sh -> busybox
> ```
>
> 確かに、`busybox`へのシンボリックリンクになっている。
