#!/bin/bash -e

source /opt/gow/bash-lib/utils.sh

# Run additional startup scripts
for file in /opt/gow/startup.d/* ; do
    if [ -f "$file" ] ; then
        gow_log "[start] Sourcing $file"
        source $file
    fi
done

gow_log "[start] Starting KDE"
source /opt/gow/launch-comp.sh
mkdir -p /tmp/.X11-unix/
chown retro:retro /tmp/.X11-unix/
chmod +t /tmp/.X11-unix

# Flatpak
export $(dbus-launch)
export XDG_DATA_DIRS=/var/lib/flatpak/exports/share:/home/retro/.local/share/flatpak/exports/share:/usr/local/share/:/usr/share/
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

export XDG_CURRENT_DESKTOP=KDE
export DE=kde
export DESKTOP_SESSION=kde
export XDG_SESSION_TYPE=wayland
# Disable compositing and screen lock
if [ ! -f $HOME/.config/kwinrc ]; then
	kwriteconfig6 --file $HOME/.config/kwinrc --group Compositing --key Enabled true
fi
if [ ! -f $HOME/.config/kscreenlockerrc ]; then
	kwriteconfig6 --file $HOME/.config/kscreenlockerrc --group Daemon --key Autolock false
fi
launcher startplasma-wayland --xwayland
