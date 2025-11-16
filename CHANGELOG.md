# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-11-16

### Added
- Modern Docker Compose configuration with health checks
- Environment variable support for configuration
- .env.example template for easy setup
- Comprehensive documentation in README.md
- .gitignore file for better version control
- Proper user management with non-root user
- Build script with error handling and validation
- Support for custom Docker registries
- Debug mode and logging improvements

### Changed
- **BREAKING**: Updated base image from `ubuntu:latest` to `ubuntu:24.04` LTS
- **BREAKING**: Updated TigerVNC from 1.10.1 to 1.15.0
- **BREAKING**: Updated noVNC from 1.2.0 to 1.7.0
- **BREAKING**: Updated websockify from 0.10.0 to 0.13.0
- Improved Dockerfile with layer optimization and best practices
- Enhanced build script with proper error handling
- Updated Docker Compose to version 3.8 with modern features
- Improved security with proper user creation
- Better package management and cleanup

### Fixed
- Removed duplicate package installations
- Fixed layer optimization issues
- Improved error handling in build process
- Better cleanup of temporary files and caches

### Security
- Container now runs as non-root user (`headless:1000`)
- Improved file permissions and ownership
- Added security considerations to documentation

## [0.0.1] - Previous Version

### Initial Features
- Basic XFCE desktop environment
- VNC and noVNC access
- Basic software installation
- OpenShift deployment scripts