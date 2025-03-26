#!/bin/bash

FOLDER_DIR="."

echo "In Progress.."

for subset in train dev test; do
    echo "Processing $subset..."

    uttids_file="$FOLDER_DIR/$subset/uttids"
    utt2spk_file="$FOLDER_DIR/$subset/utt2spk"

    if [[ ! -f "$uttids_file" ]]; then
        echo "Error: $uttids_file not found!"
        continue
    fi

    # Adding
    while IFS= read -r utterance_id; do
        # Extracting speaker_id from the utterance_id
        speaker_id="${utterance_id:0:2}"

        echo "$utterance_id $speaker_id" >> "$utt2spk_file"
    done < "$uttids_file"

    echo "$subset processing completed."
done

echo "All subsets processed."
