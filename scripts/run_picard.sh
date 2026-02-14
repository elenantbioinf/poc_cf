#!/usr/bin/env bash

#####################################
# This is the script to mark duplicates using picard
######################################

BAM_SORTED="$1"
BAM_DEDUP="$2"
MARK_METRICS="$3"

mkdir -p "$(dirname "$BAM_DEDUP")"

picard MarkDuplicates \
    INPUT="$BAM_SORTED" \
    OUTPUT="$BAM_DEDUP" \
    METRICS_FILE="$MARK_METRICS" \
    ASSUME_SORTED=true
