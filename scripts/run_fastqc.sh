#!/usr/bin/env bash

R1="$1"
R2="$2"
OUTDIR="$3"

mkdir -p "$OUTDIR"
fastqc "$R1" "$R2" -o "$OUTDIR"
