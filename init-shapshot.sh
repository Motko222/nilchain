#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/config
source ~/.bash_profile

read -p "Are you sure? " sure
case $sure in y|Y|yes|YES|Yes) ;; *) exit ;; esac

pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="19"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $DATA/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $DATA/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $DATA/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $DATA/config/app.toml

sudo systemctl stop $BINARY.service

cp $DATA/data/priv_validator_state.json $DATA/priv_validator_state.json.backup

$BINARY tendermint unsafe-reset-all --home $DATA --keep-addr-book

if [ -z $SNAPSHOT_URL ] && read -p "Snapshot URL? " url || url=$SNAPSHOT_URL
curl $url | lz4 -dc - | tar -xf - -C $DATA

mv $DATA/priv_validator_state.json.backup $DATA/data/priv_validator_state.json

sudo systemctl start $BINARY.service
sudo journalctl -u $BINARY.service -f --no-hostname -o cat
