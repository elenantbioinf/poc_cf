# This is the snakefile for the proyect poc_cf

#Configuration

configfile: "config/config.yml"

include: "rules/common_utils.smk"
include: "rules/quality_control.smk"

rule targets:
    input:
        expand("results/quality_control/fastqc/{id}_R1_fastqc.html", id = SAMPLES),
        expand("results/quality_control/fastqc/{id}_R2_fastqc.html", id = SAMPLES),
        expand("results/quality_control/fastqc/{id}_R1_fastqc.zip", id = SAMPLES),
        expand("results/quality_control/fastqc/{id}_R2_fastqc.zip", id = SAMPLES),
        "results/quality_control/multiqc/multiqc_report.html"