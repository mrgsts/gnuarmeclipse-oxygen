#!/bin/sh
docker run --rm -it -v /tmp/.X11-unix/:/tmp/.X11-unix/ -v /run/user/1000/gdm/:/run/user/1000/gdm/ -e XAUTHORITY=/run/user/1000/gdm/Xauthority -e DISPLAY=$DISPLAY $1 /usr/local/eclipse/eclipse
