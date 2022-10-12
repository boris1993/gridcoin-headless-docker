FROM gridcoincommunity/grc-dev:jammy as builder

ENV TAGGED_VERSION 5.4.0.0
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir /build
WORKDIR /build

RUN apt update \
 && apt upgrade -y \
 && apt install -y tzdata \
 && echo "dash dash/sh boolean false" | debconf-set-selections && dpkg-reconfigure dash \
 && git clone https://github.com/gridcoin/Gridcoin-Research \
 && cd Gridcoin-Research \
 && git checkout $TAGGED_VERSION \
 && ./autogen.sh \
 && ./configure --enable-upnp-default --with-incompatible-bdb --disable-gui-tests --with-gui=no --without-qrencode \
 && make

FROM ubuntu:jammy as runner

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
 && apt upgrade -y \
 && apt install -y \
        curl \
        cron \
        tzdata \
        libboost-chrono1.74.0 \
        libboost-filesystem1.74.0 \
        libboost-iostreams1.74.0 \
        libboost-program-options1.74.0 \
        libboost-thread1.74.0 \
        libdb5.3++ \
        libcurl3-gnutls \
        libzip4 \
        libminiupnpc17 \
 && echo "dash dash/sh boolean false" | debconf-set-selections && dpkg-reconfigure dash \
 && mkdir -p /appdata/.GridcoinResearch 

ADD entrypoint.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/entrypoint.sh

COPY --from=builder /build/Gridcoin-Research/src/gridcoinresearchd /usr/local/bin/
COPY --from=builder /build/Gridcoin-Research/doc/gridcoinresearch.1 /usr/local/man/man1/
COPY --from=builder /build/Gridcoin-Research/doc/gridcoinresearchd.1 /usr/local/man/man1/

VOLUME /root/.GridcoinResearch
VOLUME /var/lib/boinc

EXPOSE 32749

WORKDIR /root
CMD /usr/local/bin/entrypoint.sh
