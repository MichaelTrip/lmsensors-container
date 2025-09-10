# Web Container

This container serves the web interface for viewing sensor data collected from all nodes.

## Features

- **Modern UI**: Terminal-style interface with dark theme
- **Dynamic discovery**: Automatically finds and displays data from all nodes
- **Real-time updates**: Refreshes data every 30 seconds
- **Responsive design**: Works on desktop and mobile devices
- **Tab persistence**: Remembers active tab across refreshes
- **Status indicators**: Shows node status (online/warning/offline)

## Technology Stack

- **Base**: nginx:alpine
- **Frontend**: Pure HTML/CSS/JavaScript
- **Styling**: CSS Grid/Flexbox with custom properties
- **Icons**: Font Awesome
- **Fonts**: JetBrains Mono, Fira Code, Roboto Mono

## Volumes

- `/usr/share/nginx/html/data`: Mount point for sensor data from shared storage

## Ports

- `80`: HTTP port for web interface

## Features

### JavaScript Functionality
- Dynamic node discovery via `file-list.json`
- Automatic tab generation for each node
- Real-time file loading and display
- Error handling for missing files
- Fullscreen toggle
- Local storage for user preferences

### CSS Features
- Dark theme optimized for readability
- Smooth animations and transitions
- Custom scrollbars
- Responsive breakpoints
- Terminal-style aesthetics

## Usage

This container is deployed as a standard Kubernetes Deployment with a Service for external access.
