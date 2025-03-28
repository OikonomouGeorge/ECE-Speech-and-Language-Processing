. ./path.sh
. ./cmd.sh

cd /home/zeno/kaldi/egs/wsj/s5
data_dir="/home/zeno/kaldi/egs/project1/data"

/home/zeno/kaldi/egs/wsj/s5/steps/train_mono.sh --nj $(nproc) --cmd run.pl \
    $data_dir/train $data_dir/lang $data_dir/kaldi_monophone || exit 1;

/home/zeno/kaldi/egs/wsj/s5/steps/align_si.sh --nj $(nproc) --cmd run.pl \
    $data_dir/train $data_dir/lang $data_dir/kaldi_monophone $data_dir/kaldi_monophone
