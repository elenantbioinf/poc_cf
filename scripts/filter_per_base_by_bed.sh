#!/usr/bin/env bash

#####################################
# This script filters a mosdepth per-base coverage file by a BED file
#####################################

PER_BASE_COVERAGE="$1"
BED="$2"
OUT_BED_GZ="$3"

mkdir -p "$(dirname "$OUT_BED_GZ")"

zcat "$PER_BASE_COVERAGE" \
    | bedtools intersect \
        -a - \
        -b <(grep -v "^#" "$BED") \
    | bgzip -c > "$OUT_BED_GZ"