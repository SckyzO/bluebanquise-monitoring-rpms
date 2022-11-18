#!/bin/bash -eux

build_prometheus() {
  # Prometheus version
  VERSION="2.40.2"
  sudo wget https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.linux-amd64.tar.gz -O /workspace/prometheus/prometheus-${VERSION}.tar.gz -c

  sudo rpmbuild \
  	--clean \
  	--define "pkgversion ${VERSION}" \
  	--define "_topdir /tmp/rpm" \
  	--define "_sourcedir /workspace/prometheus" \
  	-bb /workspace/prometheus/prometheus.spec

  sudo cp /tmp/rpm/RPMS/*/*.rpm /workspace/build/
}

build_alertmanager() {
  # alertmanager version
  VERSION="0.24.0"
  sudo wget https://github.com/prometheus/alertmanager/releases/download/v${VERSION}/alertmanager-${VERSION}.linux-amd64.tar.gz -O /workspace/alertmanager/alertmanager-${VERSION}.tar.gz -c

  sudo rpmbuild \
  	--clean \
  	--define "pkgversion ${VERSION}" \
  	--define "_topdir /tmp/rpm" \
  	--define "_sourcedir /workspace/alertmanager" \
	-bb /workspace/alertmanager/alertmanager.spec

  sudo cp /tmp/rpm/RPMS/*/*.rpm /workspace/build/
}

build_node_exporter() {
  # node_exporter version
  VERSION="1.4.0"
  sudo wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz -O /workspace/exporters/node_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/exporters" \
    -bb /workspace/exporters/node_exporter.spec

  sudo cp /tmp/rpm/RPMS/*/*.rpm /workspace/build/
}

build_ping_exporter() {
  # ping_exporter version
  VERSION="0.4.6"
  sudo wget https://github.com/jaxxstorm/ping_exporter/releases/download/${VERSION}/ping_exporter-${VERSION}.Linux-x86_64.tar.gz -O /workspace/exporters/ping_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/exporters" \
    -bb /workspace/exporters/ping_exporter.spec

  sudo cp /tmp/rpm/RPMS/*/*.rpm /workspace/build/
}

build_ha_cluster_exporter() {
  # ha_cluster_exporter
  VERSION="1.3.0"
  sudo wget https://github.com/ClusterLabs/ha_cluster_exporter/releases/download/${VERSION}/ha_cluster_exporter-amd64.gz -O /workspace/exporters/ha_cluster_exporter-${VERSION}.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/exporters" \
    -bb /workspace/exporters/ha_cluster_exporter.spec

  sudo cp /tmp/rpm/RPMS/*/*.rpm /workspace/build/
}

build_bind_exporter() {
  # bind_exporter version
  VERSION="0.6.0"
  sudo wget https://github.com/prometheus-community/bind_exporter/releases/download/v${VERSION}/bind_exporter-${VERSION}.linux-amd64.tar.gz -O /workspace/exporters/bind_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/exporters" \
    -bb /workspace/exporters/bind_exporter.spec

  sudo cp /tmp/rpm/RPMS/*/*.rpm /workspace/build/
}

build_process_exporter() {
  # process_exporter version
  VERSION="0.7.10"
  sudo wget https://github.com/ncabatoff/process-exporter/releases/download/v${VERSION}/process-exporter-${VERSION}.linux-amd64.tar.gz -O /workspace/exporters/process_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/exporters" \
    -bb /workspace/exporters/process_exporter.spec

  sudo cp /tmp/rpm/RPMS/*/*.rpm /workspace/build/
}

build_ipmi_exporter() {
  # ipmi_exporter version
  VERSION="1.6.1"
  sudo wget https://github.com/prometheus-community/ipmi_exporter/releases/download/v${VERSION}/ipmi_exporter-${VERSION}.linux-amd64.tar.gz -O /workspace/exporters/ipmi_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/exporters" \
    -bb /workspace/exporters/ipmi_exporter.spec

  sudo cp /tmp/rpm/RPMS/*/*.rpm /workspace/build/
}

build_snmp_exporter() {
  # snmp_exporter version
  VERSION="0.20.0"
  sudo wget https://github.com/prometheus/snmp_exporter/releases/download/v${VERSION}/snmp_exporter-${VERSION}.linux-amd64.tar.gz -O /workspace/exporters/snmp_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/exporters" \
    -bb /workspace/exporters/snmp_exporter.spec

  sudo cp /tmp/rpm/RPMS/*/*.rpm /workspace/build/
}

build_lvm_exporter() {
  # snmp_exporter version
  VERSION="0.3.1"
  sudo wget https://github.com/hansmi/prometheus-lvm-exporter/releases/download/v${VERSION}/prometheus-lvm-exporter_${VERSION}_linux_amd64.tar.gz -O /workspace/exporters/lvm_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/exporters" \
    -bb /workspace/exporters/lvm_exporter.spec

  sudo cp /tmp/rpm/RPMS/*/*.rpm /workspace/build/
}

build_slurm_exporter() {
  VERSION="0.21"
  sudo dnf install sinfo squeue sdiag
  export GO_VERSION=1.19 OS=linux ARCH=amd64
  sudo wget https://dl.google.com/go/go$GO_VERSION.$OS-$ARCH.tar.gz
  tar -xzvf go$GO_VERSION.$OS-$ARCH.tar.gz
  export PATH=$PWD/go/bin:$PATH
  sudo git clone https://github.com/vpenso/prometheus-slurm-exporter.git
  cd prometheus-slurm-exporter
  sudo git checkout development
  sudo make
  tar -czf prometheus-slurm-exporter-${VERSION}.tar.gz prometheus-slurm-exporter
  sudo mv prometheus-slurm-exporter-${VERSION}.tar.gz /workspace/exporters/
  
  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/exporters" \
    -bb /workspace/exporters/slurm_exporter.spec

  sudo cp /tmp/rpm/RPMS/*/*.rpm /workspace/build/ 
}

build_eseries_exporter() {
  # eseries_exporter version
  VERSION="1.3.0"
  sudo wget https://github.com/treydock/eseries_exporter/releases/download/v${VERSION}/eseries_exporter-${VERSION}.linux-amd64.tar.gz -O /workspace/exporters/eseries_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/exporters" \
    -bb /workspace/exporters/eseries_exporter.spec

  sudo cp /tmp/rpm/RPMS/*/*.rpm /workspace/build/
}

build_gpfs_exporter() {
  # eseries_exporter version
  VERSION="2.2.0"
  sudo wget https://github.com/treydock/gpfs_exporter/releases/download/v${VERSION}/gpfs_exporter-${VERSION}.linux-amd64.tar.gz -O /workspace/exporters/gpfs_exporter-${VERSION}.tar.gz -c

  sudo rpmbuild \
    --clean \
    --define "pkgversion ${VERSION}" \
    --define "_topdir /tmp/rpm" \
    --define "_sourcedir /workspace/exporters" \
    -bb /workspace/exporters/gpfs_exporter.spec

  sudo cp /tmp/rpm/RPMS/*/*.rpm /workspace/build/
}
#sudo yum install wget epel-release -y
sudo mkdir -p /workspace/build/

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
  all )
  build_prometheus
  build_alertmanager
  build_node_exporter
  build_ping_exporter
  build_ha_cluster_exporter
  build_bind_exporter
  build_process_exporter
  build_ipmi_exporter
  build_snmp_exporter
  build_lvm_exporter
  build_slurm_exporter
  build_eseries_exporter  
  ;;
  *)    # unknown option
  echo "Unknown option."
  exit 1
  ;;
esac
