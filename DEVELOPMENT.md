# 🛠️ Development Guide

This guide helps you develop and test the LMSensors monitoring solution locally.

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose
- Kubernetes cluster (for full testing)
- `kubectl` configured

### Local Development

```bash
# Clone the repository
git clone https://github.com/MichaelTrip/lmsensors-container.git
cd lmsensors-container

# Build and run with Docker Compose
docker-compose up --build

# Access the web interface
open http://localhost:8080
```

## 🏗️ Building Containers

### Build Individual Containers

```bash
# Sensor container
docker build -t lmsensors-daemonset:dev sensor-container/

# Web container
docker build -t lmsensors-web:dev web-container/

# Run locally
docker run --rm -p 8080:80 lmsensors-web:dev
```

### Build with Docker Compose

```bash
# Build all containers
docker-compose build

# Build specific container
docker-compose build web
docker-compose build sensor
```

## 🧪 Testing

### Container Testing

```bash
# Test web container health
docker run --rm -p 8080:80 lmsensors-web:dev
curl http://localhost:8080/health

# Test sensor container (limited without host access)
docker run --rm -v $(pwd)/test-data:/data lmsensors-daemonset:dev
```

### Kubernetes Testing

```bash
# Deploy to local cluster
./deploy.sh

# Check status
kubectl get pods -l name=lmsensors
kubectl get pods -l app=sensordash

# View logs
kubectl logs -l name=lmsensors -f
kubectl logs -l app=sensordash -f

# Cleanup
./cleanup.sh
```

## 📝 Development Workflow

### 1. Make Changes

Edit files in `sensor-container/` or `web-container/` directories.

### 2. Test Locally

```bash
# Quick web interface test
docker-compose up web

# Full stack test
docker-compose up --build
```

### 3. Commit with Conventional Commits

```bash
# Examples
git commit -m "feat(web): add dark mode toggle"
git commit -m "fix(sensor): resolve timeout issue"
git commit -m "docs: update installation guide"
```

### 4. Push and Release

```bash
git push origin main
# CI/CD automatically builds, versions, and releases
```

## 🐛 Debugging

### Container Logs

```bash
# Docker Compose logs
docker-compose logs sensor
docker-compose logs web

# Kubernetes logs
kubectl logs -l name=lmsensors
kubectl logs -l app=sensordash
```

### Container Shell Access

```bash
# Access running container
docker-compose exec web sh
docker-compose exec sensor bash

# Or with Kubernetes
kubectl exec -it <pod-name> -- sh
```

### Common Issues

#### No Sensor Data

**Problem**: Web interface shows "No sensor data found"

**Solutions**:
- Check if PVC is mounted correctly
- Verify sensor container is running on nodes
- Check sensor container logs for errors

```bash
kubectl logs -l name=lmsensors
kubectl describe pvc pvc-lmsensors
```

#### Web Interface Not Loading

**Problem**: Cannot access web dashboard

**Solutions**:
- Check service and port-forwarding
- Verify nginx configuration
- Check web container logs

```bash
kubectl get svc sensordash-service
kubectl port-forward service/sensordash-service 8080:80
kubectl logs -l app=sensordash
```

#### Permission Issues

**Problem**: Sensor container cannot access hardware

**Solutions**:
- Ensure privileged security context
- Check node permissions
- Verify hostPath mounts

```bash
kubectl describe pod <sensor-pod>
kubectl get nodes -o wide
```

## 🔧 Configuration

### Environment Variables

#### Sensor Container
- `NODE_NAME`: Node identifier (auto-set in Kubernetes)
- `TZ`: Timezone for timestamps

#### Web Container
- No specific environment variables required

### Volume Mounts

#### Sensor Container
- `/data`: Shared data directory
- `/etc/os-release`: Host OS information (read-only)

#### Web Container
- `/usr/share/nginx/html/data`: Sensor data (read-only)

## 📊 Monitoring Development

### Container Metrics

```bash
# Resource usage
docker stats

# Container inspection
docker inspect <container-id>

# Image layers
docker history lmsensors-web:dev
```

### Kubernetes Metrics

```bash
# Pod resource usage
kubectl top pods

# Node resource usage
kubectl top nodes

# Describe resources
kubectl describe deployment sensordash-webserver
kubectl describe daemonset lmsensors
```

## 🚀 Release Process

1. **Develop**: Make changes in feature branches
2. **Test**: Validate with local Docker Compose and Kubernetes
3. **Commit**: Use conventional commit messages
4. **Push**: Push to main branch
5. **Automatic**: CI/CD handles building, versioning, and releasing

### Manual Release

If needed, you can manually trigger a release:

```bash
# Create and push a tag
git tag v1.2.3
git push origin v1.2.3

# Or use GitHub CLI
gh release create v1.2.3 --generate-notes
```

## 📚 Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [nginx Configuration](https://nginx.org/en/docs/)
- [lm-sensors Documentation](https://github.com/lm-sensors/lm-sensors)
