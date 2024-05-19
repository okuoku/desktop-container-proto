FROM alpine:edge as build

# Build patched weston
ADD /weston-patched/ /weston-patched/
RUN apk add libxkbcommon-dev pixman-dev pkgconf wayland-dev \
    libinput-dev libevdev-dev libdrm-dev wayland-protocols cairo-dev mesa-dev \
    linux-pam-dev \
    freerdp-dev xwayland-dev xwayland libxcursor-dev librsvg-dev \
    meson gcc musl-dev

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

# Build final runner
# FIMXE: Strip debugging information
FROM alpine:edge
COPY --from=build /opt /opt
Add startup.sh /
RUN apk add libxkbcommon pixman wayland \
    libinput libevdev libdrm wayland-protocols cairo mesa \
    linux-pam-dev \
    freerdp xwayland libxcursor librsvg \
    musl
