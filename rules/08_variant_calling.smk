##################################
# This module is for variant calling
###################################

# Rule for variant calling with FreeBayes

rule r08_01_variant_calling:
    input:
        bam_dedup = "results/mark_duplicates/{id}.dedup.bam",
        bai_dedup = "results/mark_duplicates/{id}.dedup.bam.bai",
        bed = "data/database_cftr/cftr_mane_select_exons.bed",
        ref = config["03_reference"]["fasta"],
        ref_fai = config["03_reference"]["fasta"] + ".fai",
        script = "scripts/run_freebayes.sh"
    output:
        vcf = "results/variant_calling/{id}.ori.vcf.gz"
    log:
        "logs/08_variant_calling/{id}.freebayes.log"
    conda:
        "../envs/variant_calling.yml"
    threads: 5
    shell:
        """
        {input.script} {input.bam_dedup} {input.ref} {input.bed} {output.vcf} {threads} > {log} 2>&1
        """

# Rule for index the vcf file with tabix

rule r08_02_vcf_index:
    input:
        vcf = "results/variant_calling/{id}.ori.vcf.gz",
        script = "scripts/vcf_index.sh"
    output:
        tbi = "results/variant_calling/{id}.ori.vcf.gz.tbi"
    log:
        "logs/08_variant_calling/{id}.vcf_index.log"
    conda:
        "../envs/variant_calling.yml"
    shell:
        """
        {input.script} {input.vcf} > {log} 2>&1
        """