#/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source ~/.bash_profile
source $path/config

# init node
$BINARY init $MONIKER --chain-id=$CHAIN --home $DATA
$BINARY config set client chain-id $CHAIN

# genesis
rm $DATA/config/genesis.json
wget -P $DATA/config $GENESIS
$BINARY genesis validate


