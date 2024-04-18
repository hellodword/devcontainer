#!/bin/bash
set -e
set +H
set -x

sudo apt-get update &&
    DEBIAN_FRONTEND="noninteractive" sudo apt-get install --no-install-recommends -y \
        fonts-liberation fonts-noto fonts-noto-cjk fonts-noto-color-emoji libgtk-3-dev &&
    sudo apt-get clean
