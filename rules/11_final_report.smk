##################################
# This module is for the generation of final report
###################################

rule r11_01_final_report:
    input:
        script = "scripts/final_report.py",
        annotation = "results/annotation/{id}.vep.tsv",
        check = "results/annotation/{id}.variants_check.txt"
    output:
        report_txt = "final_report/{id}.final_report.txt",
        json = "final_report/{id}.final_report.json"
    log:
        "logs/11_final_report/{id}.final_report.log"
    conda:
        "../envs/11_final_report.yml"
    params:
        reference = config["03_reference"]["genome_build"],
        out_dir = config["11_final_report"]["out_dir"],
        disease = config["11_final_report"]["disease"],
        gene = config["11_final_report"]["gene"],
        sample_id = "{id}"
    shell:
        """
        python {input.script} \
            {input.annotation} \
            {input.check} \
            {output.report_txt} \
            "{params.out_dir}" \
            "{params.disease}" \
            "{params.gene}" \
            "{params.reference}" \
            "{params.sample_id}" \
            > {log} 2>&1
        """