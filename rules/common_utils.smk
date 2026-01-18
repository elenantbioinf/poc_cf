###################################################################
#This rule brings together common variables to be accessed in other 
#rules/helper functions
###################################################################


#Read samples table
#samples.tsv has the following columns: sample_id, fastq_1, #fastq_2

import pandas as pd 

sample_table = pd.read_table(
    config["samples_table"],
    dtype=str
).set_index("sample_id")

SAMPLES = sample_table.index.unique().tolist()


#Function to read fastq files, to get the name

def get_read1(wildcards):
    return sample_table.loc[wildcards.id, "fastq_1"]

def get_read2(wildcards):
    return sample_table.loc[wildcards.id, "fastq_2"]


#Function to know the lenght of trimming

def get_minlen(wildcards):
    return config["trimming"]["min_length"]
