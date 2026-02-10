#!/usr/bin/env bash

#####################################
# This is the script to check if there are or not
# variants in variants.tsv
######################################

VARIANTS_TSV="$1"
CHECK_TXT="$2"

mkdir -p "$(dirname "$CHECK_TXT")"

if [ "$(wc -l < "$VARIANTS_TSV")" -le 1 ]; then
    echo "NO VARIANTS DETECTED" > "$CHECK_TXT"
else
    echo "VARIANTS DETECTED" > "$CHECK_TXT"
fi
