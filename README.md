# Docker XFCE VNC Desktop

A modern, containerized XFCE desktop environment accessible via VNC and web browser. This image is designed for development, education, and remote desktop scenarios.

## Features

- **Base**: Ubuntu 24.04 LTS
- **Desktop**: XFCE4 window manager
- **Access Methods**: 
  - VNC client (port 5901)
  - Web browser via noVNC (port 6901)
- **Latest Components**:
  - TigerVNC 1.15.0
  - noVNC 1.7.0
  - websockify 0.13.0

## Included Software

### Development Tools
- Visual Studio Code
- Geany IDE with plugins
- Git
- Ansible

### Office & Productivity
- LibreOffice Suite
- Firefox Browser
- Terminator Terminal
- XFCE Terminal

### System Tools
- OpenSSL
- Nmap
- Screen & Tmux
- SSH Client
- Various network utilities

## Quick Start

### Using Docker Run
```bash
docker run -d \
  --name xfce-vnc \
  -p 5902:5901 \
  -p 6902:6901 \
  -e VNC_PW=your_secure_password \
  -e VNC_RESOLUTION=1920x1080 \
  archham/xfce-vnc:latest
```

### Using Docker Compose
1. Copy the environment template:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` with your preferences:
   ```bash
   VNC_PASSWORD=your_secure_password
   VNC_RESOLUTION=1920x1080
   DEBUG=false
   ```

3. Start the container:
   ```bash
   docker-compose up -d
   ```

## Access Methods

### Web Browser (Recommended)
Open your browser and navigate to:
```
http://localhost:6902/
```
Enter your VNC password when prompted.

### VNC Client
Connect using any VNC client to:
```
localhost:5902
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `VNC_PW` | `vncpassword` | VNC access password |
| `VNC_RESOLUTION` | `1280x1024` | Desktop resolution |
| `VNC_COL_DEPTH` | `24` | Color depth (16, 24, 32) |
| `DEBUG` | `false` | Enable debug logging |
| `VNC_VIEW_ONLY` | `false` | Enable view-only mode |

## Building from Source

### Prerequisites
- Docker
- Git (optional, for version control)

### Build Process
1. Clone the repository:
   ```bash
   git clone https://github.com/archham/docker.xfce-vnc.git
   cd docker.xfce-vnc
   ```

2. Update version (optional):
   ```bash
   echo "0.1.0" > VERSION
   ```

3. Build using the provided script:
   ```bash
   ./build.sh
   ```

### Build Script Options
The build script supports several environment variables:

```bash
# Skip pushing to registry
SKIP_PUSH=true ./build.sh

# Clean Docker system before build
CLEAN_BUILD=true ./build.sh

# Auto-push stable tag
AUTO_STABLE=true ./build.sh

# Custom registry
DOCKER_REGISTRY=your-registry.com/xfce-vnc ./build.sh
```

## OpenShift/OKD Deployment

For OpenShift and OKD deployments, use the provided setup scripts:
- `openshift39x-classroom-setup.sh` - For OpenShift 3.9.x
- `openshift4x-classroom-setup.sh` - For OpenShift 4.x

These scripts configure the necessary resources for classroom environments with shared storage.

## Security Considerations

- The container runs as a non-root user (`headless:1000`)
- Change the default VNC password in production
- Consider using HTTPS/TLS for web access in production
- Limit network access as needed for your use case

## Troubleshooting

### Common Issues

1. **Connection refused**: Ensure ports are properly mapped and not blocked by firewall
2. **Black screen**: Wait for the desktop to fully initialize (60-90 seconds)
3. **Performance issues**: Increase shared memory with `--shm-size=2g`

### Debug Mode
Enable debug logging:
```bash
docker run -e DEBUG=true archham/xfce-vnc:latest
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the build
5. Submit a pull request

## License

This project is licensed under the terms specified in the LICENSE file.

## Screenshot

![XFCE VNC Desktop](ss.png)
