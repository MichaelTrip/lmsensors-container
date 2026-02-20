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

# Function to collect SSD temperatures
collect_ssd_temps() {
    local output_file="/data/ssd-temps-$NODE_NAME.txt"
    echo "refreshed @ $(date)" > "$output_file"
    echo "" >> "$output_file"

    # Find all block devices that are SATA/NVMe drives
    local devices=$(lsblk -d -n -o NAME,TYPE | awk '$2=="disk" {print $1}')

    if [ -z "$devices" ]; then
        echo "No disk devices found" >> "$output_file"
        return
    fi

    local found_any=false
    for device in $devices; do
        local dev_path="/dev/$device"

        # Try to get SMART data (some devices might not support it)
        if smartctl -i "$dev_path" >/dev/null 2>&1; then
            echo "=== $device ===" >> "$output_file"

            # Get device model
            local model=$(smartctl -i "$dev_path" 2>/dev/null | grep "Device Model\|Model Number\|Product:" | head -1 | sed 's/.*: *//')
            if [ -n "$model" ]; then
                echo "Model: $model" >> "$output_file"
            fi

            # Get temperature (try different SMART attributes)
            local temp=$(smartctl -A "$dev_path" 2>/dev/null | grep -i "Temperature_Celsius\|Airflow_Temperature_Cel\|Temperature" | head -1 | awk '{print $10}')

            # If the above didn't work, try the -x flag for NVMe drives
            if [ -z "$temp" ] || [ "$temp" = "0" ]; then
                temp=$(smartctl -x "$dev_path" 2>/dev/null | grep -i "Temperature:" | head -1 | awk '{print $2}')
            fi

            if [ -n "$temp" ] && [ "$temp" != "0" ] && [ "$temp" != "-" ]; then
                echo "Temperature: ${temp}°C" >> "$output_file"
                found_any=true
            else
                echo "Temperature: Not available" >> "$output_file"
            fi

            echo "" >> "$output_file"
        fi
    done

    if [ "$found_any" = false ]; then
        echo "No temperature data available from detected drives" >> "$output_file"
    fi
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

    # Collect SSD temperatures
    collect_ssd_temps

    # Generate file list for dynamic discovery
    generate_file_list

    # Sleep for 60 seconds before next update
    echo "Data collection complete, sleeping for 60 seconds..."
    sleep 60
done
