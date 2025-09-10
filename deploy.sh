#!/bin/bash

# Deployment script for LMSensors dual-container setup
# This script deploys the complete monitoring solution

set -e

echo "🚀 Deploying LMSensors Monitoring Solution"
echo "=========================================="

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed or not in PATH"
    exit 1
fi

# Check if we can connect to the cluster
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Cannot connect to Kubernetes cluster"
    exit 1
fi

echo "✅ Kubernetes connection verified"

# Deploy PVC first
echo ""
echo "📦 Deploying Persistent Volume Claim..."
kubectl apply -f deployment-files/pvc.yaml

# Wait for PVC to be bound (optional)
echo "⏳ Waiting for PVC to be ready..."
kubectl wait --for=condition=Bound pvc/pvc-lmsensors --timeout=60s || echo "⚠️  PVC not bound yet, continuing..."

# Deploy DaemonSet
echo ""
echo "🔧 Deploying Sensor DaemonSet..."
kubectl apply -f deployment-files/daemonset.yaml

# Deploy Web Server
echo ""
echo "🌐 Deploying Web Server..."
kubectl apply -f deployment-files/webserver-modern.yaml

echo ""
echo "✅ Deployment completed!"
echo ""
echo "📊 Checking deployment status..."
echo ""

# Show status
echo "DaemonSet status:"
kubectl get daemonset lmsensors -o wide

echo ""
echo "Web server status:"
kubectl get deployment sensordash-webserver -o wide
kubectl get service sensordash-service -o wide

echo ""
echo "� Container Images:"
echo "  Sensor DaemonSet: ghcr.io/michaeltrip/lmsensors-daemonset-container:latest"
echo "  Web Dashboard:    ghcr.io/michaeltrip/lmsensors-web:latest"
echo ""
echo "�📋 Useful commands:"
echo "  View sensor pods:     kubectl get pods -l name=lmsensors"
echo "  View web pods:        kubectl get pods -l app=sensordash"
echo "  Check logs (sensors): kubectl logs -l name=lmsensors"
echo "  Check logs (web):     kubectl logs -l app=sensordash"
echo "  Port-forward web:     kubectl port-forward service/sensordash-service 8080:80"
echo ""
echo "🎉 Access the dashboard at: http://localhost:8080 (after port-forward)"
