FROM debian:stable-slim

ARG USERNAME
ARG UID
ARG GID
ARG PWD="/mnt/bind"

# New user
RUN groupadd -g "$GID" "$USERNAME" &&\
    useradd -l -u "$UID" -g "$GID" "$USERNAME"
# Login new user
USER $USERNAME
WORKDIR $PWD
RUN chown -R "$USERNAME" "$PWD"

ENTRYPOINT ["/bin/sh"]
