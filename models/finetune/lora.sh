#! /bin/bash

OUTPUT_DIR=adapter
DATA=../../dataset/en-samples-10.json


while [[ "$1" != "" ]]; do
    case $1 in
        -d | --data )
            shift
            DATA=$1
            ;;
        -o | --output )
            shift
            OUTPUT_DIR=$1
            ;;
        * )
            echo "Unknown argument ${1}"
            exit 1
            ;;
    esac
    shift
done


deepspeed --include localhost:0 finetune.py \
    --model_name_or_path openbmb/MiniCPM-2B-sft-bf16 \
    --output_dir "$OUTPUT_DIR" \
    --train_data_path "$DATA" \
    --learning_rate 1e-5 \
    --per_device_train_batch_size 1 \
    --per_device_eval_batch_size 1 \
    --model_max_length 3000 \
    --bf16 \
    --use_lora \
    --gradient_accumulation_steps 1 \
    --gradient_checkpointing true \
    --warmup_steps 100 \
    --num_train_epochs 1 \
    --weight_decay 0.01 \
    --eval_strategy no \
    --save_strategy epoch \
    --seed 42 \
    --log_level warning \
    --logging_strategy epoch \
    --deepspeed ds_config_zero3_offload.json

