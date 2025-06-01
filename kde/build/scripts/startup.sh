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

# Make user directory
mkdir -p ~/Desktop ~/Documents ~/Downloads ~/Music ~/Pictures ~/Public ~/Templates ~/Videos
chmod 755 ~/Desktop ~/Documents ~/Downloads ~/Music ~/Pictures ~/Public ~/Templates ~/Videos

# Flatpak
export XDG_DATA_DIRS=/var/lib/flatpak/exports/share:/home/retro/.local/share/flatpak/exports/share:/usr/local/share/:/usr/share/
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
#flatpak override --user --nosocket=wayland
sudo /opt/gow/startdbus
export $(dbus-launch)

# Heroic symlync to shared storage
[ -d $HOME/Games ] || ln -s /shared /home/retro/Games


if [ ! -f $HOME/.config/kwinrc ]; then
	kwriteconfig5 --file $HOME/.config/kwinrc --group Compositing --key Enabled enable
fi
if [ ! -f $HOME/.config/kscreenlockerrc ]; then
	kwriteconfig5 --file $HOME/.config/kscreenlockerrc --group Daemon --key Autolock false
fi

export XDG_CURRENT_DESKTOP=KDE
export DE=kde
export DESKTOP_SESSION=kde
export XDG_SESSION_TYPE=wayland
launcher startplasma-wayland --xwyaland
# Check eula
#[ -f $HOME/EULA ] || echo eula=false > $HOME/EULA
#if grep -Fxq "eula=true" $HOME/EULA
#then
#    gow_log "EULA accepted"
#    startplasma-wayland --xwyaland
#else
#    gow_log "EULA regected"
#    firefox
#fi
