FROM redis:7.2.4

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq &&\
    apt-get install -qq \
    procps\
    less\
    curl\
    dnsutils\
    iproute2\
    iputils-ping\
    telnet\
    traceroute\
    &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

COPY redis.conf /etc/redis.conf
RUN echo "PS1='\u@\h(\$(hostname -i)):\w \\$ '" >> ~/.bashrc
ENTRYPOINT [ "redis-server", "/etc/redis.conf" ]
