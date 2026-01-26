##################################
# This module is for filtering the variants
###################################

# Rule for filter

rule filter_bcftools:
    input:
        vcf = "results/variant_calling/{id}.vcf.gz",
        tbi = "results/variant_calling/{id}.vcf.gz.tbi",
        script = "scripts/filter_vcf_bcftools.sh"
    output:
        vcf_filtered = "results/variant_filtering/{id}.filtered.vcf.gz"
    params:
        min_coverage = 5,
        min_quality = 20
    conda:
        "../envs/variant_filtering.yml"
    threads: 10
    shell:
        """
        {input.script} {input.vcf} {output.vcf_filtered} {params.min_coverage} {params.min_quality} {threads}
        """

# Rule for index the filtered vcf file

rule vcf_filtered_index:
    input:
        vcf_filtered = "results/variant_filtering/{id}.filtered.vcf.gz",
        script = "scripts/vcf_index.sh"
    output:
        tbi = "results/variant_filtering/{id}.filtered.vcf.gz.tbi"
    conda:
        "../envs/variant_filtering.yml"
    shell:
        """
        {input.script} {input.vcf_filtered}
        """