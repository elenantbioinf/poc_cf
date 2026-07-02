##################################
#This rule is to mapping
###################################


#Rule to do the mapping

rule r04_01_bwa_mapping:
    input:
        script = "scripts/run_mapping.sh",
        r1 = "data/clean/{id}_R1.trimmed.fastq.gz",
        r2 = "data/clean/{id}_R2.trimmed.fastq.gz",
        reference = config["03_reference"]["fasta"],
        bwa_index = expand(
            config["03_reference"]["fasta"] + ".{ext}",
            ext = ["amb", "ann", "bwt", "pac", "sa"]
        )
    output:
        sam = config["04_mapping"]["out_dir"] + "/{id}.sam"
    log:
        "logs/04_mapping/{id}.bwa_mapping.log"
    conda:
        "../envs/04_mapping.yml"
    threads: 10
    shell:
        """
        {input.script} {input.reference} {input.r1} {input.r2} {output.sam} {threads} > {log} 2>&1
        """

#Rule to transform the sam file into bam fle

rule r04_02_sam_to_bam:
    input:
        sam = config["04_mapping"]["out_dir"] + "/{id}.sam",
        script = "scripts/sam_to_bam.sh"
    output:
        bam_unsorted = config["04_mapping"]["out_dir"] + "/{id}.unsorted.bam"
    log:
        "logs/04_mapping/{id}.sam_to_bam.log"
    conda:
        "../envs/04_mapping.yml"
    threads: 10
    shell:
        """
        {input.script} {input.sam} {output.bam_unsorted} {threads} > {log} 2>&1
        """

#Rule to sort the bam file

rule r04_03_bam_sort:
    input:
        bam_unsorted = config["04_mapping"]["out_dir"] + "/{id}.unsorted.bam",
        script = "scripts/bam_sort.sh"
    output:
        bam_sorted = config["04_mapping"]["out_dir"] + "/{id}.sorted.bam"
    log:
        "logs/04_mapping/{id}.bam_sort.log"
    conda: 
        "../envs/04_mapping.yml"
    threads: 10
    shell:
        """
        {input.script} {input.bam_unsorted} {output.bam_sorted} {threads} > {log} 2>&1
        """

#Rule to index the bam_sorted file

rule r04_04_bam_index:
    input:
        bam_sorted = config["04_mapping"]["out_dir"] + "/{id}.sorted.bam",
        script = "scripts/bam_index.sh"
    output:
        bam_index = config["04_mapping"]["out_dir"] + "/{id}.sorted.bam.bai"
    log:
        "logs/04_mapping/{id}.bam_index.log"
    conda: 
        "../envs/04_mapping.yml"
    threads: 2
    shell:
        """
        {input.script} {input.bam_sorted} {threads} > {log} 2>&1
        """
