DATASET=$1 
MODE=$2
EXP="$DATASET"
EPOCH="100"

#export CUDA_VISIBLE_DEVICES=$(nvidia-smi -q -d Memory |grep -A4 GPU|grep Free| ppp "print(np.argmax([int(a.split()[2]) for a in arg.split('\n') if a]))")
echo "EXP:" $EXP "CUDA:" $CUDA_VISIBLE_DEVICES



if [[ $MODE == "topk10" ]]
then
    EPAR=" --sampling --temperature 0.15 --sampling-topk 10 "
elif [[ $MODE == "topk40" ]]
then
    EPAR=" --sampling --temperature 0.2 --sampling-topk 40 "
elif [[ $MODE == "topp0.9" ]]
then
    EPAR=" --sampling --temperature 0.2 --sampling-topp 0.9 "
elif [[ $MODE == "topp0.95" ]]
then
    EPAR=" --sampling --temperature 0.15 --sampling-topp 0.95 "
elif [[ $MODE == "temp" ]]
then
    EPAR=" --sampling --temperature 0.15 "
elif [[ $MODE == "sampling" ]]
then
    EPAR=" --sampling "
fi

echo $MODE ":" $EPAR



mkdir -p output/eval/$EXP

export PYTHONPATH=PYTHONPATH:tools/fairseq
#func_name () {

###fairseq-eval-lm output/data-bin/$DATASET --task translation --path output/models/$EXP/checkpoint$EPOCH.pt 
python $DBG tools/fairseq/fairseq_cli/generate.py output/data-bin/$DATASET --path output/models/$EXP/checkpoint$EPOCH.pt --beam 1 --batch-size 500  $EPAR > output/eval/$EXP/log.$EPOCH.$MODE.txt

cat output/eval/$EXP/log.$EPOCH.$MODE.txt| ./scripts/ppp "print('\n'.join([y[1] for y in sorted(map(lambda x: (int(x.split('\t')[0][2:]), x.split('\t')[-1]), arg.split('\n')[9:-3:5]))]).replace('=', ' ').replace('@@ ', ''))" > output/eval/$EXP/output.$EPOCH.$MODE.txt


rm output/eval/$EXP/e2e_eval.$EPOCH.$MODE.txt
./tools/e2e-metrics/measure_scores.py -p output/preprocessed/$DATASET/test.en.ref output/eval/$EXP/output.$EPOCH.$MODE.txt 2>&1 | tee -a  output/eval/$EXP/e2e_eval.$EPOCH.$MODE.txt
#}

python src/fs_eval.py --input_file output/eval/$EXP/log.$EPOCH.$MODE.txt > output/eval/$EXP/eval.$EPOCH.$MODE.txt

cat output/eval/$EXP/eval.$EPOCH.$MODE.txt


#--batch-size 128 --buffer-size 128 

