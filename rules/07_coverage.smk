##################################
# This rules is for calculate the coverage in interesting region
###################################


# Mosdepth rule

rule r_07_01_coverage:
    input:
        bam_dedup = "results/mark_duplicates/{id}.dedup.bam",
        bai_dedup = "results/mark_duplicates/{id}.dedup.bam.bai",
        bed = "data/database_cftr/cftr_mane_select_exons.bed",
        script = "scripts/coverage_mosdepth.sh"
    output:
        regions = "results/coverage/{id}.regions.bed.gz"
    log:
        "logs/07_coverage/{id}.mosdepth.log"
    conda:
        "../envs/coverage.yml"
    shell:
        """
        {input.script} {input.bam_dedup} {input.bed} results/coverage/{wildcards.id} > {log} 2>&1
        """