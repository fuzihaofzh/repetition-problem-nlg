E2E NLG Challenge Evaluation metrics
====================================

The metrics used for the challenge include:
* BLEU + NIST from [MT-Eval](#mt-eval),
* METEOR, ROUGE-L, CIDEr from the [MS-COCO Caption evaluation scripts](#microsoft-coco-caption-evaluation).

Running the evaluation
----------------------

### Requirements/Installation ###

The metrics script requires the following dependencies:
- Java 1.8
- Python **3.6+** with [matplotlib](https://pypi.python.org/pypi/matplotlib) and [scikit-image](https://pypi.python.org/pypi/scikit-image) packages
- Perl 5.8.8 or higher with the [XML::Twig](http://search.cpan.org/~mirod/XML-Twig-3.49/Twig.pm) CPAN module


To install the required Python packages, run (assuming root access or [virtualenv](https://virtualenv.pypa.io/en/stable/)):
```
pip install -r requirements.txt
```

To install the required Perl module, run (assuming root access or [perlbrew](https://perlbrew.pl/)/[plenv](https://github.com/tokuhirom/plenv)):
```
curl -L https://cpanmin.us | perl - App::cpanminus  # install cpanm
cpanm XML::Twig
```


### Usage ###

The main entry point is [measure_scores.py](measure_scores.py). The script assumes one instance
per line for your system outputs and one entry per line, multiple references for the same instance
separated by empty lines for the references (see 
[TGen data conversion](https://github.com/UFAL-DSG/tgen/blob/master/e2e-challenge/README.md)).
Example human reference and system output files are provided in the [example-inputs](example-inputs/)
subdirectory.

```
./measure_scores.py example-inputs/devel-conc.txt example-inputs/baseline-output.txt
```

Source metrics scripts
----------------------

### MT-Eval ###

We used the NIST MT-Eval v13a script adapted for significance tests, from 
<http://www.cs.cmu.edu/~ark/MT/>.
We adapted the script to allow a variable number of references.


### Microsoft COCO Caption Evaluation ###

These provide a different variant of BLEU (which is not used for evaluation in the E2E challenge), 
METEOR, ROUGE-L, CIDER. We used the [Github code for these metrics](https://github.com/tylin/coco-caption).
The metrics are unchanged, apart from removing support for images and some of the dependencies.


References
----------

- [Microsoft COCO Captions: Data Collection and Evaluation Server](http://arxiv.org/abs/1504.00325)
- PTBTokenizer: We use the [Stanford Tokenizer](http://nlp.stanford.edu/software/tokenizer.shtml) which is included in [Stanford CoreNLP 3.4.1](http://nlp.stanford.edu/software/corenlp.shtml).
- BLEU: [BLEU: a Method for Automatic Evaluation of Machine Translation](http://www.aclweb.org/anthology/P02-1040.pdf)
- NIST: [Automatic Evaluation of Machine Translation Quality Using N-gram Co-Occurrence Statistics](http://www.mt-archive.info/HLT-2002-Doddington.pdf)
- Meteor: [Project page](http://www.cs.cmu.edu/~alavie/METEOR/) with related publications. We use the latest version (1.5) of the [Code](https://github.com/mjdenkowski/meteor). Changes have been made to the source code to properly aggreate the statistics for the entire corpus.
- Rouge-L: [ROUGE: A Package for Automatic Evaluation of Summaries](http://anthology.aclweb.org/W/W04/W04-1013.pdf)
- CIDEr: [CIDEr: Consensus-based Image Description Evaluation](http://arxiv.org/pdf/1411.5726.pdf)

Acknowledgements
----------------
Original developers of the MSCOCO evaluation scripts:

Xinlei Chen, Hao Fang, Tsung-Yi Lin, Ramakrishna Vedantam, David Chiang, Michael Denkowski, Alexander Rush
