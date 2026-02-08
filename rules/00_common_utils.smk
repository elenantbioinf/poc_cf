###################################################################
#This rule brings together common variables to be accessed in other 
#rules/helper functions
###################################################################

import os
import pandas as pd 

#READ SAMPLES.TSV, THE SAMPLE-TABLE
#samples.tsv has the following columns: sample_id, fastq_1, fastq_2
#you need to change for your own raw data

sample_table = pd.read_table(
    config["samples_table_path"],
    dtype=str
).set_index("sample_id")

SAMPLES = sample_table.index.unique().tolist()


#FUNCTION FOR FASTQ FILES

#return R1 path for a given sample_id from samples.tsv
def get_read1(wildcards):
    return sample_table.loc[wildcards.id, "fastq_1"]

#return R2 path for a given sample_id from samples.tsv
def get_read2(wildcards):
    return sample_table.loc[wildcards.id, "fastq_2"]

#return basename without extensions
def get_fastq_basename(path: str) -> str:
    filename = os.path.basename(path)
    possible_ext = [".fastq.gz", ".fq.gz", ".fastq", ".fq"]
    for e in possible_ext:
        if filename.endswith(e):
            return filename[:-len(e)]
    return os.path.splitext(filename)[0]

#get the basename for R1
def get_r1_base(wildcards):
    return get_fastq_basename(get_read1(wildcards))

#get the basename for R2
def get_r2_base(wildcards):
    return get_fastq_basename(get_read2(wildcards))

#Function to know the lenght of trimming

def get_minlen(wildcards):
    return config["trimming"]["min_length"]
