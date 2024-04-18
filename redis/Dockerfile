FROM redis:7.2.4

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update &&\
    apt-get -qq install procps less\
    curl dnsutils iproute2 iputils-ping telnet traceroute &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

COPY redis.conf /etc/redis.conf
CMD [ "redis-server", "/etc/redis.conf" ]
