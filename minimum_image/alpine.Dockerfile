FROM alpine:3.9.6

RUN echo "PS1='\u@\h(\$(hostname -i)):\w \\$ '" >> ~/.profile

ENTRYPOINT ["/bin/sh"]
