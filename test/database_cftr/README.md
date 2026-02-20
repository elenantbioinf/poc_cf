# CFTR database


This directory contains CFTR-specific resources used by the pipeline,
such as BED files defining the target exonic regions of the CFTR gene.

The files included here are provided as a reference example to the
the correct execution of the workflow. A BED file defining the genomic
coordinates of the target region is required for coverage calculation
and variant calling restricted to CFTR.

These files are considered part of the project database and are
version-controlled to guarantee reproducibility.

If you have an alternative BED file it can be used instead by updating the path in config.yml.