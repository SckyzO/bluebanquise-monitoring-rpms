#!/bin/bash

# Set the script to exit immediately on any errors and print each command before execution
set -euxo pipefail

# Function to fetch the latest GitHub release version
check_last_release() {
  local repo="$1"
  local tag=$(curl --silent "https://api.github.com/repos/$repo/releases/latest" | jq -r .tag_name)
  echo "${tag#v}"  # Assuming the tag starts with 'v' which should be stripped out
}

# Fetch version information
VERSION=$(check_last_release NVIDIA/dcgm-exporter | awk -F'-' '{print $2}')

# Define the archive directory and the exporter directory
ARCHIVE_DIR="/workspace/archives"
EXPORTER_DIR="${ARCHIVE_DIR}/dcgm-exporter"

# Clean up previous exports if exists
if [ -d "${EXPORTER_DIR}" ]; then
    echo "Removing existing DCGM Exporter directory."
    sudo rm -rf "${EXPORTER_DIR}"
fi

# Clone the repository
echo "Cloning DCGM Exporter repository."
git clone https://github.com/NVIDIA/dcgm-exporter "${EXPORTER_DIR}"

# Add NVIDIA CUDA repository
sudo dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo

# Install necessary packages
sudo dnf install -y datacenter-gpu-manager docker

# Install Go from the official source
GO_VERSION="1.21.6"
wget "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go${GO_VERSION}.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf /tmp/go${GO_VERSION}.linux-amd64.tar.gz

# Set up environment variables for Go
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Build the binary using Make
cd "${EXPORTER_DIR}"
make binary

# Prepare the binary directory and package it
BIN_DIR="${EXPORTER_DIR}/cmd/dcgm-exporter"
mkdir -p "${BIN_DIR}/nvidia-dcgm_exporter-${VERSION}.linux-amd64/"
mv "${BIN_DIR}/dcgm-exporter" "${BIN_DIR}/nvidia-dcgm_exporter-${VERSION}.linux-amd64/nvidia-dcgm_exporter"

# Create a tarball for distribution
echo "Packaging the exporter binary."
cd "${BIN_DIR}"
tar czf "nvidia-dcgm_exporter-${VERSION}.tar.gz" "nvidia-dcgm_exporter-${VERSION}.linux-amd64/"

# Move the tarball to the archives directory
cp "nvidia-dcgm_exporter-${VERSION}.tar.gz" "${ARCHIVE_DIR}/"

echo "NVIDIA DCGM Exporter build and packaging complete."
