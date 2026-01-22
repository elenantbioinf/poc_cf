#!/usr/bin/env bash

#####################################
# This is the script to transform the sam file into
# bam file 
######################################

SAM="$1"
BAM="$2"
THREADS="$3"

mkdir -p "(dirname "$BAM")"

samtools view -@ "$THREADS" -bSh "$SAM" > "$BAM"