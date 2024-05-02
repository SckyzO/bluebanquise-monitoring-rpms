#!/bin/bash

# Initialisation des répertoires s'ils ne sont pas présents
test -d /workspace/build/ || sudo mkdir -p /workspace/build/
test -d /workspace/build/rpms || sudo mkdir -p /workspace/build/rpms
test -d /workspace/build/sources || sudo mkdir -p /workspace/build/sources
test -d /workspace/archives/ || sudo mkdir -p /workspace/archives/

# Fonction pour vérifier la dernière version GitHub
check_last_release() {
    local tag=$(curl --silent "https://api.github.com/repos/$1/releases/latest" | jq -r .tag_name)
    local clean_tag="${tag#v}"
    if [[ -z "$clean_tag" || "$clean_tag" == "null" ]]; then
        echo "1.0"
    else
        # Use awk to extract potentially more specific parts of the tag, if needed
        echo "$clean_tag" | awk -F'-' '{print $1}'
    fi
}

# Fonction pour télécharger le tarball de GitHub et le renommer pour standardiser
download_and_prepare() {
    local repo=$1
    local exporter=$2
    local type=$3
    local version=$(check_last_release "$repo")
    local release_info=$(curl -s "https://api.github.com/repos/${repo}/releases/latest")

    echo "$release_info" | jq -r --arg type "$type" '.assets[] | select(.name | endswith($type)) | .browser_download_url' | while read url; do
        local filename=$(basename "$url")
        local out="/workspace/archives/${filename}"
        wget "$url" -O "$out" -c

        local new_filename="${exporter}-${version}.linux-amd64.tar.gz"
        mv "/workspace/archives/${filename}" "/workspace/archives/${new_filename}"
        echo "Renamed $filename to $new_filename"
    done
}

# Function to handle custom build scripts if they exist
custom_build_and_prepare() {
  local exporter=$1
  if [[ -f "/workspace/exporter/${exporter}/custom_build.sh" ]]; then
    echo "Running custom build script for ${exporter}"
    bash "/workspace/exporter/${exporter}/custom_build.sh"
    return 0  # Return 0 if custom build script is executed
  else
    echo "No custom build script for ${exporter}, proceeding with standard preparation"
    return 1  # Return 1 if no custom build script is executed
  fi
}

# Function to handle each exporter build process
build_exporter() {
  local repo=$1
  local exporter=$2
  local type=$3
  local spec_dir=$4

  # Check and run any custom build script first
  if custom_build_and_prepare "$exporter"; then
    echo "Custom build completed, skipping standard preparation."
  else
    # Proceed with standard download and preparation if no custom script was executed
    download_and_prepare "$repo" "$exporter" "$type"
  fi

  # Finally, build the RPM
  local version=$(check_last_release "$repo")
  build_rpm "$exporter" "$version" "$spec_dir"
}

