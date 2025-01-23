#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source ~/.bash_profile

#create config file
if [ -f $path/config ]
then
 echo "Config exists."
else
 cp $path/config.sample $path/config
 nano $path/config
fi
source $path/config

# cosmovisor setup
mkdir -p $DATA/cosmovisor/genesis/bin
mkdir -p $DATA/cosmovisor/upgrades

#download binary
wget -O $DATA/cosmovisor/genesis/bin/$BINARY https://snapshots.kjnodes.com/nillion-testnet/nilchaind-v0.2.2-linux-amd64
chmod +x $DATA/cosmovisor/genesis/bin/$BINARY
cp $DATA/cosmovisor/genesis/bin/$BINARY /root/go/bin

#check version
$BINARY version



