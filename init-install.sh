#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/.bash_profile

# cosmovisor setup
mkdir -p ~/.nillionapp/cosmovisor/genesis/bin
mkdir -p ~/.nillionapp/cosmovisor/upgrades
cp ~/go/bin/nilchaind ~/.nillionapp/cosmovisor/genesis/bin

#download binary
wget -O $HOME/.nillionapp/cosmovisor/genesis/bin/nilchaind https://snapshots.kjnodes.com/nillion-testnet/nilchaind-v0.2.2-linux-amd64

#create config file
if [ -f ~/scripts/$folder/config ]
then
 echo "Config exists."
else
 cp ~/scripts/$folder/config.sample ~/scripts/$folder/config
 nano ~/scripts/$folder/config
fi

source ~/scripts/$folder/config

#check version
$BINARY version



