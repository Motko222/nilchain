#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/config
source ~/.bash_profile

read -p "Keys? (blank for all) " keys
[ -z $keys ] && keys=$(echo $PASS | $BINARY keys list | grep -E 'name' | sed 's/  name: //g')

echo   "---- SUMMARY --------------------------------------------------------------------------"
printf "%-12s %-9s %-9s %-12s \n" Id Balance Delegated Reward
echo   "---------------------------------------------------------------------------------------"


for key in $keys
do
   wallet=$(echo $PASS | $BINARY keys show $key -a) 
#   balance=$($BINARY query bank balances $wallet | grep amount | awk '{print $3}' | sed 's/"//g' | awk '{print $1/1000000}')
   balance=$($BINARY query bank balance $wallet unil -o json | jq '.balance | select(.denom=="'$DENOM'")' | jq -r .amount | awk '{print $1/1000000}')
   [ -z $balance ] && balance="-"

#   valoper=$(echo $PASS | $BINARY keys show $KEY --bech val | grep valoper | awk '{print $3}')
#   rewards=$($BINARY query distribution rewards $wallet $valoper 2>/dev/null \
#     | grep amount | awk '{print $3}' | sed 's/"//g' | awk '{print $1/1000000}')
   [ -z $rewards ] && rewards="-"
#   stake=$($BINARY query staking delegation $wallet $valoper 2>/dev/null \
#     | grep amount | awk '{print $2}' | sed 's/"//g' | awk '{print $1/1000000}' )
   [ -z $stake ] && stake="-"

#   stake=$($BINARY query staking delegations $wallet -o json | jq -r .delegation_responses[].delegation.shares | awk '{s+=$1} END {print s/1000000}')
   [ -z $stake ] && stake="-"

   printf "%-12s %-9s %-9s %-12s \n" \
      $key $balance $stake $rewards
done
