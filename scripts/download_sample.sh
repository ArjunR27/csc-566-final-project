#!/bin/bash
# Downloads 2 TAR files (~1.5 GB) from the MTG-Jamendo mel spectrogram dataset.
# Each tar contains ~185 tracks as .npy files (96 mel bands, full track duration).
# Tars are removed after unpacking to save space.
#
# To download more tars, add lines following the same pattern (-01, -02, ... -99).

set -e

BASE_URL="https://cdn.freesound.org/mtg-jamendo/autotagging_moodtheme/melspecs"
OUT_DIR="$(dirname "$0")/../data/melspecs"

mkdir -p "$OUT_DIR"

for i in 00 01; do
    FILENAME="autotagging_moodtheme_melspecs-${i}.tar"
    echo "Downloading $FILENAME..."
    curl -o "$OUT_DIR/$FILENAME" "$BASE_URL/$FILENAME"

    echo "Unpacking $FILENAME..."
    tar -xf "$OUT_DIR/$FILENAME" -C "$OUT_DIR"
    rm "$OUT_DIR/$FILENAME"
    echo "Done with $FILENAME."
done

echo "All done. Mel specs are in $OUT_DIR"
