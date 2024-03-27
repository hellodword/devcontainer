#!/bin/bash
set -e
set +H
set -x

# avoid using github api which has rate limit, especially with VPN
REPO="solana-labs/solana"
export LATEST_VERSION="$(curl -fsS -w "%{redirect_url}" -o /dev/null "https://github.com/$REPO/releases/latest" | grep -oP '(?<=/releases/tag/)[^/]+$')"
[ -n "$LATEST_VERSION" ]

sudo -Eu "$_REMOTE_USER" bash -ex << EOF
# fix HOME rewrited by sudo -E
export HOME="$_REMOTE_USER_HOME"

curl -sSfL "https://release.solana.com/$LATEST_VERSION/install" | sh
EOF
