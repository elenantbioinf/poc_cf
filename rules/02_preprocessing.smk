##################################
#This rule is for all the preprocessing needed for the analysis
###################################


#TRIMMING WITH FASTP
rule r02_01_trimming_fastp:
    input:
        r1 = get_read1,
        r2 = get_read2,
        script = "scripts/run_fastp.sh"
    output:
        r1 = "data/clean/{id}_R1.trimmed.fastq.gz",
        r2 = "data/clean/{id}_R2.trimmed.fastq.gz",
        html = "results/preprocessing/{id}.fastp.html",
        json = "results/preprocessing/{id}.fastp.json"
    log:
        "logs/02_preprocessing/{id}.fastp.log"
    conda:
        "../envs/02_preprocessing.yml"
    params:
        minlen = get_minlen,
        extra = config["trimming"]["fastp_extra_args"]
    shell:
        """
        {input.script} \
            {input.r1} {input.r2} \
            {output.r1} {output.r2} \
            {output.html} {output.json} \
            {params.minlen} \
            "{params.extra}"
            > {log} 2>&1
        """

#QUALITY_CONTROL POST-TRIMMING WITH FASTQC AND MULTIQC

rule r02_02_clean_fastqc:
    input:
        r1 = "data/clean/{id}_R1.trimmed.fastq.gz",
        r2 = "data/clean/{id}_R2.trimmed.fastq.gz",
        script = "scripts/run_fastqc.sh"
    output:
        done = "results/quality_control/clean_fastqc/.done/{id}.fastqc.done"
    log:
        "logs/02_preprocessing/{id}.clean_fastqc.log"
    conda:
        "../envs/01_quality_control.yml"
    params:
        outdir = config["02_preprocessing"]["clean_fastqc_dir"]
    shell:
        """
        mkdir -p {params.outdir}/.done
        {input.script} {input.r1} {input.r2} {params.outdir} > {log} 2>&1
        touch {output.done}
        """

rule r02_03_clean_multiqc:
    input:  #Depend on .done directory
        done = expand("results/quality_control/clean_fastqc/.done/{id}.fastqc.done", id=SAMPLES),
        script = "scripts/multiqc.sh"
    output:
        "results/quality_control/clean_multiqc/multiqc_report.html"
    log:
        "logs/02_preprocessing/clean_multiqc.log"
    conda:
        "../envs/01_quality_control.yml"
    params:
        fastqc_dir = config["02_preprocessing"]["clean_fastqc_dir"],
        outdir = config["02_preprocessing"]["clean_multiqc_dir"]
    shell:
        """
         {input.script} {params.fastqc_dir} {params.outdir} > {log} 2>&1
        """