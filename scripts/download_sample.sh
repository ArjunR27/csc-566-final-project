#!/bin/bash
# Downloads mel spectrograms from the MTG-Jamendo dataset, extracting only
# the tracks listed in data/data_ids.txt (generated from the notebook).
# Tars are removed after extraction to save space.
#
# Usage: ./download_sample.sh
# Prereq: run the notebook cell that writes data/data_ids.txt first.

set -e

BASE_URL="https://cdn.freesound.org/mtg-jamendo/autotagging_moodtheme/melspecs"
SCRIPT_DIR="$(dirname "$0")"
OUT_DIR="$SCRIPT_DIR/../data/melspecs"
IDS_FILE="$SCRIPT_DIR/../data/data_ids.txt"

if [ ! -f "$IDS_FILE" ]; then
    echo "ERROR: $IDS_FILE not found. Run the notebook cell to generate it first."
    exit 1
fi

mkdir -p "$OUT_DIR"

# Build a set of already-downloaded IDs
already_have() {
    local id="$1"
    find "$OUT_DIR" -name "${id}.npy" | grep -q .
}

# Count how many we still need
total=$(wc -l < "$IDS_FILE" | tr -d ' ')
echo "Need $total mel spectrograms total."

for i in $(seq -w 0 99); do
    # Check if we already have all needed files
    missing=0
    while IFS= read -r id; do
        already_have "$id" || { missing=1; break; }
    done < "$IDS_FILE"

    if [ "$missing" -eq 0 ]; then
        echo "All needed files downloaded. Done."
        exit 0
    fi

    FILENAME="autotagging_moodtheme_melspecs-${i}.tar"
    echo "Checking $FILENAME..."

    # List tar contents and see if any needed IDs are in it
    tmpfile=$(mktemp)
    curl -sf --head "$BASE_URL/$FILENAME" > /dev/null 2>&1 || { echo "  Skipping (not found)."; continue; }
    curl -s -o "$OUT_DIR/$FILENAME" "$BASE_URL/$FILENAME"

    # Get list of npy files in this tar
    tar -tf "$OUT_DIR/$FILENAME" | grep '\.npy$' | xargs -I{} basename {} .npy > "$tmpfile"

    # Extract only the files we need
    extracted=0
    while IFS= read -r id; do
        if grep -qx "$id" "$tmpfile" 2>/dev/null; then
            # Find the path inside the tar for this file
            tarpath=$(tar -tf "$OUT_DIR/$FILENAME" | grep "/${id}\.npy$\|^${id}\.npy$" | head -1)
            if [ -n "$tarpath" ]; then
                tar -xf "$OUT_DIR/$FILENAME" -C "$OUT_DIR" "$tarpath"
                extracted=$((extracted + 1))
            fi
        fi
    done < "$IDS_FILE"

    rm "$tmpfile" "$OUT_DIR/$FILENAME"
    echo "  Extracted $extracted files from $FILENAME."
done

echo "All done. Mel specs are in $OUT_DIR"
