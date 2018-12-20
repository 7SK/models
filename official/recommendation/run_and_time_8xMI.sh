#!/bin/bash
set -e
set -o pipefail

sudo docker build . -f Dockerfile.rocm -t rocm
sudo docker run -v /proc:/host_proc --device=/dev/kfd/ --device=/dev/dri/ \
-t rocm:latest /root/run.sh 2>&1 | sudo tee output.txt
