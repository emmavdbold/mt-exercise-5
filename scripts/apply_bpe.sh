#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

data=$base/data
tools=$base/tools
shared_models=$base/shared_models

src=nl
trg=en

bpe_vocab_threshold=10
bpe_num_operations=4000  # change accordingly

# apply BPE model to train, dev and test data for both source and target side

for corpus in train dev test; do
    subword-nmt apply-bpe -c $shared_models/$bpe_num_operations/$src$trg.bpe --vocabulary $shared_models/$bpe_num_operations/vocab.$src --vocabulary-threshold $bpe_vocab_threshold < $data/$corpus/$corpus.tokenized.$src > $data/$corpus/$corpus.bpe.$bpe_num_operations.$src
    subword-nmt apply-bpe -c $shared_models/$bpe_num_operations/$src$trg.bpe --vocabulary $shared_models/$bpe_num_operations/vocab.$trg --vocabulary-threshold $bpe_vocab_threshold < $data/$corpus/$corpus.tokenized.$trg > $data/$corpus/$corpus.bpe.$bpe_num_operations.$trg
done

# build joeynmt vocab

python3 $tools/joeynmt/scripts/build_vocab.py $data/train/train.bpe.$bpe_num_operations.$src $data/train/train.bpe.$bpe_num_operations.$trg --output_path $base/shared_models/$bpe_num_operations/vocab.txt

