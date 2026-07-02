#!/usr/bin/env bash

#####################################
# This is the script to index the bam files
######################################

BAM="$1"
THREADS="$2"

samtools index -@ "$THREADS" "$BAM"
