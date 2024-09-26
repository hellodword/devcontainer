#!/bin/bash
set -e
set +H
set -x


su - "$_REMOTE_USER" bash -c '
env

# check pip version
pip -V

bash -c "pip install $DEPS"
rm -rf ~/.cache/pip
'
