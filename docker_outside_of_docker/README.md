# docker-outside-of-dockerとは？

コンテナからホストのdockerシステムにアクセスする方法。  

```yaml
      volumes:
        - type: bind # docker providerを使う場合必須
          source: /var/run/docker.sock
          target: /var/run/docker.sock
```

dockerのソケットファイルをマウントすることで可能となる。

## 使い方

doodコンテナを起動する。

```console
$ docker compose up -d
```

doodコンテナに入る。

```console
$ docker compose exec -it dood /bin/bash
```

チュートリアルのheello-worldを実行する。

```console
# docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
e6590344b1a5: Pull complete 
Digest: sha256:940c619fbd418f9b2b1b63e25d8861f9cc1b46e3fc8b018ccfe8b78f19b8cc4f
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

ホスト側のイメージにhello-worldが追加されていることが確認できる

```console
$ docker images
REPOSITORY                      TAG       IMAGE ID       CREATED         SIZE
docker_outside_of_docker-dood   latest    a279f0e1544e   3 minutes ago   806MB
hello-world                     latest    74cc54e27dc4   4 months ago    10.1kB
```

## dockerグループはいつ作られる？

```console
# apt-get -qq install --no-install-recommends -y docker-ce
```

この段階で作られる。  
その前に`docker`というグループを作ってあると、それが使われるようだ。

```console
# groupadd docker --gid 9999
```
