##################################
# This module is for filtering the variants
###################################

# Rule for mark variants

rule r09_01_mark_variants_bcftools:
    input:
        vcf = config["08_variant_calling"]["out_dir"] + "/{id}.ori.vcf.gz",
        tbi = config["08_variant_calling"]["out_dir"] + "/{id}.ori.vcf.gz.tbi",
        script = "scripts/mark_variants_bcftools.sh"
    output:
        vcf_marked = config["09_variant_filtering"]["out_dir"] + "/{id}.marked.vcf.gz"
    log:
        "logs/09_variant_filtering/{id}.bcftools_mark.log"
    params:
        min_coverage = config["09_variant_filtering"]["min_coverage"],
        min_quality = config["09_variant_filtering"]["min_quality"]
    conda:
        "../envs/09_variant_filtering.yml"
    threads: 10
    shell:
        """
        {input.script} \
            {input.vcf} \
            {output.vcf_marked} \
            {params.min_coverage} \
            {params.min_quality} \
            {threads} \
            > {log} 2>&1
        """

# Rule for index the marked vcf file

rule r09_02_vcf_marked_index:
    input:
        vcf_marked = config["09_variant_filtering"]["out_dir"] + "/{id}.marked.vcf.gz",
        script = "scripts/vcf_index.sh"
    output:
        tbi_marked = config["09_variant_filtering"]["out_dir"] + "/{id}.marked.vcf.gz.tbi"
    log:
        "logs/09_variant_filtering/{id}.marked_vcf_index.log"
    conda:
        "../envs/09_variant_filtering.yml"
    shell:
        """
        {input.script} {input.vcf_marked} > {log} 2>&1
        """

# Rule for filtering marked variants

rule r09_03_filter_pass:
    input:
        vcf_marked = config["09_variant_filtering"]["out_dir"] + "/{id}.marked.vcf.gz",
        tbi_marked = config["09_variant_filtering"]["out_dir"] + "/{id}.marked.vcf.gz.tbi",
        script = "scripts/filter_pass_variants.sh"
    output:
        vcf_filtered = config["09_variant_filtering"]["out_dir"] + "/{id}.filtered.vcf.gz"
    log:
        "logs/09_variant_filtering/{id}.filter_pass.log"
    conda:
        "../envs/09_variant_filtering.yml"
    threads: 10
    shell:
        """
        {input.script} {input.vcf_marked} {output.vcf_filtered} {threads} > {log} 2>&1
        """

# Rule for index the filtered vcf

rule r09_04_filtered_vcf_index:
    input:
        vcf = config["09_variant_filtering"]["out_dir"] + "/{id}.filtered.vcf.gz",
        script = "scripts/vcf_index.sh"
    output:
        tbi = config["09_variant_filtering"]["out_dir"] + "/{id}.filtered.vcf.gz.tbi"
    log:
        "logs/09_variant_filtering/{id}.filtered_vcf_index.log"
    conda:
        "../envs/09_variant_filtering.yml"
    shell:
        """
        {input.script} {input.vcf} > {log} 2>&1
        """
        