#!/bin/bash

# Script to build the Slurm exporter
# Usage: ./build_slurm_exporter.sh SLURM_TAG SLURM_IMAGE_TAG SLURM_EXPORTER_VERSION

SLURM_TAG=$1
SLURM_IMAGE_TAG=$2
SLURM_EXPORTER_VERSION=$3
DOCKER_OS_RELEASE="$4"

# Remove existing slurm-docker-cluster if it exists
rm -Rf slurm-docker-cluster

# Clone the slurm-docker-cluster repository
git clone https://github.com/giovtorres/slurm-docker-cluster
cd slurm-docker-cluster

# Tear down any existing docker-compose setup
docker compose down

# Build the Docker image
sed -i 's/FROM $(DOCKER_OS_RELEASE)/FROM $(DOCKER_OS_RELEASE)/g' Dockerfile
SLURM_TAG="$SLURM_TAG" IMAGE_TAG="$SLURM_IMAGE_TAG" docker compose build --no-cache
IMAGE_TAG=$SLURM_IMAGE_TAG docker compose up -d

# Install go and build the slurm exporter
docker exec -t slurmctld bash -c "\
    dnf install go -y; \
    cd /tmp; \
    git clone https://github.com/vpenso/prometheus-slurm-exporter.git; \
    cd prometheus-slurm-exporter; \
    git checkout development; \
    make;"

# Copy the built exporter out of the Docker container
docker cp "slurmctld:/tmp/prometheus-slurm-exporter/bin/prometheus-slurm-exporter" "."

# Package the exporter
mkdir -p "slurm_exporter-$SLURM_EXPORTER_VERSION.linux-amd64"
mv prometheus-slurm-exporter slurm_exporter-$SLURM_EXPORTER_VERSION.linux-amd64/
tar -czf slurm_exporter-$SLURM_EXPORTER_VERSION.tar.gz slurm_exporter-$SLURM_EXPORTER_VERSION.linux-amd64
mv ./slurm_exporter-$SLURM_EXPORTER_VERSION.tar.gz archives/slurm_exporter-$SLURM_EXPORTER_VERSION.tar.gz

# Clean up
rm -Rf slurm_exporter-$SLURM_EXPORTER_VERSION.linux-amd64
cd slurm-docker-cluster
docker compose down
rm -Rf slurm-docker-cluster

