##################################
# This rules is for mark the duplicates in bam file
###################################


# Add Read Groups
rule r06_01_add_read_groups:
    input:
        bam_sorted = "results/mapping/{id}.sorted.bam",
        script = "scripts/add_read_groups.sh"
    output:
        bam_rg = "results/mark_duplicates/{id}.sorted.rg.bam"
    log:
        "logs/06_mark_duplicates/{id}.add_read_groups.log"
    conda:
        "../envs/mark_duplicates.yml"
    shell:
        """
        {input.script} {input.bam_sorted} {output.bam_rg} {wildcards.id} > {log} 2>&1
        """

# Index rg.bam

rule r06_02_index_rg_bam:
    input:
        bam_rg = "results/mark_duplicates/{id}.sorted.rg.bam",
        script = "scripts/bam_index.sh"
    output:
        bai_rg = "results/mark_duplicates/{id}.sorted.rg.bam.bai"
    log:
        "logs/06_mark_duplicates/{id}.index_rg_bam.log"
    conda:
        "../envs/mark_duplicates.yml"
    threads: 2
    shell:
        """
        {input.script} {input.bam_rg} {threads} > {log} 2>&1
        """

# Mark duplicates using Picard
rule r06_03_mark_duplicates:
    input:
        bam_rg = "results/mark_duplicates/{id}.sorted.rg.bam",
        bai_rg = "results/mark_duplicates/{id}.sorted.rg.bam.bai",
        script = "scripts/mark_duplicates.sh"
    output:
        bam_dedup = "results/mark_duplicates/{id}.dedup.bam",
        metrics = "results/mark_duplicates/{id}_mark_duplicates_metrics.txt"
    log:
        "logs/06_mark_duplicates/{id}.mark_duplicates.log"
    conda:
        "../envs/mark_duplicates.yml"
    shell:
        """
        {input.script} {input.bam_rg} {output.bam_dedup} {output.metrics} > {log} 2>&1
        """

# Index dedup.bam
rule r06_04_index_dedup_bam:
    input:
        bam_dedup = "results/mark_duplicates/{id}.dedup.bam",
        script = "scripts/bam_index.sh"
    output:
        bai_dedup = "results/mark_duplicates/{id}.dedup.bam.bai"
    log:
        "logs/06_mark_duplicates/{id}.index_dedup_bam.log"
    conda:
        "../envs/mark_duplicates.yml"
    threads: 2
    shell: 
        """
        {input.script} {input.bam_dedup} {threads} > {log} 2>&1
        """