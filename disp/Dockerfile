FROM alpine:edge as build

ADD /PulseAudio-patched/ /PulseAudio-patched/
ADD /weston-patched/ /weston-patched/

# Build patched weston
RUN apk add libxkbcommon-dev pixman-dev pkgconf wayland-dev \
    libinput-dev libevdev-dev libdrm-dev wayland-protocols cairo-dev mesa-dev \
    linux-pam-dev \
    freerdp-dev xwayland-dev xwayland libxcursor-dev librsvg-dev \
    meson gcc g++ musl-dev

WORKDIR /weston-patched
RUN meson build/ --prefix=/opt/weston --libdir=/opt/weston/lib \
  --sysconfdir=/etc \
  -Dimage-jpeg=false -Dimage-webp=false -Dlauncher-logind=false \
  -Dbackend-default=rdp -Dbackend-drm=false -Dbackend-headless=false \
  -Dbackend-wayland=false -Dbackend-x11=false -Dbackend-fbdev=false \
  -Dcolor-management-lcms=false -Dcolor-management-colord=false \
  -Dsystemd=false -Dremoting=false -Dpipewire=false -Ddemo-clients=false
RUN ninja -C build
RUN ninja -C build install

# Build patched PulseAudio
WORKDIR /PulseAudio-patched
ADD pulseaudio-.tarball-version /PulseAudio-patched/.tarball-version
RUN apk add \
    libsndfile-dev tdb-dev libsm-dev libice-dev libxtst-dev \
    libtool \
    g++ m4
RUN meson build/ -Dtests=false -Ddoxygen=false -Dman=false \
  -Doss-output=disabled -Dudev=disabled \
  -Dopenssl=disabled --prefix=/opt/PulseAudio --sysconfdir=/etc
RUN ninja -C build
RUN ninja -C build install

# Build final runner
# FIMXE: Strip debugging information
FROM alpine:edge
COPY --from=build /opt /opt
RUN apk add libxkbcommon pixman wayland \
    libinput libevdev libdrm wayland-protocols cairo \
    mesa-egl mesa-gles mesa-gl \
    linux-pam-dev \
    freerdp xwayland libxcursor librsvg \
    libsndfile tdb libsm libice libxtst \
    libltdl \
    musl libstdc++ 

# FIXME: This is tentative; find some suitable X11(or Wayland) client
RUN apk add xeyes

# Add startup script
Add startup.sh /
