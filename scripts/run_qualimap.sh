#!/usr/bin/env bash

#####################################
# This scripts runs Qualimap quality control on
# a sorted and indexed BAM file
######################################

BAM_SORTED="$1"
OUT_DIR="$2"
THREADS="$3"
JAVA_MEM="$4"
GENOME="$5"

mkdir -p "$OUT_DIR"

qualimap bamqc \
    --bam "$BAM_SORTED" \
    -c \
    -nt "$THREADS" \
    -gd "$GENOME" \
    --java-mem-size="$JAVA_MEM" \
    -outdir "$OUT_DIR"