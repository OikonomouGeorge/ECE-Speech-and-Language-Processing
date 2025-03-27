
base_dir="/home/zeno/kaldi/egs/project1/data"

sort $base_dir/train/wav.scp -o $base_dir/train/wav.scp
sort $base_dir/train/text -o $base_dir/train/text
sort $base_dir/train/utt2spk -o $base_dir/train/utt2spk

sort $base_dir/dev/wav.scp -o $base_dir/dev/wav.scp
sort $base_dir/dev/text -o $base_dir/dev/text
sort $base_dir/dev/utt2spk -o $base_dir/dev/utt2spk

sort $base_dir/test/wav.scp -o $base_dir/test/wav.scp
sort $base_dir/test/text -o $base_dir/test/text
sort $base_dir/test/utt2spk -o $base_dir/test/utt2spk
