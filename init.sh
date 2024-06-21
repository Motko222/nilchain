#/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$folder/cfg


#init node and wallet
$BINARY init $MONIKER --chain-id=$CHAIN --home $DATA
$BINARY config chain-id $CHAIN

# genesis
rm ~/.0gchain/config/genesis.json
wget -P ~/.0gchain/config https://github.com/0glabs/0g-chain/releases/download/v0.2.3/genesis.json
0gchaind validate-genesis

#seeds
SEEDS=265120a9bb170cf21198aabf88f7908c9944897c@54.241.167.190:26656,497f865d8a0f6c830e2b73009a01b3edefb22577@54.176.175.48:26656,ffc49903241a4e442465ec78b8f421c56b3ae3d4@54.193.250.204:26656,f37bc8623bfa4d8e519207b965a24a288f3213d8@18.166.164.232:26656
sed -i 's|seeds =.*|seeds = "'$SEEDS'"|g' $DATA/config/config.toml

#min gas
#sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "$GAS_PRICE"/g' $DATA/config/app.toml

#prunning
#sed -i \
#  -e 's|^pruning *=.*|pruning = "custom"|' \
#  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
#  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
#  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
#  $DATA/config/app.toml
