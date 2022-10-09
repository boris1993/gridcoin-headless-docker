#!/bin/bash

set -e

CONFIG_FILE="/root/.GridcoinResearch/gridcoinresearch.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "Generating the default gridcoinresearch.conf"
    echo -e "rpcuser=grc_user" >> "${CONFIG_FILE}"
    echo -e "rpcpassword=grc_pass" >> "${CONFIG_FILE}"
    echo -e "printtoconsole=1" >> "${CONFIG_FILE}"

    if [ -n "$EMAIL" ]; then
        echo -e "email=${EMAIL}" >> "${CONFIG_FILE}"
    fi
fi

if [ -n "$PASSPHRASE" ]; then
    echo -e "Passphrase is given, setting cron job to unlock the wallet periodically"
    echo -e "*/5 * * * * gridcoinresearchd -debug -printtoconsole walletpassphrase "${PASSPHRASE}" 300 true" > /etc/cron.d/unlock-wallet
fi

echo -e "Starting gridcoinresearchd"
gridcoinresearchd
