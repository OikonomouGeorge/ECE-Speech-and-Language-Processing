#!/bin/bash

# Copyright 2013  (Author: Daniel Povey)
# Apache 2.0

# This script takes data prepared in a corpus-dependent way
# in data/local/, and converts it into the "canonical" form,
# in various subdirectories of data/, e.g. data/lang, data/train, etc.

. ./path.sh || exit 1;

echo "Preparing train, dev and test data"
lmdir=/home/zeno/kaldi/egs/project1/data/local/nist_lm
tmpdir=/home/zeno/kaldi/egs/project1/data/local/lm_tmp
lexicon=/home/zeno/kaldi/egs/project1/data/local/dict/lexicon.txt
mkdir -p $tmpdir

# Next, for each type of language model, create the corresponding FST
# and the corresponding lang_test_* directory.

echo "Preparing language models for test"

for lm_suffix in ug ug_dev ug_test bg bg_dev bg_test; do
  outlang=/home/zeno/kaldi/egs/project1/data//lang_phones_${lm_suffix}
  mkdir -p $outlang
  cp -r /home/zeno/kaldi/egs/project1/data//lang/* $outlang

  lm_file="$lmdir/lm_phone_${lm_suffix}.arpa.gz"

  if [[ -f "$lm_file" ]]; then
    gunzip -c "$lm_file" | \
      arpa2fst --disambig-symbol=#0 \
               --read-symbol-table=$outlang/words.txt - $outlang/G.fst
    fstisstochastic $outlang/G.fst
    # The output is like:
    # 9.14233e-05 -0.259833
    # we do expect the first of these 2 numbers to be close to zero (the second is
    # nonzero because the backoff weights make the states sum to >1).
    # Because of the <s> fiasco for these particular LMs, the first number is not
    # as close to zero as it could be.

    # Everything below is only for diagnostic.
    # Checking that G has no cycles with empty words on them (e.g. <s>, </s>);
    # this might cause determinization failure of CLG.
    # #0 is treated as an empty word.
    mkdir -p $tmpdir/g
    awk '{if(NF==1){ printf("0 0 %s %s\n", $1,$1); }} END{print "0 0 #0 #0"; print "0";}' \
      < "$lexicon"  >$tmpdir/g/select_empty.fst.txt
    fstcompile --isymbols=$outlang/words.txt --osymbols=$outlang/words.txt $tmpdir/g/select_empty.fst.txt | \
     fstarcsort --sort_type=olabel | fstcompose - $outlang/G.fst > $tmpdir/g/empty_words.fst
    fstinfo $tmpdir/g/empty_words.fst | grep cyclic | grep -w 'y' &&
      echo "Language model has cycles with empty words" && exit 1
    rm -r $tmpdir/g

    utils/validate_lang.pl $outlang || exit 1
  else
    echo "Warning: Language model file $lm_file not found. Skipping..."
  fi
done

echo "Succeeded in formatting data."
rm -r $tmpdir
