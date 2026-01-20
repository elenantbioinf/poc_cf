#!/usr/bin/env bash

#####################################
# This is the script to download, decompress and index the 
# reference genome fasta for mapping
######################################
#   get_reference.sh <REF_URL> <OUT_FASTA>

URL="$1"
FASTA="$2"

FASTA_GZ="${FASTA}.gz"

mkdir -p "$(dirname "$FASTA")"

## Download compressed fasta reference
wget -O "$FASTA_GZ" "$URL"

## Decompress to FASTA 
gunzip -f "$FASTA_GZ"

## Create index for other processes
samtools faidx "$FASTA"

## Create index for bwa mapping
bwa index "$FASTA"