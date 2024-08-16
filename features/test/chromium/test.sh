#!/bin/bash
set -e

source dev-container-features-test-lib

check "execute command" bash -c "id; whoami; env"
check "execute command" bash -c "chrome --version"
# # hang here
# # Warning: vkCreateInstance: Found no drivers!
# # Warning: vkCreateInstance failed with VK_ERROR_INCOMPATIBLE_DRIVER
# #     at CheckVkSuccessImpl (../../third_party/dawn/src/dawn/native/vulkan/VulkanError.cpp:106)
# check "execute command" bash -c "chrome --disable-e-gpu --no-sandbox --headless"

reportResults
