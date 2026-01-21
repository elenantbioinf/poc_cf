#!/usr/bin/env bash

#####################################
# This is the script to run bwa for the mapping
######################################

REF="$1"
R1_CLEAN="$2"
R2_CLEAN="$3"
OUT_SAM="$4"
OUT_ERROR="$5"
THREADS="$6"

mkdir -p "$(dirname "$OUT_SAM")"
mkdir -p "$(dirname "$OUT_ERROR")"

bwa mem -t "$THREADS" -a "$REF" "$R1_CLEAN" "$R2_CLEAN" > "$OUT_SAM" 2> "$OUT_ERROR"