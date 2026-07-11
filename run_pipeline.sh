#!/usr/bin/env bash

#Run the complete Snakemake pipeline

#Usage: bash run_pipeline.sh [-c cores] [-n] [-f config_file] [-s snakemake_file] [-h]

#Options:
#   -c  Number of cores to use. Default: 10
#   -f  Config file. Default: config/config.yml
#   -s  Snakefile. Default: Snakefile
#   -n  Dry-run mode
#   -h  Show help message

set -euo pipefail

#Initial variables
CORES=10
CONFIG_FILE="config/config.yml"
SNAKEFILE="Snakefile"
DRY_RUN=false

#Define usage of the script
usage () {
    echo "run_pipeline.sh"
    echo ""
    echo "Usage: bash $0 [-c cores] [-n] [-f config_file] [-s snakemake_file] [-h]"
    echo ""
    echo "Description:"
    echo "  Run the complete Snakemake pipeline"
    echo ""
    echo "Options:"
    echo "  -c  Cores to use. Default: 10"
    echo "  -f  Config file. Default: config/config.yml"
    echo "  -s  Snakefile. Default: Snakefile"
    echo "  -n  Dry-run mode"
    echo "  -h  Display this help message and exit"
}

#Parse command line arguments
while getopts ":c:f:s:nh" opt; do
    case "$opt" in
        c ) CORES="$OPTARG" ;;
        f ) CONFIG_FILE="$OPTARG" ;;
        s ) SNAKEFILE="$OPTARG" ;;
        n ) DRY_RUN=true ;;
        h ) usage
            exit 0
            ;;
        : )
            echo "Error: option -$OPTARG requires an argument." >&2
            usage
            exit 1
            ;;
        \? )
            echo "Error: invalid option -$OPTARG" >&2
            usage
            exit 1
            ;;
    esac
done

#Check if input files exist
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: config file not found: $CONFIG_FILE" >&2
    exit 1
fi

if [[ ! -f "$SNAKEFILE" ]]; then
    echo "Error: Snakefile not found: $SNAKEFILE" >&2
    exit 1
fi

#Check Snakemake and conda availability
if command -v snakemake >/dev/null 2>&1; then
    CMD_PREFIX=()
elif command -v conda >/dev/null 2>&1; then
    CMD_PREFIX=(conda run -n poc_cf)
else
    echo "Error: snakemake is not available and conda was not found." >&2
    echo "Please, activate the pipeline environment with: conda activate poc_cf" >&2
    exit 1
fi

#Run variables
RUN_DATE=$(date +%Y-%m-%d_%H-%M-%S)
LOG_DIR="logs/pipeline"
LOG_FILE="$LOG_DIR/pipeline_run_${RUN_DATE}.log"

mkdir -p "$LOG_DIR"

#Run the Snakemake command
CMD=(
    "${CMD_PREFIX[@]}"
    snakemake
        --snakefile "$SNAKEFILE"
        --configfile "$CONFIG_FILE"
        --cores "$CORES"
        --printshellcmds
        --rerun-incomplete
        --use-conda
        --show-failed-logs
)

#Check if dry-run mode is selected
if [[ "$DRY_RUN" = true ]]; then
    CMD+=("--dry-run")
fi

#Banner
{
    echo "============================================================"
    echo "                  Pipeline execution"
    echo "============================================================"
    echo "Run date:     $RUN_DATE"
    echo "Workdir:      $(pwd)"
    echo "Snakefile:    $SNAKEFILE"
    echo "Config file:  $CONFIG_FILE"
    echo "Cores:        $CORES"
    echo "Dry-run:      $DRY_RUN"
    echo "Log file:     $LOG_FILE"
    echo "Command:      ${CMD[*]}"
    echo "============================================================"
    echo ""
} | tee "$LOG_FILE"


#Start pipeline runtime measurement
START_TIME=$(date +%s)
START_DATE=$(date "+%Y-%m-%d %H:%M:%S")

#Run the command and capture the status
if "${CMD[@]}" 2>&1 | tee -a "$LOG_FILE"; then
    STATUS=0
else
    STATUS=$?
fi

#Finish pipeline runtime measurement
END_TIME=$(date +%s)
END_DATE=$(date "+%Y-%m-%d %H:%M:%S")

ELAPSED_SECONDS=$((END_TIME - START_TIME))

ELAPSED_FORMATTED=$(printf "%02d:%02d:%02d" \
    $((ELAPSED_SECONDS / 3600)) \
    $(((ELAPSED_SECONDS % 3600) / 60)) \
    $((ELAPSED_SECONDS % 60))
)

#Save pipeline runtime summary
PERFORMANCE_DIR="results/13_performance"
RUNTIME_FILE="$PERFORMANCE_DIR/pipeline_runtime.tsv"

mkdir -p "$PERFORMANCE_DIR"

{
    printf "metric\tvalue\tunit\n"
    printf "start_date\t%s\t\n" "$START_DATE"
    printf "end_date\t%s\t\n" "$END_DATE"
    printf "elapsed_time\t%s\tHH:MM:SS\n" "$ELAPSED_FORMATTED"
    printf "elapsed_seconds\t%s\tseconds\n" "$ELAPSED_SECONDS"
} > "$RUNTIME_FILE"

#Final message
{
    echo ""
    echo "============================================================"
    echo "Pipeline finished"
    echo "============================================================"
    echo "End date:   $END_DATE"
    echo "Elapsed time:  $ELAPSED_FORMATTED"
    echo "Runtime file:  $RUNTIME_FILE"
    echo "Exit code:  $STATUS"
    echo "Log file:   $LOG_FILE"
    echo "============================================================"
} | tee -a "$LOG_FILE"

exit "$STATUS"