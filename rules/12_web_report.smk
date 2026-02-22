##################################
# This module is for the generation of web report
###################################

rule r12_01_render_rmd:
    input:
        script = "scripts/render_web_report.R",
        rmd = "reports/web_report.Rmd",
        final_report = "final_report/NA12878rep1-4.final_report.txt"
    output:
        html = "final_report/web_report.html"
    log:
        "logs/12_web_report/web_report.log"
    conda:
        "../envs/12_web_report.yml"
    shell:
        """
        Rscript {input.script} > {log} 2>&1
        """