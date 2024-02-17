#!/bin/bash
set -e
set +H
set -x

DEBIAN_FRONTEND="noninteractive" sudo apt-get update &&
    sudo apt-get install --no-install-recommends -y curl &&
    sudo apt-get clean

mkdir -p /usr/local/bin

mv "$(dirname $0)/update-cloudflared" /usr/local/bin/update-cloudflared
chmod +x /usr/local/bin/update-cloudflared

/usr/local/bin/update-cloudflared
