#!/bin/bash

set -euxo pipefail

for REPO in examples extras; do
    DEST="/tmp/pico-${REPO}"
    export "PICO_${REPO^^}_PATH=${DEST}"

    if [ ! -d "$DEST" ]; then
        git clone -b "sdk-${PICO_SDK_VERSION}" -c advice.detachedHead=false \
            "https://github.com/raspberrypi/pico-${REPO}.git" \
            "$DEST"
    fi
done

FREERTOS_KERNEL_PATH=/tmp/FreeRTOS-Kernel

if [ ! -d "$FREERTOS_KERNEL_PATH" ]; then
    git clone --depth=1 -b main \
        "https://github.com/FreeRTOS/FreeRTOS-Kernel.git" \
        "$FREERTOS_KERNEL_PATH"
fi

test-build () {
    BUILD_DIR="$1"
    shift 1
    mkdir -p "$BUILD_DIR"
    pushd "$BUILD_DIR"
    cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Debug --fresh "$@"
    cmake --build .
    popd
}

cd "$PICO_SDK_PATH"
test-build build -DPICO_SDK_TESTS_ENABLED=1

cd "$PICO_EXAMPLES_PATH"

test-build build-pico -DPICO_BOARD=pico
# pico2 build disabled: https://github.com/raspberrypi/pico-examples/issues/513
# test-build build-pico2 -DPICO_BOARD=pico2
test-build build-pico2-riscv -DPICO_BOARD=pico2 -DPICO_PLATFORM=rp2350-riscv
test-build build-pico_w \
    -DPICO_BOARD=pico_w \
    -DWIFI_SSID=ssid \
    -DWIFI_PASSWORD=pass \
    "-DFREERTOS_KERNEL_PATH=${FREERTOS_KERNEL_PATH}" \
    -DTEST_TCP_SERVER_IP=10.10.10.10
