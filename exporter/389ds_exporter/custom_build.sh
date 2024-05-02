#!/bin/bash -x

# Set bash options to stop on error and error on unset variables
set -euo pipefail

# Define version and directories
VERSION="1.0"
ARCHIVE_DIR="/workspace/archives"
EXPORTER_DIR="${ARCHIVE_DIR}/389DS-exporter"
EXPORTER_BIN_DIR="${EXPORTER_DIR}/${VERSION}.linux-amd64"

# Clean up previous builds
if [ -d "${EXPORTER_DIR}" ]; then
    echo "Cleaning up old exporter directory."
    sudo rm -rf "${EXPORTER_DIR}"
fi

# Clone the repository
echo "Cloning the 389DS-exporter repository..."
git clone https://github.com/ozgurcd/389DS-exporter "${EXPORTER_DIR}"

# Build the exporter
echo "Building the 389DS-exporter..."
cd "${EXPORTER_DIR}"
mkdir -p "${EXPORTER_BIN_DIR}"
go build -o "${EXPORTER_BIN_DIR}/389ds_exporter"

# Package the binary
echo "Packaging the exporter..."
cd "${ARCHIVE_DIR}"
tar czf "389ds_exporter-${VERSION}.tar.gz" -C "${EXPORTER_BIN_DIR}" .

# Move the package to the final directory (if different)
# This step seems redundant in your script as it copies within the same directory
# I'll keep it in case you have different intentions for modifications.
echo "Moving the tarball to the archives directory."
cp "${ARCHIVE_DIR}/389ds_exporter-${VERSION}.tar.gz" "${ARCHIVE_DIR}/"

echo "Build and packaging complete."
