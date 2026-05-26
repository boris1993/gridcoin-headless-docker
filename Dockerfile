FROM ubuntu:resolute

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /appdata/.GridcoinResearch
RUN echo "dash dash/sh boolean false" | debconf-set-selections && dpkg-reconfigure dash

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
       ca-certificates \
       curl \
       cron \
       tzdata \
       software-properties-common

RUN add-apt-repository -y ppa:gridcoin/gridcoin-stable \
 && apt-get update \
 && apt-get install -y gridcoinresearchd

RUN apt-get purge -y software-properties-common \
 && apt-get autoremove -y

ADD entrypoint.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/entrypoint.sh

VOLUME /root/.GridcoinResearch
VOLUME /var/lib/boinc

EXPOSE 32749

WORKDIR /root
CMD ["/usr/local/bin/entrypoint.sh"]
