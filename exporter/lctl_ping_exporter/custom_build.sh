#!/bin/bash -x

# Set bash options to stop on error and error on unset variables
set -euo pipefail

# Define version and directories

VERSION=1.0
ARCHIVE_DIR="/workspace/archives"
EXPORTER_DIR="${ARCHIVE_DIR}/lctl_ping_exporter"

# Clean up previous exports if exists
if [ -d "${EXPORTER_DIR}" ]; then
        echo "Removing existing Rackpower Exporter directory."
            sudo rm -rf "${EXPORTER_DIR}"
fi

# Install exporter
mkdir -p $EXPORTER_DIR
cp "/workspace/exporter/lctl_ping_exporter/lctl_ping_exporter-$VERSION.tar.gz" $ARCHIVE_DIR

