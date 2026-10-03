@echo off
REM Builds the Docker image gilhari_streaming_example:1.0 for this Gilhari microservice.
REM
REM Can be run from any directory (e.g., gilhari\build.cmd from the project
REM root). It switches to the project root first because the Docker build
REM context must be the project root (bin\ and config\ live there), even
REM though the Dockerfile itself is in gilhari\.
REM
REM --platform linux/amd64: the softwaretree/gilhari base image is published
REM for linux/amd64 only (it runs under emulation on Apple Silicon).
cd /d "%~dp0.."
docker build --platform linux/amd64 -f gilhari/Dockerfile -t gilhari_streaming_example:1.0 .
docker images
