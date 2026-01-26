#!/usr/bin/env bash

#####################################
# This is the script to index the vcf file with tabix
######################################

VCF_GZ="$1"

mkdir -p "$(dirname "$VCF_GZ")"

tabix -p vcf "$VCF_GZ"