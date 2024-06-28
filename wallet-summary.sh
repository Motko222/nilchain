#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$folder/cfg
source ~/.bash_profile

echo   "---- SUMMARY --------------------------------------------------------------------------"
printf "%-12s %9s %9s %9s\n" Id Balance Delegated Reward
echo   "---------------------------------------------------------------------------------------"

keys=$(echo $PASS | $BINARY keys list | grep -E 'name' | sed 's/  name: //g')

for key in $keys
do
   wallet=$(echo $PASS | $BINARY keys show $key -a) 
   balance=$($BINARY query bank balances $wallet | grep amount | awk '{print $3}' | sed 's/"//g' | awk '{print $1/1000000}')
   valoper=$(echo $PASS | $BINARY keys show $KEY --bech val | grep valoper | awk '{print $3}')
   rewards=$($BINARY query distribution rewards $wallet $valoper 2>/dev/null \
     | grep amount | awk '{print $3}' | sed 's/"//g' | awk '{print $1/1000000}')

   stake=$($BINARY query staking delegation $wallet $valoper 2>/dev/null \
     | grep amount | awk '{print $2}' | sed 's/"//g' | awk '{print $1/1000000}' )

   printf "%-12s %9s %9s %9s\n" \
      $key $balance $stake $rewards
done
