#!/bin/bash
while true; do
    set -x
    echo "refreshed @ $(date) \n" > /data/lmsensors-$NODE_NAME.txt
    sensors >> /data/lmsensors-$NODE_NAME.txt
    echo "refreshed @ $(date) \n \n" > /data/fastfetch-$NODE_NAME.txt
    fastfetch --pipe --logo none | sed 's/\x1b\[[0-9;]*m//g'
    fastfetch --pipe --logo none | sed 's/\x1b\[[0-9;]*m//g' >> /data/fastfetch-$NODE_NAME.txt
    echo $?
    sleep 60
done