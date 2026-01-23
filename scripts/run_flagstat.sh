#!/usr/bin/env bash

#####################################
# This scripts generates alignment quality control
# metrics using samtools flagstat
######################################

IN="$1"
OUT="$2"
THREADS="$3"

mkdir -p "$(dirname "$OUT")"

samtools flagstat -@ "$THREADS" "$IN" > "$OUT"