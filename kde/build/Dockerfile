# syntax=docker/dockerfile:1.4
ARG BASE_APP_IMAGE

# hadolint ignore=DL3006
FROM ${BASE_APP_IMAGE}

ARG CORE_PACKAGES=" \
    flatpak \
    sudo \
    dbus-x11 \
    firefox \
    "

RUN apt-get update && \
    apt-get install -y kde-standard

ARG ADDITIONAL_PACKAGES=" \
    systemsettings \
    plasma-discover \
    neofetch \
    zip unzip p7zip-full \
    kde-config-flatpak \
    plasma-discover-backend-flatpak \
    "
# 
# Prevent firefox snap
COPY scripts/ff-unsnap /etc/apt/preferences.d/ff-unsnap

RUN dpkg --remove --force-remove-reinstreq libgl1-amber-dri

RUN \
    # \
    # Get steam \
    dpkg --add-architecture i386 && \
    apt update &&  apt upgrade -y && \
    apt install steam-installer -y

#Added 32-bit libs because of GE-Proton needs
ARG HEROIC_PACKAGES=" \
    libfreetype6:i386 \
    libvulkan1 \
    libvulkan1:i386 \
    mesa-vulkan-drivers \
    mesa-vulkan-drivers:i386 \
    wine64 \
    wine32 \
    libasound2-plugins:i386 \
    libsdl2-2.0-0:i386 \
    libdbus-1-3:i386 \
    libsqlite3-0:i386 \
    wine-stable \
    winetricks \
    zenity \
    libnotify4 \
    xdg-utils \
    libsecret-1-0 \
    curl \
    unzip \
    p7zip-full \
    cabextract \
    gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav \
    gstreamer1.0-plugins-base:i386 gstreamer1.0-plugins-good:i386 gstreamer1.0-plugins-bad:i386 gstreamer1.0-plugins-ugly:i386 gstreamer1.0-libav:i386 \
    tar \
    wget \
    ca-certificates \
    xz-utils \
    "

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends $HEROIC_PACKAGES && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /

RUN <<_INSTALL_HEROIC
#!/bin/bash
set -e
source /opt/gow/bash-lib/utils.sh

github_download "Heroic-Games-Launcher/HeroicGamesLauncher" ".assets[]|select(.name|endswith(\"amd64.deb\")).browser_download_url" "heroic.deb"
dpkg -i heroic.deb
rm heroic.deb
_INSTALL_HEROIC

RUN <<_INSTALL_MANGO
#!/bin/bash
set -e
source /opt/gow/bash-lib/utils.sh

github_download "flightlessmango/MangoHud" ".assets[]|select(.name|endswith(\".tar.gz\")).browser_download_url" "MangoHud.tar.gz"
tar xf MangoHud.tar.gz
cd MangoHud
tar xf MangoHud-package.tar
chmod +x ./mangohud-setup.sh && ./mangohud-setup.sh install
rm -rf /MangoHud
rm /MangoHud.tar.gz
_INSTALL_MANGO

RUN \
    # \
    # Setup Firefox PPA \
    apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common gpg-agent && \
    add-apt-repository -y ppa:mozillateam/ppa && \
    apt-get update
    # \
    # Install core packages \
RUN \
    apt-get install -y --no-install-recommends $CORE_PACKAGES
    # \
    # Install de \
RUN \
    # \
    apt-get install -y $ADDITIONAL_PACKAGES
    # \
    # Fixes \
RUN \
    rm -f \
    /etc/xdg/autostart/xscreensaver.desktop
    # \
    # Clean \
RUN \
    apt update && \
    apt-get remove -y foot && \
    apt autoremove -y &&\
    apt clean && \
    rm -rf \
        /config/.cache \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*


# 
# Replace launch scripts
COPY --chmod=777 scripts/startup.sh /opt/gow/
COPY --chmod=777 scripts/startdbus.sh /opt/gow/startdbus

COPY configs /cfg

# 
# Fix locals
COPY scripts/locale /etc/default/locale

# 
# Allow anyone to start dbus without password
RUN echo "\nALL ALL=NOPASSWD: /opt/gow/startdbus" >> /etc/sudoers

# 
# Fix bwarp perms for flatpaks
RUN chmod u+s /usr/bin/bwrap

ENV XDG_RUNTIME_DIR=/tmp/.X11-unix

ARG IMAGE_SOURCE
LABEL org.opencontainers.image.source=$IMAGE_SOURCE
