#!/bin/bash
set -e

source dev-container-features-test-lib

check "execute command" bash -c "fc-match sans --sort | head -10"

reportResults
