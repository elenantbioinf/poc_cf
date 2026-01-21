##################################
#This rule is to mapping
###################################

rule bwa_mapping:
    input:
        script = "scripts/run_mapping.sh",
        r1 = expand("data/clean/{id}_R1.trimmed.fastq.gz", id = SAMPLES),
        r2 = expand("data/clean/{id}_R2.trimmed.fastq.gz", id = SAMPLES),
        reference = config["reference"]["fasta"],
        bwa_index = expand(
            config["reference"]["fasta"] + ".{ext}",
            ext = ["amb", "ann", "bwt", "pac", "sa"]
        )
    output:
        sam = "results/mapping/{id}.sam",
        error = "results/mapping/stderr/{id}.error"
    conda:
        "../envs/mapping.yml"
    threads: 10
    shell:
        """
        {input.script} {input.reference} {input.r1} {input.r2} {output.sam} {output.error} {threads}
        """