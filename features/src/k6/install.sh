#!/bin/bash
set -e
set +H
set -x

sudo gpg -k &&
sudo gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69 &&
echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list &&
DEBIAN_FRONTEND="noninteractive" sudo apt-get update &&
DEBIAN_FRONTEND="noninteractive" sudo apt-get install --no-install-recommends -y k6 &&
    sudo apt-get clean
