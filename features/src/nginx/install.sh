#!/bin/bash
set -e
set +H
set -x

DEBIAN_FRONTEND="noninteractive" sudo apt-get update &&
DEBIAN_FRONTEND="noninteractive" sudo apt-get install --no-install-recommends -y nginx nginx-extras &&
    sudo apt-get clean
