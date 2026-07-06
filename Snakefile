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
include: "rules/12_web_report.smk"

#Goal rule with the final files

rule all:
    input:
        #Quality_control in raw reads
        expand(config["01_quality_control"]["raw_multiqc_dir"] + "/{id}/multiqc_report.html", id=SAMPLES),
        
        #Preprocessing: trimming_fastp
        expand("data/clean/{id}_R1.trimmed.fastq.gz", id = SAMPLES),
        expand("data/clean/{id}_R2.trimmed.fastq.gz", id = SAMPLES),

        #Preprocessing: fastp reports
        expand(config["02_preprocessing"]["fastp_dir"] + "/{id}.fastp.html", id = SAMPLES),
        expand(config["02_preprocessing"]["fastp_dir"] + "/{id}.fastp.json", id = SAMPLES),
       
        #Preprocessing: Quality control after trimming
        expand(config["02_preprocessing"]["clean_multiqc_dir"] + "/{id}/multiqc_report.html", id=SAMPLES),
        
        #Reference genome
        config["03_reference"]["fasta"],
        config["03_reference"]["fasta"] + ".fai",
        expand(
            config["03_reference"]["fasta"] + ".{ext}",
            ext = ["amb", "ann", "bwt", "pac", "sa"]
        ),

        #Mapping
        expand(config["04_mapping"]["out_dir"] + "/{id}.sam", id = SAMPLES),
        #SAM_to_BAM
        expand(config["04_mapping"]["out_dir"] + "/{id}.unsorted.bam", id=SAMPLES),
        #BAM_sorted:
        expand(config["04_mapping"]["out_dir"] + "/{id}.sorted.bam", id=SAMPLES),
        #BAM_index:
        expand(config["04_mapping"]["out_dir"] + "/{id}.sorted.bam.bai", id=SAMPLES),
        
        #Quality control in alignment:
        expand(config["05_quality_alignment"]["flagstat_dir"] + "/{id}.flagstat.txt", id=SAMPLES),
        expand(config["05_quality_alignment"]["qualimap_dir"] + "/{id}", id=SAMPLES),

        ## Add read groups
        expand(config["06_mark_duplicates"]["out_dir"] + "/{id}.sorted.rg.bam", id=SAMPLES),
        expand(config["06_mark_duplicates"]["out_dir"] + "/{id}.sorted.rg.bam.bai", id=SAMPLES),

        #Mark duplicates
        expand(config["06_mark_duplicates"]["out_dir"] + "/{id}.dedup.bam", id=SAMPLES),
        expand(config["06_mark_duplicates"]["out_dir"] + "/{id}.dedup.bam.bai", id=SAMPLES),
        expand(config["06_mark_duplicates"]["out_dir"] + "/{id}_mark_duplicates_metrics.txt", id=SAMPLES),
        
        #Coverage_CFTR:
        expand(config["07_coverage"]["out_dir"] + "/{id}.regions.bed.gz", id=SAMPLES),
        expand(config["07_coverage"]["out_dir"] + "/{id}.thresholds.bed.gz", id=SAMPLES),
        expand(config["07_coverage"]["out_dir"] + "/{id}.per-base.bed.gz", id=SAMPLES),
        expand(config["07_coverage"]["out_dir"] + "/{id}.target-per-base.bed.gz", id=SAMPLES),

        #Variant_calling and index:
        expand(config["08_variant_calling"]["out_dir"] + "/{id}.ori.vcf.gz", id=SAMPLES),
        expand(config["08_variant_calling"]["out_dir"] + "/{id}.ori.vcf.gz.tbi", id=SAMPLES),

        #Variant marking and index:
        expand(config["09_variant_filtering"]["out_dir"] + "/{id}.marked.vcf.gz", id=SAMPLES),
        expand(config["09_variant_filtering"]["out_dir"] + "/{id}.marked.vcf.gz.tbi", id=SAMPLES),

        #Variant filtering and index:
        expand(config["09_variant_filtering"]["out_dir"] + "/{id}.filtered.vcf.gz", id=SAMPLES),
        expand(config["09_variant_filtering"]["out_dir"] + "/{id}.filtered.vcf.gz.tbi", id=SAMPLES),

        #Extract the variants from filtered.vcf:
        expand(config["10_annotation"]["out_dir"] + "/{id}.variants.tsv", id=SAMPLES),

        #Check the variants tsv:
        expand(config["10_annotation"]["out_dir"] + "/{id}.variants_check.txt", id=SAMPLES),
        
        #Annotation with vep rest:
        expand(config["10_annotation"]["out_dir"] + "/{id}.vep.tsv", id=SAMPLES),

        #Generate the final report:
        expand(config["11_final_report"]["out_dir"] + "/{id}.final_report.txt", id=SAMPLES),
        expand(config["11_final_report"]["out_dir"] + "/{id}.final_report.json", id=SAMPLES),

        #Generate the web report:
        expand(config["12_web_report"]["out_dir"] + "/{id}.web_report.html", id = SAMPLES)

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
        ["bash", "scripts/dag_web_report.sh", 
        dag_config["dag_dir"], 
        dag_config["log_dir"],
        dag_config["final_target"]],
        check=True,
        cwd=cwd
    )