FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
       ca-certificates \
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
       software-properties-common \
 && add-apt-repository -y ppa:gridcoin/gridcoin-stable \
 && apt-get update \
 && apt-get install -y gridcoinresearchd \
 && apt-get purge -y software-properties-common \
 && apt-get autoremove -y \
 && echo "dash dash/sh boolean false" | debconf-set-selections && dpkg-reconfigure dash \
 && mkdir -p /appdata/.GridcoinResearch 

ADD entrypoint.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/entrypoint.sh

VOLUME /root/.GridcoinResearch
VOLUME /var/lib/boinc

EXPOSE 32749

WORKDIR /root
CMD /usr/local/bin/entrypoint.sh
