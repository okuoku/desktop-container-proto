#!/bin/sh
export LD_LIBRARY_PATH=/opt/weston/lib
export XDG_RUNTIME_DIR=/tmp
mkdir /tmp/.X11-unix
exec /opt/weston/bin/weston --shell=rdprail-shell.so --address=0.0.0.0 \
    --port=5699 --xwayland
