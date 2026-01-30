#!/usr/bin/env bash

#####################################
# This is the script to extract the variants from the
# filtered vcf file
######################################

VCF_FILTERED="$1"
OUT_TSV="$2"

mkdir -p "$(dirname "$OUT_TSV")"

echo -e "CHROM\tPOS\tID\tREF\tALT" > "$OUT_TSV"

bcftools query -f '%CHROM\t%POS\t%ID\t%REF\t%ALT\n' "$VCF_FILTERED" >> "$OUT_TSV"