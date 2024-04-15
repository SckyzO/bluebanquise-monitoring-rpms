#!/bin/bash -x

# Exit immediately if a command exits with a non-zero status.
set -x
# Function to fetch the latest GitHub release version
check_last_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | jq -r .tag_name | sed 's/^v//g'
}

# Define the base directory for archives
ARCHIVE_DIR="/workspace/archives"

# Fetch version information
VERSION=$(check_last_release ClusterLabs/ha_cluster_exporter)

# Download the latest release
echo "Downloading ha_cluster_exporter version ${VERSION}..."
wget "https://github.com/ClusterLabs/ha_cluster_exporter/releases/download/${VERSION}/ha_cluster_exporter-amd64.gz" -O "${ARCHIVE_DIR}/ha_cluster_exporter-${VERSION}.gz" -c

# Prepare the directory and extract the file
echo "Preparing and extracting the file..."
cd "${ARCHIVE_DIR}"
gunzip -f "ha_cluster_exporter-${VERSION}.gz"
mkdir -p "ha_cluster_exporter-${VERSION}.linux-amd64"
mv "ha_cluster_exporter-${VERSION}" "ha_cluster_exporter-${VERSION}.linux-amd64/ha_cluster_exporter"

# Create a tarball for the RPM build
echo "Creating tarball..."
tar czf "ha_cluster_exporter-${VERSION}.linux-amd64.tar.gz" "ha_cluster_exporter-${VERSION}.linux-amd64/"
rm -Rf "ha_cluster_exporter-${VERSION}.linux-amd64/"

echo "Preparation complete."
