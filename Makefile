# Makefile for creating exporters compatible with BlueBanquise
# By Thomas Bourcey <thomas.bourcey@eviden.com>

# Variables
RPM_DIST ?= rockylinux8
DIST_NAME := $(word 1,$(subst _, ,$(RPM_DIST)))
DIST_VERSION := $(word 2,$(subst _, ,$(RPM_DIST)))
DOCKER_OS_RELEASE := $(DIST_NAME):$(DIST_VERSION)
DOCKER_COMPOSE_RUN := docker-compose run --rm $(RPM_DIST)
.PHONY: all clean help debug $(EXPORTERS)

# General debug log file
DEBUG_LOG = logs/build_debug.log

# Ensure the logs directory exists
$(shell mkdir -p logs)

# Function to determine logging behavior
define log_command
    if [ "$(DEBUG)" = "1" ]; then \
        echo "@@@@@@@@@@@@ $1 @@@@@@@@@@@@" >> $(DEBUG_LOG); \
        echo "Running $1 in $(DOCKER_OS_RELEASE) environment in DEBUG MODE" >> $(DEBUG_LOG); \
        DEBUG=$(DEBUG) DOCKER_OS_RELEASE=$(DOCKER_OS_RELEASE) PKG=$1 $(DOCKER_COMPOSE_RUN) | tee -a $(DEBUG_LOG); \
        RESULT=$$?; \
        if [ $$RESULT -eq 0 ]; then \
            echo "Build of $1 succeeded." | tee -a $(DEBUG_LOG); \
        else \
            echo "Build of $1 failed with exit code $$RESULT." | tee -a $(DEBUG_LOG); \
            exit $$RESULT; \
        fi; \
    else \
        DEBUG=$(DEBUG) DOCKER_OS_RELEASE=$(DOCKER_OS_RELEASE) PKG=$1 $(DOCKER_COMPOSE_RUN) >/dev/null 2>&1; \
        RESULT=$$?; \
        if [ $$RESULT -ne 0 ]; then \
            echo "Build of $1 failed with exit code $$RESULT." >&2; \
            exit $$RESULT; \
        fi; \
    fi
endef

# Dynamically find exporters with a .spec file in their directory
EXPORTERS := $(shell find exporter/* -type f -name '*.spec' -exec dirname {} \; | sed 's|exporter/||')

all: clean $(EXPORTERS)

$(EXPORTERS):
	@$(call log_command,$@)

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf build/rpms/* build/sources/* archives/* logs/*

debug:
	@$(MAKE) $(filter-out $@,$(MAKECMDGOALS)) DEBUG=1
%:
	@: # do nothing

help:
	@echo "Available commands:"
	@echo "  make all                   - Build all exporters and clean up previous builds"
	@echo "  make clean                 - Remove build artifacts and clean workspace"
	@echo "  make debug all             - Run all builds in debug mode for detailed logging"
	@echo "  make debug EXPORTER_NAME   - Run specified exporter build in debug mode for detailed logging"
	@echo "  make list                  - List all available exporters"
	@echo "  help                       - Display this help message"
	@echo ""
	@echo "Available exporters:"
	@$(foreach exp,$(EXPORTERS),echo "  - $(exp)";)

list:
	@echo "Available exporters are:"
	@$(foreach exp,$(EXPORTERS),echo "- $(exp)";)
