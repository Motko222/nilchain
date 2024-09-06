#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/cfg

sudo tee /etc/systemd/system/$BINARY.service > /dev/null << EOF
[Unit]
Description=$BINARY node service
After=network-online.target

[Service]
User=root
ExecStart=/root/go/bin/$BINARY start --log_output_console
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=/root/.$BINARY"
Environment="DAEMON_NAME=$BINARY"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable $BINARY.service
