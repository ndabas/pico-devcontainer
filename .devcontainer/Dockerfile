# syntax=docker/dockerfile:1

ARG PYTHON_VERSION=3.12
FROM python:${PYTHON_VERSION}-bookworm

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        cmake \
        ninja-build \
        gcc-arm-none-eabi \
        libnewlib-arm-none-eabi \
        libstdc++-arm-none-eabi-newlib \
    ; \
    rm -rf /var/lib/apt/lists/*

RUN pip install pycryptodome

ARG PICO_SDK_VERSION=1.5.1
ENV PICO_SDK_VERSION=${PICO_SDK_VERSION}
ENV PICO_SDK_PATH=/opt/pico-sdk
RUN set -eux; \
    git clone -b "${PICO_SDK_VERSION}" -c advice.detachedHead=false "https://github.com/raspberrypi/pico-sdk.git" "${PICO_SDK_PATH}"; \
    git -C "${PICO_SDK_PATH}" submodule update --init --depth=1; \
    git -C "${PICO_SDK_PATH}/lib/tinyusb" submodule update --init --depth=1 hw/mcu/raspberry_pi
