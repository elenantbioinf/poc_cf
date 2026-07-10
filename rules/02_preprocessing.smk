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
        html = config["02_preprocessing"]["fastp_dir"] + "/{id}.fastp.html",
        json = config["02_preprocessing"]["fastp_dir"] + "/{id}.fastp.json"
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
            "{params.extra}" \
            > {log} 2>&1
        """

#QUALITY_CONTROL POST-TRIMMING WITH FASTQC AND MULTIQC

rule r02_02_clean_fastqc:
    input:
        r1 = "data/clean/{id}_R1.trimmed.fastq.gz",
        r2 = "data/clean/{id}_R2.trimmed.fastq.gz",
        script = "scripts/run_fastqc.sh"
    output:
        done = config["02_preprocessing"]["clean_fastqc_dir"] + "/.done/{id}.fastqc.done"
    log:
        "logs/02_preprocessing/{id}.clean_fastqc.log"
    conda:
        "../envs/01_quality_control.yml"
    params:
        outdir = config["02_preprocessing"]["clean_fastqc_dir"]
    shell:
        """
        mkdir -p {params.outdir}/.done
        {input.script} \
            {input.r1} {input.r2} \
            {params.outdir} > {log} 2>&1
        touch {output.done}
        """

rule r02_03_clean_multiqc:
    input: 
        done = config["02_preprocessing"]["clean_fastqc_dir"] + "/.done/{id}.fastqc.done",
        script = "scripts/multiqc.sh"
    output:
        html = config["02_preprocessing"]["clean_multiqc_dir"] + "/{id}/multiqc_report.html",
        fastqc_tsv = config["02_preprocessing"]["clean_multiqc_dir"] + "/{id}/multiqc_report_data/multiqc_fastqc.txt"
    log:
        "logs/02_preprocessing/{id}.clean_multiqc.log"
    conda:
        "../envs/01_quality_control.yml"
    params:
        fastqc_dir = config["02_preprocessing"]["clean_fastqc_dir"],
        outdir = config["02_preprocessing"]["clean_multiqc_dir"] + "/{id}"
    shell:
        """
        {input.script} \
            {params.fastqc_dir} \
            {params.outdir} \
            > {log} 2>&1
        """

rule r02_04_qc_summary:
    input:
        raw_multiqc = config["01_quality_control"]["raw_multiqc_dir"] + "/{id}/multiqc_report_data/multiqc_fastqc.txt",
        clean_multiqc = config["02_preprocessing"]["clean_multiqc_dir"] + "/{id}/multiqc_report_data/multiqc_fastqc.txt",
        script = "scripts/qc_summary.sh"
    output:
        qc_summary_tsv = config["02_preprocessing"]["qc_summary_dir"] + "/{id}.qc_summary.tsv"
    log:
        "logs/02_preprocessing/{id}.qc_summary.log"
    conda:
        "../envs/01_quality_control.yml"
    shell:
        """
        {input.script} \
            {input.raw_multiqc} \
            {input.clean_multiqc} \
            {output.qc_summary_tsv} \
            > {log} 2>&1
        """