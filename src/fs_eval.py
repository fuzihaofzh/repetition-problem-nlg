import fire
from eval_metrics import get_score
import numpy as np
import json

def main(input_file, ori_ppl = 1.):
    data = open(input_file).readlines()
    hyps = [d.strip().split()[2:] for d in data if d.startswith('H')]
    ppl = np.mean([np.exp(-float(d.strip().split()[1])) for d in data if d.startswith('H') and len(d.split()) > 4])
    #print(([d for d in data if d.startswith('H')][4]))
    #ppl1 = [[-float(d.strip().split()[1]), d.strip().split()[2:]] for d in data if d.startswith('H')]
    #ppl = np.mean([np.exp(ps[0] * len(ps[1]) / (len(ps[1]) + ' '.join(ps[1]).count('='))) for ps in ppl1])
    scores = []
    for hyp in hyps:
        scores.append(get_score(hyp))

    names = ["rep-r", "rep-w", "seq-rep-n"]
    scores1 = {name : np.mean([s[name] for s in scores]) for name in names}


    scores1['ppl-c'] = ppl / ori_ppl


    print(json.dumps(scores1))
    #return scores1

    

if __name__ == '__main__':
    fire.Fire(main)