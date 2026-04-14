#!/bin/bash
set -e

# Script to build wheel locally using Docker, mimicking CI builds.
# Usage: ./build-local.sh [linux|windows]

TARGET=${1:-linux} # Default to linux
echo "==> Building for $TARGET"

if [ "$TARGET" == "linux" ]; then
    echo "==> Building linux build image..."
    docker build -t mmcv-build-linux -f docker/ltrace/Dockerfile.linux .

    echo "==> Running linux build..."
    docker run --rm \
        -u "$(id -u):$(id -g)" \
        -v "$(pwd):/workspace" \
        mmcv-build-linux
elif [ "$TARGET" == "windows" ]; then
    echo "--> NOTE: Windows builds must be run on a Windows host with Docker Desktop"
    echo "    in 'Windows containers' mode."
    echo "--> Building windows build image..."
    docker build -t mmcv-build-windows -f docker/ltrace/Dockerfile.windows .

    echo "--> Running windows build..."
    echo "Run the following command on your Windows machine (using PowerShell):"
    docker run --rm \
        -v "\${PWD}:C:\workspace" \
        mmcv-build-windows

else
    echo "Invalid target: $TARGET. Use 'linux' or 'windows'."
    exit 1
fi

echo "==> Build complete. Find wheels in the 'dist' directory."
ls -l dist
