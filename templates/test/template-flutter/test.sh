#!/bin/bash
cd $(dirname "$0")
source test-utils.sh

# Template specific tests
check "execute command" bash -c "id; whoami; env"
check "execute command" bash -c "ls -alh $FLUTTER_HOME"
check "execute command" bash -c "flutter doctor -v"
check "execute command" bash -c "cd /tmp && flutter create test_drive && cd test_drive && flutter build linux && flutter build apk"

# Report result
reportResults
