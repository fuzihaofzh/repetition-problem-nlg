RATIO=0.1

DATASET=iwslt14deen
VSIZE=10000
TOOL=fastbpe

#=========STEP 1. Fastbpe

EXP="$DATASET"_"$TOOL"_"$VSIZE"
mkdir -p output/preprocessed/$EXP
echo "EXP:" $EXP

for PART in en de
do
    tools/fastBPE/fast learnbpe $VSIZE output/preprocessed/$DATASET/train.$PART output/preprocessed/$DATASET/valid.$PART > output/preprocessed/$EXP/"$PART"_codes
    tools/fastBPE/fast applybpe output/preprocessed/$EXP/train.$PART output/preprocessed/$DATASET/train.$PART output/preprocessed/$EXP/"$PART"_codes
    tools/fastBPE/fast applybpe output/preprocessed/$EXP/test.$PART output/preprocessed/$DATASET/test.$PART output/preprocessed/$EXP/"$PART"_codes
    tools/fastBPE/fast applybpe output/preprocessed/$EXP/valid.$PART output/preprocessed/$DATASET/valid.$PART output/preprocessed/$EXP/"$PART"_codes
done
cp output/preprocessed/$DATASET/test.en output/preprocessed/$EXP/test.en.ref

#=========STEP 2. Rebalanced Encoding
DATASET1=$EXP

EXP="$DATASET1"_re$RATIO
mkdir -p output/preprocessed/$EXP
echo "EXP:" $EXP

for PART in en de
do
    python src/rebalanced_encoding.py rebalance_fastbpe --input_dir $DATASET1 --output_dir $EXP --connect_high_freq $RATIO --suffix ".$PART"
done

cp output/preprocessed/$DATASET/test.en output/preprocessed/$EXP/test.en.ref

#=========STEP 3. preprocessing
DATASET2=$EXP

rm output/data-bin/$DATASET2 -rf
fairseq-preprocess --source-lang de --target-lang en --trainpref output/preprocessed/$DATASET2/train --validpref output/preprocessed/$DATASET2/valid --testpref output/preprocessed/$DATASET2/test --destdir output/data-bin/$DATASET2 --thresholdtgt 0 --thresholdsrc 0 --workers 20


#=========STEP 4. preprocessing for baseline
DATASET3=iwslt14deen_fastbpe_"$VSIZE"

rm output/data-bin/$DATASET3 -rf
fairseq-preprocess --source-lang de --target-lang en --trainpref output/preprocessed/$DATASET3/train --validpref output/preprocessed/$DATASET3/valid --testpref output/preprocessed/$DATASET3/test --destdir output/data-bin/$DATASET3 --thresholdtgt 0 --thresholdsrc 0 --workers 20
