#!/usr/bin/env bash

#####################################
# This is the script to index the sorted bam
######################################

BAM_SORTED="$1"

samtools index "$BAM_SORTED"
