#!/bin/sh

set -e

CONFIG_FILE="/root/.GridcoinResearch/gridcoinresearch.conf"

echo -e "rpcuser=grc_user" >> "${CONFIG_FILE}"
echo -e "rpcpassword=grc_pass" >> "${CONFIG_FILE}"
echo -e "printtoconsole=1" >> "${CONFIG_FILE}"

if [ -n "$EMAIL" ]; then
    echo -e "email=${EMAIL}" >> "${CONFIG_FILE}"
fi

gridcoinresearchd
