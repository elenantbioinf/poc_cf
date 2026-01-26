#!/usr/bin/env bash

#####################################
# This is the script to filter the vcf file
######################################

VCF="$1"
VCF_FILTERED="$2"
MIN_COVERAGE="${3:-5}"
MIN_QUALITY="${4:-20}"
THREADS="$5"

mkdir -p "$(dirname "$VCF_FILTERED")"

bcftools view --threads "$THREADS" -Ou "$VCF" |
bcftools filter -i "INFO/DP>=$MIN_COVERAGE && QUAL>=$MIN_QUALITY" -Ou |
bcftools view --threads "$THREADS" -Oz -o "$VCF_FILTERED"