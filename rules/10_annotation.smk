##################################
# This module is for the annotation
###################################

# Extract variants from filtered.vcf and verification that there are
# variants to annotation

rule r10_01_extract_variants:
    input:
        vcf_filtered = "results/variant_filtering/{id}.filtered.vcf.gz",
        script = "scripts/extract_variants_from_vcf.sh"
    output:
        tsv = "results/annotation/{id}.variants.tsv",
        check = "results/annotation/{id}.variants_check.txt"
    log:
        "logs/10_annotation/{id}.extract_variants.log"
    conda:
        "../envs/annotation.yml"
    shell:
        """
        {input.script} {input.vcf_filtered} {output.tsv} {output.check} > {log} 2>&1
        """

# Annotation with rest api vep

rule r10_02_rest_vep_annotation:
    input:
        tsv = "results/annotation/{id}.variants.tsv",
        check = "results/annotation/{id}.variants_check.txt",
        script = "scripts/vep_rest_annotation.py"
    log:
        "logs/10_annotation/{id}.vep_rest_annotation.log"
    output:
        annotation = "results/annotation/{id}.vep.tsv"
    conda:
        "../envs/annotation.yml"
    shell:
        """
        python {input.script} {input.tsv} {input.check} {output.annotation} {wildcards.id} > {log} 2>&1
        """