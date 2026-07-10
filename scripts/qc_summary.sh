#!/usr/bin/env bash

########################################################
# Generate raw and post-filtering read quality summary
########################################################

set -euo pipefail

#Check arguments
if [[ "$#" -ne 3 ]]; then
    echo "Usage: $0 RAW_MULTIQC_FASTQC CLEAN_MULTIQC_FASTQC OUTPUT_TSV" >&2
    exit 1
fi

#Input arguments
RAW_FASTQC="$1"
CLEAN_FASTQC="$2"
OUTPUT_TSV="$3"

#Check if input files exist
for input_file in "$RAW_FASTQC" "$CLEAN_FASTQC"; do
    if [[ ! -f "$input_file" ]]; then
        echo "Error: Input file '$input_file' does not exist." >&2
        exit 1
    fi
done

mkdir -p "$(dirname "$OUTPUT_TSV")"

#Write header to output TSV
printf "sample\tread\tstage\ttotal_sequences\tsequence_length\tavg_sequence_length\tpercent_gc\tpercent_duplicates\n" \
    > "$OUTPUT_TSV"

#Function to extract metrics from MultiQC and FastQC summary
extract_metrics() {
    local input_file="$1"
    local stage="$2"

    awk -F '\t' -v OFS='\t' -v stage="$stage" '
        NR > 1 {
            sample = $1
            read_type = ""

            if (sample ~ /_R1$/) {
                read_type = "R1"
            }

            if (sample ~ /_R2$/) {
                read_type = "R2"
            }

            if (read_type == "") {
                print "Error: Cannot identify read from sample: " sample > "/dev/stderr"
                exit 1
            }

            sub(/_S[0-9]+_L[0-9]+_[0-9]+_R[12]$/, "", sample)
            sub(/_R[12]$/, "", sample)

            percent_duplicates = 100 - $10

            printf "%s\t%s\t%s\t%.0f\t%s\t%.2f\t%.2f\t%.2f\n", \
                sample, \
                read_type, \
                stage, \
                $5, \
                $8, \
                $11, \
                $9, \
                percent_duplicates
        }
    ' "$input_file"
}

extract_metrics "$RAW_FASTQC" "Raw" >> "$OUTPUT_TSV"
extract_metrics "$CLEAN_FASTQC" "Post-filtering" >> "$OUTPUT_TSV"