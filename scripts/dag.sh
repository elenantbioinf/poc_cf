#!/usr/bin/env bash

#####################################
# This scripts generates DAG of pipeline
######################################

DAG_DIR="$1"
DAG_DOT="${DAG_DIR}/dag.dot"
DAG_PNG="${DAG_DIR}/dag.png"
LOG_DIR="$2"
DAG_LOG="${LOG_DIR}/dag.log"

mkdir -p "${DAG_DIR}"
mkdir -p "${LOG_DIR}"

snakemake --dry-run --dag dot 2> "${DAG_LOG}"

dot -Tpng "${DAG_DOT}" -o "${DAG_PNG}"