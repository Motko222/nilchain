#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$folder/cfg

[ -z $1 ] && read -p "Key name ? " key || key=$1

$BINARY keys add $key --eth --recover
$BINARY keys show $key --bech val
echo "0x$($BINARY debug addr $(echo $PASS | $BINARY keys show $key -a) | grep hex | awk '{print $3}')"
{ echo y; sleep 1; echo $PASS; } |  $BINARY keys unsafe-export-eth-key $key
