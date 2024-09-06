#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/cfg

[ -z $1 ] && read -p "Key name ? " key || key=$1

$BINARY keys add $key --recover
$BINARY keys show $key --bech val
