#!/bin/bash

service ssh start

GSF_HOME=$(pwd)
export PYTHONPATH=${GSF_HOME}/python/
PART_CONFIG=/data/movielen_100k_train_val_1p_4t/movie-lens-100k.json

NUM_TRAINERS=1
NUM_SERVERS=1
NUM_SAMPLERS=0
echo "127.0.0.1" > /tmp/ip_list.txt
IP_CONFIG=/tmp/ip_list.txt

error_and_exit () {
	# check exec status of launch.py
	status=$1
	echo $status

	if test $status -ne 0
	then
		exit -1
	fi
}

python3 -m graphstorm.run.launch \
        --workspace /data \
        --num_trainers ${NUM_TRAINERS} \
        --num_servers ${NUM_SERVERS} \
        --num_samplers ${NUM_SAMPLERS} \
        --part_config ${PART_CONFIG} \
        --ip_config ${IP_CONFIG} \
        --ssh_port 2222 \
        ${GSF_HOME}/tests/end2end-tests/custom-gnn/train.py \
        --graph-name movie-lens-100k \
        --target-ntype movie \
        --node-feat feat \
        --num-classes 19 \
        --label genre

error_and_exit $?
