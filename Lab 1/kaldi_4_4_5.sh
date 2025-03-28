. ./path.sh
. ./cmd.sh

cd /home/zeno/kaldi/egs/wsj/s5
data_dir="/home/zeno/kaldi/egs/project1/data"

# Alignment Usage: steps/align_si.sh <data-dir> <lang-dir> <src-dir> <align-dir>
/home/zeno/kaldi/egs/wsj/s5/steps/align_si.sh --cmd "$train_cmd" \ 
  $data_dir/train $data_dir/lang $data_dir/kaldi_monophone $data_dir/kaldi_monophone || exit 1;

# Train Deltas Usage: steps/train_deltas.sh <num-leaves> <tot-gauss> <data-dir> <lang-dir> <alignment-dir> <exp-dir>
/home/zeno/kaldi/egs/wsj/s5/steps/train_deltas.sh --cmd "$train_cmd" 2500 15000 \
  $data_dir/train $data_dir/lang $data_dir/kaldi_monophone/mono_ali $data_dir/kaldi_triphone || exit 1;

# Unigram Graph Creation for Triphone Model
/home/zeno/kaldi/egs/wsj/s5/utils/mkgraph.sh $data_dir/lang_phones_ug \
  $data_dir/kaldi_triphone $data_dir/kaldi_triphone/graph/trigram/u || exit 1;

# Bigram Graph Creation for Triphone Model
/home/zeno/kaldi/egs/wsj/s5/utils/mkgraph.sh $data_dir/lang_phones_bg \
  $data_dir/kaldi_triphone $data_dir/kaldi_triphone/graph/trigram/b || exit 1;

# Decoding - Unigram (Dev and Test)
/home/zeno/kaldi/egs/wsj/s5/steps/decode.sh $data_dir/kaldi_triphone/graph/trigram/u \
  $data_dir/dev $data_dir/kaldi_triphone/graph/trigram/u/decode_dev || exit 1;

 /home/zeno/kaldi/egs/wsj/s5/steps/decode.sh $data_dir/kaldi_triphone/graph/trigram/u \
  $data_dir/test $data_dir/kaldi_triphone/graph/trigram/u/decode_test || exit 1;

# Decoding - Bigram (Dev and Test)
/home/zeno/kaldi/egs/wsj/s5/steps/decode.sh $data_dir/kaldi_triphone/graph/trigram/b \
  $data_dir/dev $data_dir/kaldi_triphone/graph/trigram/b/decode_dev || exit 1;

 /home/zeno/kaldi/egs/wsj/s5/steps/decode.sh $data_dir/kaldi_triphone/graph/trigram/b \
  $data_dir/test $data_dir/kaldi_triphone/graph/trigram/b/decode_test || exit 1;
