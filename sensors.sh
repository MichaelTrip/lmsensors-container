#!/bin/bash
while true; do
    set -x
    sensors > /data/lmsensors-$NODE_NAME.txt
    fastfetch --pipe --logo none | sed 's/\x1b\[[0-9;]*m//g'
    sleep 60
done