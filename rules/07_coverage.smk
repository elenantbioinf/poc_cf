##################################
# This rules is for calculate the coverage in interesting region
###################################


# Mosdepth rule

rule r07_01_coverage:
    input:
        bam_dedup = "results/mark_duplicates/{id}.dedup.bam",
        bai_dedup = "results/mark_duplicates/{id}.dedup.bam.bai",
        bed = config["target_region"]["bed"],
        script = "scripts/coverage_mosdepth.sh"
    output:
        regions = "results/coverage/{id}.regions.bed.gz"
    log:
        "logs/07_coverage/{id}.mosdepth.log"
    conda:
        "../envs/coverage.yml"
    params:
        thresholds = config["07_coverage"]["thresholds"],
        extra_args = config["07_coverage"]["extra_args"],
        prefix = "results/coverage/{id}"
    shell:
        """
        {input.script} \
            {input.bam_dedup} \
            {input.bed} \
            {params.prefix} \
            {params.thresholds} \
            {params.extra_args} \
            > {log} 2>&1
        """