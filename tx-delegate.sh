#!/bin/bash

#usage: bash delegate.sh <key> <valoper> <amount>

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/config
source ~/.bash_profile

[ -z $1 ] && read -p "From ($KEY) ? " key || key=$1
[ -z $key ] && key=$KEY

wallet=$(echo $PASS | $BINARY keys show $key -a)
balance=$($BINARY query bank balances $wallet -o json 2>/dev/null | jq -r '.balances[] | select(.denom=="'$DENOM'")' | jq -r .amount)
echo "Balance: $balance $DENOM"
echo "Delegations:"
$BINARY query staking delegations $wallet -o json | jq -c -r '.delegation_responses[] |  [ .delegation.validator_address, .balance.amount ]' | sed 's/\"\|\[\|\]//g' | sed 's/,/   /g'
def_valoper=$(echo $PASS | $BINARY keys show $KEY -a --bech val)
[ -z $2 ] && read -p "To valoper (default $def_valoper) ? " valoper || valoper=$2
[ -z $valoper ] && valoper=$def_valoper

[ -z $3 ] && read -p "Amount ? " amount || amount=$3

echo $PASS | $BINARY tx staking delegate $valoper $amount$DENOM --from $key \
 --gas-adjustment $GAS_ADJ --gas auto -y
