# Base Image (ci-base)

FROM ubuntu:22.04

ARG UID=1000
ARG GID=1000
ARG ZSDK_VERSION=0.17.0
ENV ZSDK_VERSION=$ZSDK_VERSION

# Set default shell during Docker image build to bash
SHELL ["/bin/bash", "-c"]

# Set non-interactive frontend for apt-get to skip any user confirmations
ENV DEBIAN_FRONTEND=noninteractive

# Install base packages and multi-lib gcc (x86 only) in a single RUN command
RUN apt-get -y update && \
    apt-get install --no-install-recommends -y \
    software-properties-common lsb-release autoconf automake bison build-essential \
    ca-certificates ccache chrpath cmake cpio device-tree-compiler dfu-util diffstat \
    dos2unix file flex g++ gawk gcc gcovr gdb git gnupg gperf help2man iproute2 \
    lcov libcairo2-dev libglib2.0-dev liblocale-gettext-perl libncurses5-dev libpcap-dev \
    libpopt0 libsdl1.2-dev libsdl2-dev libssl-dev libtool libtool-bin locales make net-tools \
    ninja-build openssh-client parallel pkg-config python3-dev python3-pip python3-ply \
    python3-setuptools python-is-python3 qemu rsync socat srecord sudo texinfo unzip valgrind \
    wget ovmf xz-utils thrift-compiler \
    $(if [ "${HOSTTYPE}" = "x86_64" ]; then echo "gcc-multilib g++-multilib"; fi) && \
    if [ "${HOSTTYPE}" = "x86_64" ]; then \
    dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y \
    libsdl2-dev:i386 libfuse-dev:i386 libc6-dbg:i386; \
    fi && \
    apt-get clean -y && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Python dependencies in a single RUN command
RUN python3 -m pip install -U --no-cache-dir pip wheel setuptools && \
    pip3 install --no-cache-dir pygobject && \
    pip3 install --no-cache-dir \
    -r https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/main/scripts/requirements.txt \
    -r https://raw.githubusercontent.com/zephyrproject-rtos/mcuboot/main/scripts/requirements.txt \
    GitPython imgtool junitparser junit2html numpy protobuf PyGithub pylint sh statistics west \
    nrf-regtool~=7.0.0 && \
    if [ "${HOSTTYPE}" = "x86_64" ]; then pip3 check; fi && \
    rm -rf /root/.cache/pip

# Install Zephyr SDK
RUN mkdir -p /opt/toolchains
WORKDIR /opt/toolchains
RUN wget -q --show-progress --progress=bar:force:noscroll "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZSDK_VERSION}/zephyr-sdk-${ZSDK_VERSION}_linux-${HOSTTYPE}_minimal.tar.xz" && \
    tar xf zephyr-sdk-${ZSDK_VERSION}_linux-${HOSTTYPE}_minimal.tar.xz && \
    /opt/toolchains/zephyr-sdk-${ZSDK_VERSION}/setup.sh -t arm-zephyr-eabi -h -c && \
    rm zephyr-sdk-${ZSDK_VERSION}_linux-${HOSTTYPE}_minimal.tar.xz && \
    rm -rf /opt/toolchains/zephyr-sdk-${ZSDK_VERSION}/sysroots/x86_64-pokysdk-linux/usr/src/debug && \
    rm -rf /opt/toolchains/zephyr-sdk-${ZSDK_VERSION}/sysroots/x86_64-pokysdk-linux/usr/include


ENV ZEPHYR_TOOLCHAIN_VARIANT=zephyr
ENV PKG_CONFIG_PATH=/usr/lib/i386-linux-gnu/pkgconfig
ENV OVMF_FD_PATH=/usr/share/ovmf/OVMF.fd
ENV ARMFVP_BIN_PATH=/usr/local/bin