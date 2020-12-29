#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2 # There are 32 CPU cores on GPU nodes
#SBATCH --mem=50000 # Request the full memory of the node
#SBATCH --time=3:00
#SBATCH --partition=infofil01

DATASET=$1 
EXP=$DATASET #"_"$2
export CUDA_VISIBLE_DEVICES=0
echo "EXP:" $EXP "CUDA:" $CUDA_VISIBLE_DEVICES



MAX_TOKENS=50000

python ./tools/fairseq/fairseq_cli/train.py output/data-bin/$DATASET --arch transformer_iwslt_de_en --share-decoder-input-output-embed --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 1.0 --lr 5e-4 --lr-scheduler inverse_sqrt --warmup-updates 4000 --dropout 0.3 --weight-decay 0.0001 --criterion label_smoothed_cross_entropy --label-smoothing 0.1 --eval-bleu --eval-bleu-args '{"beam": 5, "max_len_a": 1.2, "max_len_b": 10}' --eval-bleu-detok moses --eval-bleu-remove-bpe --eval-bleu-print-samples --best-checkpoint-metric bleu --maximize-best-checkpoint-metric --fp16 --max-tokens $MAX_TOKENS --validate-interval 5 --save-interval 5 --num-workers 20 --max-epoch 100 --save-dir "$PREFIX"output/models/$EXP  --tensorboard-logdir output/log/runs/$EXP #--seed $2


#--no-save
