FROM debian:stable-slim

RUN echo "PS1='\u@\h(\$(hostname -i)):\w \\$ '" >> ~/.bashrc

ENTRYPOINT ["/bin/bash"]
