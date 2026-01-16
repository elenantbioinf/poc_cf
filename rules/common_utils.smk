###################################################################
#This rule brings together common variables to be accessed in other 
#rules/helper functions
###################################################################


#Read samples table

import pandas as pd 

    #samples.tsv has the following columns: sample_id, fastq_1,
    #fastq_2

sample_table = pd.read_table(
    config["samples_table"],
    dtype=str
).set_index("sample_id")

SAMPLES = sample_table.index.unique().tolist()


#Note for me: the function to read fastq will be done in
#future
