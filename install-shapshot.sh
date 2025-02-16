#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/config
source ~/.bash_profile

read -p "Are you sure? " sure
case $sure in y|Y|yes|YES|Yes) ;; *) exit ;; esac

sed -i -e "s/^pruning *=.*/pruning = \"$PRUNING\"/" $DATA/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$PRUNING_KEEP_RECENT\"/" $DATA/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$PRUNING_KEEP_EVERY\"/" $DATA/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$PRUNING_INTERVAL\"/" $DATA/config/app.toml

sudo systemctl stop $BINARY.service

cp $DATA/data/priv_validator_state.json $DATA/priv_validator_state.json.backup

$BINARY tendermint unsafe-reset-all --home $DATA --keep-addr-book

[ -z $SNAPSHOT_URL ] && read -p "Snapshot URL? " url || url=$SNAPSHOT_URL
curl -L $url | tar -Ilz4 -xf - -C $DATA

mv $DATA/priv_validator_state.json.backup $DATA/data/priv_validator_state.json
