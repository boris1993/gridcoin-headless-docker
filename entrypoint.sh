#!/bin/bash

set -e

CONFIG_FILE="/root/.GridcoinResearch/gridcoinresearch.conf"
LOG_FILE="/tmp/gridcoin.log"
PARAMS=""

if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "Generating the default gridcoinresearch.conf"

    echo -e "addnode=addnode-us-central.cycy.me" >> "${CONFIG_FILE}"
    echo -e "addnode=ec2-3-81-39-58.compute-1.amazonaws.com" >> "${CONFIG_FILE}"
    echo -e "addnode=gridcoin.network" >> "${CONFIG_FILE}"
    echo -e "addnode=seeds.gridcoin.ifoggz-network.xyz" >> "${CONFIG_FILE}"
    echo -e "addnode=seed.gridcoin.pl" >> "${CONFIG_FILE}"
    echo -e "addnode=www.grcpool.com" >> "${CONFIG_FILE}"

    if [ -n "$RPC_USER" ]; then
        echo -e "rpcuser=${RPC_USER}" >> "${CONFIG_FILE}"
    else
        echo -e "rpcuser=grc_user" >> "${CONFIG_FILE}"
    fi

    if [ -n "$RPC_PASSWORD" ]; then
        echo -e "rpcpassword=${RPC_PASSWORD}" >> "${CONFIG_FILE}"
    else
        echo -e "rpcpassword=$(openssl rand -hex 12)" >> "${CONFIG_FILE}"
    fi

    echo -e "printtoconsole=1" >> "${CONFIG_FILE}"

    if [ -n "$EMAIL" ]; then
        echo -e "email=${EMAIL}" >> "${CONFIG_FILE}"
    fi
fi

if [ -n "$PASSPHRASE" ]; then
    echo -e "Passphrase is given, setting cron job to unlock the wallet periodically"
    echo -e "*/5 * * * * root /usr/local/bin/gridcoinresearchd -debug -printtoconsole walletpassphrase "${PASSPHRASE}" 295 true >> ${LOG_FILE} 2>&1" >> /etc/crontab
fi

if [ -n "$SOCKS_PROXY" ]; then
    echo -e "Using SOCKS5 proxy ${SOCKS_PROXY}"
    PARAMS+="-proxy=${SOCKS_PROXY}"
fi

echo -e "Starting gridcoinresearchd"
gridcoinresearchd $PARAMS > ${LOG_FILE} 2>&1 &

echo -e "Starting up cron"
/etc/init.d/cron start

tail -f ${LOG_FILE}
