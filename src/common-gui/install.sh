#!/bin/bash
set -e
set +H

DEBIAN_FRONTEND="noninteractive" sudo apt update &&
    sudo apt install --no-install-recommends -y \
        fonts-noto fonts-noto-cjk libgtk-3-dev
