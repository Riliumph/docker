FROM kibana:8.12.0

ENV TZ=Asia/Tokyo
ENV I18N_LOCALE=ja-JP

RUN printf "PS1='[\T]\u@\h(\$(hostname -i)):\w \n\\$ '" >> $HOME/.bashrc
