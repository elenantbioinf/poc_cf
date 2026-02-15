#!/usr/bin/env bash

#####################################
# This is the script to calculate the coverage in
# region wanted
######################################

BAM_DEDUP="$1"
BED="$2"
PREFIX="$3"
THRESHOLDS="$4"
EXTRA_ARGS="$5"

mkdir -p "$(dirname "$PREFIX")"

mosdepth \
    --by "$BED" \
    --thresholds "$THRESHOLDS" \
    $EXTRA_ARGS \
    "$PREFIX" \
    "$BAM_DEDUP"