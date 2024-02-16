#!/bin/bash
set -e
set +H
set -x

DEBIAN_FRONTEND="noninteractive" sudo apt-get update &&
    sudo apt-get install --no-install-recommends -y \
        fonts-liberation fonts-noto fonts-noto-cjk fonts-noto-color-emoji libgtk-3-dev &&
    sudo apt-get clean
