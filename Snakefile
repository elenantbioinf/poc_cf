# This is the snakefile for the proyect poc_cf

#Configuration

configfile: "config/config.yml"

#Rules

include: "rules/00_common_utils.smk"
include: "rules/01_quality_control.smk"
include: "rules/02_preprocessing.smk"
include: "rules/03_get_reference.smk"
include: "rules/04_mapping.smk"
include: "rules/05_quality_alignment.smk"
include: "rules/06_mark_duplicates.smk"
include: "rules/07_coverage.smk"
include: "rules/08_variant_calling.smk"
include: "rules/09_variant_filtering.smk"
include: "rules/10_annotation.smk"
include: "rules/11_final_report.smk"

#Goal rule with the final files

rule all:
    input:
        #Quality_control in raw reads
        "results/quality_control/raw_multiqc/multiqc_report.html",
        #Preprocessing: trimming_fastp
        expand("data/clean/{id}_R1.trimmed.fastq.gz", id = SAMPLES),
        expand("data/clean/{id}_R2.trimmed.fastq.gz", id = SAMPLES),
        #Preprocessing: fastp reports
        expand("results/preprocessing/{id}.fastp.html", id = SAMPLES),
        expand("results/preprocessing/{id}.fastp.json", id = SAMPLES),
        #Preprocessing: Quality control after trimming
        "results/quality_control/clean_multiqc/multiqc_report.html",
        #Reference genome
        config["03_reference"]["fasta"],
        config["03_reference"]["fasta"] + ".fai",
        expand(
            config["03_reference"]["fasta"] + ".{ext}",
            ext = ["amb", "ann", "bwt", "pac", "sa"]
        ),
        #Mapping
        expand("results/mapping/{id}.sam", id = SAMPLES),
        #SAM_to_BAM
        expand("results/mapping/{id}.unsorted.bam", id=SAMPLES),
        #BAM_sorted:
        expand("results/mapping/{id}.sorted.bam", id=SAMPLES),
        #BAM_index:
        expand("results/mapping/{id}.sorted.bam.bai", id=SAMPLES),
        #Quality control in alignment:
        expand("results/quality_alignment/{id}.flagstat.txt", id=SAMPLES),
        expand("results/quality_alignment/qualimap/{id}", id=SAMPLES),
        ## Add read groups
        expand("results/mark_duplicates/{id}.sorted.rg.bam", id=SAMPLES),
        expand("results/mark_duplicates/{id}.sorted.rg.bam.bai", id=SAMPLES),
        #Mark duplicates
        expand("results/mark_duplicates/{id}.dedup.bam", id=SAMPLES),
        expand("results/mark_duplicates/{id}.dedup.bam.bai", id=SAMPLES),
        expand("results/mark_duplicates/{id}_mark_duplicates_metrics.txt", id=SAMPLES),
        #Coverage_CFTR:
        expand("results/coverage/{id}.regions.bed.gz", id=SAMPLES),
        #Variant_calling and index:
        expand("results/variant_calling/{id}.ori.vcf.gz", id=SAMPLES),
        expand("results/variant_calling/{id}.ori.vcf.gz.tbi", id=SAMPLES),
        #Variant marking and index:
        expand("results/variant_filtering/{id}.marked.vcf.gz", id=SAMPLES),
        expand("results/variant_filtering/{id}.marked.vcf.gz.tbi", id=SAMPLES),
        #Variant filtering and index:
        expand("results/variant_filtering/{id}.filtered.vcf.gz", id=SAMPLES),
        expand("results/variant_filtering/{id}.filtered.vcf.gz.tbi", id=SAMPLES),
        #Extract the variants from filtered.vcf:
        expand("results/annotation/{id}.variants.tsv", id=SAMPLES),
        #Check the variants tsv:
        expand("results/annotation/{id}.variants_check.txt", id=SAMPLES),
        #Annotation with vep rest:
        expand("results/annotation/{id}.vep.tsv", id=SAMPLES),
        #Generate the final report:
        expand("final_report/{id}.final_report.txt", id=SAMPLES)

#DAG execution

onsuccess:
    import os
    import subprocess
    dag_config = config["00_workflow_dag"]
    cwd = os.path.dirname(workflow.snakefile)
    subprocess.run(
        ["bash", "scripts/dag.sh", dag_config["dag_dir"], dag_config["log_dir"]],
        check=True,
        cwd=cwd
    )
    subprocess.run(
        ["bash", "scripts/dag_final_report.sh", 
        dag_config["dag_dir"], 
        dag_config["log_dir"],
        dag_config["final_target"]],
        check=True,
        cwd=cwd
    )