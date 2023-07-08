FROM ubuntu:22.04

RUN apt-get update &&\
    apt-get install --no-install-recommends -y \
    curl \
    iproute2 \
    iputils-ping \
    telnetd \
    traceroute &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

RUN echo "PS1='\u@\h(\$(hostname -i)):\w \\$ '" >> ~/.bashrc

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN useradd -m docker && \
    gpasswd -a docker sudo && \
    echo "docker:docker" | \
    chpasswd

ENTRYPOINT [ "/usr/sbin/in.telnetd", "-debug", "23" ]
