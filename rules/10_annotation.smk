##################################
# This module is for the annotation
###################################

# Extract variants from filtered.vcf and verification that there are
# variants to annotation

rule extract_variants:
    input:
        vcf_filtered = "results/variant_filtering/{id}.filtered.vcf.gz",
        script = "scripts/extract_variants_from_vcf.sh"
    output:
        tsv = "results/annotation/{id}.variants.tsv",
        check = "results/annotation/{id}.variants_check.txt"
    conda:
        "../envs/annotation.yml"
    shell:
        """
        {input.script} {input.vcf_filtered} {output.tsv} {output.check}
        """
