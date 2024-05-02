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
VERSION=$(check_last_release sysdiglabs/grok_exporter)

# Define the directory for Oniguruma and Grok exporter
ONIGURUMA_DIR="/tmp/onig-6.9.5"
GROK_EXPORTER_DIR="/tmp/grok_exporter"

# Download and build Oniguruma
echo "Downloading and building Oniguruma..."
curl -sLo /tmp/onig-6.9.5-rev1.tar.gz https://github.com/kkos/oniguruma/releases/download/v6.9.5_rev1/onig-6.9.5-rev1.tar.gz
tar -C /tmp -xzf /tmp/onig-6.9.5-rev1.tar.gz
cd "$ONIGURUMA_DIR"
./configure
make
sudo make install
rm /tmp/onig-6.9.5-rev1.tar.gz

# Clone and build Grok Exporter
echo "Cloning and building Grok Exporter..."
git clone https://github.com/fstab/grok_exporter "$GROK_EXPORTER_DIR"
cd "$GROK_EXPORTER_DIR"
git submodule update --init --recursive
go install .

# Prepare the binary directory
ARCHIVE_DIR="/workspace/archives"
EXPORTER_BIN_DIR="${ARCHIVE_DIR}/grok_exporter-${VERSION}.linux-amd64"
mkdir -p "$EXPORTER_BIN_DIR"
mv $HOME/go/bin/grok_exporter "$EXPORTER_BIN_DIR/"

# Package the binary into a tarball
echo "Packaging the exporter binary..."
cd "$ARCHIVE_DIR"
ls -alR $ARCHIVE_DIR
tar czf "grok_exporter-${VERSION}.linux-amd64.tar.gz" "grok_exporter-${VERSION}.linux-amd64/"
rm -rf "grok_exporter-${VERSION}.linux-amd64/"

echo "Grok Exporter build and packaging complete."
