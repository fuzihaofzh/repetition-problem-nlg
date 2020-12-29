#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=$GPU    # There are 3$GPU CPU cores on GPU nodes
#SBATCH --mem=50000               # Request the full memory of the node
#SBATCH --time=3:00
#SBATCH --partition=infofil01
GPU=1
VSIZE=10000
CUDA_VISIBLE_DEVICES=$GPU ./scripts/wiki103_test_single.sh wiki103_fastbpe_"$VSIZE" base
CUDA_VISIBLE_DEVICES=$GPU ./scripts/wiki103_test_single.sh wiki103_fastbpe_"$VSIZE" sampling
CUDA_VISIBLE_DEVICES=$GPU ./scripts/wiki103_test_single.sh wiki103_fastbpe_"$VSIZE" temp 
CUDA_VISIBLE_DEVICES=$GPU ./scripts/wiki103_test_single.sh wiki103_fastbpe_"$VSIZE" topk10 
CUDA_VISIBLE_DEVICES=$GPU ./scripts/wiki103_test_single.sh wiki103_fastbpe_"$VSIZE" topk40 
CUDA_VISIBLE_DEVICES=$GPU ./scripts/wiki103_test_single.sh wiki103_fastbpe_"$VSIZE" topp0.9 
CUDA_VISIBLE_DEVICES=$GPU ./scripts/wiki103_test_single.sh wiki103_fastbpe_"$VSIZE" topp0.95 

CUDA_VISIBLE_DEVICES=$GPU ./scripts/wiki103_test_single.sh wiki103_fastbpe_"$VSIZE"_re0.1 temp 
#CUDA_VISIBLE_DEVICES=$GPU ./scripts/wiki103_test_single.sh wiki103_fastbpe_"$VSIZE"_re0.08 temp







