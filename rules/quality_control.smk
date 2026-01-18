############################################
#This is the rule to make a quality control analysis
#for the raw data
############################################

rule raw_fastqc:
    input:
        r1 = "data/raw/{id}_R1.fastq.gz",
        r2 = "data/raw/{id}_R2.fastq.gz",
        script = "scripts/run_fastqc.sh"
    output:
        "results/quality_control/{id}_R1_fastqc.html",
        "results/quality_control/{id}_R2_fastqc.html",
        "results/quality_control/{id}_R1_fastqc.zip",
        "results/quality_control/{id}_R2_fastqc.zip"
    conda:
        "../envs/quality_control.yml"
    shell:
        """
        {input.script} {input.r1} {input.r2} results/quality_control
        """