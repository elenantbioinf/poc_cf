#!/usr/bin/env bash

############################################
# Generate pipeline performance summary
############################################

#This will be used by run_pipeline.sh to measure the resources metrics

# Output:
# 1. TSV table with pipeline performance metrics

set -euo pipefail

#Check arguments
if [[ "$#" -ne 7 ]]; then
    echo "Usage: $0 TIME_FILE OUTPUT_TSV EXIT_CODE START_DATE END_DATE ELAPSED_SECONDS CORES" >&2    
    exit 1
fi

#Arguments
TIME_FILE="$1"
OUTPUT_TSV="$2"
EXIT_CODE="$3"
START_DATE="$4"
END_DATE="$5"
ELAPSED_SECONDS="$6"
CORES="$7"

#Check required files
if [[ ! -f "$TIME_FILE" ]]; then
    echo "Error: GNU time output file not found: $TIME_FILE" >&2
    exit 1
fi

#Determine pipeline status
if [[ "$EXIT_CODE" -eq 0 ]]; then
    PIPELINE_STATUS="SUCCESS"
else
    PIPELINE_STATUS="FAILED"
fi

#Format elapsed time as HH:MM:SS
ELAPSED_FORMATTED=$(printf "%02d:%02d:%02d" \
    $((ELAPSED_SECONDS / 3600)) \
    $(((ELAPSED_SECONDS % 3600) / 60)) \
    $((ELAPSED_SECONDS % 60))
)

# Extract GNU Time metrics
USER_CPU_SECONDS=$(awk -F': ' \
    '/User time \(seconds\)/ {
        print $2
        exit
    }' "$TIME_FILE"
)

SYSTEM_CPU_SECONDS=$(awk -F': ' \
    '/System time \(seconds\)/ {
        print $2
        exit
    }' "$TIME_FILE"
)

AVERAGE_CPU_PERCENT=$(awk -F': ' \
    '/Percent of CPU this job got/ {
        value = $2
        gsub(/%/, "", value)
        print value
        exit
    }' "$TIME_FILE"
)

MAX_MEMORY_KB=$(awk -F': ' \
    '/Maximum resident set size \(kbytes\)/ {
        print $2
        exit
    }' "$TIME_FILE"
)

#Use default values if a metric is missing
USER_CPU_SECONDS="${USER_CPU_SECONDS:-0}"
SYSTEM_CPU_SECONDS="${SYSTEM_CPU_SECONDS:-0}"
AVERAGE_CPU_PERCENT="${AVERAGE_CPU_PERCENT:-0}"
MAX_MEMORY_KB="${MAX_MEMORY_KB:-0}"

#Calculate total CPU time
TOTAL_CPU_SECONDS=$(awk \
    -v user_cpu="$USER_CPU_SECONDS" \
    -v system_cpu="$SYSTEM_CPU_SECONDS" \
    'BEGIN {
        printf "%.2f", user_cpu + system_cpu
    }'
)

#Convert maximum memory to MB and GB
MAX_MEMORY_MB=$(awk \
    -v kb="$MAX_MEMORY_KB" \
    'BEGIN {
        printf "%.2f", kb / 1024
    }'
)

MAX_MEMORY_GB=$(awk \
    -v kb="$MAX_MEMORY_KB" \
    'BEGIN {
        printf "%.2f", kb / 1024 / 1024
    }'
)

#Create output dir if it doesn't exists
mkdir -p "$(dirname "$OUTPUT_TSV")"

#Write performance summary
{
    printf "metric\tvalue\tunit\n"
    printf "pipeline_status\t%s\t\n" "$PIPELINE_STATUS"
    printf "exit_code\t%s\t\n" "$EXIT_CODE"
    printf "start_date\t%s\t\n" "$START_DATE"
    printf "end_date\t%s\t\n" "$END_DATE"
    printf "elapsed_time\t%s\tHH:MM:SS\n" "$ELAPSED_FORMATTED"
    printf "elapsed_seconds\t%s\tseconds\n" "$ELAPSED_SECONDS"
    printf "user_cpu_time\t%s\tseconds\n" "$USER_CPU_SECONDS"
    printf "system_cpu_time\t%s\tseconds\n" "$SYSTEM_CPU_SECONDS"
    printf "total_cpu_time\t%s\tseconds\n" "$TOTAL_CPU_SECONDS"
    printf "average_cpu_usage\t%s\tpercent\n" "$AVERAGE_CPU_PERCENT"
    printf "maximum_memory\t%s\tMB\n" "$MAX_MEMORY_MB"
    printf "maximum_memory_gb\t%s\tGB\n" "$MAX_MEMORY_GB"
    printf "cores_requested\t%s\tcores\n" "$CORES"
} > "$OUTPUT_TSV"


echo "Performance summary generated: $OUTPUT_TSV"