# This is the snakefile for the proyect poc_cf

#Configuration

configfile: "config/config.yml"

#Rules

include: "rules/common_utils.smk"
include: "rules/quality_control.smk"
include: "rules/preprocessing.smk"

#Goal rule with the final files

rule all:
    input:
        #Quality_control
        "results/quality_control/raw_multiqc/multiqc_report.html",
        #Preprocessing: trimming_fastp
        expand("data/clean/{id}_R1.trimmed.fastq.gz", id = SAMPLES),
        expand("data/clean/{id}_R2.trimmed.fastq.gz", id = SAMPLES),
        expand("results/preprocessing/{id}.fastp.html", id = SAMPLES),
        expand("results/preprocessing/{id}.fastp.json", id = SAMPLES),
        "results/quality_control/clean_multiqc/multiqc_report.html",
        