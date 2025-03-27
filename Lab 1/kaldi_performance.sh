. ./path.sh 

cd "/home/zeno/kaldi/egs/project1/data/local/lm_tmp"
export IRSTLM=$KALDI_ROOT/tools/irstlm/
export PATH=${PATH}:$IRSTLM/bin

compile-lm lm_test1.ilm.gz --eval=../dict/lm_dev.text 
compile-lm lm_test2.ilm.gz --eval=../dict/lm_dev.text 

compile-lm lm_dev1.ilm.gz --eval=../dict/lm_test.text
compile-lm lm_dev2.ilm.gz --eval=../dict/lm_test.text

cd "../../../"
