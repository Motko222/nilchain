#/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/config

# init node
$BINARY init $MONIKER --chain-id=$CHAIN --home $DATA
$BINARY config chain-id $CHAIN

# genesis
rm $DATA/config/genesis.json
wget -P $DATA/config $GENESIS
$BINARY validate-genesis