# Build and install the rpm from the spec file
build_rpm() {
  local exporter=$1
  local version=$2
  local spec_dir=$3
  local spec_file="/workspace/exporter/${exporter}/${exporter}.spec"

  sudo rpmbuild --clean \
                --define "pkgversion ${version}" \
                --define "_topdir /tmp/rpm" \
                --define "_sourcedir /workspace/archives" \
                -ba "$spec_file"

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

# Generate build functions for all exporters, one per line for readability
build_389ds_exporter() { 
  build_exporter "ozgurcd/389DS-exporter" "389ds_exporter" "linux-amd64.tar.gz" "/workspace/exporter" 
}

build_alertmanager() {
  build_exporter "prometheus/alertmanager" "alertmanager" "linux-amd64.tar.gz" "/workspace/exporter"
}

build_apache_exporter() { 
  build_exporter "Lusitaniae/apache_exporter" "apache_exporter" "linux-amd64.tar.gz" "/workspace/exporter" 
}

build_bind_exporter() { 
  build_exporter "prometheus-community/bind_exporter" "bind_exporter" "linux-amd64.tar.gz" "/workspace/exporter" 
}

build_eseries_exporter() { 
  build_exporter "treydock/eseries_exporter" "eseries_exporter" "linux-amd64.tar.gz" "/workspace/exporter" 
}

build_gpfs_exporter() { 
  build_exporter "treydock/gpfs_exporter" "gpfs_exporter" "linux-amd64.tar.gz" "/workspace/exporter" 
}

build_grok_exporter() { 
  build_exporter "sysdiglabs/grok_exporter" "grok_exporter" "linux-amd64.tar.gz" "/workspace/exporter" 
}

build_ha_cluster_exporter() { 
  build_exporter "ClusterLabs/ha_cluster_exporter" "ha_cluster_exporter" "linux-amd64.tar.gz" "/workspace/exporter" 
}

build_infiniband_exporter() { 
  build_exporter "treydock/infiniband_exporter" "infiniband_exporter" "linux-amd64.tar.gz" "/workspace/exporter" 
}

build_ipmi_exporter() { 
  build_exporter "prometheus-community/ipmi_exporter" "ipmi_exporter" "linux-amd64.tar.gz" "/workspace/exporter" 
}

build_lustre_exporter() { 
  build_exporter "HPC/lustre_exporter" "lustre_exporter" "linux-amd64.tar.gz" "/workspace/exporter" 
}

build_lvm_exporter() { 
  build_exporter "hansmi/prometheus-lvm-exporter" "lvm_exporter" "linux_amd64.tar.gz" "/workspace/exporter" 
}

build_nvidia-dcgm_exporter() { 
  build_exporter "NVIDIA/dcgm-exporter" "nvidia-dcgm_exporter" "linux-amd64.tar.gz" "/workspace/exporter" 
}

build_node_exporter() {
  build_exporter "prometheus/node_exporter" "node_exporter" "linux-amd64.tar.gz" "/workspace/exporter"
}

build_ping_exporter() {
  build_exporter "jaxxstorm/ping_exporter" "ping_exporter" "Linux-x86_64.tar.gz" "/workspace/exporter"
}

build_podman_exporter() {
  build_exporter "containers/prometheus-podman-exporter" "podman_exporter" "linux-amd64.tar.gz" "/workspace/exporter"
}

build_process_exporter() {
  build_exporter "ncabatoff/process-exporter" "process_exporter" "linux-amd64.tar.gz" "/workspace/exporter"
}

build_prometheus() {
  build_exporter "prometheus/prometheus" "prometheus" "linux-amd64.tar.gz" "/workspace/exporter"
}

build_smartctl_exporter() {
  build_exporter "prometheus-community/smartctl_exporter" "smartctl_exporter" "linux-amd64.tar.gz" "/workspace/exporter"
}

build_snmp_exporter() {
  build_exporter "prometheus/snmp_exporter" "snmp_exporter" "linux-amd64.tar.gz" "/workspace/exporter"
}

build_slurm_exporter(){
  build_exporter "vpenso/prometheus-slurm-exporter" "slurm_exporter" "linux-amd64.tar.gz" "/workspace/exporter"
}

# Handle the argument passed to the script to select the right function
case $1 in
  389ds_exporter )
    build_389ds_exporter ;;
  alertmanager )
    build_alertmanager ;;
  apache_exporter )
    build_apache_exporter ;;
  bind_exporter )
    build_bind_exporter ;;
  eseries_exporter )
    build_eseries_exporter ;;
  gpfs_exporter )
    build_gpfs_exporter ;;
  grok_exporter )
    build_grok_exporter ;;
  ha_cluster_exporter )
    build_ha_cluster_exporter ;;
  infiniband_exporter )
    build_infiniband_exporter ;;
  ipmi_exporter )
    build_ipmi_exporter ;;
  lustre_exporter )
    build_lustre_exporter ;;
  lvm_exporter )
    build_lvm_exporter ;;
  nvidia-dcgm_exporter )
    build_nvidia-dcgm_exporter ;;
  node_exporter )
    build_node_exporter ;;
  ping_exporter )
    build_ping_exporter ;;
  podman_exporter )
    build_podman_exporter ;;
  process_exporter )
    build_process_exporter ;;
  prometheus )
    build_prometheus ;;
  smartctl_exporter )
    build_smartctl_exporter ;;
  snmp_exporter )
    build_snmp_exporter ;;
  slurm_exporter )
    build_slurm_exporter ;;
  *)
    echo "Unknown exporter: $1"
    exit 1 ;;
esac
