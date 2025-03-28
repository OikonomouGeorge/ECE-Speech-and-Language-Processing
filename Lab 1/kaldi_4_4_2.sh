. ./path.sh
. ./cmd.sh

cd /home/zeno/kaldi/egs/wsj/s5
data_dir="/home/zeno/kaldi/egs/project1/data"

# Unigram
/home/zeno/kaldi/egs/wsj/s5/utils/mkgraph.sh --mono $data_dir/lang_phones_ug \
  $data_dir/kaldi_monophone $data_dir/kaldi_monophone/graph/u

# Bigram
/home/zeno/kaldi/egs/wsj/s5/utils/mkgraph.sh --mono $data_dir/lang_phones_bg \
  $data_dir/kaldi_monophone $data_dir/kaldi_monophone/graph/b
