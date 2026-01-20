#!/usr/bin/env bash

#This is the script to run the rule: trimming_fastp, include in
#preprocessing.smk

R1="$1"
R2="$2"
OUT1="$3"
OUT2="$4"
HTML="$5"
JSON="$6"
MINLEN="$7"

mkdir -p data/clean
mkdir -p results/preprocessing

fastp \
    -i "$R1" \
    -I "$R2" \
    -o "$OUT1" \
    -O "$OUT2" \
    --detect_adapter_for_pe \
    --trim_poly_g \
    --trim_poly_x \
    --cut_tail \
    --cut_window_size 4 \
    --cut_mean_quality 20 \
    --qualified_quality_phred 20 \
    --unqualified_percent_limit 40 \
    --n_base_limit 5 \
    --length_required "$MINLEN" \
    --html "$HTML" \
    --json "$JSON"