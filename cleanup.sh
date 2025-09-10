#!/bin/bash

# Cleanup script for LMSensors dual-container setup
# This script removes the complete monitoring solution

set -e

echo "🧹 Cleaning up LMSensors Monitoring Solution"
echo "============================================"

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed or not in PATH"
    exit 1
fi

echo "⚠️  This will remove:"
echo "  - DaemonSet (lmsensors)"
echo "  - Deployment (sensordash-webserver)"
echo "  - Service (sensordash-service)"
echo "  - PVC (pvc-lmsensors) - WARNING: This will delete all collected data!"
echo ""

read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Cleanup cancelled"
    exit 1
fi

# Remove Web Server
echo ""
echo "🌐 Removing Web Server..."
kubectl delete -f deployment-files/webserver-modern.yaml --ignore-not-found=true

# Remove DaemonSet
echo ""
echo "🔧 Removing Sensor DaemonSet..."
kubectl delete -f deployment-files/daemonset.yaml --ignore-not-found=true

# Ask about PVC
echo ""
read -p "Do you want to delete the PVC and all sensor data? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📦 Removing Persistent Volume Claim..."
    kubectl delete -f deployment-files/pvc.yaml --ignore-not-found=true
    echo "⚠️  All sensor data has been deleted!"
else
    echo "💾 PVC preserved - sensor data is safe"
fi

echo ""
echo "✅ Cleanup completed!"
echo ""
echo "📋 Verify cleanup:"
echo "  kubectl get pods -l name=lmsensors"
echo "  kubectl get pods -l app=sensordash"
echo "  kubectl get pvc pvc-lmsensors"
