#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')

#install binary
cd ~
git clone -b v0.2.3 https://github.com/0glabs/0g-chain.git
./0g-chain/networks/testnet/install.sh
source ~/.bash_profile

#create cfg file
cp ~/scripts/$folder/cfg.sample ~/scripts/$folder/cfg
source ~/scripts/$folder/cfg

#check version
$BINARY version
