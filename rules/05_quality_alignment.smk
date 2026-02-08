##################################
# This rules gives quality about the mapping process
###################################

#Flagstat analysis

rule r_05_01_alignment_flagstat:
    input:
        bam_sorted = "results/mapping/{id}.sorted.bam",
        bai = "results/mapping/{id}.sorted.bam.bai",
        script = "scripts/run_flagstat.sh"
    output:
        flagstat = "results/quality_alignment/{id}.flagstat.txt"
    log:
        "logs/05_quality_alignment/{id}.flagstat.log"
    conda:
        "../envs/quality_alignment.yml"
    threads: 10
    shell:
        """
        {input.script} {input.bam_sorted} {output.flagstat} {threads} > {log} 2>&1
        """

#Qualimap analysis

rule r_05_02_qualimap:
    input:
        bam_sorted ="results/mapping/{id}.sorted.bam",
        bai = "results/mapping/{id}.sorted.bam.bai",
        script = "scripts/run_qualimap.sh"
    output:
        qualimap_directory = directory("results/quality_alignment/qualimap/{id}")
    log:
        "logs/05_quality_alignment/{id}.qualimap.log"
    conda:
        "../envs/quality_alignment.yml"
    threads: 10
    shell:
        """
        {input.script} {input.bam_sorted} {output.qualimap_directory} {threads} > {log} 2>&1
        """