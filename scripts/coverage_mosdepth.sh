#!/usr/bin/env bash

#####################################
# This is the script to calculate the coverage in
# region wanted
######################################

BAM_DEDUP="$1"
BED="$2"
PREFIX="$3"
THRESHOLDS="$4"
FLAG="$5"

mkdir -p "$(dirname "$PREFIX")"

mosdepth \
    --by "$BED" \
    --thresholds "$THRESHOLDS" \
    --flag "$FLAG" \
    "$PREFIX" \
    "$BAM_DEDUP"