. ./path.sh 

export IRSTLM=$KALDI_ROOT/tools/irstlm/
export PATH=${PATH}:$IRSTLM/bin

cd "/home/zeno/kaldi/egs/project1/data/local/lm_tmp"

compile-lm lm_train1.ilm.gz -t=yes /dev/stdout | grep -v unk | gzip -c > lm_phone_ug.arpa.gz
compile-lm lm_train2.ilm.gz -t=yes /dev/stdout | grep -v unk | gzip -c > lm_phone_bg.arpa.gz

compile-lm lm_test1.ilm.gz -t=yes /dev/stdout | grep -v unk | gzip -c > lm_phone_ug_test.arpa.gz
compile-lm lm_test2.ilm.gz -t=yes /dev/stdout | grep -v unk | gzip -c > lm_phone_bg_test.arpa.gz

compile-lm lm_dev1.ilm.gz -t=yes /dev/stdout | grep -v unk | gzip -c > lm_phone_ug_dev.arpa.gz
compile-lm lm_dev2.ilm.gz -t=yes /dev/stdout | grep -v unk | gzip -c > lm_phone_bg_dev.arpa.gz

mv lm_phone_ug.arpa.gz ../nist_lm
mv lm_phone_bg.arpa.gz ../nist_lm
mv lm_phone_ug_test.arpa.gz ../nist_lm
mv lm_phone_bg_test.arpa.gz ../nist_lm
mv lm_phone_ug_dev.arpa.gz ../nist_lm
mv lm_phone_bg_dev.arpa.gz ../nist_lm

cd "../../../"
