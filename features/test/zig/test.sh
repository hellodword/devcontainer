#!/bin/bash
set -e

source dev-container-features-test-lib

check "execute command" bash -c "id; whoami; env"
check "execute command" bash -c "zig version"
check "execute command" bash -c "zls --version"

reportResults
