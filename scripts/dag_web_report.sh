#!/usr/bin/env bash

#####################################
# This scripts generates DAG for final_report
######################################

DAG_DIR="$1"
DAG_DOT="${DAG_DIR}/dag_web_report.dot"
DAG_PNG="${DAG_DIR}/dag_web_report.png"
LOG_DIR="$2"
DAG_LOG="${LOG_DIR}/dag_web_report.log"
FINAL_TARGET="$3"

mkdir -p "${DAG_DIR}"
mkdir -p "${LOG_DIR}"

snakemake --dry-run --dag dot "${FINAL_TARGET}" 2> "${DAG_LOG}" \
    | tail -n +2 > "${DAG_DOT}"

dot -Tpng "${DAG_DOT}" -o "${DAG_PNG}"