##################################
# This rules gives quality about the mapping process
###################################

#Flagstat analysis

rule alignment_flagstat:
    input:
        bam_sorted = "results/mapping/{id}.sorted.bam",
        bai = "results/mapping/{id}.sorted.bam.bai",
        script = "scripts/run_flagstat.sh"
    output:
        flagstat = "results/quality_alignment/{id}.flagstat.txt"
    conda:
        "../envs/quality_alignment.yml"
    threads: 10
    shell:
        """
        {input.script} {input.bam_sorted} {output.flagstat} {threads}
        """

#Qualimap analysis

rule qualimap:
    input:
        bam_sorted ="results/mapping/{id}.sorted.bam",
        bai = "results/mapping/{id}.sorted.bam.bai",
        script = "scripts/run_qualimap.sh"
    output:
        qualimap_directory = directory("results/quality_alignment/qualimap/{id}")
    conda:
        "../envs/quality_alignment.yml"
    threads: 10
    shell:
        """
        {input.script} {input.bam_sorted} {output.qualimap_directory} {threads}
        """