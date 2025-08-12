#!/bin/bash -e

mkdir -p /tmp/.X11-unix/
chown retro:retro /tmp/.X11-unix/
chmod 0700 /tmp/.X11-unix/
chmod +t /tmp/.X11-unix

sudo -u retro bash -c "
  mkdir -p ~/Desktop ~/Documents ~/Downloads ~/Music ~/Pictures ~/Public ~/Templates ~/Videos
  chmod 755 ~/Desktop ~/Documents ~/Downloads ~/Music ~/Pictures ~/Public ~/Templates ~/Videos

  export XDG_DATA_DIRS=/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:/usr/local/share/:/usr/share/
  flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  export \$(dbus-launch)

  if [ ! -f \$HOME/.config/kwinrc ]; then
       kwriteconfig5 --file \$HOME/.config/kwinrc --group Compositing --key Enabled enable
  fi
  if [ ! -f \$HOME/.config/kscreenlockerrc ]; then
       kwriteconfig5 --file \$HOME/.config/kscreenlockerrc --group Daemon --key Autolock false
  fi


  export XDG_CURRENT_DESKTOP=KDE
  export DE=kde
  export DESKTOP_SESSION=kde
  export XDG_SESSION_TYPE=wayland
  export XDG_RUNTIME_DIR=/tmp/.X11-unix
  dbus-run-session -- startplasma-wayland --xwyaland
"
