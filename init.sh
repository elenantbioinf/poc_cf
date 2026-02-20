#!/usr/bin/env bash

# Read config file
CONFIG="config/config.yml"

# Data directories
RAW_DIR=$(grep "raw_reads:" $CONFIG | awk '{print $2}' | tr -d '"')
CLEAN_DIR=$(grep "clean_reads:" $CONFIG | awk '{print $2}' | tr -d '"')
FASTA_PATH=$(grep "fasta:" $CONFIG | awk '{print $2}' | tr -d '"')
REF_DIR=$(dirname "$FASTA_PATH")

# Result directory
RESULTS_DIR=$(grep "results_dir:" "$CONFIG" | awk '{print $2}' | tr -d '"')

#Logs directory
LOGS_DIR=$(grep "logs_dir:" "$CONFIG" | awk '{print $2}' | tr -d '"')

# Visual directory
VISUAL_DIR=$(grep "visual_dir:" "$CONFIG" | awk '{print $2}' | tr -d '"')

# Final report directory
FINAL_REPORT_DIR=$(grep "final_report_dir:" "$CONFIG" | awk '{print $2}' | tr -d '"')

# Creation of all the directories
mkdir -p "$RAW_DIR" "$CLEAN_DIR" "$REF_DIR" \
         "$RESULTS_DIR" "$LOGS_DIR" "$VISUAL_DIR" "$FINAL_REPORT_DIR"

echo "Directory structure initialized."