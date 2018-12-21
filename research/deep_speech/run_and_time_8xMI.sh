#!/bin/bash
set -e
set -o pipefail

MODEL_PATH=`pwd`/../..


sudo docker build . -f Dockerfile.rocm -t rocm
sudo docker run -v $MLP_HOST_DATA_DIR:/data \
-v $MODEL_PATH:/models -v /proc:/host_proc --device=/dev/kfd/ --device=/dev/dri/ \
-t rocm:latest /root/run_helper_8xMI.sh 2>&1 | sudo tee output.txt
