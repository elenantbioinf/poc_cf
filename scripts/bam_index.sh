#!/usr/bin/env bash

#####################################
# This is the script to index the sorted bam
######################################

BAM_SORTED="$1"
THREADS="$2"

samtools index -@ "$THREADS" "$BAM_SORTED"
