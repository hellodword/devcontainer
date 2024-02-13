#!/bin/bash
set -e

source dev-container-features-test-lib

check "execute command" bash -c "id; whoami; env"
check "execute command" bash -c "ls -alh $FLUTTER_HOME"
check "execute command" bash -c "flutter doctor -v"
check "execute command" bash -c "cd /tmp && flutter create test_drive && cd test_drive && flutter build linux && flutter build apk"

reportResults
