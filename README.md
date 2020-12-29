# A Theoretical Analysis of the Repetition Problem in Text Generation
This repository share the code for the paper "A Theoretical Analysis of the Repetition Problem in Text Generation" in AAAI 2021. The repetition problem has been observed in nearly all text generation models. We theoretically prove that this problem is, unfortunately, caused by the traits of our language itself. There exists too many words predicting the same word as the subsequent word with high probability. Consequently, it is easy to go back to that word and form repetitions and we dub it as the high inflow problem. Based on the theoretical analysis, we propose a novel rebalanced encoding approach to alleviate the high inflow problem.

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
./scripts/iwslt14_preprocess.sh
```
### Train
```bash
./scripts/iwslt14_train.sh iwslt14deen_fastbpe_10000
./scripts/iwslt14_train.sh iwslt14deen_fastbpe_10000_re0.1
```

### Test
```bash
./scripts/iwslt14_test.sh
```
Results can be found in `output/eval/*`


## wiki103
### Download the preprocessed data
```bash
git clone https://github.com/fuzihaofzh/preprocessed_wiki103.git output/preprocessed/wiki103
```
This may take few minutes to complete.

### Preprocess Data
```bash
./scripts/wiki103_preprocess.sh
```
### Train
```bash
./scripts/wiki103_train.sh wiki103_fastbpe_10000
./scripts/wiki103_train.sh wiki103_fastbpe_10000_re0.1
```

### Test
```bash
./scripts/wiki103_test.sh
```
Results can be found in `output/eval/*`



## Cite 
```latex
@inproceedings{fu2020a,
  title={A Theoretical Analysis of the Repetition Problem in Text Generation.},
  author={Fu, Zihao and Lam, Wai and So, Anthony Man-Cho and Shi, Bei },
  booktitle={Thirty-Fifth AAAI Conference on Artificial Intelligence},
  year={2021}
}
```
