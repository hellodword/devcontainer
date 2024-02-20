#!/bin/bash
set -e
set +H
set -x

DEBIAN_FRONTEND="noninteractive" sudo apt-get update &&
    sudo apt-get install --no-install-recommends -y \
        wget curl ca-certificates \
        unzip p7zip-full \
        vim bash-completion \
        software-properties-common \
        jq file &&
    sudo apt-get clean
