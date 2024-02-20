#!/bin/bash
set -e

source dev-container-features-test-lib

check "execute command" bash -c "id; whoami; env"
check "execute command" bash -c "valac --version"
check "execute command" bash -c "vala-language-server -v || true"
check "execute command" bash -c "uncrustify --version"

reportResults
