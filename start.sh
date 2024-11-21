#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/config

sudo systemctl restart $folder.service
sudo journalctl -u $folder.service -f --no-hostname -o cat
