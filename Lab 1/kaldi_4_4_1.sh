. ./path.sh
. ./cmd.sh

cd /home/zeno/kaldi/egs/wsj/s5
data_dir="/home/zeno/kaldi/egs/project1/data"

for x in train test dev; do
    /home/zeno/kaldi/egs/wsj/s5/steps/make_mfcc.sh --mfcc-config /home/zeno/kaldi/egs/project1/data/conf/mfcc.conf --nj $(nproc) --cmd run.pl $data_dir/$x $data_dir/$x/logs $data_dir/$x/mfcc || exit 1;
    /home/zeno/kaldi/egs/wsj/s5/steps/compute_cmvn_stats.sh $data_dir/$x $data_dir/$x/logs $data_dir/$x/mfcc || exit 1;
done
