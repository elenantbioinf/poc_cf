#!/usr/bin/env bash

#####################################
# This is the script to sort the bam file
######################################

BAM="$1"
BAM_SORTED="$2"
THREADS="$3"

mkdir -p "$(dirname "$BAM_SORTED")"

samtools sort -@ "$THREADS" -o "$BAM_SORTED" "$BAM"