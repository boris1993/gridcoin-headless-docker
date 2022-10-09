# Gridcoin Headless Wallet in Docker

[![Build and publish the image](https://github.com/boris1993/gridcoin-headless-docker/actions/workflows/build.yml/badge.svg)](https://github.com/boris1993/gridcoin-headless-docker/actions/workflows/build.yml)
![Docker Pulls](https://img.shields.io/docker/pulls/boris1993/gridcoin-headless-docker)

A non-official headless GridCoin wallet in Docker.

## Usage

### Docker command

```bash
# Remove the comments between lines when executing
docker run \
    --name gridcoin \
    --restart=unless-stopped \
    -d \
    -v /path/to/data/dir:/root/.GridcoinResearch \
    -v /path/to/boinc/data/dir:/var/lib/boinc \
    # Optional. You can pass your wallet into the container if you want
    -v /path/to/your/wallet/wallet.dat:/root/.GridcoinResearch/wallet.dat \
    # Use your timezone instead
    -e TZ=Asia/Shanghai \
    # Optional. Required when you are solo mining
    -e EMAIL=your@email.com \
    # Optional. Required when your wallet is encrypted
    -e PASSPHRASE=your_wallet_passphrase
    -p 32749:32749 \
    boris1993/gridcoin-headless-docker:latest
```

### Docker Compose

```yaml
version: '3'

services:
  gridcoin:
    image: boris1993/gridcoin-headless-docker:latest
    container_name: gridcoin
    restart: unless-stopped
    environment:
      # Use your timezone instead
      - TZ=Asia/Shanghai
      # Optional. Required when you are solo mining
      - EMAIL=your@email.com
      # Optional. Required when your wallet is encrypted
      - PASSPHRASE=your_wallet_passphrase
    volumes:
      - /path/to/data/dir:/root/.GridcoinResearch
      # Optional. You can pass your wallet into the container if you want
      - /path/to/your/wallet/wallet.dat:/root/.GridcoinResearch/wallet.dat
      - /path/to/boinc/data/dir:/var/lib/boinc
    ports:
      - 32749:32749

```
