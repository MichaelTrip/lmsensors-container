#!/bin/bash
while true; do
    sensors > /data/lmsensors-$NODE_NAME.txt
    fastfetch --pipe --logo none | sed 's/\x1b\[[0-9;]*m//g' > fastfetch-$NODE_NAME.txt
    sleep 60
done