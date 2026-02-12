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

## Download compressed fasta reference if does not exists
if [ ! -f "$FASTA" ]; then
    wget -O "$FASTA_GZ" "$URL"
    gunzip -f "$FASTA_GZ"
fi

## Create index for other processes if does not exists
if [ ! -f "$FASTA.fai" ]; then
    samtools faidx "$FASTA"
fi

## Create index for bwa mapping if does not exists
if [ ! -f "$FASTA.amb" ]; then
    bwa index "$FASTA"
fi