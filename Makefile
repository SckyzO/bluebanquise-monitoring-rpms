# Makefile for creating exporters compatible with BlueBanquise
# By Thomas Bourcey <thomas.bourcey@eviden.com>

# Variables
RPM_DIST?=rockylinux8
SLURM_EXPORTER_VERSION = 0.20
SLURM_TAG = slurm-23-11-1-1
SLURM_IMAGE_TAG = 23.11.1
DIST_NAME := $(word 1,$(subst _, ,$(RPM_DIST)))
DIST_VERSION := $(word 2,$(subst _, ,$(RPM_DIST)))
DOCKER_OS_RELEASE := $(DIST_NAME):$(DIST_VERSION)
DOCKER_COMPOSE_RUN := docker-compose run --rm $(RPM_DIST)
.PHONY: all clean help

# Error log file
ERROR_LOG = logs/build.log

# Targets for exporters, excluding slurm_exporter, in alphabetical order
EXPORTERS = \
	389ds_exporter \
	alertmanager \
	apache_exporter \
	bind_exporter \
	eseries_exporter \
	gpfs_exporter \
	grok_exporter \
	ha_cluster_exporter \
	infiniband_exporter \
	ipmi_exporter \
	lustre_exporter \
	lvm_exporter \
	nvidia-dcgm_exporter \
	node_exporter \
	ping_exporter \
	podman_exporter \
	process_exporter \
	prometheus \
	smartctl_exporter \
	snmp_exporter

# 'all' now depends on 'clean'
all: clean $(EXPORTERS) slurm_exporter

$(EXPORTERS):
	-PKG=$@ $(DOCKER_COMPOSE_RUN) >$(ERROR_LOG) || echo "Error building $@, see $(ERROR_LOG)"

# Special cases
slurm_exporter:
	-./exporter/slurm_exporter/build_slurm_exporter.sh $(SLURM_TAG) $(SLURM_IMAGE_TAG) $(SLURM_EXPORTER_VERSION) $(DOCKER_OS_RELEASE) 2>>$(ERROR_LOG) || echo "Error building slurm_exporter, see $(ERROR_LOG)"

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf build/rpms/* build/sources/* archives/*

# Help function
help:
	@echo "Available commands:"
	@echo "  make all          - Build all exporters and clean up previous builds"
	@echo "  make clean        - Remove build artifacts and clean workspace"
	@echo "  help              - Display this help message"
	@echo ""
	@echo "Available exporters:"
	@$(foreach exp, $(EXPORTERS) slurm_exporter, echo "  - $(exp)";)
