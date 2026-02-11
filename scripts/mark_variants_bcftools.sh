#!/usr/bin/env bash

#####################################
# This is the script to mark the variants in FILTER from the
# vcf based on its quality and coverage
# Outputs keeps all variants without removal with FILTER tags
######################################

VCF_ORI="$1"
VCF_MARKED="$2"
MIN_COVERAGE="${3:-5}"
MIN_QUALITY="${4:-20}"
THREADS="${5:-1}"

mkdir -p "$(dirname "$VCF_MARKED")"

bcftools view --threads "$THREADS" -Ou "$VCF_ORI" |
bcftools filter -s LowDP -e "INFO/DP < $MIN_COVERAGE && QUAL >= $MIN_QUALITY" -Ou |
bcftools filter -s LowQual -e "QUAL < $MIN_QUALITY && INFO/DP >= $MIN_COVERAGE" -Ou |
bcftools filter -s LowDP_LowQual -e "INFO/DP < $MIN_COVERAGE && QUAL < $MIN_QUALITY" -Ou |
bcftools view --threads "$THREADS" -Oz -o "$VCF_MARKED"