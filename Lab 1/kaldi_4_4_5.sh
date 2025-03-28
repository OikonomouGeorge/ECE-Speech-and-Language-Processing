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
