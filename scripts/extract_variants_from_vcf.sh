#!/usr/bin/env bash

#####################################
# This is the script to extract the variants from the
# filtered vcf file
######################################

VCF_FILTERED="$1"
OUT_TSV="$2"
HEADER="$3"
QUERY_FORMAT="$4"

mkdir -p "$(dirname "$OUT_TSV")"


#Generate variants tsv

echo -e "$HEADER" > "$OUT_TSV"

bcftools query -f "$QUERY_FORMAT" "$VCF_FILTERED" >> "$OUT_TSV"