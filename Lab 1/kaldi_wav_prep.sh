#!/bin/bash

FOLDER_DIR="."
WAV_DIR="/home/zeno/kaldi/egs/project1/dataset/usc/wav"

echo "In Progress.."

for subset in train dev test; do
    echo "Processing $subset..."

    uttids_file="$FOLDER_DIR/$subset/uttids"
    wav_scp_file="$FOLDER_DIR/$subset/wav.scp"

    if [[ ! -f "$uttids_file" ]]; then
        echo "Error: $uttids_file not found!"
        continue
    fi

    # Adding
    while IFS= read -r utterance_id; do

        wav_path="$WAV_DIR/$utterance_id.wav"

        echo "$utterance_id $wav_path" >> "$wav_scp_file"
    done < "$uttids_file"

    echo "$subset processing completed."
done

echo "All subsets processed."
