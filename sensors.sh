#!/bin/bash

# Ensure NODE_NAME is set
if [ -z "$NODE_NAME" ]; then
    NODE_NAME=$(hostname)
    echo "NODE_NAME not set, using hostname: $NODE_NAME"
fi

# Create data directory if it doesn't exist
mkdir -p /data

# Function to generate file list
generate_file_list() {
    # Use flock to ensure only one process updates the file list at a time
    (
        flock -n 9 || return 1
        echo "Generating file list..."
        find /data -type f -name "*.txt" | sed 's|/data/||' | jq -R . | jq -s . > /data/file-list.json.tmp
        mv /data/file-list.json.tmp /data/file-list.json
        echo "File list generated successfully"
    ) 9>/data/.file-list-lock
}

while true; do
    echo "Starting data collection for node: $NODE_NAME"
    
    # Generate lmsensors data
    echo "refreshed @ $(date) \n" > /data/lmsensors-$NODE_NAME.txt
    if ! sensors >> /data/lmsensors-$NODE_NAME.txt 2>&1; then
        echo "Error running sensors command" >> /data/lmsensors-$NODE_NAME.txt
    fi
    
    # Generate fastfetch data
    echo "refreshed @ $(date) \n \n" > /data/fastfetch-$NODE_NAME.txt
    if ! fastfetch --pipe --logo none | sed 's/\x1b\[[0-9;]*m//g' | sed ':a;/^\s*$/{$d;N;/\S/!ba}' >> /data/fastfetch-$NODE_NAME.txt 2>&1; then
        echo "Error running fastfetch command" >> /data/fastfetch-$NODE_NAME.txt
    fi
    
    # Generate file list for dynamic discovery
    generate_file_list
    
    # Sleep for 60 seconds before next update
    echo "Data collection complete, sleeping for 60 seconds..."
    sleep 60
done
