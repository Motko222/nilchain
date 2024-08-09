#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/.bash_profile
sudo apt install -y unzip wget golang-go

#remove old binary and repo
rm $(which 0gchaind)
rm -r ~/0g-chain

#install binary
cd ~
git clone -b v0.2.3 https://github.com/0glabs/0g-chain.git
./0g-chain/networks/testnet/install.sh
source ~/.profile

#create cfg file
if [ -f ~/scripts/$folder/cfg ]
then
 echo "Config exists."
else
 cp ~/scripts/$folder/cfg.sample ~/scripts/$folder/cfg
 nano ~/scripts/$folder/cfg
fi

source ~/scripts/$folder/cfg

#check version
$BINARY version



