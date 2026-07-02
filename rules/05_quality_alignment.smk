##################################
# This rules gives quality about the mapping process
###################################

#Flagstat analysis

rule r05_01_alignment_flagstat:
    input:
        bam_sorted = config["04_mapping"]["out_dir"] + "/{id}.sorted.bam",
        bai = config["04_mapping"]["out_dir"] + "/{id}.sorted.bam.bai",
        script = "scripts/run_flagstat.sh"
    output:
        flagstat = config["05_quality_alignment"]["flagstat_dir"] + "/{id}.flagstat.txt"
    log:
        "logs/05_quality_alignment/{id}.flagstat.log"
    conda:
        "../envs/05_quality_alignment.yml"
    threads: 10
    shell:
        """
        {input.script} {input.bam_sorted} {output.flagstat} {threads} > {log} 2>&1
        """

#Qualimap analysis

rule r05_02_qualimap:
    input:
        bam_sorted = config["04_mapping"]["out_dir"] + "/{id}.sorted.bam",
        bai = config["04_mapping"]["out_dir"] + "/{id}.sorted.bam.bai",
        script = "scripts/run_qualimap.sh"
    output:
        qualimap_directory = directory(config["05_quality_alignment"]["qualimap_dir"] + "/{id}")
    log:
        "logs/05_quality_alignment/{id}.qualimap.log"
    conda:
        "../envs/05_quality_alignment.yml"
    threads: 10
    params:
        java_mem = config["05_quality_alignment"]["qualimap_java_mem"],
        genome = config["05_quality_alignment"]["qualimap_genome"]
    shell:
        """
        {input.script} \
            {input.bam_sorted} \
            {output.qualimap_directory} \
            {threads} \
            {params.java_mem} \
            {params.genome} \
            > {log} 2>&1
        """