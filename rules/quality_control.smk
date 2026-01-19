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
        done = "results/quality_control/fastqc/.done/{id}.fastqc.done"
    conda:
        "../envs/quality_control.yml"
    shell:
        """
        mkdir -p results/quality_control/fastqc/.done
        {input.script} {input.r1} {input.r2} results/quality_control/fastqc
        touch {output.done}
        """

rule raw_multiqc:
    input:  #Depend on ALL FastQC zip files
        done = expand("results/quality_control/fastqc/.done/{id}.fastqc.done", id=SAMPLES),
        script = "scripts/multiqc.sh"
    output:
        "results/quality_control/multiqc/multiqc_report.html"
    conda:
        "../envs/quality_control.yml"
    shell:
        """
         {input.script} results/quality_control/fastqc results/quality_control/multiqc
        """