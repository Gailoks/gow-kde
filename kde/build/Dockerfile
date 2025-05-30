# syntax=docker/dockerfile:1.4
ARG BASE_APP_IMAGE

# hadolint ignore=DL3006
FROM ${BASE_APP_IMAGE}

ARG CORE_PACKAGES=" \
    firefox \
    flatpak \
    sudo \
    "

ARG DE_PACKAGES=" \
    kde-standard \
    "

ARG ADDITIONAL_PACKAGES=" \
    systemsettings \
    plasma-discover \
    neofetch \
    zip unzip p7zip-full \
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
    apt-get install -y --no-install-recommends $DE_PACKAGES && \
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
