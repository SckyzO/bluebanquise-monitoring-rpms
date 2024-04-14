#!/bin/bash

# Set the script to exit immediately on any errors and print each command before execution
set -euxo pipefail

# Function to fetch the latest GitHub release version
check_last_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | jq -r .tag_name | sed 's/^v//g'
}

# Fetch version information
VERSION=$(check_last_release containers/prometheus-podman-exporter)

# Determine OS release and set appropriate repositories and package URLs
OS_RELEASE=$(awk -F= '/REDHAT_SUPPORT_PRODUCT_VERSION/ { gsub(/"/, "", $2); print int($2); }' /etc/os-release)
if (( OS_RELEASE > 8 )); then
    additional_repo=crb
    REPO_BTRFS="https://cbs.centos.org/kojifiles/packages/btrfs-progs/6.8/1.el9/x86_64/"
else 
    additional_repo=powertools
    REPO_BTRFS="https://cbs.centos.org/kojifiles/packages/btrfs-progs/6.6.3/2.el8/x86_64/"
fi

# Clean up previous exports if exists
ARCHIVE_DIR="/workspace/archives"
EXPORTER_DIR="${ARCHIVE_DIR}/podman_exporter"
if [ -d "${EXPORTER_DIR}" ]; then
    echo "Removing existing Podman Exporter directory."
    sudo rm -rf "${EXPORTER_DIR}"
fi

# Clone the repository
echo "Cloning Podman Exporter repository."
git clone https://github.com/containers/prometheus-podman-exporter "${EXPORTER_DIR}"

# Navigate to the cloned directory
cd "${EXPORTER_DIR}"

# Install necessary DNF plugins and enable the appropriate repository
sudo dnf install 'dnf-command(config-manager)' -y
sudo dnf config-manager --set-enabled $additional_repo

# Install development tools
sudo dnf install device-mapper-devel gpgme-devel libassuan-devel -y

# Download necessary RPMs from the repository and install them
echo "Downloading and installing RPMs from repository."
curl -s $REPO_BTRFS | grep -oP 'href="\K[^"]*.rpm' | xargs -I{} wget "{}" -P /tmp
sudo dnf install /tmp/*.rpm -y

# Build the binary
echo "Building the exporter."
make binary

# Prepare the binary directory
BIN_DIR="${EXPORTER_DIR}/bin"
mkdir -p "${BIN_DIR}/podman_exporter-${VERSION}.linux-amd64/"
mv "${BIN_DIR}/prometheus-podman-exporter" "${BIN_DIR}/podman_exporter-${VERSION}.linux-amd64/podman_exporter"

# Package the binary into a tarball
echo "Packaging the binary into a tarball."
cd "${BIN_DIR}"
tar czf "podman_exporter-${VERSION}.tar.gz" "podman_exporter-${VERSION}.linux-amd64/"

# Move the tarball to the archives directory
cp "podman_exporter-${VERSION}.tar.gz" "${ARCHIVE_DIR}/"

echo "Podman Exporter build and packaging complete."
