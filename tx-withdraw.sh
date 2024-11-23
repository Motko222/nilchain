#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/config
source ~/.bash_profile

[ -z $1 ] && read -p "From ? " from || from=$1

echo $PASS | $BINARY tx distribution withdraw-all-rewards --from $from \
   --gas-adjustment $GAS_ADJ --gas auto -y
