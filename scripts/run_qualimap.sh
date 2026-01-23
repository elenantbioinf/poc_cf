#!/usr/bin/env bash

#####################################
# This scripts runs Qualimap quality control on
# a sorted and indexed BAM file
######################################

BAM_SORTED="$1"
OUT_DIR="$2"
THREADS="$3"

mkdir -p "$OUT_DIR"

qualimap bamqc --bam "$BAM_SORTED" -c -nt "$THREADS" -gd HUMAN --java-mem-size=10G -outdir "$OUT_DIR"