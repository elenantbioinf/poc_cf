#!/usr/bin/env bash

#This is the script to run the rule: R02_01_trimming_fastp, include in
#02_preprocessing.smk

R1="$1"
R2="$2"
OUT1="$3"
OUT2="$4"
HTML="$5"
JSON="$6"
MINLEN="$7"
EXTRA_ARGS="${8:-}"

mkdir -p "$(dirname "$OUT1")"
mkdir -p "$(dirname "$HTML")"

fastp \
    -i "$R1" \
    -I "$R2" \
    -o "$OUT1" \
    -O "$OUT2" \
    $EXTRA_ARGS \
    --length_required "$MINLEN" \
    --html "$HTML" \
    --json "$JSON"