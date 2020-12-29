# A Theoretical Analysis of the Repetition Problem in Text Generation
This repository share the code for the paper "A Theoretical Analysis of the Repetition Problem in Text Generation" in AAAI 2021. 

## Requirements
- GCC >= 4.8
- Python >= 3.7

## Install 
```bash
git clone https://github.com/fuzihaofzh/repetition-problem-nlg.git
cd repetition-problem-nlg
./scripts/setup.sh
```

## iwslt14
### Preprocess Data
```bash
iwslt14_preprocess.sh
```
### Train
```bash
./scripts/iwslt14_train.sh iwslt14deen_fastbpe_10000
./scripts/iwslt14_train.sh iwslt14deen_fastbpe_10000_re0.1
```

### Test

