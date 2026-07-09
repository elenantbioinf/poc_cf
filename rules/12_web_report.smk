##################################
# This module is for the generation of web report
###################################

rule r12_01_render_rmd:
    input:
        script = "scripts/render_web_report.R",
        rmd = config["12_web_report"]["rmd_template"],
        final_report_json = "final_report/{id}.final_report.json",
        coverage_plot = config["07_coverage"]["out_dir"] + "/{id}.target_region_evaluability.png"
    output:
        html = config["12_web_report"]["out_dir"] + "/{id}.web_report.html"
    log:
        "logs/12_web_report/{id}.web_report.log"
    conda:
        "../envs/12_web_report.yml"
    shell:
        """
        Rscript {input.script} \
            {input.rmd} \
            {output.html} \
            {input.final_report_json} \
            {input.coverage_plot} \
            > {log} 2>&1
        """