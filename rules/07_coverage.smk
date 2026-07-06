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

rule r07_02_filter_per_base_by_bed:
    input:
        per_base = config["07_coverage"]["out_dir"] + "/{id}.per-base.bed.gz",
        bed = config["target_region"]["bed"],
        script = "scripts/filter_per_base_by_bed.sh"
    output:
        bed_filtered = config["07_coverage"]["out_dir"] + "/{id}.target-per-base.bed.gz"
    log:
        "logs/07_coverage/{id}.filter_per_base_by_bed.log"
    conda:
        "../envs/07_coverage.yml"
    shell:
        """
        {input.script} \
            {input.per_base} \
            {input.bed} \
            {output.bed_filtered} \
            > {log} 2>&1
        """

rule r07_03_detect_coverage_gaps:
    input:
        bed = config["07_coverage"]["out_dir"] + "/{id}.target-per-base.bed.gz",
        script = "scripts/detect_coverage_gaps.py"
    output:
        tsv = config["07_coverage"]["out_dir"] + "/{id}.coverage_gaps.tsv"
    log:
        "logs/07_coverage/{id}.detect_coverage_gaps.log"
    conda:
        "../envs/07_coverage.yml"
    params:
        min_coverage = config["07_coverage"]["gap_min_coverage"]
    shell:
        """
        python {input.script} \
            {input.bed} \
            {output.tsv} \
            {wildcards.id} \
            {params.min_coverage} \
            > {log} 2>&1
        """
    