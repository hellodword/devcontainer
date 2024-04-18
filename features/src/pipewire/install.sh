#!/bin/bash
set -e
set +H
set -x

sudo apt-get update &&
    DEBIAN_FRONTEND="noninteractive" sudo apt-get install --no-install-recommends -y \
        pipewire alsa-utils ffmpeg &&
    sudo apt-get clean
