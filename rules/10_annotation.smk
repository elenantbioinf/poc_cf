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

# Annotation with rest api vep

rule rest_vep_annotation:
    input:
        tsv = "results/annotation/{id}.variants.tsv",
        check = "results/annotation/{id}.variants_check.txt",
        script = "scripts/vep_rest_annotation.py"
    output:
        annotation = "results/annotation/{id}.vep.tsv"
    conda:
        "../envs/annotation.yml"
    shell:
        """
        python {input.script} {input.tsv} {input.check} {output.annotation} {wildcards.id}
        """