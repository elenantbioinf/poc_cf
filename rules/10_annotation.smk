##################################
# This module is for the annotation
###################################

# Extract variants from filtered.vcf

rule extract_variants:
    input:
        vcf_filtered = "results/variant_filtering/{id}.filtered.vcf.gz",
        script = "scripts/extract_variants_from_vcf.sh"
    output:
        tsv = "results/annotation/{id}.variants.tsv"
    conda:
        "../envs/annotation.yml"
    shell:
        """
        {input.script} {input.vcf_filtered} {output.tsv}
        """