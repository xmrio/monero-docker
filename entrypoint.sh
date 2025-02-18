#!/usr/bin/env bash

set -e

mkdir -p /opt/data/blocks

if test $# -eq 0; then
  /opt/coin/monerod \
    --detach \
    --hide-my-port \
    --rpc-bind-ip 0.0.0.0 \
    --rpc-bind-port 18081 \
    --confirm-external-bind \
    --data-dir /opt/data/blocks \
    --log-file /opt/data/monerod.log
  # wait until node started
  echo 'Waiting for monerod...'
  while ! nc -z -w 1 127.0.0.1 18081; do
    sleep .2
  done
  exec /opt/coin/monero-wallet-rpc \
    --wallet-file /opt/data/mywallet \
    --password "" \
    --rpc-bind-ip 0.0.0.0 \
    --rpc-bind-port 18088 \
    --confirm-external-bind \
    --disable-rpc-login
else
  exec $@
fi
