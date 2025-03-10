#!/bin/bash
while true; do
    set -x
    # Generate sensor data files
    echo "refreshed @ $(date) \n" > /data/lmsensors-$NODE_NAME.txt
    sensors >> /data/lmsensors-$NODE_NAME.txt
    echo "refreshed @ $(date) \n \n" > /data/fastfetch-$NODE_NAME.txt
    fastfetch --pipe --logo none | sed 's/\x1b\[[0-9;]*m//g' | sed ':a;/^\s*$/{$d;N;/\S/!ba}'
    fastfetch --pipe --logo none | sed 's/\x1b\[[0-9;]*m//g' | sed ':a;/^\s*$/{$d;N;/\S/!ba}' >> /data/fastfetch-$NODE_NAME.txt
    
    # Generate file list for dynamic discovery
    # This runs on each node but only one will succeed in writing due to file locking
    (
        flock -n 9 || exit 1
        find /data -type f -name "*.txt" | sed 's|/data/||' | jq -R . | jq -s . > /data/file-list.json.tmp
        mv /data/file-list.json.tmp /data/file-list.json
    ) 9>/data/.file-list-lock
    
    echo $?
    sleep 60
done
