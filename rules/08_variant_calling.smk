##################################
# This module is for variant calling
###################################

# Rule for variant calling with FreeBayes

rule variant_calling:
    input:
        bam_dedup = "results/mark_duplicates/{id}.dedup.bam",
        bai_dedup = "results/mark_duplicates/{id}.dedup.bam.bai",
        bed = "data/database_cftr/cftr_mane_select_exons.bed",
        ref = config["reference"]["fasta"],
        ref_fai = config["reference"]["fasta"] + ".fai",
        script = "scripts/run_freebayes.sh"
    output:
        vcf = "results/variant_calling/{id}.vcf.gz"
    conda:
        "../envs/variant_calling.yml"
    threads: 5
    shell:
        """
        {input.script} {input.bam_dedup} {input.ref} {input.bed} {output.vcf} {threads}
        """

# Rule for index the vcf file with tabix

rule vcf_index:
    input:
        vcf = "results/variant_calling/{id}.vcf.gz",
        script = "scripts/vcf_index.sh"
    output:
        tbi = "results/variant_calling/{id}.vcf.gz.tbi"
    conda:
        "../envs/variant_calling.yml"
    shell:
        """
        {input.script} {input.vcf}
        """