#!/bin/bash

# Feature branch testing script
# Usage: ./test-feature.sh <branch-name>

if [ -z "$1" ]; then
    echo "Usage: $0 <branch-name>"
    echo "Example: $0 feature-add-gpu-monitoring"
    exit 1
fi

BRANCH_NAME="$1"
SENSOR_IMAGE="ghcr.io/michaeltrip/lmsensors-daemonset-container:${BRANCH_NAME}"
WEB_IMAGE="ghcr.io/michaeltrip/lmsensors-web:${BRANCH_NAME}"

echo "🧪 Testing feature branch: $BRANCH_NAME"
echo "📦 Using images:"
echo "  Sensor: $SENSOR_IMAGE"
echo "  Web:    $WEB_IMAGE"
echo ""

# Create temporary deployment files
echo "📝 Creating temporary deployment files..."

# Copy and modify daemonset
cp deployment-files/daemonset.yaml /tmp/daemonset-feature.yaml
sed -i "s|ghcr\.io/michaeltrip/lmsensors-daemonset-container:latest|$SENSOR_IMAGE|g" /tmp/daemonset-feature.yaml

# Copy and modify webserver
cp deployment-files/webserver-modern.yaml /tmp/webserver-feature.yaml
sed -i "s|ghcr\.io/michaeltrip/lmsensors-web:latest|$WEB_IMAGE|g" /tmp/webserver-feature.yaml

echo "🚀 Deploying feature branch..."

# Deploy PVC (unchanged)
kubectl apply -f deployment-files/pvc.yaml

# Deploy feature containers
kubectl apply -f /tmp/daemonset-feature.yaml
kubectl apply -f /tmp/webserver-feature.yaml

echo ""
echo "✅ Feature branch deployed!"
echo ""
echo "📊 Check status:"
echo "  kubectl get pods -l name=lmsensors"
echo "  kubectl get pods -l app=sensordash"
echo ""
echo "🌐 Access dashboard:"
echo "  kubectl port-forward service/sensordash-service 8080:80"
echo ""
echo "🧹 Cleanup when done:"
echo "  kubectl delete -f /tmp/daemonset-feature.yaml"
echo "  kubectl delete -f /tmp/webserver-feature.yaml"
echo "  rm /tmp/daemonset-feature.yaml /tmp/webserver-feature.yaml"
