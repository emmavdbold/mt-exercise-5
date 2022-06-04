#!usr/bin/env python3

# Randomly samples a fixed number of lines from two parallel files (source and target)

import random
import argparse
from typing import Tuple


def get_parser() -> argparse.ArgumentParser:

    parser = argparse.ArgumentParser("Sample subset of parallel data.")
    parser.add_argument('-si', '--src-in', type=str, help="path to original source file", required=True)
    parser.add_argument('-ti', '--trg-in', type=str, help="path to original target file", required=True)
    parser.add_argument('-so', '--src-out', type=str, help="path to subsampled source file", required=True)
    parser.add_argument('-to', '--trg-out', type=str, help="path to subsampled target file", required=True)
    parser.add_argument('-s', '--subsample-size', type=int, help="size of subsample", default=100000)

    return parser


def reservoir_sampling(src, trg, k: int) -> Tuple[list, list]:
    """Use Reservoir sampling to extract a sample of k elements from the given source and target files.

    Adapted from slides session 13 of lecture PCL-2 at UZH, spring term 2020.
    :param src: Iterable containing source sentences
    :param trg: Iterable containing target language sentences
    :param k: Number of elements to extract
    :returns: (src samples, trg samples) -- random sample of both source and target sentences, aligned
    """
    reservoir_src = []
    reservoir_trg = []
    for t, (sent_src, sent_trg) in enumerate(zip(src, trg)):
        if t < k:
            reservoir_src.append(sent_src)
            reservoir_trg.append(sent_trg)
        else:
            m = random.randint(0, t)
            if m < k:
                reservoir_src[m] = sent_src
                reservoir_trg[m] = sent_trg

    return reservoir_src, reservoir_trg


def main():

    parser = get_parser()
    args = parser.parse_args()

    random.seed(10)

    with open(args.src_in, 'r', encoding='utf-8') as src_in, open(args.trg_in, 'r', encoding='utf-8') as trg_in, \
        open(args.src_out, 'w', encoding='utf-8') as src_out, open(args.trg_out, 'w', encoding='utf-8') as trg_out:

        src_subsample, trg_subsample = reservoir_sampling(src_in, trg_in, args.subsample_size)
        
        for src, trg in zip(src_subsample, trg_subsample):
            src_out.write(src)
            trg_out.write(trg)


if __name__ == '__main__':
    main()

