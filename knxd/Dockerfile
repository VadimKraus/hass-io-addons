ARG BUILD_FROM

# Base runtime environement
FROM ${BUILD_FROM} as run_time
ENV LANG C.UTF-8
RUN set -xe \
    && apk update \
    && apk add --no-cache \
                udev \
                libusb \
                libev 


# build knxd in here
FROM run_time as build_env
ARG KNXD_VERSION

RUN set -xe \
    && apk add --no-cache --virtual .build-dependencies \
                build-base \
                gcc \
                git \
                abuild \
                binutils \
                automake \
                autoconf \
                libtool \
                argp-standalone \
                linux-headers \
                libev-dev \
                libusb-dev \
                cmake \
                dev86 \
     && git clone --branch "${KNXD_VERSION}" --depth 1 https://github.com/knxd/knxd.git \
     && cd knxd \
     && ./bootstrap.sh \
     && ./configure --disable-systemd --enable-tpuart --enable-usb --enable-eibnetipserver --enable-eibnetip --enable-eibnetserver --enable-eibnetiptunnel \
     && mkdir -p src/include/sys && ln -s /usr/lib/bcc/include/sys/cdefs.h src/include/sys \
     && make \
     && make install 

# actual runtime image
FROM run_time

# copy knxd binaries
RUN mkdir -p /usr/local/libexec/knxd
COPY --from=build_env  /usr/local/bin/*knx* /usr/local/bin/
COPY --from=build_env  /usr/local/include/eib* /usr/local/include/
COPY --from=build_env /usr/local/lib/*eib* /usr/local/lib/
COPY --from=build_env /usr/local/libexec/knxd /usr/local/libexec/knxd
COPY --from=build_env /usr/local/share/knxd /usr/local/share/knxd

# copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh
RUN dos2unix /run.sh

CMD [ "/run.sh" ]
