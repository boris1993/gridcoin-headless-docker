#!/bin/bash

set -e

CONFIG_FILE="/root/.GridcoinResearch/gridcoinresearch.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "rpcuser=grc_user" >> "${CONFIG_FILE}"
    echo -e "rpcpassword=grc_pass" >> "${CONFIG_FILE}"
    echo -e "printtoconsole=1" >> "${CONFIG_FILE}"

    if [ -n "$EMAIL" ]; then
        echo -e "email=${EMAIL}" >> "${CONFIG_FILE}"
    fi
fi

gridcoinresearchd

if [ -n "$PASSPHRASE" ]; then
    gridcoinresearchd walletpassphrase "${PASSPHRASE}" 3600 true

    while true; do
        gridcoinresearchd walletpassphrase "${PASSPHRASE}" 3600 true
        sleep 3000
    done
fi
