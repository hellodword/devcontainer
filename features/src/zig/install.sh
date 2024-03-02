#!/usr/bin/env bash

set -e
set +H
set -x

# avoid using github api which has rate limit, especially with VPN
REPO="ziglang/zig"
LATEST_VERSION="$(curl -fsS -w "%{redirect_url}" -o /dev/null "https://github.com/$REPO/releases/latest" | grep -oP '(?<=/releases/tag/)[^/]+$')"
[ -n "$LATEST_VERSION" ]

curl -fsSL --output /tmp/zig.tar.xz "https://ziglang.org/download/$LATEST_VERSION/zig-linux-x86_64-$LATEST_VERSION.tar.xz"
# TODO verify

ZIG_ROOT="/usr/local/zig"
mkdir -p "$ZIG_ROOT"
echo "Extracting Zig ${LATEST_VERSION}..."
tar -xf /tmp/zig.tar.xz -C "$ZIG_ROOT" --strip-components=1
rm -rf /tmp/zig.tar.xz

curl -fsSL --output /tmp/zls-x86_64-linux.tar.gz "https://github.com/zigtools/zls/releases/download/$LATEST_VERSION/zls-x86_64-linux.tar.gz"

mkdir -p "/usr/local/zls"
echo "Extracting zls ${LATEST_VERSION}..."
tar -xzf /tmp/zls-x86_64-linux.tar.gz -C /usr/local/zls --strip-components=1
chmod +x /usr/local/zls/bin/zls
rm -rf /tmp/zls-x86_64-linux.tar.gz
