#RPM_DIST?=centos7
RPM_DIST?=rockylinux8
#RPM_DIST?=rockylinux9
SLURM_EXPORTER_VERSION = 0.20
389DS_EXPORTER_VERSION = 0.1
SLURM_TAG = slurm-23-11-1-1
SLURM_IMAGE_TAG = 23.11.1
DIST_NAME := $(word 1,$(subst _, ,$(RPM_DIST)))
DIST_VERSION := $(word 2,$(subst _, ,$(RPM_DIST)))
DOCKER_OS_RELEASE := $(DIST_NAME):$(DIST_VERSION)
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
	gpfs_exporter \
	smartctl_exporter \
	389ds_exporter \
	infiniband_exporter \
	podman_exporter \
	apache_exporter \
	nvidia-dcgm_exporter \
	lustre_exporter \
	grok_exporter

prometheus:
	PKG=prometheus docker-compose run --rm $(RPM_DIST)

alertmanager:
	PKG=alertmanager docker-compose run --rm $(RPM_DIST)

node_exporter:
	PKG=node_exporter docker-compose run --rm $(RPM_DIST)

node_exporter_arm64:
	PKG=node_exporter_arm64 docker-compose run --rm $(RPM_DIST)

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
#	rm -Rf slurm-docker-cluster; 
#	git clone https://github.com/giovtorres/slurm-docker-cluster;  
	cd slurm-docker-cluster; \
	docker compose down; \
	sed -i 's/FROM $(DOCKER_OS_RELEASE)/FROM $(DOCKER_OS_RELEASE)/g' Dockerfile; \
	SLURM_TAG="$(SLURM_TAG)" IMAGE_TAG="$(SLURM_IMAGE_TAG)" docker compose build --no-cache; \
	IMAGE_TAG=$(SLURM_IMAGE_TAG) docker compose up -d; \
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
	mv ./slurm_exporter-$(SLURM_EXPORTER_VERSION).tar.gz archives/slurm_exporter-$(SLURM_EXPORTER_VERSION).tar.gz
	rm -Rf slurm_exporter-$(SLURM_EXPORTER_VERSION).linux-amd64
	cd slurm-docker-cluster; \
	docker compose down
	rm -Rf slurm-docker-cluster
	RPM_DIST=$(RPM_DIST) PKG=slurm_exporter docker-compose run --rm $(RPM_DIST)

eseries_exporter:
	PKG=eseries_exporter docker-compose run --rm $(RPM_DIST)

gpfs_exporter:
	PKG=gpfs_exporter docker-compose run --rm $(RPM_DIST)

smartctl_exporter:
	PKG=smartctl_exporter docker-compose run --rm $(RPM_DIST)

389ds_exporter:
	PKG=389ds_exporter docker-compose run --rm $(RPM_DIST)

infiniband_exporter:
	PKG=infiniband_exporter docker-compose run --rm $(RPM_DIST)

podman_exporter:
	PKG=podman_exporter docker-compose run --rm $(RPM_DIST)

apache_exporter:
	PKG=apache_exporter docker-compose run --rm $(RPM_DIST)

nvidia-dcgm_exporter:
	PKG=nvidia-dcgm_exporter docker-compose run --rm $(RPM_DIST)

lustre_exporter:
	PKG=lustre_exporter docker-compose run --rm $(RPM_DIST)

grok_exporter:
	PKG=grok_exporter docker-compose run --rm $(RPM_DIST)

clean:
	rm -Rf \
	build/rpms/* \
	build/sources/* \
	archives/*
