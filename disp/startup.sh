#!/bin/sh
export LD_LIBRARY_PATH=/opt/weston/lib:/opt/PulseAudio/lib
export XDG_RUNTIME_DIR=/tmp
mkdir /tmp/.X11-unix

/opt/PulseAudio/bin/pulseaudio --disallow-exit=true \
  --exit-idle-time=-1 \
  "--load=module-rdp-sink sink_name=RDPSink" \
  "--load=module-rdp-source source_name=RDPSource" \
  "--load=module-native-protocol-unix socket=/tmp/PluseServer auth-anonymous=true" &

/opt/weston/bin/weston --shell=rdprail-shell.so --address=0.0.0.0 \
    --port=5699 --xwayland
