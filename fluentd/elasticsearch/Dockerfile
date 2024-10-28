FROM elasticsearch:8.12.0

USER root
RUN chown -R 1000:1000 /usr/share/elasticsearch

USER elasticsearch
# 日本語用プラグイン
RUN elasticsearch-plugin install analysis-kuromoji
COPY --chown=elasticsearch:root elasticsearch.yaml /usr/share/elasticsearch/config/elasticsearch.yml
ENV TZ=Asia/Tokyo
RUN printf "PS1='[\T]\u@\h(\$(hostname -i)):\w \n\\$ '" >> $HOME/.bashrc
