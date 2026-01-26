#!/usr/bin/env bash

#####################################
# This is the script to index the vcf file with tabix
######################################

TBI="$1"

mkdir -p "$(dirname "$TBI")"

tabix -f -p vcf "$TBI"