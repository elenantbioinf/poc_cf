#!/usr/bin/env bash

#####################################
# This is the script to add read groups in bam file
# using picard
######################################


BAM_SORTED="$1"
OUT_BAM="$2"
SAMPLE="$3"
THREADS="$4"

mkdir -p "$(dirname "$OUT_BAM")"

#Add the read groups

picard AddOrReplaceReadGroups \
  INPUT="$BAM_SORTED" \
  OUTPUT="$OUT_BAM" \
  RGID="$SAMPLE" \
  RGLB="lib1" \
  RGPL="ILLUMINA" \
  RGPU="unit1" \
  RGSM="$SAMPLE" 

# Index the bam.rg

samtools index -@ "$THREADS" "$OUT_BAM"