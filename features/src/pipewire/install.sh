#!/bin/bash
set -e
set +H
set -x

DEBIAN_FRONTEND="noninteractive" sudo apt-get update &&
    sudo apt-get install --no-install-recommends -y \
        pipewire alsa-utils ffmpeg &&
    sudo apt-get clean
