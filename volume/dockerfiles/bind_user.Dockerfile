FROM debian:stable-slim

ARG USERNAME
ARG UID
ARG GID
ARG PWD="/mnt/bind"

WORKDIR $PWD

RUN groupadd -g "$GID" "$USERNAME" &&\
    useradd -l -u "$UID" -g "$GID" "$USERNAME" &&\
    chown -R "$USERNAME" "$PWD"
USER $USERNAME

ENTRYPOINT ["/bin/sh"]
