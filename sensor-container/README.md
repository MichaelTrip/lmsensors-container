# Sensor Container

This container is responsible for collecting sensor data from nodes using lm_sensors and fastfetch.

## Features

- **Hardware monitoring**: Uses `lm_sensors` to collect temperature, voltage, and fan data
- **SSD temperature monitoring**: Uses `smartmontools` to collect SATA/NVMe SSD temperatures via SMART data
- **System information**: Uses `fastfetch` to gather system details
- **File generation**: Creates JSON file lists for dynamic discovery
- **Scheduled collection**: Runs every 60 seconds
- **Persistent storage**: Writes data to shared volume

## Environment Variables

- `NODE_NAME`: The name of the node (automatically set by Kubernetes)
- `TZ`: Timezone (default: Europe/Amsterdam)

## Volumes

- `/data`: Shared volume where sensor data files are written

## Generated Files

- `lmsensors-{NODE_NAME}.txt`: Hardware sensor data
- `fastfetch-{NODE_NAME}.txt`: System information
- `ssd-temps-{NODE_NAME}.txt`: SATA/NVMe SSD temperature data from SMART attributes
- `file-list.json`: Dynamic list of available files

## Usage

This container is designed to run as a DaemonSet on each node in the cluster.
