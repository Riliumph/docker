FROM elasticsearch:8.12.0
# 日本語用プラグイン
RUN elasticsearch-plugin install analysis-kuromoji

ENV TZ=Asia/Tokyo
ENV discovery.type=single-node
ENV cluster.name=es-cluster
ENV node.name=elasticsearch
ENV bootstrap.memory_lock=true
ENV xpack.security.enabled=false
