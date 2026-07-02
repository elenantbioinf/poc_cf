##################################
# This rules is for calculate the coverage in interesting region
###################################


# Mosdepth rule

rule r07_01_coverage:
    input:
        bam_dedup = config["06_mark_duplicates"]["out_dir"] + "/{id}.dedup.bam",
        bai_dedup = config["06_mark_duplicates"]["out_dir"] + "/{id}.dedup.bam.bai",
        bed = config["target_region"]["bed"],
        script = "scripts/coverage_mosdepth.sh"
    output:
        regions = config["07_coverage"]["out_dir"] + "/{id}.regions.bed.gz"
    log:
        "logs/07_coverage/{id}.mosdepth.log"
    conda:
        "../envs/07_coverage.yml"
    params:
        thresholds = config["07_coverage"]["thresholds"],
        extra_args = config["07_coverage"]["extra_args"],
        prefix = config["07_coverage"]["out_dir"] + "/{id}"
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