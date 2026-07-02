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

#Check Snakemake availability
if ! command -v snakemake >/dev/null 2>&1; then
    echo "Error: snakemake is not available in the current environment."  >&2
    echo "Please, activate pipeline environment with: conda activate poc_cf" >&2
    exit 1
fi

#Run variables
RUN_DATE=$(date +%Y-%m-%d_%H-%M-%S)
LOG_DIR="logs/pipeline"
LOG_FILE="$LOG_DIR/pipeline_run_${RUN_DATE}.log"

mkdir -p "$LOG_DIR"

#Run the Snakemake command
CMD=(
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

#Run the command and capture the status
if "${CMD[@]}" 2>&1 | tee -a "$LOG_FILE"; then
    STATUS=0
else
    STATUS=$?
fi

#Final message
{
    echo ""
    echo "============================================================"
    echo "Pipeline finished"
    echo "============================================================"
    echo "End date:   $(date +%Y-%m-%d_%H-%M-%S)"
    echo "Exit code:  $STATUS"
    echo "Log file:   $LOG_FILE"
    echo "============================================================"
} | tee -a "$LOG_FILE"

exit "$STATUS"