#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=$GPU    # There are 3$GPU CPU cores on GPU nodes
#SBATCH --mem=50000               # Request the full memory of the node
#SBATCH --time=3:00
#SBATCH --partition=infofil01

GPU=3
CUDA_VISIBLE_DEVICES=$GPU ./scripts/iwslt14_test_single.sh iwslt14deen_fastbpe_10000 topk40
CUDA_VISIBLE_DEVICES=$GPU ./scripts/iwslt14_test_single.sh iwslt14deen_fastbpe_10000 topk10
CUDA_VISIBLE_DEVICES=$GPU ./scripts/iwslt14_test_single.sh iwslt14deen_fastbpe_10000 topp0.9
CUDA_VISIBLE_DEVICES=$GPU ./scripts/iwslt14_test_single.sh iwslt14deen_fastbpe_10000 topp0.95
CUDA_VISIBLE_DEVICES=$GPU ./scripts/iwslt14_test_single.sh iwslt14deen_fastbpe_10000 temp
CUDA_VISIBLE_DEVICES=$GPU ./scripts/iwslt14_test_single.sh iwslt14deen_fastbpe_10000 base 
CUDA_VISIBLE_DEVICES=$GPU ./scripts/iwslt14_test_single.sh iwslt14deen_fastbpe_10000 sampling 
CUDA_VISIBLE_DEVICES=$GPU ./scripts/iwslt14_test_single.sh iwslt14deen_fastbpe_10000_re0.1 base
CUDA_VISIBLE_DEVICES=$GPU ./scripts/iwslt14_test_single.sh iwslt14deen_fastbpe_10000_re0.15 base
CUDA_VISIBLE_DEVICES=$GPU ./scripts/iwslt14_test_single.sh iwslt14deen_fastbpe_10000_re0.05 base
CUDA_VISIBLE_DEVICES=$GPU ./scripts/iwslt14_test_single.sh iwslt14deen_fastbpe_10000_re0.02 base
