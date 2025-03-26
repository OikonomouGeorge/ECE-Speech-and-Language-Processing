#!/bin/bash

FOLDER_DIR="."

echo "In Progress.."

transcriptions_file="/home/zeno/kaldi/egs/project1/dataset/usc/transcriptions.txt"

for subset in train dev test; do
    echo "Processing $subset..."

    uttids_file="$FOLDER_DIR/$subset/uttids"
    text_file="$FOLDER_DIR/$subset/text"

    if [[ ! -f "$uttids_file" ]]; then
        echo "Error: $uttids_file not found!"
        continue
    fi

    if [[ ! -f "$transcriptions_file" ]]; then
        echo "Error: $transcriptions_file not found!"
        continue
    fi

    # Declare an associative array to store the transcriptions
    declare -A transcriptions

    while IFS= read -r line; do

        line=$(echo "$line" | sed 's/^[[:space:]]*//')  # Remove leading spaces
        utt_id=$(echo "$line" | awk '{print $1}')
        text=$(echo "$line" | sed -E 's/^[0-9]+[[:space:]]+//')

        # Store the transcription text in the array, with the numeric ID as the key
        transcriptions["$utt_id"]="$text"
    done < "$transcriptions_file"
    > "$text_file"

    while IFS= read -r utterance_id; do
        # Extract the numeric part of the utterance_id (e.g., m5_330 -> 330)
        numeric_id="${utterance_id##*_}"
        text="${transcriptions[$numeric_id]}"

        if [[ -n "$text" ]]; then
            echo "$utterance_id $text" >> "$text_file"
        else
            echo "Warning: Missing transcription for $utterance_id"
        fi
    done < "$uttids_file"

    echo "$subset processing completed."
done

echo "All subsets processed."
