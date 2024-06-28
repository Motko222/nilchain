#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')

#remove old binary and repo
rm $(which 0gchaind)
rm -r ~/0g-chain

#install binary
cd ~
git clone -b v0.2.3 https://github.com/0glabs/0g-chain.git
./0g-chain/networks/testnet/install.sh
source ~/.bash_profile

#create cfg file
if [ -f ~/scripts/$folder/cfg ]
then
 echo "Config exists."
else
 cp ~/scripts/$folder/cfg.sample ~/scripts/$folder/cfg
 nano ~/scripts/$folder/cfg
fi

#check version
$BINARY version



