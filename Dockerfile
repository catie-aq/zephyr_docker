FROM zephyrprojectrtos/ci:v0.27.4 AS workspace

RUN wget --post-data "accept_license_agreement=accepted" https://www.segger.com/downloads/jlink/JLink_Linux_V796c_x86_64.tgz \
    && mkdir -p /opt/SEGGER/JLink \
    && tar -xvf JLink_Linux_V796c_x86_64.tgz -C /opt/SEGGER/JLink \
    && ln -s /opt/SEGGER/JLink/JLink_Linux_V796c_x86_64/JLinkExe /usr/bin/JLinkExe \
    && mkdir -p /etc/udev/rules.d \
    && cp /opt/SEGGER/JLink/JLink_Linux_V796c_x86_64/99-jlink.rules /etc/udev/rules.d/ \
    && rm JLink_Linux_V796c_x86_64.tgz

RUN wget --post-data "accept_license_agreement=accepted" https://www.segger.com/downloads/jlink/Ozone_Linux_V338c_x86_64.tgz \
    && mkdir -p /opt/SEGGER/Ozone \
    && tar -xvf Ozone_Linux_V338c_x86_64.tgz -C /opt/SEGGER/Ozone \
    && ln -s /opt/SEGGER/Ozone/Ozone_Linux_V338c_x86_64/Ozone /usr/bin/Ozone \
    && rm Ozone_Linux_V338c_x86_64.tgz

RUN west init -m https://github.com/catie-aq/6tron_zephyr-workspace --mr v3.7.0+202408 6tron-workspace
WORKDIR /6tron-workspace
RUN west update

FROM zephyrprojectrtos/ci:v0.27.4

RUN wget --post-data "accept_license_agreement=accepted" https://www.segger.com/downloads/jlink/JLink_Linux_V796c_x86_64.tgz \
    && mkdir -p /opt/SEGGER/JLink \
    && tar -xvf JLink_Linux_V796c_x86_64.tgz -C /opt/SEGGER/JLink \
    && ln -s /opt/SEGGER/JLink/JLink_Linux_V796c_x86_64/JLinkExe /usr/bin/JLinkExe \
    && mkdir -p /etc/udev/rules.d \
    && cp /opt/SEGGER/JLink/JLink_Linux_V796c_x86_64/99-jlink.rules /etc/udev/rules.d/ \
    && rm JLink_Linux_V796c_x86_64.tgz

RUN wget --post-data "accept_license_agreement=accepted" https://www.segger.com/downloads/jlink/Ozone_Linux_V338c_x86_64.tgz \
    && mkdir -p /opt/SEGGER/Ozone \
    && tar -xvf Ozone_Linux_V338c_x86_64.tgz -C /opt/SEGGER/Ozone \
    && ln -s /opt/SEGGER/Ozone/Ozone_Linux_V338c_x86_64/Ozone /usr/bin/Ozone \
    && rm Ozone_Linux_V338c_x86_64.tgz
