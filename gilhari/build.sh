#!/bin/bash
# Builds the Docker image gilhari_streaming_example:1.0 for this Gilhari microservice.
#
# Can be run from any directory (e.g., ./gilhari/build.sh from the project
# root). It switches to the project root first because the Docker build
# context must be the project root (bin/ and config/ live there), even
# though the Dockerfile itself is in gilhari/.
#
# --platform linux/amd64: the softwaretree/gilhari base image is published
# for linux/amd64 only (it runs under emulation on Apple Silicon).
cd "$(dirname "$0")/.."
docker build --platform linux/amd64 -f gilhari/Dockerfile -t gilhari_streaming_example:1.0 .
docker images
