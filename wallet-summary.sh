#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$folder/cfg
source ~/.bash_profile

read -p "Keys? (blank for all) " keys
[ -z $keys ] && keys=$(echo $PASS | $BINARY keys list | grep -E 'name' | sed 's/  name: //g')

echo   "---- SUMMARY --------------------------------------------------------------------------"
printf "%-12s %-9s %-9s %-12s %-9s %-9s\n" Id Balance Delegated Reward Da Uploads
echo   "---------------------------------------------------------------------------------------"


for key in $keys
do
   wallet=$(echo $PASS | $BINARY keys show $key -a) 
   wallet_eth="0x$($BINARY debug addr $(echo $PASS | $BINARY keys show $key -a) | grep hex | awk '{print $3}')"
   balance=$($BINARY query bank balances $wallet | grep amount | awk '{print $3}' | sed 's/"//g' | awk '{print $1/1000000}')
   [ -z $balance ] && balance="-"
   valoper=$(echo $PASS | $BINARY keys show $KEY --bech val | grep valoper | awk '{print $3}')
   rewards=$($BINARY query distribution rewards $wallet $valoper 2>/dev/null \
     | grep amount | awk '{print $3}' | sed 's/"//g' | awk '{print $1/1000000}')

   stake=$($BINARY query staking delegation $wallet $valoper 2>/dev/null \
     | grep amount | awk '{print $2}' | sed 's/"//g' | awk '{print $1/1000000}' )
   [ -z $stake ] && stake="-"

   da=$(curl -sX 'GET'   'https://chainscan-newton.0g.ai/api/v2/addresses/'$wallet_eth'/transactions?filter=to%20%7C%20from'   -H 'accept: application/json' | jq | grep -c 0x0000000000000000000000000000000000001000)
   uploads=$(curl -sX 'GET'   'https://chainscan-newton.0g.ai/api/v2/addresses/'$wallet_eth'/transactions?filter=to%20%7C%20from'   -H 'accept: application/json' | jq | grep -c 0x8873cc79c5b3b5666535C825205C9a128B1D75F1)
   faucet=$(curl -sX 'GET'   'https://chainscan-newton.0g.ai/api/v2/addresses/'$wallet_eth'/transactions?filter=to%20%7C%20from'   -H 'accept: application/json' | jq | grep -c 0x83c4A688174A8d4b99b4C8A2feC124dff79D58d2)

   printf "%-12s %-9s %-9s %-12s %-9s %-9s\n" \
      $key $balance $stake $rewards $da $uploads
done
