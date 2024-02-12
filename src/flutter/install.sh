#!/bin/bash
set -e
set +H

FLUTTER_VERSION="3.16.9"
FLUTTER_USER=vscode



curl -fsSL --output /tmp/flutter.tar.xz "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$FLUTTER_VERSION-stable.tar.xz"
sudo runuser -l "$FLUTTER_USER" -c 'tar xf /tmp/flutter.tar.xz -C $HOME'
rm /tmp/flutter.tar.xz
# sudo runuser -l "$FLUTTER_USER" -c 'echo '"'"'export PATH="$PATH:$HOME/flutter/bin"'"'"' >> ~/.bashrc'
sudo runuser -l "$FLUTTER_USER" -c '$HOME/flutter/bin/flutter --disable-analytics'
# sudo runuser -l "$FLUTTER_USER" -c '$HOME/flutter/bin/flutter --disable-telemetry'
sudo runuser -l "$FLUTTER_USER" -c '$HOME/flutter/bin/flutter precache'
sudo runuser -l "$FLUTTER_USER" -c 'yes "y" | $HOME/flutter/bin/flutter doctor --android-licenses'
