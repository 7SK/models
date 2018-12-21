set -e

echo "export PYTHONPATH"
export PYTHONPATH="/models:$PYTHONPATH"
pip3 install -r /models/official/requirements.txt
pip3 install -r requirements.txt

echo "Clearing caches."
sync && echo 3 | tee /host_proc/sys/vm/drop_caches
STAT=$?
if [ $STAT -eq 0 ]; then
  echo "Cache clear successful."
  python -c "import mlperf_compliance;mlperf_compliance.mlperf_log.resnet_print(key='run_clear_caches')"
fi

# start timing
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)
echo "STARTING TIMING RUN AT $start_fmt"

# run benchmark

python3 -c 'import tensorflow; print(tensorflow.__version__)'
python3 -c 'import tensorflow; print(tensorflow.__git_version__)'

python3 deep_speech.py --train_data_dir=/data/librispeech_data/final_train_dataset.csv --eval_data_dir=/data/librispeech_data/final_eval_dataset.csv --num_gpus=-1 --wer_threshold=0.23 --seed=1

# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result
result=$(( $end - $start ))
result_name="speech_recognition"


echo "RESULT,$result_name,$seed,$result,$USER,$start_fmt"
