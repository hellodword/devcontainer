#!/bin/bash
set -e
set +H
set -x

DEBIAN_FRONTEND="noninteractive" sudo apt-get update &&
    sudo apt-get install --no-install-recommends -y \
        fonts-noto fonts-noto-cjk libgtk-3-dev &&
    sudo apt-get clean
