#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2    # There are 32 CPU cores on GPU nodes
#SBATCH --mem=50000               # Request the full memory of the node
#SBATCH --time=3:00
#SBATCH --partition=infofil01

DATASET=$1 
EXP=$DATASET
echo "EXP:" $EXP


MAX_TOKENS=60000
python ./tools/fairseq/fairseq_cli/train.py --task language_modeling output/data-bin/$DATASET --save-dir "$PREFIX"output/models/$DATASET --arch transformer_lm --share-decoder-input-output-embed --dropout 0.1 --optimizer adam --adam-betas '(0.9, 0.98)' --weight-decay 0.01 --clip-norm 0.0 --lr 0.0005 --lr-scheduler inverse_sqrt --warmup-updates 4000 --warmup-init-lr 1e-07 --tokens-per-sample 512 --sample-break-mode none --max-tokens $MAX_TOKENS --update-freq 16 --fp16 --max-update 50000 --save-interval 5 --max-epoch 100 --tensorboard-logdir output/log/runs/$EXP --num-workers 20

