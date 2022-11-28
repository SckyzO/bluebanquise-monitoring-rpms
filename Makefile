#RPM_DIST?=centos7
RPM_DIST?=rockylinux8
#RPM_DIST?=rockylinux9
SLURM_EXPORTER_VERSION = 0.20

.PHONY: *

all: prometheus \
	alertmanager \
	node_exporter \
	ping_exporter \
	ha_cluster_exporter \
	bind_exporter \
	process_exporter \
	ipmi_exporter \
	snmp_exporter \
	lvm_exporter \
	slurm_exporter \
	eseries_exporter \
	gpfs_exporter

prometheus:
	PKG=prometheus docker-compose run --rm $(RPM_DIST)

alertmanager:
	PKG=alertmanager docker-compose run --rm $(RPM_DIST)

node_exporter:
	PKG=node_exporter docker-compose run --rm $(RPM_DIST)

node_exporter_armv7:
	PKG=node_exporter_armv7 docker-compose run --rm $(RPM_DIST)

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
	rm -Rf slurm-docker-cluster
	git clone https://github.com/giovtorres/slurm-docker-cluster
	cd slurm-docker-cluster; \
	docker compose build; \
	docker compose up -d; \
	docker exec -t slurmctld bash -c "dnf install go -y; \
							cd /tmp; \
							git clone https://github.com/vpenso/prometheus-slurm-exporter.git; \
							cd prometheus-slurm-exporter; \
							git checkout development; \
							make;" 
	docker cp "slurmctld:/tmp/prometheus-slurm-exporter/bin/prometheus-slurm-exporter" "."
	mkdir -p "slurm_exporter-$(SLURM_EXPORTER_VERSION).linux-amd64"
	mv prometheus-slurm-exporter slurm_exporter-$(SLURM_EXPORTER_VERSION).linux-amd64/
	tar -czf slurm_exporter-$(SLURM_EXPORTER_VERSION).tar.gz slurm_exporter-$(SLURM_EXPORTER_VERSION).linux-amd64
	sudo mv ./slurm_exporter-$(SLURM_EXPORTER_VERSION).tar.gz archives/slurm_exporter-$(SLURM_EXPORTER_VERSION).tar.gz
	rm -Rf slurm_exporter-$(SLURM_EXPORTER_VERSION).linux-amd64
	cd slurm-docker-cluster; \
	docker compose down
	rm -Rf slurm-docker-cluster
	PKG=slurm_exporter docker-compose run --rm $(RPM_DIST)



eseries_exporter:
	PKG=eseries_exporter docker-compose run --rm $(RPM_DIST)

gpfs_exporter:
	PKG=gpfs_exporter docker-compose run --rm $(RPM_DIST)

clean:
	rm -f \
	build/rpms/* \
	build/sources/* \
	archives/*
