#!/bin/bash
set -e
set -o pipefail

export MODEL_PATH="`pwd`/../.."

sudo docker build . -f Dockerfile.rocm -t rocm
sudo docker run -v /proc:/host_proc -v $MODEL_PATH:/models --device=/dev/kfd/ --device=/dev/dri/ \
-t rocm:latest /root/run.sh 2>&1 | sudo tee output.txt
