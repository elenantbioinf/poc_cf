##################################
# This module is for the annotation
###################################

# Extract variants from filtered.vcf

rule r10_01_extract_variants:
    input:
        vcf_filtered = config["09_variant_filtering"]["out_dir"] + "/{id}.filtered.vcf.gz",
        script = "scripts/extract_variants_from_vcf.sh"
    output:
        tsv = config["10_annotation"]["out_dir"] + "/{id}.variants.tsv"
    log:
        "logs/10_annotation/{id}.extract_variants.log"
    conda:
        "../envs/10_annotation.yml"
    params:
        header = config["10_annotation"]["header"], 
        query_format = config["10_annotation"]["query_format"]
    shell:
        """
        {input.script} \
            {input.vcf_filtered} \
            {output.tsv} \
            "{params.header}" \
            "{params.query_format}" \
            > {log} 2>&1
        """

# Verification that there are variants to annotation

rule r10_02_check_variants:
    input:
        variant_tsv = config["10_annotation"]["out_dir"] + "/{id}.variants.tsv",
        script = "scripts/check_variants_tsv.sh"
    output:
        check = config["10_annotation"]["out_dir"] + "/{id}.variants_check.txt"
    log: 
        "logs/10_annotation/{id}.check_variants.log"
    conda:
        "../envs/10_annotation.yml"
    shell:
        """
        {input.script} {input.variant_tsv} {output.check} > {log} 2>&1
        """

# Annotation with rest api vep

rule r10_03_rest_vep_annotation:
    input:
        tsv = config["10_annotation"]["out_dir"] + "/{id}.variants.tsv",
        check = config["10_annotation"]["out_dir"] + "/{id}.variants_check.txt",
        script = "scripts/vep_rest_annotation.py"
    log:
        "logs/10_annotation/{id}.vep_rest_annotation.log"
    output:
        annotation = config["10_annotation"]["out_dir"] + "/{id}.vep.tsv"
    conda:
        "../envs/10_annotation.yml"
    shell:
        """
        python {input.script} {input.tsv} {input.check} {output.annotation} {wildcards.id} > {log} 2>&1
        """