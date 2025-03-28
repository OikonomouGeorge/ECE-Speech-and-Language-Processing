. ./path.sh
. ./cmd.sh

cd /home/zeno/kaldi/egs/wsj/s5
data_dir="/home/zeno/kaldi/egs/project1/data"

# Alignment
steps/align_si.sh --cmd "$train_cmd" \
  $data_dir/train $lang_dir $exp_dir/mono || exit 1;
