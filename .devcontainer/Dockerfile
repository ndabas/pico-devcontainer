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

WORKDIR /opt/corev-openhw-gcc
RUN set -eux; \
    curl -fsSL \
    https://buildbot.embecosm.com/job/corev-gcc-ubuntu2204/47/artifact/corev-openhw-gcc-ubuntu2204-20240530.tar.gz \
        --output corev-openhw-gcc.tar.gz \
    ; \
    tar -xf corev-openhw-gcc.tar.gz --strip-components=1; \
    rm corev-openhw-gcc.tar.gz
ENV PATH $PATH:/opt/corev-openhw-gcc/bin

ARG PICO_SDK_VERSION=2.0.0
ENV PICO_SDK_VERSION ${PICO_SDK_VERSION}
ENV PICO_SDK_PATH /opt/pico-sdk
RUN set -eux; \
    git clone -b "${PICO_SDK_VERSION}" -c advice.detachedHead=false "https://github.com/raspberrypi/pico-sdk.git" "${PICO_SDK_PATH}"; \
    git -C "${PICO_SDK_PATH}" submodule update --init --depth=1
