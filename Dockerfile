FROM ubuntu:22.04

ENV \
    PUID=1000 \
    PGID=1000 \
    UMASK=000 \
    UNAME="retro" \
    HOME="/home/retro" \
    TZ="Europe/Moscow" \
    DEBIAN_FRONTEND=noninteractive \
    NEEDRESTART_SUSPEND=1

RUN <<_INSTALL_PACKAGES
set -e
apt update

# Get packages
apt install -y --no-install-recommends \
    fuse \
    libnss3 \
    wget \
    curl \
    ca-certificates \
    jq \
    gnupg2 \
    dbus-x11 \
    flatpak \
    sudo \
    kde-standard \
    locales \
    plasma-workspace-wayland \
    kwin-wayland-backend-wayland \
    mesa-vulkan-drivers libgbm1 libgles2 libegl1 libgl1-mesa-dri \
    libnvidia-egl-wayland1 libnvidia-egl-gbm1

# Get gosu
wget --progress=dot:giga \
    -O /usr/bin/gosu \
    "https://github.com/tianon/gosu/releases/download/1.17/gosu-amd64"
chmod +x /usr/bin/gosu

# Cleanup
rm -rf /var/lib/apt/lists/*

# Gen locale
locale-gen en_US.UTF-8
locale-gen ru_RU.UTF-8

_INSTALL_PACKAGES

WORKDIR /

COPY entrypoint.sh .
RUN useradd --create-home --shell /bin/bash retro
