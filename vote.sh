#!/bin/bash

#usage: bash vote.sh <key> <proposal> <option>

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/cfg
source ~/.bash_profile

[ -z $1 ] && read -p "From ($KEY) ? " key || key=$1
[ -z $key ] && key=$KEY

[ -z $2 ] && read -p "Proposal ? " proposal || proposal=$2

[ -z $3 ] && read -p "Option ? " option || option=$3

echo $PASS | $BINARY gov vote $proposal $option --from $key --gas-adjustment $GAS_ADJ --gas auto -y
