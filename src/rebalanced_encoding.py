from joblib import Parallel, delayed
import joblib
#import spacy
import re
import torch
import math   
import json
import numpy as np
import logging
logging.basicConfig(level=logging.INFO)
import os
import fire
import multiprocessing
import scipy.sparse as sparse
from multiprocessing import Pool


CORE_NUM = max(os.cpu_count() - 1, 1)

def _make_stats(sents, id2w, w2id):
    #try:
    #stats = np.zeros([len(id2w), len(id2w)])
    stats = sparse.lil_matrix((len(id2w), len(id2w)))
    for q, sent in enumerate(sents):
        words = sent.split()
        for i in range(len(words) - 1):
            stats[w2id[words[i]], w2id[words[i+1]]] += 1
    return stats
    #except Exception as e:
    #    print(e)

def _add(lst):
    if len(lst) == 2:
        return lst[0] + lst[1]
    elif len(lst) == 1:
        return lst[0]
    else:
        print("Error!")

def multiple_replace(string, rep_dict):
    rep_dict = {' ' + k : ' ' + rep_dict[k] for k in rep_dict}
    pattern = re.compile("|".join([re.escape(k) + "(?=\ )"  for k in sorted(rep_dict,key=len,reverse=True)]), flags=re.DOTALL)
    return pattern.sub(lambda x: rep_dict[x.group(0)], string)


def msum(lst):
    with Pool(CORE_NUM) as pool:
        while len(lst) > 1:
            lst = pool.map(_add, [lst[i : i + 2] for i in range(0, len(lst), 2)])
    return lst[0]

def get_high_inflow(data, maxp = 0.5, N = 10, col_num = 5):
    id2w = list(set(data.split()))
    w2id = {w: i for i, w in enumerate(id2w)}
    bsz = 3000000
    hfs = {}
    data0 = data
    words = words0 = data.split()
    bsz = len(words) // (CORE_NUM - 1)
    blocks = blocks0 = [' '.join(words[i * bsz : (i+1) * bsz]) for i in range(math.ceil(len(words) / bsz))]
    for nn in range(N):
        print("Block num:", len(blocks))
        #results = Parallel(n_jobs=-1)(delayed(_make_stats)([blk], id2w, w2id) for blk in blocks)
        with Pool(CORE_NUM) as p:
            results = p.starmap(_make_stats, [[[blk], id2w, w2id] for blk in blocks])
        print("Sum blocks...")
        stats = msum(results)

        #stats = stats.tocsr()
        #row_sums = np.array(stats.sum(axis=1))[:,0] + 1
        #row_indices, col_indices = stats.nonzero()
        #stats.data /= row_sums[row_indices]
        #A = stats

        stats = torch.tensor(stats.todense())
        stats += 1
        A = stats / stats.sum(1).clamp_min(1e-10).unsqueeze(1)
        #A[w2id['<eos>'], :] = 0
        #A[:, w2id['<eos>']] = 0

        #msk = torch.zeros(A.shape[0])
        #msk[A.sum(0).sort().indices[-col_num:]] = 1
        #A = A * msk


        if A.max() <= maxp:
            print("%d element max:%f; sum max: %f; vocab size: %d"%(nn, A.max(), A.sum(0).max(), A.shape[0]))
            break
        #highers = np.stack((A > maxp).nonzero()).T.tolist()
        highers = (A > maxp).nonzero().tolist()
        # connect each high prob pair. 
        print("highers:", [(id2w[i1], id2w[i2]) for i1, i2 in highers])
        for i1, i2 in highers:
            w1, w2 = id2w[i1], id2w[i2]
            hfs[(w1 + ' ' + w2).replace('=', ' ')] = w1 + '=' + w2

        print(hfs, len(hfs))
        print("%d element max:%f; sum max: %f; vocab size: %d"%(nn, A.max(), A.sum(0).max(), A.shape[0]))
        #data = multiple_replace(data0, hfs)
        #results = Parallel(n_jobs=-1,max_nbytes='10G')(delayed(multiple_replace)(blk, hfs) for blk in blocks0)
        with Pool(CORE_NUM) as pool:
            results = pool.starmap(multiple_replace, [[blk, hfs] for blk in blocks0])
        data = ' '.join(results)
        words = data.split()
        blocks = [' '.join(words[i * bsz : (i+1) * bsz]) for i in range(math.ceil(len(words) / bsz))]
        id2w = list(set(data.split()))
        w2id = {w: i for i, w in enumerate(id2w)}
    hfs = {h: hfs[h].replace("@@=", "") for h in hfs}
    return hfs

def rebalance_fastbpe(input_dir = "wiki103_fastbpe_10000", output_dir = "wiki103_chfe0.1", connect_high_freq = None, suffix = ""):
    output_path = "output/preprocessed/%s/"%output_dir
    from nltk.tokenize import sent_tokenize
    os.system("mkdir -p %s"%output_path)
    print("output:", output_path)
    if connect_high_freq is not None:
        data = open("output/preprocessed/%s/train%s"%(input_dir, suffix)).read()
        hfs = get_high_inflow(data, maxp = connect_high_freq)
        torch.save(hfs, output_path + 'hfs.pt' + suffix)
    for part in ['valid', 'test', 'train']:
        print("processing %s ..."%part)
        data = open("output/preprocessed/%s/%s%s"%(input_dir, part, suffix)).read()
        data = data.encode('ascii',errors='ignore').decode()
        if connect_high_freq is not None:
            words = data.split(' ')
            bsz = len(words) // (CORE_NUM - 1)
            blocks = [' '.join(words[i * bsz : (i+1) * bsz]) for i in range(math.ceil(len(words) / bsz))]
            #results = Parallel(n_jobs=-1)(delayed(multiple_replace)(blk, hfs) for blk in blocks)
            with Pool(CORE_NUM) as pool:
                results = pool.starmap(multiple_replace, [[blk, hfs] for blk in blocks])
            data = ' '.join(results)
        open(output_path + part + suffix, "w", encoding = "utf-8").write(data)
    print("output:", output_path)

if __name__ == "__main__":
    fire.Fire({
        "rebalance_fastbpe" : rebalance_fastbpe,
    })