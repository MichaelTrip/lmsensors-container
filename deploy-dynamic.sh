#!/bin/bash

# SensorDash Deployment Script
# This script deploys the SensorDash application with dynamic node configuration

set -e

echo "🚀 Deploying SensorDash with Dynamic Node Configuration..."

# Create namespace if it doesn't exist
kubectl create namespace sensordash --dry-run=client -o yaml | kubectl apply -f -

# Apply ConfigMap
echo "📄 Applying ConfigMap..."
kubectl apply -f deployment-files/configmap.yaml -n sensordash

# Apply PVC
echo "💾 Applying Persistent Volume Claim..."
kubectl apply -f deployment-files/pvc.yaml -n sensordash

# Apply DaemonSet
echo "🔧 Applying Sensor DaemonSet..."
kubectl apply -f deployment-files/daemonset.yaml -n sensordash

# Apply WebServer
echo "🌐 Applying WebServer..."
kubectl apply -f deployment-files/webserver-modern.yaml -n sensordash

echo "✅ Deployment complete!"
echo ""
echo "📋 To check the status:"
echo "  kubectl get pods -n sensordash"
echo ""
echo "🔧 To edit node configuration:"
echo "  kubectl edit configmap sensordash-config -n sensordash"
echo ""
echo "📖 To view current configuration:"
echo "  kubectl get configmap sensordash-config -n sensordash -o jsonpath='{.data.nodes\.json}' | jq ."
echo ""
echo "🚪 To access the dashboard:"
echo "  kubectl port-forward svc/sensordash-service -n sensordash 8080:80"
echo "  Then visit: http://localhost:8080"
