#!/usr/bin/env bash

#####################################
# This is the script to keep the variants from marked vcf
# which PASS tag in FILTER
######################################

VCF_MARKED="$1"
VCF_FILTERED="$2"
THREADS="${3:-1}"

mkdir -p "$(dirname "$VCF_FILTERED")"

bcftools view --threads "$THREADS" -f PASS -Oz -o "$VCF_FILTERED" "$VCF_MARKED"