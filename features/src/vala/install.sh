#!/bin/bash
set -e
set +H
set -x

yes | sudo add-apt-repository ppa:vala-team/daily
DEBIAN_FRONTEND="noninteractive" sudo apt-get update &&
    sudo apt-get install --no-install-recommends -y \
        meson valac libvala-0.58-dev libjsonrpc-glib-1.0-dev libgee-0.8-dev &&
    sudo apt-get clean

mkdir -p /tmp/vala-language-server
pushd /tmp/vala-language-server
git clone --depth=1 https://github.com/vala-lang/vala-language-server
cd vala-language-server
meson -Dprefix=/usr build
ninja -C build
sudo ninja -C build install
popd
rm -rf /tmp/vala-language-server

# avoid using github api which has rate limit, especially with VPN
REPO="uncrustify/uncrustify"
LATEST_VERSION="$(curl -fsS -w "%{redirect_url}" -o /dev/null "https://github.com/$REPO/releases/latest" | grep -oP '(?<=/releases/tag/)[^/]+$')"
[ -n "$LATEST_VERSION" ]
mkdir -p /tmp/uncrustify
pushd /tmp/uncrustify
curl -fsSL "https://github.com/uncrustify/uncrustify/archive/refs/tags/$LATEST_VERSION.tar.gz" -o uncrustify.tar.gz
tar -xvf uncrustify.tar.gz --exclude="tests"
cd "uncrustify-$LATEST_VERSION"
mkdir build
cd build
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_TESTING=false \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_INSTALL_LIBDIR=lib \
    ..
make
sudo make install
popd
rm -rf /tmp/uncrustify
