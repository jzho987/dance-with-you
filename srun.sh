#!/bin/sh
currenttime=`date "+%Y%m%d%H%M%S"`
if [ ! -d log ]; then
    mkdir log
fi

echo "[Usage] ./srun.sh config_path [train|eval] partition gpunum"
# check config exists
if [ ! -e $1 ]
then
    echo "[ERROR] configuration file: $1 does not exists!"
    exit
fi


if [ ! -d ${expname} ]; then
    mkdir ${expname}
fi

echo "[INFO] saving results to, or loading files from: "$expname

if [ "$3" == "" ]; then
    echo "[ERROR] enter partition name"
    exit
fi
partition_name=$3
echo "[INFO] partition name: $partition_name"

if [ "$4" == "" ]; then
    echo "[ERROR] enter gpu num"
    exit
fi
gpunum=$4
gpunum=$(($gpunum<8?$gpunum:8))
echo "[INFO] GPU num: $gpunum"
((ntask=$gpunum*3))


TOOLS="srun --mpi=pmi2 --partition=$partition_name --gres=gpu:$gpunum -n1  --job-name=${config_suffix}"
PYTHONCMD="python -u main.py --config $1"

if [ $2 == "train_recode" ];
then
    $PYTHONCMD \
    --train_recode 
elif [ $2 == "train_fill" ];
then
    $PYTHONCMD \
    --train_fill 
elif [ $2 == "eval" ];
then
    $PYTHONCMD \
    --eval 
elif [ $2 == "anl" ];
then
    $PYTHONCMD \
    --anl 
elif [ $2 == "sample" ];
then
    $PYTHONCMD \
    --sample 
fi

