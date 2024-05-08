#!/bin/bash -x

# Set bash options to stop on error and error on unset variables
set -euo pipefail

# Define version and directories
VERSION="1.0"
ARCHIVE_DIR="/workspace/archives"
EXPORTER_DIR="${ARCHIVE_DIR}/389DS-exporter"

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
go build -o "389ds_exporter"

# Package the binary
echo "Packaging the exporter..."
mkdir ${ARCHIVE_DIR}/389ds_exporter-${VERSION}.linux-amd64
mv "${EXPORTER_DIR}/389ds_exporter" ${ARCHIVE_DIR}/389ds_exporter-${VERSION}.linux-amd64/
cd ${ARCHIVE_DIR}
tar czf "${ARCHIVE_DIR}/389ds_exporter-${VERSION}.linux-amd64.tar.gz" 389ds_exporter-${VERSION}.linux-amd64/

# Clear archives
rm -Rf ${EXPORTER_DIR}  ${ARCHIVE_DIR}/389ds_exporter-${VERSION}.linux-amd64/


echo "Build and packaging complete."

