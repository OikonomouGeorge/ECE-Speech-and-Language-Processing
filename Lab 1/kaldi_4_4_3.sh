. ./path.sh
. ./cmd.sh

cd /home/zeno/kaldi/egs/wsj/s5
data_dir="/home/zeno/kaldi/egs/project1/data"

# Usage: steps/decode.sh [options] <graph-dir> <data-dir> <decode-dir>
# Unigram Dev
/home/zeno/kaldi/egs/wsj/s5/steps/decode.sh $data_dir/kaldi_monophone/graph/u $data_dir/dev $data_dir/kaldi_monophone/graph/u/decode_dev || exit 1;
# Unigram Test
/home/zeno/kaldi/egs/wsj/s5/steps/decode.sh $data_dir/kaldi_monophone/graph/u $data_dir/test $data_dir/kaldi_monophone/graph/u/decode_test|| exit 1;

# Bigram Dev
/home/zeno/kaldi/egs/wsj/s5/steps/decode.sh $data_dir/kaldi_monophone/graph/b $data_dir/dev $data_dir/kaldi_monophone/graph/b/decode_dev || exit 1;
# Bigram Test
/home/zeno/kaldi/egs/wsj/s5/steps/decode.sh $data_dir/kaldi_monophone/graph/b $data_dir/test $data_dir/kaldi_monophone/graph/b/decode_test || exit 1;
