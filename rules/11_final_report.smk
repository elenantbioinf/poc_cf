##################################
# This module is for the generation of final report
###################################

rule r_11_01_final_report:
    input:
        script = "scripts/final_report.py",
        annotation = "results/annotation/{id}.vep.tsv",
        check = "results/annotation/{id}.variants_check.txt"
    output:
        report = "final_report/{id}.final_report.txt"
    conda:
        "../envs/final_report.yml"
    shell:
        """
        python {input.script} {input.annotation} {input.check} {output.report}
        """