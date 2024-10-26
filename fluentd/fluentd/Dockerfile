# https://docs.fluentd.org/output/elasticsearch
FROM fluent/fluentd:v1.15.0-debian-1.0

# FluentdとElasticsearchを連携させるためのプラグインをインストール
USER root
RUN gem install fluent-plugin-elasticsearch --no-document --version 5.4.3

# 通常ユーザー
USER fluent
ENV TZ=Asia/Tokyo
COPY --chown=fluent:fluent ./etc /fluentd/etc
