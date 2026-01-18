#!/usr/bin/env bash

FASTQC_DIR="$1"
OUTDIR="$2"

mkdir -p "$OUTDIR"
multiqc "$FASTQC_DIR" -o "$OUTDIR" -n "multiqc_report.html"
