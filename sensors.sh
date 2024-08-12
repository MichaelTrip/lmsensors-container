#!/bin/bash
while true; do
    sensors > /data/lmsensors-$NODE_NAME.html
    sleep 60
done