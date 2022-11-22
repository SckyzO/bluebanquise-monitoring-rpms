#!/bin/bash -eux

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
  	-ba /workspace/prometheus/spec/prometheus.spec

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
	-bb /workspace/alertmanager/spec/alertmanager.spec

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
    -bb /workspace/exporters/spec/node_exporter.spec

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
    -bb /workspace/exporters/spec/ping_exporter.spec

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
    -bb /workspace/exporters/spec/ha_cluster_exporter.spec

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
    -bb /workspace/exporters/spec/bind_exporter.spec

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
    -bb /workspace/exporters/spec/process_exporter.spec

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
    -bb /workspace/exporters/spec/ipmi_exporter.spec

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
    -bb /workspace/exporters/spec/snmp_exporter.spec

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
    -bb /workspace/exporters/spec/lvm_exporter.spec

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
    -bb /workspace/exporters/spec/slurm_exporter.spec

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
    -bb /workspace/exporters/spec/eseries_exporter.spec

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
    -bb /workspace/exporters/spec/gpfs_exporter.spec

  sudo install -g builder -o builder /tmp/rpm/RPMS/*/*.rpm /workspace/build/rpms/
  sudo install -g builder -o builder /tmp/rpm/SRPMS/*.src.rpm /workspace/build/sources/
}


if [[ $(cat /etc/os-release | grep REDHAT_SUPPORT_PRODUCT_VERSION | awk -F'=' '{print $2}' | sed 's/"//g') -le 7 ]]; then sudo yum install wget jq epel-release -y;fi
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
  *)    # unknown option
  echo "Unknown option."
  exit 1
  ;;
esac
