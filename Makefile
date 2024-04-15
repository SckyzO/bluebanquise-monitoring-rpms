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
.PHONY: all clean help debug list

# General debug log file
DEBUG_LOG = logs/build_debug.log

# Ensure the logs directory exists
$(shell mkdir -p logs)

# Function to determine logging behavior
define log_command
    if [ "$(DEBUG)" = "1" ]; then \
        PKG=$1 $(DOCKER_COMPOSE_RUN) 2>&1 | tee -a $(DEBUG_LOG); \
    else \
        PKG=$1 $(DOCKER_COMPOSE_RUN); \
    fi
endef

# Dynamically find exporters with a .spec file in their directory
EXPORTERS := $(shell find exporter/* -type f -name '*.spec' -exec dirname {} \; | sed 's|exporter/||')

# 'all' now depends on 'clean'
all: clean $(EXPORTERS) slurm_exporter

$(EXPORTERS):
	@echo "Building $@..."
	@$(call log_command,$@)

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf build/rpms/* build/sources/* archives/*

# Help function
help:
	@echo "Available commands:"
	@echo "  make all          - Build all exporters and clean up previous builds"
	@echo "  make clean        - Remove build artifacts and clean workspace"
	@echo "  make debug        - Run in debug mode for detailed logging"
	@echo "  make list         - List all available exporters"
	@echo "  help              - Display this help message"
	@echo ""
	@echo "Available exporters:"
	@$(foreach exp, $(EXPORTERS), echo "  - $(exp)";)

# List all available exporters
list:
	@echo "Available exporters are:"
	@$(foreach exp, $(EXPORTERS), echo "- $(exp)";)
