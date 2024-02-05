#!/bin/bash
set -e
set +H

DEBIAN_FRONTEND="noninteractive" sudo apt update &&
    sudo apt install --no-install-recommends -y \
        jq file vim bash-completion
