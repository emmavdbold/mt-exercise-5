# MT Exercise 5: Byte Pair Encoding, Beam Search

This repo is just a collection of scripts showing how to install [JoeyNMT](https://github.com/joeynmt/joeynmt), download
data and train & evaluate models.

# Requirements

- This only works on a Unix-like system, with bash.
- Python 3 must be installed on your system, i.e. the command `python3` must be available
- Make sure virtualenv is installed on your system. To install, e.g.

    `pip install virtualenv`

# Steps

Clone this repository in the desired place:

    git clone https://github.com/emmavdbold/mt-exercise-5

Create a new virtualenv that uses Python 3. Please make sure to run this command outside of any virtual Python environment:

    ./scripts/make_virtualenv.sh

**Important**: Then activate the env by executing the `source` command that is output by the shell script above.

Download and install required software:

    ./scripts/download_install_packages.sh

Download data:

    ./download_iwslt_2017_data.sh

The data is only minimally preprocessed, so you may want to tokenize it and apply any further preprocessing steps.

Train a model:

    ./scripts/train.sh

The training process can be interrupted at any time, and the best checkpoint will always be saved.

Evaluate a trained model with

    ./scripts/evaluate.sh

# Changes for solution

We've chosen to experiment with the translation direction Dutch -> English. In the `configs` directory, you can now find three additional config files for training:

* a word-level model, with a vocabulary of 2000 words per language
* a BPE-level model, with a joint vocabulary size of 2000
* a BPE-level model, with a joint vocabulary size of 4000

In addition to filling in the "?" fields from the sample config, the following changes were made: 

* BPE-level models: `testing: postprocess: False`, in order to see the BPE-output
* Word-level model: `model: tied_embeddings: False`, because the source and target vocabulary differ

A script has been added to choose the language pair, sample 100k training sentences and apply preprocessing up to tokenization:

    ./scripts/preprocess.sh

## BPE-Models

To split the text into subwords using BPE, a BPE-model must be trained and applied for each translation model on BPE-level.

Train a BPE-model:

    ./scripts/learn_bpe.sh

Apply a trained model:

    ./scripts/apply_bpe.sh

## Beam vs. BLEU

To evaluate a model with different beam sizes, run

    ./scripts/beam_size_vs_bleu.sh [max-beam-size (default: 30)]

To visualize the results, run

    python3 ./scripts/plot_beam_bleu.py

Note that you need to run it exactly like this, as filepaths are hard-coded into the script.
