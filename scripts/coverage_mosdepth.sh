#!/usr/bin/env bash

#####################################
# This is the script to calculate the coverage in
# region wanted
######################################

BAM_DEDUP="$1"
BED="$2"
PREFIX="$3"

mkdir -p "$(dirname "$PREFIX")"

mosdepth \
    --by "$BED" \
    --thresholds 10,20,30,40 \
    --no-per-base \
    --flag 1024 \
    "$PREFIX" \
    "$BAM_DEDUP"