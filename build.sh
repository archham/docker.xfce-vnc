#!/bin/bash
set -euo pipefail

# Configuration
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
REG=${DOCKER_REGISTRY:-docker.io/archham/xfce-vnc}
VERSION=$(cat VERSION 2>/dev/null || echo "0.1.0")
RELEASE=${BUILD_RELEASE:-latest}
BUILD_ARGS=${BUILD_ARGS:-""}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Validation
validate_environment() {
    log_info "Validating build environment..."
    
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed or not in PATH"
        exit 1
    fi
    
    if ! test -f Dockerfile; then
        log_error "Dockerfile not found in current directory"
        exit 1
    fi
    
    if ! test -f VERSION; then
        log_error "VERSION file not found"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        log_error "Docker daemon is not running or not accessible"
        exit 1
    fi
}

# Update Dockerfile with build info
update_dockerfile() {
    log_info "Updating Dockerfile with build information..."
    local timestamp=$(date '+%Y-%m-%d-%H:%M')
    
    # Create backup
    cp Dockerfile Dockerfile.bak
    
    # Update build info
    sed -i "s/^ENV REFRESHED_AT.*/ENV REFRESHED_AT $timestamp/" Dockerfile
    sed -i "s/^ENV VERSION.*/ENV VERSION $VERSION/" Dockerfile
}

# Git operations
handle_git() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        log_info "Git repository detected, committing changes..."
        
        # Check if there are changes to commit
        if ! git diff --quiet || ! git diff --cached --quiet; then
            git add -A
            git commit -m "automated build, RELEASE: $RELEASE, VERSION: $VERSION" || {
                log_warn "Git commit failed, continuing with build..."
            }
        else
            log_info "No changes to commit"
        fi
    else
        log_warn "Not a git repository, skipping git operations"
    fi
}

# Docker build
build_image() {
    log_info "Building Docker image..."
    log_info "Registry: $REG"
    log_info "Version: $VERSION"
    log_info "Release: $RELEASE"
    
    # Build the image
    docker build $BUILD_ARGS -t "$REG:$VERSION" . || {
        log_error "Docker build failed"
        # Restore backup
        if test -f Dockerfile.bak; then
            mv Dockerfile.bak Dockerfile
        fi
        exit 1
    }
    
    # Tag as latest
    docker tag "$REG:$VERSION" "$REG:$RELEASE"
    
    log_info "Build completed successfully"
}

# Push images
push_images() {
    if [[ "${SKIP_PUSH:-false}" == "true" ]]; then
        log_info "Skipping push (SKIP_PUSH=true)"
        return
    fi
    
    log_info "Pushing images to registry..."
    
    docker push "$REG:$RELEASE" || {
        log_error "Failed to push $REG:$RELEASE"
        exit 1
    }
    
    docker push "$REG:$VERSION" || {
        log_error "Failed to push $REG:$VERSION"
        exit 1
    }
    
    log_info "Images pushed successfully"
}

# Push stable tag
push_stable() {
    if [[ "${AUTO_STABLE:-false}" == "true" ]]; then
        log_info "Auto-pushing stable tag..."
        docker tag "$REG:$VERSION" "$REG:stable"
        docker push "$REG:stable"
        return
    fi
    
    echo
    log_info "Build and push completed successfully!"
    echo "If you want to push this release with 'stable' tag as well,"
    echo "press ENTER to continue or CTRL+C to exit."
    read -r
    
    log_info "Tagging and pushing stable version..."
    docker tag "$REG:$VERSION" "$REG:stable"
    docker push "$REG:stable"
    log_info "Stable tag pushed successfully"
}

# Cleanup
cleanup() {
    if test -f Dockerfile.bak; then
        rm -f Dockerfile.bak
    fi
}

# Main execution
main() {
    echo "=================================================="
    echo "Docker Build Script for XFCE VNC Desktop"
    echo "=================================================="
    echo "Registry: $REG"
    echo "Version:  $VERSION"
    echo "Release:  $RELEASE"
    echo "=================================================="
    echo
    
    validate_environment
    update_dockerfile
    handle_git
    
    # Optional cleanup before build
    if [[ "${CLEAN_BUILD:-false}" == "true" ]]; then
        log_info "Cleaning Docker system..."
        docker system prune -a -f
    fi
    
    build_image
    push_images
    push_stable
    cleanup
    
    log_info "All operations completed successfully!"
}

# Trap for cleanup
trap cleanup EXIT

# Run main function
main "$@"
