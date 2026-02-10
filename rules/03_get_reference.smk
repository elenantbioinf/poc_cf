##################################
#This rule is to download and indexing the reference genome for the
#next steps
###################################


rule r03_01_get_reference:
    input:
        script = "scripts/get_reference.sh",
    output:
        fasta = config["reference"]["fasta"],
        fai = config["reference"]["fasta"] + ".fai",
        bwa_index = expand(
            config["reference"]["fasta"] + ".{ext}",
            ext = ["amb", "ann", "bwt", "pac", "sa"]
        )
    log:
        "logs/03_get_reference/get_reference.log"
    params: 
        url=config["reference"]["url"]
    conda:
        "../envs/get_reference.yml"
    shell: 
        """
        {input.script} {params.url} {output.fasta} > {log} 2>&1
        """
