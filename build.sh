#!/bin/bash -eux

#sudo yum install -y epel-release bc


check_last_release() {
  # Check last github release
  curl --silent "https://api.github.com/repos/$1/releases/latest" | jq -r .tag_name | sed 's/^v//g'
}

build_prometheus() {
  # Prometheus version
  VERSION=$(check_last_release prometheus/prometheus)
  sudo wget https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.linux-amd64.tar.gz -O /workspace/archives/prometheus-${VERSION}.tar.gz -c

  sudo rpmbuild \
  	--clean \
  	--define "pkgversion ${VERSION}" \
  	--define "_topdir /tmp/rpm" \
  	--define "_sourcedir /workspace/archives" \
  	-ba /workspace/exporters/spec/prometheus.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_alertmanager() {
  # alertmanager version
  VERSION=$(check_last_release prometheus/alertmanager)
  sudo wget https://github.com/prometheus/alertmanager/releases/download/v${VERSION}/alertmanager-${VERSION}.linux-amd64.tar.gz -O /workspace/archives/alertmanager-${VERSION}.tar.gz -c

  sudo rpmbuild \
  	--clean \
  	--define "pkgversion ${VERSION}" \
  	--define "_topdir /tmp/rpm" \
  	--define "_sourcedir /workspace/archives" \
	-ba /workspace/exporters/spec/alertmanager.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_node_exporter() {
  # node_exporter version
  VERSION=$(check_last_release prometheus/node_exporter)
  sudo wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz -O /workspace/archives/node_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/node_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_node_exporter_arm64() {
  # node_exporter version
  VERSION=$(check_last_release prometheus/node_exporter)
  sudo wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-arm64.tar.gz -O /workspace/archives/node_exporter-${VERSION}_arm64.tar.gz -c

  sudo rpmbuild \
    --clean \
    --target aarch64-linux \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/node_exporter_arm.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_ping_exporter() {
  # ping_exporter version
  VERSION=$(check_last_release jaxxstorm/ping_exporter)
  sudo wget https://github.com/jaxxstorm/ping_exporter/releases/download/${VERSION}/ping_exporter-${VERSION}.Linux-x86_64.tar.gz -O /workspace/archives/ping_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/ping_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_ha_cluster_exporter() {
  # ha_cluster_exporter
  VERSION=$(check_last_release ClusterLabs/ha_cluster_exporter)
  sudo wget https://github.com/ClusterLabs/ha_cluster_exporter/releases/download/${VERSION}/ha_cluster_exporter-amd64.gz -O /workspace/archives/ha_cluster_exporter-${VERSION}.gz -c
  
  cd /workspace/archives
  sudo gunzip -f ha_cluster_exporter-${VERSION}.gz
  sudo test -d ha_cluster_exporter-${VERSION}.linux-amd64 || sudo mkdir ha_cluster_exporter-${VERSION}.linux-amd64
  sudo mv ha_cluster_exporter-${VERSION} ha_cluster_exporter-${VERSION}.linux-amd64/ha_cluster_exporter
  sudo tar czf ha_cluster_exporter-${VERSION}.tar.gz ha_cluster_exporter-${VERSION}.linux-amd64/
  sudo rm -Rf ha_cluster_exporter-${VERSION}.linux-amd64/

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/ha_cluster_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_bind_exporter() {
  # bind_exporter version
  VERSION=$(check_last_release prometheus-community/bind_exporter)
  sudo wget https://github.com/prometheus-community/bind_exporter/releases/download/v${VERSION}/bind_exporter-${VERSION}.linux-amd64.tar.gz -O /workspace/archives/bind_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/bind_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_process_exporter() {
  # process_exporter version
  VERSION=$(check_last_release ncabatoff/process-exporter)
  sudo wget https://github.com/ncabatoff/process-exporter/releases/download/v${VERSION}/process-exporter-${VERSION}.linux-amd64.tar.gz -O /workspace/archives/process_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/process_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_ipmi_exporter() {
  # ipmi_exporter version
  VERSION=$(check_last_release prometheus-community/ipmi_exporter)
  sudo wget https://github.com/prometheus-community/ipmi_exporter/releases/download/v${VERSION}/ipmi_exporter-${VERSION}.linux-amd64.tar.gz -O /workspace/archives/ipmi_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/ipmi_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_snmp_exporter() {
  # snmp_exporter version
  VERSION=$(check_last_release prometheus/snmp_exporter)
  sudo wget https://github.com/prometheus/snmp_exporter/releases/download/v${VERSION}/snmp_exporter-${VERSION}.linux-amd64.tar.gz -O /workspace/archives/snmp_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/snmp_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_lvm_exporter() {
  # snmp_exporter version
  VERSION=$(check_last_release hansmi/prometheus-lvm-exporter)
  sudo wget https://github.com/hansmi/prometheus-lvm-exporter/releases/download/v${VERSION}/prometheus-lvm-exporter_${VERSION}_linux_amd64.tar.gz -O /workspace/archives/lvm_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/lvm_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_slurm_exporter() {
  VERSION=$(check_last_release vpenso/prometheus-slurm-exporter)
  
  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/slurm_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_eseries_exporter() {
  # eseries_exporter version
  VERSION=$(check_last_release treydock/eseries_exporter)
  sudo wget https://github.com/treydock/eseries_exporter/releases/download/v${VERSION}/eseries_exporter-${VERSION}.linux-amd64.tar.gz -O /workspace/archives/eseries_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/eseries_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_gpfs_exporter() {
  # eseries_exporter version
  VERSION=$(check_last_release treydock/gpfs_exporter)
  sudo wget https://github.com/treydock/gpfs_exporter/releases/download/v${VERSION}/gpfs_exporter-${VERSION}.linux-amd64.tar.gz -O /workspace/archives/gpfs_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/gpfs_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_smartctl_exporter() {
  # eseries_exporter version
  VERSION=$(check_last_release prometheus-community/smartctl_exporter)
  sudo wget https://github.com/prometheus-community/smartctl_exporter/releases/download/v${VERSION}/smartctl_exporter-${VERSION}.linux-amd64.tar.gz -O /workspace/archives/smartctl_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/smartctl_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_389ds_exporter() {
  # 389ds_exporter
  VERSION="0.1"
  
  [ -d /workspace/archives/389DS-exporter ] && sudo rm -Rf /workspace/archives/389DS-exporter
  cd /workspace/archives
  git clone https://github.com/ozgurcd/389DS-exporter
  cd /workspace/archives/389DS-exporter
  go build -o 389ds_exporter-${VERSION}.linux-amd64/389ds_exporter
  tar czf 389ds_exporter-${VERSION}.tar.gz 389ds_exporter-${VERSION}.linux-amd64/
  cp /workspace/archives/389DS-exporter/389ds_exporter-${VERSION}.tar.gz /workspace/archives/

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/389ds_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_infiniband_exporter() {
  # infiniband version
  VERSION=$(check_last_release treydock/infiniband_exporter)
  sudo wget https://github.com/treydock/infiniband_exporter/releases/download/v${VERSION}/infiniband_exporter-${VERSION}.linux-amd64.tar.gz -O /workspace/archives/infiniband_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/infiniband_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_apache_exporter() {
  # apache version
  VERSION=$(check_last_release Lusitaniae/apache_exporter)
  sudo wget https://github.com/Lusitaniae/apache_exporter/releases/download/v${VERSION}/apache_exporter-${VERSION}.linux-amd64.tar.gz -O /workspace/archives/apache_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/apache_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_podman_exporter() {
  # podman version
  VERSION=$(check_last_release containers/prometheus-podman-exporter)
  
  [ -d /workspace/archives/podman_exporter ] && sudo rm -Rf /workspace/archives/podman_exporter
  cd /workspace/archives
  git clone https://github.com/containers/prometheus-podman-exporter podman_exporter
  cd /workspace/archives/podman_exporter
  sudo dnf install 'dnf-command(config-manager)' -y
  sudo dnf config-manager --set-enabled $additionnal_repo
  sudo dnf install device-mapper-devel gpgme-devel libassuan-devel -y
  curl -s $REPO_BTRFS | grep -oP 'href="\K[^"]*.rpm' | while read RPM; do wget "${REPO_BTRFS}${RPM}" -P /tmp; done
  sudo dnf install /tmp/*.rpm -y
  make binary
  cd bin/
  mkdir podman_exporter-${VERSION}.linux-amd64/
  mv prometheus-podman-exporter podman_exporter-${VERSION}.linux-amd64/podman_exporter
  tar czf podman_exporter-${VERSION}.tar.gz podman_exporter-${VERSION}.linux-amd64/
  cp /workspace/archives/podman_exporter/bin/podman_exporter-${VERSION}.tar.gz /workspace/archives/

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/podman_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}

build_nvidia-dcgm_exporter() {
  # nvidia-dcgm version
  VERSION=$(check_last_release NVIDIA/dcgm-exporter | awk -F'-' '{print $2}')  
  
  [ -d /workspace/archives/dcgm-exporter ] && sudo rm -Rf /workspace/archives/dcgm-exporter
  cd /workspace/archives
  sudo dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo
  sudo dnf install -y datacenter-gpu-manager docker 
  wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz -O /tmp/go1.21.6.linux-amd64.tar.gz
  cd /tmp
  tar xf go1.21.6.linux-amd64.tar.gz
  export GOROOT=/tmp/go/
  export GOPATH=$HOME/go
  export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
  git clone https://github.com/NVIDIA/dcgm-exporter /workspace/archives/dcgm-exporter
  cd /workspace/archives/dcgm-exporter
  PATH=$GOPATH/bin:$GOROOT/bin:$PATH make binary
  cd cmd/dcgm-exporter
  mkdir nvidia-dcgm_exporter-${VERSION}.linux-amd64/
  mv dcgm-exporter nvidia-dcgm_exporter-${VERSION}.linux-amd64/nvidia-dcgm_exporter
  tar czf nvidia-dcgm_exporter-${VERSION}.tar.gz nvidia-dcgm_exporter-${VERSION}.linux-amd64/
  cp /workspace/archives/dcgm-exporter/cmd/dcgm-exporter/nvidia-dcgm_exporter-${VERSION}.tar.gz /workspace/archives/


  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/archives" \
    -ba /workspace/exporters/spec/nvidia-dcgm_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}



#command -v dnf 2>&1 && dnf install bc epel-release -y || sudo yum install -y bc epel-release 
#if [[ $(echo "$(cat /etc/os-release | grep REDHAT_SUPPORT_PRODUCT_VERSION | awk -F'=' '{print $2}' | sed 's/"//g') <= 7" | bc -l) ]]; then sudo yum install wget jq epel-release -y;fii
OS_RELEASE=$(awk -F= '/REDHAT_SUPPORT_PRODUCT_VERSION/ { gsub(/"/, "", $2); print int($2); }' /etc/os-release)
#if [[ $(echo "$(cat /etc/os-release | grep REDHAT_SUPPORT_PRODUCT_VERSION | awk -F'=' '{print $2}' | sed 's/"//g' | cut -d '.' -f1 ) > 8" | bc -l) ]]; 
if (( OS_RELEASE > 8))
then 
    additionnal_repo=crb
    REPO_BTRFS="https://cbs.centos.org/kojifiles/packages/btrfs-progs/6.8/1.el9/x86_64/"
else 
    additionnal_repo=powertools
    REPO_BTRFS="https://cbs.centos.org/kojifiles/packages/btrfs-progs/6.6.3/2.el8/x86_64/"
fi

test -d /workspace/build/ || sudo mkdir -p /workspace/build/
test -d /workspace/build/rpms || sudo mkdir -p /workspace/build/rpms
test -d /workspace/build/sources || sudo mkdir -p /workspace/build/sources
test -d /workspace/archives/ || sudo mkdir -p /workspace/archives/


case $1 in
  prometheus )
  build_prometheus 
  ;;
  alertmanager )
  build_alertmanager 
  ;;
  node_exporter )
  build_node_exporter 
  ;;
  node_exporter_arm64 )
  build_node_exporter_arm64
  ;;
  ping_exporter )
  build_ping_exporter 
  ;;
  ha_cluster_exporter )
  build_ha_cluster_exporter 
  ;;
  bind_exporter )
  build_bind_exporter 
  ;; 
  process_exporter )
  build_process_exporter 
  ;;
  ipmi_exporter )
  build_ipmi_exporter 
  ;;
  snmp_exporter )
  build_snmp_exporter 
  ;;
  lvm_exporter )
  build_lvm_exporter 
  ;;
  slurm_exporter )
  build_slurm_exporter 
  ;;
  eseries_exporter )
  build_eseries_exporter 
  ;;
  gpfs_exporter )
  build_gpfs_exporter 
  ;;
  smartctl_exporter )
  build_smartctl_exporter 
  ;;
  389ds_exporter )
  build_389ds_exporter 
  ;;
  infiniband_exporter )
  build_infiniband_exporter
  ;;
  podman_exporter )
  build_podman_exporter
  ;;
  nvidia-dcgm_exporter )
  build_nvidia-dcgm_exporter
  ;;
  lustre_exporter )
  build_lustre_exporter
  ;;
  apache_exporter )
  build_apache_exporter
  ;;
  *)    # unknown option
  echo "Unknown option."
  exit 1
  ;;
esac
