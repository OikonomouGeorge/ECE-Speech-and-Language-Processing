. ./path.sh
. ./cmd.sh

cd /home/zeno/kaldi/egs/wsj/s5
data_dir="/home/zeno/kaldi/egs/project1/data"

/home/zeno/kaldi/egs/wsj/s5/steps/train_mono.sh --nj $(nproc) --cmd run.pl \
    $data_dir/train $data_dir/lang $data_dir/kaldi_4_4 || exit 1;



#steps/train_mono.sh --boost-silence 1.25 --nj 4 --cmd "$train_cmd" \
#  data/train data/lang_test exp/mono0a || exit 1;
#steps/align_si.sh --boost-silence 1.25 --nj 4 --cmd "$train_cmd" \
#  data/train data/lang_test exp/mono0a exp/mono0a_ali
