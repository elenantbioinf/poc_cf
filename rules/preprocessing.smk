##################################
#This rule is for all the preprocessing needed for the analysis
###################################

rule trimming_fastp:
    input:
        r1 = get_read1,
        r2 = get_read2,
        script = "scripts/run_fastp.sh"
    output:
        r1 = "data/clean/{id}_R1.trimmed.fastq.gz",
        r2 = "data/clean/{id}_R2.trimmed.fastq.gz",
        html = "results/preprocessing/{id}.fastp.html",
        json = "results/preprocessing/{id}.fastp.json"
    conda:
        "../envs/preprocessing.yml"
    params:
        minlen = get_minlen
    shell:
        """
        {input.script} {input.r1} {input.r2} {output.r1} {output.r2} {output.html} {output.json} {params.minlen}
        """

