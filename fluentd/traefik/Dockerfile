FROM traefik:latest

# fluentdとの連携のため共有ディレクトリを権限変更
RUN mkdir -p /var/log/traefik && \
    chmod 777 -R /var/log/traefik
