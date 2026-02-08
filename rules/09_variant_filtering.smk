##################################
# This module is for filtering the variants
###################################

# Rule for filter

rule r_09_01_filter_bcftools:
    input:
        vcf = "results/variant_calling/{id}.vcf.gz",
        tbi = "results/variant_calling/{id}.vcf.gz.tbi",
        script = "scripts/filter_vcf_bcftools.sh"
    output:
        vcf_filtered = "results/variant_filtering/{id}.filtered.vcf.gz"
    log:
        "logs/09_variant_filtering/{id}.bcftools_filter.log"
    params:
        min_coverage = 5,
        min_quality = 20
    conda:
        "../envs/variant_filtering.yml"
    threads: 10
    shell:
        """
        {input.script} {input.vcf} {output.vcf_filtered} {params.min_coverage} {params.min_quality} {threads} > {log} 2>&1
        """

# Rule for index the filtered vcf file

rule r_09_02_vcf_filtered_index:
    input:
        vcf_filtered = "results/variant_filtering/{id}.filtered.vcf.gz",
        script = "scripts/vcf_index.sh"
    output:
        tbi = "results/variant_filtering/{id}.filtered.vcf.gz.tbi"
    log:
        "logs/09_variant_filtering/{id}.filtered_vcf_index.log"
    conda:
        "../envs/variant_filtering.yml"
    shell:
        """
        {input.script} {input.vcf_filtered} > {log} 2>&1
        """