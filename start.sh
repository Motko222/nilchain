#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/config

sudo systemctl restart $BINARY.service
sudo journalctl -u $BINARY.service -f --no-hostname -o cat
