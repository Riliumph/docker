#!/bin/bash

# Signalをshell scriptで受け取らないようにプロセスを上書き
exec websockify --web=/usr/share/novnc/ --wrap-mode=ignore 6080 ${VNC_SERVER_HOST}:5901
