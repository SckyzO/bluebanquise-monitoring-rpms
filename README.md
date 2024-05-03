# Prometheus Exporters Build System

This repository contains scripts for building various Prometheus exporters, compatible with BlueBanquise infrastructure management. The system is designed to build RPMs using Docker containers to ensure compatibility and reproducibility.

## Overview

- `Makefile`: Orchestrates the building of multiple exporters using Docker containers.
- `build.sh`: Provides the functionality to build individual exporters either through standard or custom build procedures.
- `exporter/`: Directory containing custom build scripts and RPM spec files for each exporter.

## Prerequisites

- Docker and Docker Compose
- `jq` for parsing JSON in shell scripts
- Go, if building Go-based exporters from source
- Access to the internet to pull base images and clone repositories

## Setup

1. **Clone the repository:**

    ```bash
    git clone <repository-url>
    cd <repository-folder>
    ```

2. **Ensure Docker and Docker Compose are installed:**

    Check Docker:

    ```bash
    docker --version
    ```

    Check Docker Compose:

    ```bash
    docker-compose --version
    ```

3. **Prepare your environment:**

    It's recommended to ensure your Docker environment is clean by removing unused images and containers if necessary.

## Usage

### Makefile

The `Makefile` contains several targets corresponding to different exporters and includes debugging and logging capabilities:

- **Build All Exporters:**

    ```bash
    make all
    ```

- **Clean Build Artifacts:**

    This target cleans up all build artifacts, ensuring a fresh start.

    ```bash
    make clean
    ```

- **Build Specific Exporter:**

    Replace `<exporter_name>` with the actual name of the exporter.

    ```bash
    make <exporter_name>
    ```

    For example, to build the Node Exporter:

    ```bash
    make node_exporter
    ```

- **Debugging Builds:**

    Run builds in debug mode for detailed logging.

    ```bash
    make debug <exporter_name>
    ```

### build.sh

This script handles the building of each exporter based on the latest release information fetched from GitHub and supports downloading, renaming, and building RPMs. It checks for custom build scripts in the exporter's directory. If a custom build script is present, it executes that; otherwise, it proceeds with a standard build process.

#### Adding a New Exporter

1. **Add a spec file in the directory:**

    `/workspace/exporter/<exporter_name>/<exporter_name>.spec`

2. **Add any custom build logic:**

    `/workspace/exporter/<exporter_name>/custom_build.sh`

3. **Register the exporter in the Makefile and `build.sh` if necessary.**

### Custom Builds

Some exporters require specific build steps, which are handled by custom scripts located in:

```plaintext
/workspace/exporter/<exporter_name>/custom_build.sh
```

## Available Commands

You can list all available exporters and their corresponding commands using:

```bash
make list
```

## Contributors

- Thomas Bourcey <thomas.bourcey@eviden.com>

## License

This project is licensed under the Apache License 2.0. For the full license text, see the LICENSE file in the repository or visit [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).
