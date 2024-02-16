#!/bin/bash
set -e

source dev-container-features-test-lib

check "execute command" bash -c "id; whoami; env"
check "execute command" bash -c "chrome --version"
check "execute command" bash -c "chrome --disable-e-gpu --no-sandbox --headless"

reportResults
