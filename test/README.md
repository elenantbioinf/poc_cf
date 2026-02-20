# Test VCF files

This directory contains the VCF files used for testing and validation of the CFTR variant analysis pipeline.

Two types of test VCF files are included:

- **Empty VCF**: vcf_empty/
    Raw variant calls generated from the NA12878 sample.
    After filtering there were no variants. Therefore, this dataset is used as a negative control to validate the pipeline. 

- **Synthetic VCF**: vcf_synthetic/
    Modified VCF including a known CFTR pathogenic variant (e.g. F508del) for validation purposes as a positive control.

In addition, this directory includes the database_cftr/ subdirectory, that contains the CFTR BED file used for coverage analysis.