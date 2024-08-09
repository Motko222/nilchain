#!/bin/bash


echo $PASS | $BINARY tx slashing unjail --from $KEY --gas-adjustment $GAS_ADJ --gas auto -y
