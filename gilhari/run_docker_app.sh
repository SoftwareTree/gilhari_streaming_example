#!/bin/bash
# Runs the Docker image gilhari_streaming_example:1.0, mapping host port 80 to the
# microservice's port 8081. Can be run from any directory.
docker run --platform linux/amd64 -p 80:8081 gilhari_streaming_example:1.0
