# This is the snakefile for the proyect poc_cf

#Configuration

configfile: "config/config.yml"

#Rules

include: "rules/common_utils.smk"
include: "rules/quality_control.smk"
include: "rules/preprocessing.smk"

#Goal rule with the final files

rule targets:
    input:
        #Quality_control
        expand("results/quality_control/fastqc/{id}_R1_fastqc.html", id = SAMPLES),
        expand("results/quality_control/fastqc/{id}_R2_fastqc.html", id = SAMPLES),
        expand("results/quality_control/fastqc/{id}_R1_fastqc.zip", id = SAMPLES),
        expand("results/quality_control/fastqc/{id}_R2_fastqc.zip", id = SAMPLES),
        "results/quality_control/multiqc/multiqc_report.html",
        #Preprocessing: trimming_fastp
        expand("data/clean/{id}_R1.trimmed.fastq.gz", id = SAMPLES),
        expand("data/clean/{id}_R2.trimmed.fastq.gz", id = SAMPLES),
        expand("results/preprocessing/{id}.fastp.html", id = SAMPLES),
        expand("results/preprocessing/{id}.fastp.json", id = SAMPLES)
        