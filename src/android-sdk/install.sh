#!/bin/bash
set -e
set +H
set -x

URL_SDK="https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip"

# check java version
[ -n "$JAVA_HOME" ]
[ "$(javac --version | grep -oP '(?<=javac\s)\d+')" = "17" ]

DEBIAN_FRONTEND="noninteractive" sudo apt-get update &&
    sudo apt-get install --no-install-recommends -y unzip wget usbutils &&
    sudo apt-get clean

# Prepare install folder.
mkdir -p "$ANDROID_HOME"
chown -R "$_REMOTE_USER:$_REMOTE_USER" "$ANDROID_HOME"

su - "$_REMOTE_USER"

cd $ANDROID_HOME

wget -q "$URL_SDK" -O sdk.zip
unzip sdk.zip
rm sdk.zip

mkdir -p $ANDROID_HOME/cmdline-tools/latest
cd $ANDROID_HOME/cmdline-tools
shopt -s extglob dotglob
mv !(latest) latest
shopt -u dotglob

cd $ANDROID_HOME

export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"

# Options.
if [ -z "$PLATFORM" ]; then
    PLATFORM="$(sdkmanager --list 2>/dev/null | grep -oP '(?<=\splatforms;android-)[\d]+(?=\s)' | sort --version-sort -r  | head -1)"
fi
if [ -z "$BUILD_TOOLS" ]; then
    BUILD_TOOLS="$(sdkmanager --list 2>/dev/null | grep -oP '(?<=\sbuild-tools;)[\d\.]+(?=\s)' | sort --version-sort -r  | head -1)"
fi
if [ -z "$NDK" ]; then
    NDK="$(sdkmanager --list 2>/dev/null | grep -oP '(?<=\sndk;)[\d\.]+(?=\s)' | sort --version-sort -r | head -1)"
fi
if [ -n "$BASE_PACKAGES" ]; then
    IFS=' ' read -ra PACKAGES <<< "$BASE_PACKAGES"
else
    PACKAGES=( "platform-tools" "platforms;android-$PLATFORM" "build-tools;$BUILD_TOOLS" "ndk;$NDK" )
fi
if [ -n "$EXTRA_PACKAGES" ]; then
    IFS=' ' read -ra extra <<< "$EXTRA_PACKAGES"
    PACKAGES=("${PACKAGES[@]}" "${extra[@]}")
fi

# # Save original JAVA_HOME.
# OG_JAVA_HOME=$JAVA_HOME

# # thanks https://askubuntu.com/questions/772235/how-to-find-path-to-java#comment2258200_1029326.
# export JAVA_HOME=$(dirname $(dirname $(update-alternatives --list javac 2>&1 | head -n 1)))

# TODO: Update everything to future-proof for the link getting stale.
# yes | sdkmanager "cmdline-tools;latest"
# Download the platform tools.
yes | sdkmanager "${PACKAGES[@]}"

if [ -d "$ANDROID_HOME/ndk" ]; then
    NDK="$(find "$ANDROID_HOME/ndk" -maxdepth 1 -mindepth 1 -type d -print -quit)"
    ln -s "$NDK" "$ANDROID_NDK_PATH"
fi

# # Restore JAVA_HOME.
# export JAVA_HOME=$OG_JAVA_HOME

# Make sure the Android SDK has the correct permissions.
sudo chown -R "$_REMOTE_USER:$_REMOTE_USER" "$ANDROID_HOME"

# Exist subshell.
exit
