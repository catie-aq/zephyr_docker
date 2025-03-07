# Base Image

FROM ubuntu:22.04 as ci

ARG ZSDK_VERSION=0.17.0
ENV ZSDK_VERSION=$ZSDK_VERSION
ARG WORKSPACE_VERSION=v3.7.0+202408
ENV WORKSPACE_VERSION=$WORKSPACE_VERSION
ARG PROTOC_VERSION=21.7
ENV PROTOC_VERSION=$PROTOC_VERSION

# Set default shell during Docker image build to bash
SHELL ["/bin/bash", "-c"]

# Set non-interactive frontend for apt-get to skip any user confirmations
ENV DEBIAN_FRONTEND=noninteractive

# Install base packages and multi-lib gcc (x86 only) in a single RUN command
RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y \
    software-properties-common lsb-release autoconf automake bison build-essential \
    ca-certificates ccache chrpath cmake device-tree-compiler dfu-util \
    dos2unix file flex g++ gawk gcc gcovr gdb git gnupg \
    lcov libcairo2-dev libglib2.0-dev liblocale-gettext-perl libncurses5-dev libpcap-dev \
    libpopt0 libsdl1.2-dev libsdl2-dev libssl-dev libtool libtool-bin locales make net-tools \
    ninja-build parallel pkg-config python3-dev python3-pip python3-ply \
    python3-setuptools python-is-python3 qemu rsync unzip \
    wget xz-utils thrift-compiler gcc-multilib g++-multilib libsdl2-dev:i386 libfuse-dev:i386 libc6-dbg:i386;\
    apt-get clean -y && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN python3 -m pip install -U --no-cache-dir pip==25.0.1 wheel==0.45.1 setuptools==75.8.2 && \
    pip3 install --no-cache-dir pygobject==3.42.1 && \
    pip3 install --no-cache-dir \
    -r https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/main/scripts/requirements.txt \
    -r https://raw.githubusercontent.com/zephyrproject-rtos/mcuboot/main/scripts/requirements.txt \
    GitPython imgtool junitparser junit2html numpy protobuf PyGithub pylint sh statistics west \
    nrf-regtool~=7.0.0 && \
    if [ "${HOSTTYPE}" = "x86_64" ]; then pip3 check; fi && \
    rm -rf /root/.cache/pip

# Install protobuf-compiler
RUN mkdir -p /opt/protoc
WORKDIR /opt/protoc
RUN	wget -q --show-progress --progress=bar:force:noscroll https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip && \
	unzip protoc-${PROTOC_VERSION}-linux-x86_64.zip && \
	ln -s /opt/protoc/bin/protoc /usr/local/bin && \
	rm -f protoc-${PROTOC_VERSION}-linux-x86_64.zip

# Install Zephyr SDK
RUN mkdir -p /opt/toolchains
WORKDIR /opt/toolchains
RUN wget -q --show-progress --progress=bar:force:noscroll https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZSDK_VERSION}/zephyr-sdk-${ZSDK_VERSION}_linux-${HOSTTYPE}_minimal.tar.xz && \
    tar xf zephyr-sdk-${ZSDK_VERSION}_linux-${HOSTTYPE}_minimal.tar.xz && \
    /opt/toolchains/zephyr-sdk-${ZSDK_VERSION}/setup.sh -t arm-zephyr-eabi -h -c && \
    rm zephyr-sdk-${ZSDK_VERSION}_linux-${HOSTTYPE}_minimal.tar.xz && \
    rm -rf /opt/toolchains/zephyr-sdk-${ZSDK_VERSION}/sysroots/x86_64-pokysdk-linux/usr/src/debug && \
    rm -rf /opt/toolchains/zephyr-sdk-${ZSDK_VERSION}/sysroots/x86_64-pokysdk-linux/usr/include


ENV ZEPHYR_TOOLCHAIN_VARIANT=zephyr

FROM ci as dev

RUN wget -q --show-progress --progress=bar:force:noscroll --post-data "accept_license_agreement=accepted" https://www.segger.com/downloads/jlink/JLink_Linux_V796c_x86_64.tgz \
    && mkdir -p /opt/SEGGER/JLink \
    && tar -xvf JLink_Linux_V796c_x86_64.tgz -C /opt/SEGGER/JLink \
    && ln -s /opt/SEGGER/JLink/JLink_Linux_V796c_x86_64/JLinkExe /usr/bin/JLinkExe \
    && mkdir -p /etc/udev/rules.d \
    && cp /opt/SEGGER/JLink/JLink_Linux_V796c_x86_64/99-jlink.rules /etc/udev/rules.d/ \
    && rm JLink_Linux_V796c_x86_64.tgz

RUN wget -q --show-progress --progress=bar:force:noscroll --post-data "accept_license_agreement=accepted" https://www.segger.com/downloads/jlink/Ozone_Linux_V338c_x86_64.tgz \
    && mkdir -p /opt/SEGGER/Ozone \
    && tar -xvf Ozone_Linux_V338c_x86_64.tgz -C /opt/SEGGER/Ozone \
    && ln -s /opt/SEGGER/Ozone/Ozone_Linux_V338c_x86_64/Ozone /usr/bin/Ozone \
    && rm Ozone_Linux_V338c_x86_64.tgz

FROM dev as workspace

RUN west init -m https://github.com/catie-aq/6tron_zephyr-workspace --mr ${WORKSPACE_VERSION}  /6tron-workspace
WORKDIR /6tron-workspace
RUN west update
