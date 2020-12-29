DATASET=wiki103
VSIZE=10000
TOOL=fastbpe
RATIO=0.08

#=========STEP 1. Fastbpe

EXP="$DATASET"_"$TOOL"_"$VSIZE"
mkdir -p output/preprocessed/$EXP
echo "EXP:" $EXP
tools/fastBPE/fast learnbpe $VSIZE output/preprocessed/$DATASET/train output/preprocessed/$DATASET/valid > output/preprocessed/$EXP/"$DATASET"_codes
tools/fastBPE/fast applybpe output/preprocessed/$EXP/train output/preprocessed/$DATASET/train output/preprocessed/$EXP/"$DATASET"_codes
tools/fastBPE/fast applybpe output/preprocessed/$EXP/test output/preprocessed/$DATASET/test output/preprocessed/$EXP/"$DATASET"_codes
tools/fastBPE/fast applybpe output/preprocessed/$EXP/valid output/preprocessed/$DATASET/valid output/preprocessed/$EXP/"$DATASET"_codes

#=========STEP 2. Rebalanced Encoding


python src/rebalanced_encoding.py rebalance_fastbpe  --input_dir wiki103_fastbpe_"$VSIZE" --connect_high_freq $RATIO --output_dir wiki103_fastbpe_"$VSIZE"_re$RATIO

cp output/preprocessed/wiki103/test_1word output/preprocessed/wiki103_fastbpe_"$VSIZE"/
cp output/preprocessed/wiki103/test_1word output/preprocessed/wiki103_fastbpe_"$VSIZE"_re$RATIO/


#=========STEP 3. preprocessing
DATASET1=wiki103_fastbpe_"$VSIZE"_re$RATIO

rm output/data-bin/$DATASET1 -rf
fairseq-preprocess --only-source --trainpref output/preprocessed/$DATASET1/train --validpref output/preprocessed/$DATASET1/valid --testpref output/preprocessed/$DATASET1/test --destdir output/data-bin/$DATASET1 --workers 30 


#=========STEP 4. preprocessing for baseline
DATASET2=wiki103_fastbpe_"$VSIZE"

rm output/data-bin/$DATASET2 -rf
fairseq-preprocess --only-source --trainpref output/preprocessed/$DATASET2/train --validpref output/preprocessed/$DATASET2/valid --testpref output/preprocessed/$DATASET2/test --destdir output/data-bin/$DATASET2 --workers 30 