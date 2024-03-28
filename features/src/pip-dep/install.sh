#!/bin/bash
set -e
set +H
set -x


sudo -Eu "$_REMOTE_USER" bash -ex << EOF

# check pip version
pip -V

# fix HOME rewrited by sudo -E
export HOME="$_REMOTE_USER_HOME"

bash -c "pip install $DEPS"
rm -rf "$_REMOTE_USER_HOME/.cache/pip"
EOF
