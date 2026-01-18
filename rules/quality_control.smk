############################################
#This is the rule to make a quality control analysis
#for the raw data
############################################

rule raw_fastqc:
    input:
        r1 = get_read1,
        r2 = get_read2,
        script = "scripts/run_fastqc.sh"
    output:
        "results/quality_control/fastqc/{id}_R1_fastqc.html",
        "results/quality_control/fastqc/{id}_R2_fastqc.html",
        "results/quality_control/fastqc/{id}_R1_fastqc.zip",
        "results/quality_control/fastqc/{id}_R2_fastqc.zip"
    conda:
        "../envs/quality_control.yml"
    shell:
        """
        {input.script} {input.r1} {input.r2} results/quality_control/fastqc
        """

rule raw_multiqc:
    input:
        expand("results/quality_control/fastqc/{id}_R1_fastqc.zip", id=SAMPLES),
        expand("results/quality_control/fastqc/{id}_R2_fastqc.zip", id=SAMPLES),
        script = "scripts/multiqc.sh"
    output:
        "results/quality_control/multiqc/multiqc_report.html"
    conda:
        "../envs/quality_control.yml"
    shell:
        """
         {input.script} results/quality_control/fastqc results/quality_control/multiqc
        """