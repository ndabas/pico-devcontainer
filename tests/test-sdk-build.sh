#!/bin/bash

set -euxo pipefail

COMMON_BUILD_PARAMS=(-G Ninja -DCMAKE_BUILD_TYPE=Debug -DPICO_BOARD=pico_w --fresh)

mkdir -p /tmp/pico-sdk-build
cd /tmp/pico-sdk-build
cmake "$PICO_SDK_PATH" -DPICO_SDK_TESTS_ENABLED=1 "${COMMON_BUILD_PARAMS[@]}"
cmake --build .

for REPO in examples extras; do
    DEST="/tmp/pico-${REPO}"
    export "PICO_${REPO^^}_PATH=${DEST}"

    if [ ! -d "$DEST" ]; then
        git clone -b "sdk-${PICO_SDK_VERSION}" -c advice.detachedHead=false \
            "https://github.com/raspberrypi/pico-${REPO}.git" \
            "$DEST"
    fi
done

cd "$PICO_EXAMPLES_PATH"
mkdir -p build
cd build

cmake .. "${COMMON_BUILD_PARAMS[@]}"
cmake --build .

FREERTOS_KERNEL_PATH=/tmp/FreeRTOS-Kernel

if [ ! -d "$FREERTOS_KERNEL_PATH" ]; then
    git clone --depth=1 -b main \
        "https://github.com/FreeRTOS/FreeRTOS-Kernel.git" \
        "$FREERTOS_KERNEL_PATH"
fi

cmake .. \
    -DWIFI_SSID=ssid \
    -DWIFI_PASSWORD=pass \
    "-DFREERTOS_KERNEL_PATH=${FREERTOS_KERNEL_PATH}" \
    -DTEST_TCP_SERVER_IP=10.10.10.10 \
    "${COMMON_BUILD_PARAMS[@]}"
# Currently broken: https://github.com/raspberrypi/pico-examples/pull/429
# Can un-comment when this lands in SDK and examples 1.6.0.
# cmake --build .
