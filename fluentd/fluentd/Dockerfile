# https://docs.fluentd.org/output/elasticsearch
FROM fluent/fluentd:v1.15.0-debian-1.0

USER root

# FluentdとElasticsearchを連携させるためのプラグインをインストール
RUN gem install fluent-plugin-elasticsearch --no-document --version 5.4.3

USER fluent
