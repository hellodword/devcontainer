#!/bin/bash
set -e
set +H
set -x

export FLUTTER_PARENT="$(dirname $FLUTTER_HOME)"
mkdir -p "$FLUTTER_PARENT"

sudo -Eu "$_REMOTE_USER" bash -x << EOF
# fix HOME rewrited by sudo -E
export HOME="$_REMOTE_USER_HOME"

export PATH="$PATH:$FLUTTER_HOME/bin"

id
whoami
env


curl -fsSL --output /tmp/flutter.tar.xz "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$FLUTTER_VERSION-stable.tar.xz"
sudo tar xf /tmp/flutter.tar.xz -C "$FLUTTER_PARENT"
rm /tmp/flutter.tar.xz

sudo chown -R "$_REMOTE_USER:$_REMOTE_USER" "$FLUTTER_HOME"

dart --disable-analytics
flutter --disable-analytics
# flutter --disable-telemetry
flutter precache
yes "y" | flutter doctor --android-licenses

# simply prepare sdk/emulator/build-tools for flutter
# or parse from source and sdkmanager --list
# https://github.com/flutter/flutter/blob/41456452f29d64e8deb623a3c927524bcf9f111b/packages/flutter_tools/gradle/src/main/groovy/flutter.groovy#L44-L62
pushd /tmp
flutter create test_drive && cd test_drive && flutter build linux && flutter build apk
popd
rm -rf /tmp/test_drive

sudo chown -R "$_REMOTE_USER:$_REMOTE_USER" "$FLUTTER_HOME"

EOF
