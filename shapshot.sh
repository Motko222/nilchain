#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$folder/cfg
source ~/.bash_profile

read -p "Are you sure? " sure
case $sure in
 y|Y|yes|YES|Yes) ;;
 *) exit ;;
esac

sudo systemctl stop $BINARY.service
sudo journalctl -u $BINARY.service -f --no-hostname -o cat

sudo systemctl stop 0gchaind

cp ~/.0gchain/data/priv_validator_state.json ~/.0gchain/priv_validator_state.json.backup

0gchaind tendermint unsafe-reset-all --home ~/.0gchain --keep-addr-book
curl https://snapshots-testnet.unitynodes.com/0gchain-testnet/0gchain-testnet-latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.0gchain

mv ~/.0gchain/priv_validator_state.json.backup ~/.0gchain/data/priv_validator_state.json

sudo systemctl start $BINARY.service
sudo journalctl -u $BINARY.service -f --no-hostname -o cat