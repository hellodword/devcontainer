#!/bin/bash
set -e

source dev-container-features-test-lib

check "execute command" bash -c "id; whoami; env"
check "execute command" bash -c "cloudflared version"
check "execute command" bash -c "update-cloudflared"

reportResults
