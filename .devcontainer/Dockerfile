FROM mcr.microsoft.com/devcontainers/base:2-debian12 AS toolchain
# hadolint
ARG HADOLINT_URL
RUN wget -q -O /usr/local/bin/hadolint ${HADOLINT_URL} --no-check-certificate && chmod +x /usr/local/bin/hadolint
# diff-highlight
WORKDIR /usr/share/doc/git/contrib/diff-highlight
RUN make


FROM mcr.microsoft.com/devcontainers/base:2-debian12

RUN apt-get -qq update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends -y\
    # utility
    peco\
    silversearcher-ag\
    vim\
    # networks
    dnsutils\
    iputils-ping\
    && apt-get clean\
    && rm -rf /var/lib/apt/lists/*

# hadolint for docker
COPY --from=toolchain /usr/local/bin/hadolint /usr/local/bin/hadolint
# diff-highlight
COPY --from=toolchain /usr/share/doc/git/contrib/diff-highlight/diff-highlight /usr/local/bin/diff-highlight
COPY etc/bash_completion.d/docker /etc/bash_completion.d/
