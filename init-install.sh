#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/.bash_profile

read -p "Tag? " tag

#remove old binary and repo
rm $(which 0gchaind)
rm -r ~/0g-chain

#install binary
git clone TBD nillion
cd nillion
git checkout $tag
make install

# cosmovisor
mkdir -p ~/.nillionapp/cosmovisor/genesis/bin
mkdir -p ~/.nillionapp/cosmovisor/upgrades
cp ~/go/bin/nilchaind ~/.nillionapp/cosmovisor/genesis/bin

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



