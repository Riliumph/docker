FROM busybox:stable

RUN echo "PS1='\u@\h(\$(hostname -i)):\w \\$ '" >> ~/.profile

ENTRYPOINT ["/bin/sh"]
