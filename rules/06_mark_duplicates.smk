##################################
# This rules is for mark the duplicates in bam file
###################################


# Add Read Groups
rule r_06_01_add_read_groups:
    input:
        bam_sorted = "results/mapping/{id}.sorted.bam",
        script = "scripts/add_read_groups.sh"
    output:
        bam_rg = "results/mark_duplicates/{id}.sorted.rg.bam",
        bai_rg = "results/mark_duplicates/{id}.sorted.rg.bam.bai"
    conda:
        "../envs/mark_duplicates.yml"
    threads: 4
    shell:
        """
        {input.script} {input.bam_sorted} {output.bam_rg} {wildcards.id} {threads}
        """


# Mark duplicates using Picard
rule r_06_02_mark_duplicates:
    input:
        bam_rg = "results/mark_duplicates/{id}.sorted.rg.bam",
        bai_rg = "results/mark_duplicates/{id}.sorted.rg.bam.bai",
        script = "scripts/run_picard.sh"
    output:
        bam_dedup = "results/mark_duplicates/{id}.dedup.bam",
        bai_dedup = "results/mark_duplicates/{id}.dedup.bam.bai",
        metrics = "results/mark_duplicates/{id}_mark_duplicates_metrics.txt"
    conda:
        "../envs/mark_duplicates.yml"
    threads: 4
    shell:
        """
        {input.script} {input.bam_rg} {output.bam_dedup} {output.metrics} {threads}
        """

