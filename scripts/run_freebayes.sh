#!/usr/bin/env bash

#####################################
# This is the script to run FreeBayes, to the 
# variant calling
######################################

BAM_DEDUP="$1"
REF="$2"
BED="$3"
OUT_VCF="$4"
THREADS="$5"

mkdir -p "$(dirname "$OUT_VCF")"

freebayes \
    -C 5 \
    --ploidy 2 \
    --min-mapping-quality 20 \
    -f "$REF" \
    -t "$BED" \
    "$BAM_DEDUP" \
| bgzip -c > "$OUT_VCF"