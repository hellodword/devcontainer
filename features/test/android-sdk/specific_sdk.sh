#!/bin/bash
set -e

source dev-container-features-test-lib

check "execute command" bash -c "id; whoami; env"
check "execute command" bash -c "ls -alh $ANDROID_HOME"
check "execute command" bash -c "adb --version"
check "execute command" bash -c "sdkmanager --list_installed"

reportResults
