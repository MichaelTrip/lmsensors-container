#!/bin/bash
while true; do
    sensors > /data/lmsensors-$HOSTNAME.html
    sleep 60
done