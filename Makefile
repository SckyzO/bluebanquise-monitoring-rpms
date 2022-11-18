#RPM_DIST?=centos7
RPM_DIST?=rockylinux8
#RPM_DIST?=rockylinux9

.PHONY: *

all:
	PKG=all docker-compose run --rm $(RPM_DIST)

prometheus:
	PKG=prometheus docker-compose run --rm $(RPM_DIST)

alertmanager:
	PKG=alertmanager docker-compose run --rm $(RPM_DIST)

node_exporter:
	PKG=node_exporter docker-compose run --rm $(RPM_DIST)

ping_exporter:
	PKG=ping_exporter docker-compose run --rm $(RPM_DIST)

ha_cluster_exporter:
	PKG=ha_cluster_exporter docker-compose run --rm $(RPM_DIST)

bind_exporter:
	PKG=bind_exporter docker-compose run --rm $(RPM_DIST)

process_exporter:
	PKG=process_exporter docker-compose run --rm $(RPM_DIST)

ipmi_exporter:
	PKG=ipmi_exporter docker-compose run --rm $(RPM_DIST)

snmp_exporter:
	PKG=snmp_exporter docker-compose run --rm $(RPM_DIST)

lvm_exporter:
	PKG=lvm_exporter docker-compose run --rm $(RPM_DIST)

slurm_exporter:
	PKG=slurm_exporter docker-compose run --rm $(RPM_DIST)

eseries_exporter:
	PKG=eseries_exporter docker-compose run --rm $(RPM_DIST)

gpfs_exporter:
	PKG=gpfs_exporter docker-compose run --rm $(RPM_DIST)

clean:
	rm -f build/* \
		prometheus/prometheus-*.tar.gz \
		alertmanager/alertmanager-*.tar.gz \
		exporters/node_exporter-*.tar.gz \
		exporters/ping_exporter-*.tar.gz \
		exporters/ha_cluster_exporter-*.tar.gz \
		exporters/bind_exporter-*.tar.gz \
		exporters/process_exporter-*.tar.gz \
		exporters/ipmi_exporter-*.tar.gz \
		exporters/snmp_exporter-*.tar.gz \
		exporters/lvm_exporter-*.tar.gz \
		exporters/slurm_exporter-*.tar.gz \
		exporters/eseries_exporter-*.tar.gz \
		exporters/gpfs_exporter-*.tar.gz 		
