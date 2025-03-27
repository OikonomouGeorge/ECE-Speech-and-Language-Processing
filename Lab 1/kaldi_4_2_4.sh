. ./path.sh
. ./cmd.sh

export IRSTLM=$KALDI_ROOT/tools/irstlm/
export PATH=${PATH}:$IRSTLM/bin
./utils/prepare_lang.sh  /home/zeno/kaldi/egs/project1/data/local/dict "<oov>" /home/zeno/kaldi/egs/project1/data/local/lm_tmp /home/zeno/kaldi/egs/project1/data/lang
