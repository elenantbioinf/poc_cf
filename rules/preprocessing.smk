##################################
#This rule is for all the preprocessing needed for the analysis
###################################


#TRIMMING WITH FASTP
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

#QUALITY_CONTROL POST-TRIMMING WITH FASTQC AND MULTIQC

rule clean_fastqc:
    input:
        r1 = "data/clean/{id}_R1.trimmed.fastq.gz",
        r2 = "data/clean/{id}_R2.trimmed.fastq.gz",
        script = "scripts/run_fastqc.sh"
    output:
        done = "results/quality_control/clean_fastqc/.done/{id}.fastqc.done"
    conda:
        "../envs/quality_control.yml"
    shell:
        """
        mkdir -p results/quality_control/clean_fastqc/.done
        {input.script} {input.r1} {input.r2} results/quality_control/clean_fastqc
        touch {output.done}
        """

rule clean_multiqc:
    input:  #Depend on .done directory
        done = expand("results/quality_control/clean_fastqc/.done/{id}.fastqc.done", id=SAMPLES),
        script = "scripts/multiqc.sh"
    output:
        "results/quality_control/clean_multiqc/multiqc_report.html"
    conda:
        "../envs/quality_control.yml"
    shell:
        """
         {input.script} results/quality_control/clean_fastqc results/quality_control/clean_multiqc
        """