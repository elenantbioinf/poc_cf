# Resources

This directory contains biological and reference resources required by the poc_cf workflow.

The directory structure is: 

```text
resources/ 
├── README.md 
├── database_cftr/ 
│   ├── README.md 
│   └── cftr_mane_select_exons.bed 
└── reference/ 
    └── README.md
```

Files that should be versioned:

- CFTR BED files
- README files
- Small manually curated resources required for reproducibility

Files that should not be versioned:

- Reference genome FASTA files
- Reference genome index files
- Large generated resources
- Temporary files produced during workflow execution