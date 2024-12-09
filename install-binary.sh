#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')

source $folder/config
source ~/.bash_profile

# cosmovisor setup
mkdir -p /root/.nillionapp/cosmovisor/genesis/bin
mkdir -p /root/.nillionapp/cosmovisor/upgrades
cp ~/go/bin/nilchaind /root/.nillionapp/cosmovisor/genesis/bin

#download binary
wget -O /root/.nillionapp/cosmovisor/genesis/bin/nilchaind https://snapshots.kjnodes.com/nillion-testnet/nilchaind-v0.2.2-linux-amd64
chmod +x /root/.nillionapp/cosmovisor/genesis/bin/nilchaind

#create config file
if [ -f ~/scripts/$folder/config ]
then
 echo "Config exists."
else
 cp /root/scripts/$folder/config.sample ~/scripts/$folder/config
 nano /root/scripts/$folder/config
fi

source /root/scripts/$folder/config

#check version
$BINARY version



