#!/usr/bin/env bash

#####################################
# This is the script to extract the variants from the
# filtered vcf file
######################################

VCF_FILTERED="$1"
OUT_TSV="$2"
OUT_CHECK="$3"

mkdir -p "$(dirname "$OUT_TSV")"


#Generate variants tsv

echo -e "CHROM\tPOS\tID\tREF\tALT" > "$OUT_TSV"

bcftools query -f '%CHROM\t%POS\t%ID\t%REF\t%ALT\n' "$VCF_FILTERED" >> "$OUT_TSV"


#Check if variants tsv has variants or not

if [ "$(cat "$OUT_TSV" | wc -l)" -le 1 ]; then
    echo "NO VARIANTS DETECTED" > "$OUT_CHECK"
else
    echo "VARIANTS DETECTED" > "$OUT_CHECK"
fi