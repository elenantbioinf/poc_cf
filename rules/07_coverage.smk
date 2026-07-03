##################################
# These rules are for calculating the coverage in interesting regions
###################################


# Mosdepth rule

rule r07_01_coverage:
    input:
        bam_dedup = config["06_mark_duplicates"]["out_dir"] + "/{id}.dedup.bam",
        bai_dedup = config["06_mark_duplicates"]["out_dir"] + "/{id}.dedup.bam.bai",
        bed = config["target_region"]["bed"],
        script = "scripts/coverage_mosdepth.sh"
    output:
        regions = config["07_coverage"]["out_dir"] + "/{id}.regions.bed.gz",
        thresholds = config["07_coverage"]["out_dir"] + "/{id}.thresholds.bed.gz",
        per_base = config["07_coverage"]["out_dir"] + "/{id}.per-base.bed.gz"
    log:
        "logs/07_coverage/{id}.mosdepth.log"
    conda:
        "../envs/07_coverage.yml"
    params:
        thresholds = config["07_coverage"]["thresholds"],
        flag = config["07_coverage"]["flag"],
        prefix = config["07_coverage"]["out_dir"] + "/{id}"
    shell:
        """
        {input.script} \
            {input.bam_dedup} \
            {input.bed} \
            {params.prefix} \
            {params.thresholds} \
            {params.flag} \
            > {log} 2>&1
        """