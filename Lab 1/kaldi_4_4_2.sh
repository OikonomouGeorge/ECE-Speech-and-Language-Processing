. ./path.sh
. ./cmd.sh

cd /home/zeno/kaldi/egs/wsj/s5
data_dir="/home/zeno/kaldi/egs/project1/data"

/home/zeno/kaldi/egs/wsj/s5/utils/mkgraph.sh --mono $data_dir/lang \
  $data_dir/kaldi_monophone $data_dir/kaldi_monophone/graph
