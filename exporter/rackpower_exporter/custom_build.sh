#!/bin/bash

# Set bash options to stop on error and error on unset variables
set -euo pipefail

# Get the directory where the script is located to find source files
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define version to match what rpmbuild expects (1.0 based on logs)
VERSION=1.1.0
NAME="rackpower_exporter"
DIRNAME="${NAME}-${VERSION}"
ARCHIVE_NAME="${DIRNAME}.tar.gz"
ARCHIVE_DIR="/workspace/archives"

echo "Starting custom build for ${NAME} ${VERSION}..."

# Create a secure temporary directory for building
BUILD_TMP=$(mktemp -d)
echo "Working in temporary directory: ${BUILD_TMP}"

# Ensure cleanup on exit
trap 'rm -rf "${BUILD_TMP}"' EXIT

# Prepare source directory structure
mkdir -p "${BUILD_TMP}/${DIRNAME}"

# Copy source files from the script directory to the temp dir
echo "Copying source files from ${SCRIPT_DIR}..."
if [ -f "${SCRIPT_DIR}/rackpower_exporter" ] && [ -f "${SCRIPT_DIR}/rackpower.yml" ]; then
    cp "${SCRIPT_DIR}/rackpower_exporter" "${BUILD_TMP}/${DIRNAME}/"
    cp "${SCRIPT_DIR}/rackpower.yml" "${BUILD_TMP}/${DIRNAME}/"
else
    echo "Error: Source files (rackpower_exporter, rackpower.yml) not found in ${SCRIPT_DIR}."
    exit 1
fi

# Create the tarball inside the temp directory
echo "Creating tarball ${ARCHIVE_NAME}..."
# We change directory to BUILD_TMP so the tarball contains the relative path "${DIRNAME}/..."
(cd "${BUILD_TMP}" && tar czf "${ARCHIVE_NAME}" "${DIRNAME}")

# Export artifact
if [ ! -d "${ARCHIVE_DIR}" ]; then
    echo "Creating archive directory ${ARCHIVE_DIR}..."
    # Try to create it, might fail if no permissions, but let's try. 
    # If it fails, the script will exit due to set -e when cp fails later, which is fine.
    mkdir -p "${ARCHIVE_DIR}" || true
fi

if [ -d "${ARCHIVE_DIR}" ]; then
    echo "Copying ${ARCHIVE_NAME} to ${ARCHIVE_DIR}..."
    cp "${BUILD_TMP}/${ARCHIVE_NAME}" "${ARCHIVE_DIR}/"
    echo "Artifact exported successfully to ${ARCHIVE_DIR}/${ARCHIVE_NAME}"
else
    echo "Error: Archive directory ${ARCHIVE_DIR} is not accessible."
    exit 1
fi

echo "Build complete."

