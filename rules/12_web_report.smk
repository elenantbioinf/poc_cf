##################################
# This module is for the generation of web report
###################################

rule r12_01_render_rmd:
    input:
        script = "scripts/render_web_report.R",
        rmd = config["12_web_report"]["rmd_template"],
        final_report_json = config["12_web_report"]["out_dir"] + "/{id}.final_report.json",
        qc_summary = config["02_preprocessing"]["qc_summary_dir"] + "/{id}.qc_summary.tsv",
        raw_multiqc = config["01_quality_control"]["raw_multiqc_dir"] + "/{id}/multiqc_report.html",
        clean_multiqc = config["02_preprocessing"]["clean_multiqc_dir"] + "/{id}/multiqc_report.html",
        coverage_plot = config["07_coverage"]["out_dir"] + "/{id}.target_region_evaluability.png",
        coverage_gaps = config["07_coverage"]["out_dir"] + "/{id}.coverage_gaps.tsv",
        target_bed = config["target_region"]["bed"]
    output:
        html = config["12_web_report"]["out_dir"] + "/{id}.web_report.html"
    log:
        "logs/12_web_report/{id}.web_report.log"
    conda:
        "../envs/12_web_report.yml"
    params:
        gap_min_coverage = config["07_coverage"]["gap_min_coverage"]
    shell:
        """
        Rscript {input.script} \
            {input.rmd} \
            {output.html} \
            {input.final_report_json} \
            {input.qc_summary} \
            {input.raw_multiqc} \
            {input.clean_multiqc} \
            {input.coverage_plot} \
            {input.coverage_gaps} \
            {input.target_bed} \
            {params.gap_min_coverage} \
            > {log} 2>&1
        """