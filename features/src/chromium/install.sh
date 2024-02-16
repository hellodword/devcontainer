#!/bin/bash
set -e
set +H
set -x

# ldd `which chrome` | grep -i found | awk '{print $1}' | xargs -I {} bash -c 'echo finding {}; apt-file search {}'
DEBIAN_FRONTEND="noninteractive" sudo apt-get update &&
    sudo apt-get install --no-install-recommends -y \
        unzip wget curl \
        fonts-noto fonts-noto-cjk \
        libglib2.0-0 libnss3 libdbus-1-3 \
        libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 \
        libxcomposite1 libxdamage1 libxfixes3 libxrandr2 \
        libgbm1 libxkbcommon0 libpango-1.0-0 libcairo2 libasound2 &&
    sudo apt-get clean

# Options.
if [ -z "$REVISION" ]; then
    REVISION="$(curl -fsSL https://storage.googleapis.com/chromium-browser-snapshots/Linux_x64/LAST_CHANGE)"
fi

mkdir -p /usr/local/lib

wget -q "https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F${REVISION}%2Fchrome-linux.zip?alt=media" -O chromium.zip
unzip chromium.zip -d /usr/local/lib
rm chromium.zip
