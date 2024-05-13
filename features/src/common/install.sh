#!/bin/bash
set -e
set +H
set -x

sudo apt-get update &&
    DEBIAN_FRONTEND="noninteractive" sudo apt-get install --no-install-recommends -y \
        wget curl ca-certificates \
        unzip p7zip-full \
        vim bash-completion \
        software-properties-common \
        jq file \
        aria2 \
        apt-file \
        fd-find ripgrep netcat &&
    sudo apt-file update &&
    sudo apt-get clean

ln -s $(which fdfind) $(dirname $(which fdfind))/fd
