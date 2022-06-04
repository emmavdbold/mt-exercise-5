#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

data=$base/data
tools=$base/tools

mkdir -p $data/train
mkdir -p $data/dev
mkdir -p $data/test

src=nl
trg=en

# cloned from https://github.com/bricksdont/moses-scripts
MOSES=$tools/moses-scripts/scripts

# sample 100k sentences from source and target file

python3 $scripts/sample.py -si $data/train.nl-en.$src -ti $data/train.nl-en.$trg \
    -so $data/train/train.$src -to $data/train/train.$trg

# copy dev and test

for corpus in dev test; do
    cp $data/$corpus.nl-en.$src $data/$corpus/$corpus.$src
    cp $data/$corpus.nl-en.$trg $data/$corpus/$corpus.$trg
done

# tokenize

for corpus in train dev test; do
    cat $data/$corpus/$corpus.$src | $MOSES/tokenizer/tokenizer.perl -l $src > $data/$corpus/$corpus.tokenized.$src
    cat $data/$corpus/$corpus.$trg | $MOSES/tokenizer/tokenizer.perl -l $trg > $data/$corpus/$corpus.tokenized.$trg
done
