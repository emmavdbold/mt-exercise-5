#! bin/bash

scripts=`dirname "$0"`
base=$scripts/..

data=$base/data
configs=$base/configs

beam_experiments=$base/beam_experiments
translations=$beam_experiments/translations
bleu_scores=$beam_experiments/bleu_scores

mkdir -p $beam_experiments
mkdir -p $translations
mkdir -p $bleu_scores

src=nl
trg=en

# cloned from https://github.com/bricksdont/moses-scripts
MOSES=$base/tools/moses-scripts/scripts

num_threads=4
device=0

SECONDS=0

model_name=transformer_nlen_bpe_4000
bpe_num_operations=4000

# optional user input: maximum beam size

max_beam=${1:-30}

for (( i=1; i<=${max_beam}; i++ )); do

    # create copy of config with modified beam size

    cat $configs/$model_name.yaml | sed "s/^\(\s*beam_size\s*:\s*\).*/\1$i/" > $configs/$model_name.$i.yaml

    echo "########################################"
    echo "Beam size $i"

    # BPE level model

    CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.$i.yaml < $data/test/test.bpe.$bpe_num_operations.$src > $translations/test.bpe.$i.$trg

    # undo BPE

    cat $translations/test.bpe.$i.$trg | sed 's/\@\@ //g' > $translations/test.tokenized.$i.$trg

    # undo tokenization

    cat $translations/test.tokenized.$i.$trg | $MOSES/tokenizer/detokenizer.perl -l $trg > $translations/test.$i.$trg

    # compute case-sensitive BLEU on detokenized data

    cat $translations/test.$i.$trg | sacrebleu $data/test/test.$trg > $bleu_scores/bleu.$i.json

    # clean up

    rm $configs/$model_name.$i.yaml
    rm $translations/test.bpe.$i.$trg
    rm $translations/test.tokenized.$i.$trg

done

echo "time taken:"
echo "$SECONDS seconds"
