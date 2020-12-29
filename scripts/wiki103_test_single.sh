DATASET=$1 
MODE=$2
EXP="$DATASET"

#export CUDA_VISIBLE_DEVICES=$(nvidia-smi -q -d Memory |grep -A4 GPU|grep Free| ppp "print(np.argmax([int(a.split()[2]) for a in arg.split('\n') if a]))")
echo "EXP:" $EXP "MODE: " $MODE "CUDA:" $CUDA_VISIBLE_DEVICES



if [[ $MODE == "topk40" ]]
then
    EPAR=" --sampling --temperature 0.92 --sampling-topk 40 "
elif [[ $MODE == "topk10" ]]
then
    EPAR=" --sampling --temperature 1.1 --sampling-topk 10 "
elif [[ $MODE == "topp0.9" ]]
then
    EPAR=" --sampling --temperature 0.86 --sampling-topp 0.9 "
elif [[ $MODE == "topp0.95" ]]
then
    EPAR=" --sampling --temperature 0.83 --sampling-topp 0.95 "
elif [[ $MODE == "temp" ]]
then
    EPAR=" --sampling --temperature 0.8 "
elif [[ $MODE == "sampling" ]]
then
    EPAR=" --sampling "
fi

OPPL=23.54 
if [[ "$DATASET" = *"_re0.1"* ]]; then
    EPAR=" --sampling --temperature 0.72 "
    OPPL=33.15 
fi
if [[ "$DATASET" = *"_re0.08"* ]]; then
    OPPL=36.24 
    EPAR=" --sampling --temperature 0.72 "
fi

mkdir -p output/eval/$EXP

export PYTHONPATH=PYTHONPATH:tools/fairseq



#DBG="-m ptvsd --host 0.0.0.0 --port 5678 --wait"
#fairseq-generate
EPOCH=80
#fairseq-eval-lm output/data-bin/$DATASET --task language_modeling --path output/models/$EXP/checkpoint$EPOCH.pt 
python $DBG tools/fairseq/fairseq_cli/interactive.py output/data-bin/$DATASET --task language_modeling --path output/models/$EXP/checkpoint$EPOCH.pt --beam 1 --input ../output/dev/test_1word --batch-size 500 --buffer-size 500 $EPAR > output/eval/$EXP/output.$EPOCH.$MODE.txt

#output/preprocessed/$DATASET/test_1word

python src/fs_eval.py --input_file output/eval/$EXP/output.$EPOCH.$MODE.txt --ori_ppl $OPPL > output/eval/$EXP/eval.$EPOCH.$MODE.txt

cat output/eval/$EXP/eval.$EPOCH.$MODE.txt
echo ""


#--batch-size 128 --buffer-size 128 

