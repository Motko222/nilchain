#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
result=~/logs/0g-upload-result
contract=0x8873cc79c5b3b5666535C825205C9a128B1D75F1

source ~/scripts/0g-chain/cfg
source ~/.bash_profile

read -p "Key? (main) " key
[ -z $key ] && key=$KEY

pk=$({ echo y; sleep 1; echo $PASS; } |  $BINARY keys unsafe-export-eth-key $key)

file=~/logs/0g-upload-file
echo $(openssl rand -base64 $(( $RANDOM % 40 + 10 )) ) > $file

cd ~/0g-storage-client
./0g-storage-client upload --url $CHAIN_RPC --contract $contract  \
  --key $pk --node $STORAGE_RPC --file $file



