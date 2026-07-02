##################################
# This module is for variant calling
###################################

# Rule for variant calling with FreeBayes

rule r08_01_variant_calling:
    input:
        bam_dedup = config["06_mark_duplicates"]["out_dir"] + "/{id}.dedup.bam",
        bai_dedup = config["06_mark_duplicates"]["out_dir"] + "/{id}.dedup.bam.bai",
        bed = config["target_region"]["bed"],
        ref = config["03_reference"]["fasta"],
        ref_fai = config["03_reference"]["fasta"] + ".fai",
        script = "scripts/run_freebayes.sh"
    output:
        vcf = config["08_variant_calling"]["out_dir"] + "/{id}.ori.vcf.gz"
    log:
        "logs/08_variant_calling/{id}.freebayes.log"
    conda:
        "../envs/08_variant_calling.yml"
    params:
        extra_args = config["08_variant_calling"]["extra_args"]
    shell:
        """
        {input.script} \
            {input.bam_dedup} \
            {input.ref} \
            {input.bed} \
            {output.vcf} \
            "{params.extra_args}" \
            > {log} 2>&1
        """

# Rule for index the vcf file with tabix

rule r08_02_vcf_index:
    input:
        vcf = config["08_variant_calling"]["out_dir"] + "/{id}.ori.vcf.gz",
        script = "scripts/vcf_index.sh"
    output:
        tbi = config["08_variant_calling"]["out_dir"] + "/{id}.ori.vcf.gz.tbi"
    log:
        "logs/08_variant_calling/{id}.vcf_index.log"
    conda:
        "../envs/08_variant_calling.yml"
    shell:
        """
        {input.script} {input.vcf} > {log} 2>&1
        """