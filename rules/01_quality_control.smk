############################################
#This is the rule to make a quality control analysis
#for the raw data
############################################

rule r01_01_raw_fastqc:
    input:
        r1 = get_read1,
        r2 = get_read2,
        script = "scripts/run_fastqc.sh"
    output:
        done = "results/quality_control/raw_fastqc/.done/{id}.fastqc.done"
    log:
        "logs/01_quality_control/{id}.raw_fastqc.log"
    conda:
        "../envs/01_quality_control.yml"
    params:
        outdir = config["01_quality_control"]["raw_fastqc_dir"]
    shell:
        """
        mkdir -p {params.outdir}/.done
        {input.script} {input.r1} {input.r2} {params.outdir} > {log} 2>&1
        touch {output.done}
        """

rule r01_02_raw_multiqc:
    input:
        done = expand("results/quality_control/raw_fastqc/.done/{id}.fastqc.done", id=SAMPLES),
        script = "scripts/multiqc.sh"
    output:
        config["01_quality_control"]["raw_multiqc_dir"] + "/multiqc_report.html"
    conda:
        "../envs/01_quality_control.yml"
    log:
        "logs/01_quality_control/raw_multiqc.log"
    params:
        fastqc_dir = config["01_quality_control"]["raw_fastqc_dir"],
        outdir = config["01_quality_control"]["raw_multiqc_dir"]
    shell:
        """
        {input.script} {params.fastqc_dir} {params.outdir} > {log} 2>&1
        """
