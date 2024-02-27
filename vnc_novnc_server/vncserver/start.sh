#!/bin/bash

# debian
vncserver :1 -xstartup /usr/bin/xterm -PasswordFile $HOME/.vnc/passwd -fg
