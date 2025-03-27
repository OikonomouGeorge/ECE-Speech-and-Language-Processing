#!/bin/bash

# Source Kaldi's environment variables (sets up paths and tools)
. ./path.sh

# Define directory paths for dictionary files and datasets
target_dir="/home/zeno/kaldi/egs/project1/data/local/dict"
lexicon_dir="/home/zeno/kaldi/egs/project1/dataset/usc/lexicon.txt"
nonsilence_phones_dir="$target_dir/nonsilence_phones.txt"
new_lexicon_dir="$target_dir/lexicon.txt"
train_file="/home/zeno/kaldi/egs/project1/data/train/text"
dev_file="/home/zeno/kaldi/egs/project1/data/dev/text"
test_file="/home/zeno/kaldi/egs/project1/data/test/text"

# Create the 'dict' directory if it doesn't exist
mkdir -p $target_dir

# Create 'silence_phones.txt' and 'optional_silence.txt' with "sil" (silence token)
echo "sil" > $target_dir/silence_phones.txt
echo "sil" > $target_dir/optional_silence.txt

# Generate 'nonsilence_phones.txt':
# 1. Extract all non-silence phones from the lexicon (skip the first column, which is the word).
# 2. Remove the "sil" entry (if present).
# 3. Sort and deduplicate the list.
awk '{for (i=2; i<=NF; i++) print $i}' "$lexicon_dir" | \
    grep -v '^sil$' | \
    sort -u > "$nonsilence_phones_dir"

# Create 'lexicon.txt':
# 1. Add a default entry for silence ("sil sil").
# 2. For each non-silence phone, add an entry mapping the phone to itself (e.g., "p p").
echo "sil sil" > $new_lexicon_dir
while read phone; do
    echo "$phone $phone" >> $new_lexicon_dir
done < $nonsilence_phones_dir

# Define output paths for language model (LM) training files
train_output="$target_dir/lm_train.text"
dev_output="$target_dir/lm_dev.text"
test_output="$target_dir/lm_test.text"

# Function to add <s> and </s> tokens to utterances in a dataset file
add_special_tokens() {
    input_file=$1    # Input file (e.g., train/text)
    output_file=$2   # Output file (e.g., lm_train.text)

    echo "Creating $output_file..."

    # Process each line:
    # 1. Extract the utterance ID (first field).
    # 2. Extract the phones (remaining fields).
    # 3. Wrap the phones with <s> and </s> tokens.
    while read -r line; do
        id=$(echo "$line" | awk '{print $1}')
        phones=$(echo "$line" | awk '{for(i=2;i<=NF;i++) printf "%s ", $i; print ""}')
        phones=$(echo "$phones" | sed 's/[[:space:]]*$//')  # Trim trailing whitespace
        echo "$id <s> $phones </s>" >> $output_file
    done < $input_file
}

# Process train, dev, and test files to add special tokens
add_special_tokens $train_file $train_output
add_special_tokens $dev_file $dev_output
add_special_tokens $test_file $test_output
