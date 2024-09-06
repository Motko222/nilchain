#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/cfg
source ~/.bash_profile

echo $PASS | $BINARY tx slashing unjail --from $KEY --gas-adjustment $GAS_ADJ --gas auto -y
