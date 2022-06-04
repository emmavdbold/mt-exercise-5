#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

data=$base/data
shared_models=$base/shared_models

mkdir -p $shared_models

src=nl
trg=en

bpe_num_operations=4000  # change accordingly

mkdir -p $shared_models/$bpe_num_operations

# learn BPE model on training data from the source and target language

subword-nmt learn-joint-bpe-and-vocab -i $data/train/train.tokenized.$src $data/train/train.tokenized.$trg \
	--write-vocabulary $shared_models/$bpe_num_operations/vocab.$src $shared_models/$bpe_num_operations/vocab.$trg \
	-s $bpe_num_operations --total-symbols -o $shared_models/$bpe_num_operations/$src$trg.bpe
