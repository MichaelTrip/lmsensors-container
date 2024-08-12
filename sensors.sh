#!/bin/bash
while true; do
    sensors > /data/lmsensors-$NODE_NAME.txt
    sleep 60
done