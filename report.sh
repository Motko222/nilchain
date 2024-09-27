#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/cfg
source ~/.bash_profile
json=~/logs/report-$folder

network=testnet
grp=validator
owner=$OWNER
id=$ID
chain=$CHAIN

rpc=$($BINARY config get client node | sed 's/\"//g' | sed 's/tcp:\/\///g')
status_json=$(curl -s $rpc/status | jq .result)
pid=$(pgrep $BINARY)
version=$($BINARY version)
foldersize1=$(du -hs $DATA | awk '{print $1}')
latest_block=$(echo $status_json | jq -r .sync_info.latest_block_height)
network_height=$(curl -s $PUBLIC_RPC/status | jq -r .result.sync_info.latest_block_height)
catchingUp=$(echo $status_json | jq -r .sync_info.catching_up)
node_id=$(echo $status_json | jq -r .node_info.id)@$(echo $json | jq -r .node_info.listen_addr)
votingPower=$($BINARY status 2>&1 | jq -r .ValidatorInfo.VotingPower)
wallet=$(echo $PASS | $BINARY keys show $KEY -a)
valoper=$(echo $PASS | $BINARY keys show $KEY -a --bech val)
moniker=$MONIKER
pubkey=$($BINARY tendermint show-validator --log_format json | jq -r .key)
delegators=$($BINARY query staking delegations-to $valoper -o json | jq '.delegation_responses | length')
#jailed=$($BINARY query staking validator $valoper -o json | jq -r .jailed)
if [ -z $jailed ]; then jailed=false; fi
#tokens=$($BINARY query staking validator $valoper -o json | jq -r .tokens | awk '{print $1/1000000}')
balance=$($BINARY query bank balances $wallet -o json 2>/dev/null \
      | jq -r '.balances[] | select(.denom=="'$DENOM'")' | jq -r .amount)
active=$(( $($BINARY query tendermint-validator-set --page 1 | grep -c $pubkey ) ))
         #  + $($BINARY query tendermint-validator-set --page 2 | grep -c $pubkey) ))
threshold=$($BINARY query tendermint-validator-set --page 1 -o json | jq -r .validators[].voting_power | tail -1)

if $catchingUp
 then 
  status="syncing"
  message="height $latest_block/$network_height left $(( network_height - latest_block ))";
 else 
  if [ $active -eq 1 ]; 
   then status=active; 
   else status=inactive;message="height $latest_block/$network_height left $(( network_height - latest_block ))";
 fi
fi

if $jailed
 then
  status="jailed"
  message="height $latest_block/$network_height left $(( network_height - latest_block ))";
fi 

if [ -z $pid ];
then status="offline";
 message="process not running";
fi

#json output
cat >$json << EOF
{ 
  "updated":"$(date --utc +%FT%TZ)",
  "measurement":"report",
  "tags": {
    "id":"$ID",
    "machine":"$MACHINE",
    "owner":"$owner",
    "grp":"$grp" },
  "fields": {
    "version":"$version",
    "chain":"$chain",
    "status":"$status",
    "message":"$message",
    "rpc":"$rpc",
    "folder1":"$foldersize1",
    "moniker":"$moniker",
    "key":"$KEY",
    "wallet":"$wallet",
    "valoper":"$valoper",
    "pubkey":"$pubkey",
    "catchingUp":"$catchingUp",
    "jailed":"$jailed",
    "active":$active,
    "local_height":$latest_block,
    "network_height":$network_height,
    "votingPower":$votingPower,
    "tokens":$tokens,
    "threshold":$threshold,
    "delegators":$delegators,
    "balance":$balance }
}
EOF

cat $json
