<div align="center">

# 🌡️ LMSensors Kubernetes Monitor

**Real-time hardware monitoring for Kubernetes clusters with a beautiful web interface**

[![Build Status](https://github.com/MichaelTrip/lmsensors-container/actions/workflows/build-dual-containers.yaml/badge.svg)](https://github.com/MichaelTrip/lmsensors-container/actions)
[![License](https://img.shields.io/github/license/michaeltrip/lmsensors-container?color=blue)](LICENSE)
[![Latest Release](https://img.shields.io/github/v/release/michaeltrip/lmsensors-container?color=green)](https://github.com/MichaelTrip/lmsensors-container/releases)
[![Container Registry](https://img.shields.io/badge/registry-ghcr.io-blue)](https://github.com/MichaelTrip/lmsensors-container/pkgs/container/lmsensors-daemonset-container)

![LMSensors Dashboard](img/screenshot.png)

</div>

## ✨ Features

- 🔥 **Real-time Monitoring**: Live hardware sensor data from all cluster nodes
- 🎨 **Modern UI**: Beautiful terminal-style web interface with dark theme
- 🚀 **Cloud Native**: Kubernetes-first design with DaemonSet architecture
- 📱 **Responsive**: Works perfectly on desktop and mobile devices
- 🔄 **Auto-Discovery**: Automatically detects and displays new nodes
- 📊 **Multi-Node**: Monitor temperature, voltage, and system info across your entire cluster
- ⚡ **Lightweight**: Optimized containers with minimal resource footprint

## 🏗️ Architecture

This project uses a **dual-container microservice architecture**:

| Component | Purpose | Image | Deployment |
|-----------|---------|-------|------------|
| **Sensor DaemonSet** | Hardware data collection | `ghcr.io/michaeltrip/lmsensors-daemonset-container` | Runs on every node |
| **Web Dashboard** | Modern web interface | `ghcr.io/michaeltrip/lmsensors-web` | Centralized deployment |

### 🔧 Sensor DaemonSet
- **Purpose**: Collects hardware sensor data from each node
- **Technology**: Ubuntu + lm_sensors + fastfetch
- **Deployment**: Runs on every node via DaemonSet
- **Data**: Temperature, voltage, fan speeds, system information
- **Schedule**: Updates every 60 seconds

### 🌐 Web Dashboard
- **Purpose**: Modern web interface for monitoring
- **Technology**: nginx + responsive HTML/CSS/JS
- **Features**: Real-time updates, node discovery, mobile-friendly
- **Access**: Single deployment with service endpoint

## 🚀 Quick Start

Get up and running in under 2 minutes:

```bash
# Clone the repository
git clone https://github.com/MichaelTrip/lmsensors-container.git
cd lmsensors-container

# Deploy everything
./deploy.sh

# Access the dashboard
kubectl port-forward service/sensordash-service 8080:80
```

Then open [http://localhost:8080](http://localhost:8080) in your browser! 🎉

## 📦 Container Images

| Container | Registry | Latest Version |
|-----------|----------|----------------|
| **DaemonSet** | `ghcr.io/michaeltrip/lmsensors-daemonset-container:latest` | ![Sensor](https://img.shields.io/badge/latest-blue) |
| **Web UI** | `ghcr.io/michaeltrip/lmsensors-web:latest` | ![Web](https://img.shields.io/badge/latest-blue) |

## 🔧 Requirements

- Kubernetes cluster (1.19+)
- Persistent volume support (`ReadWriteMany`)
- Privileged container support (for hardware access)

## 📋 What You'll Monitor

- 🌡️ **CPU Temperature** - Real-time thermal monitoring
- ⚡ **Voltage Rails** - Power supply monitoring
- 🌀 **Fan Speeds** - Cooling system status
- 💾 **System Info** - Hardware specifications
- 📊 **Node Status** - Health indicators
- 🔄 **Live Updates** - Auto-refresh every 30 seconds

## 🛠️ Manual Deployment

<details>
<summary>Click to expand manual deployment steps</summary>

```bash
# 1. Deploy persistent volume claim
kubectl apply -f deployment-files/pvc.yaml

# 2. Deploy sensor collection DaemonSet
kubectl apply -f deployment-files/daemonset.yaml

# 3. Deploy web dashboard
kubectl apply -f deployment-files/webserver-modern.yaml

# 4. Access the dashboard
kubectl port-forward service/sensordash-service 8080:80
```

</details>

## 🧹 Cleanup

Remove all components safely:

```bash
./cleanup.sh
```

The cleanup script will:
- Remove all deployments and services
- Optionally preserve your sensor data
- Confirm before destructive operations

## 🚀 CI/CD Pipeline

This project uses **semantic versioning** with **conventional commits**:

- 🎯 **Automatic versioning** based on commit messages
- 🏗️ **Parallel container builds** for optimal speed
- 📦 **Multi-platform support** (linux/amd64)
- 🔄 **Auto-deployment** file updates
- 🏷️ **Smart tagging** with semantic versions

### Commit Convention

```
feat: add new sensor support     # → Minor version bump
fix: resolve memory leak         # → Patch version bump
feat!: breaking API change       # → Major version bump
```

## 👨‍💻 Development

### Local Development

```bash
# Build containers locally
docker build -t lmsensors-daemonset:dev sensor-container/
docker build -t lmsensors-web:dev web-container/

# Test with docker-compose
docker-compose up
```

### Contributing

1. 🍴 Fork the repository
2. 🌿 Create a feature branch
3. 📝 Use conventional commits
4. 🧪 Test your changes
5. 📤 Submit a pull request

### Project Structure

```
├── sensor-container/     # DaemonSet container source
├── web-container/        # Web interface container source
├── deployment-files/     # Kubernetes manifests
├── .github/workflows/    # CI/CD pipelines
├── deploy.sh            # Quick deployment script
└── cleanup.sh           # Cleanup script
```

## 📸 Screenshots

<div align="center">

### 🖥️ Desktop View
![Desktop Dashboard](img/screenshot.png)

*Modern terminal-style interface with real-time sensor data*

</div>

## 🤝 Support

- 📖 **Documentation**: Check our [Wiki](https://github.com/MichaelTrip/lmsensors-container/wiki)
- 🐛 **Issues**: [Report bugs](https://github.com/MichaelTrip/lmsensors-container/issues)
- 💡 **Features**: [Request features](https://github.com/MichaelTrip/lmsensors-container/issues/new?template=feature_request.md)
- 💬 **Discussions**: [Community discussions](https://github.com/MichaelTrip/lmsensors-container/discussions)

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## ⭐ Show Your Support

If this project helped you, please consider:
- ⭐ **Starring** the repository
- 🍴 **Forking** for your own use
- 📢 **Sharing** with others
- 🐛 **Contributing** improvements

---

<div align="center">
<strong>Built with ❤️ for the Kubernetes community</strong>
</div>

## Caution
Running containers with `privileged` access can pose security risks. Be cautious where and how you use such configurations.




