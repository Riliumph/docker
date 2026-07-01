FROM debian:bookworm-slim

RUN apt-get -q update &&\
    apt-get -q install --no-install-recommends -y \
    curl \
    dnsutils \
    iproute2 \
    iputils-ping \
    telnet \
    traceroute \
    openssh-client &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

RUN echo "echo 'loading /etc/profile'" >> /etc/profile && \
    echo "echo 'loading /etc/bash.bashrc'" >> /etc/bash.bashrc && \
    echo "echo 'loading ~/.bash_profile'" >> ~/.bash_profile && \
    echo "echo 'loading ~/.bash_login'" >> ~/.bash_login && \
    echo "echo 'loading ~/.profile'" >> ~/.profile && \
    echo "echo 'loading ~/.bashrc'" >> ~/.bashrc

RUN echo "PS1='\u@\h(\$(hostname -i)):\w \\$ '" >> ~/.bashrc
