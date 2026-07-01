FROM debian:bookworm-slim

RUN apt-get update &&\
    apt-get install --no-install-recommends -y \
    curl \
    dnsutils \
    iproute2 \
    iputils-ping \
    telnetd \
    traceroute \
    openssh-server\
    apache2\
    supervisor\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo "echo 'loading /etc/profile'" >> /etc/profile && \
    echo "echo 'loading /etc/bash.bashrc'" >> /etc/bash.bashrc && \
    echo "echo 'loading ~/.bash_profile'" >> ~/.bash_profile && \
    echo "echo 'loading ~/.bash_login'" >> ~/.bash_login && \
    echo "echo 'loading ~/.profile'" >> ~/.profile && \
    echo "echo 'loading ~/.bashrc'" >> ~/.bashrc

RUN echo "PS1='\u@\h(\$(hostname -i)):\w \\$ '" >> ~/.bashrc

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN useradd -m docker && \
    gpasswd -a docker sudo && \
    echo "docker:docker" | \
    chpasswd

RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor

COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENTRYPOINT ["/usr/bin/supervisord"]

