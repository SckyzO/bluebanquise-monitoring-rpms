# Prometheus-rpm

Build Prometheus, Alert Manager and node/postgres_exporter rpm for RHEL/CentOS 7 & 8.

## Usage

Use this variable to choose wich distribution of RHEL/CentOS you want to build :
```
RPM_DIST=centos8 make all
# or
RPM_DIST=centos7 make all
```

Build Prometheus :
```
make prometheus
```

Build alertmanager :
```
make prometheus-alertmanager
```

Build postgres_exporter :
```
make postgres_exporter
```

Build node_exporter :
```
make node_exporter
```

Build all :
```
make all
```

## Version

To change Prometheus and exporters versions see `build.sh`.
