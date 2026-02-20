# poc_cf 

Proof of concept for an automated and reproducible genetic diagnosis workflow for cystic fibrosis (CF)

**poc_cf** is a modular Snakemake-based pipeline designed as a proof of concept for automated analysis of CFTR variants from paired-end sequencing data.

The workflow follows reproducibility and FAIR principles by:

- Using a fully modular rule structure
- Managing dependencies through Conda environments
- Centralizing configuration in `config/config.yml`
- Separating production data from test datasets
- Providing a bootstrap initialization step

## Project initialization 

Before running the workflow, initialize the project structure:

```bash
./init.sh
```

This script reads directory paths from config/config.yml and creates the required base directories:
    data/
        clean/
        raw/
        reference/
    results/
    logs/
    visual/
    final_report/