#!/usr/bin/env python3

###############################################
# This is the script to make annotation with VEP rest api
###############################################


#========================Importar librerias===========================
import requests 
import pandas as pd
import sys

#=============Variables=================================================

VARIANTS_TSV = sys.argv[1]
CHECK_TXT = sys.argv[2]
OUT_ANNOTATION = sys.argv[3]
SAMPLE_ID = sys.argv[4]

#=================Leer el archivo de control de variantes======================
with open(CHECK_TXT) as check:
    status = check.read().strip()

#Si no hay variantes, parar
if status == "NO VARIANTS DETECTED": 
    no_variants = pd.DataFrame([
        {
            "sample_id": SAMPLE_ID,
            "status": "NO VARIANTS DETECTED"
        }
    ])
    no_variants.to_csv(OUT_ANNOTATION, sep="\t", index=False)
    sys.exit(0)


#===========Lectura de la variante del tsv generado por bcftools query=================

with open(VARIANTS_TSV) as variant_file:
    next(variant_file)
    first_line = variant_file.readline()

chrom, pos, rs_id, ref, alt = first_line.strip().split("\t")

variant = f"{chrom} {pos} {rs_id} {ref} {alt}"

#====================Llamada al VEP rest api=================================

server = "https://rest.ensembl.org"

endpoint = "/vep/homo_sapiens/region"

payload = {
    "variants": [variant]
}

params = {
    "hgvs": 1,
    "mane": 1,
    "canonical": 1,
    "protein": 1,
    "numbers": 1,
    "variant_class": 1
}

headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
}

response = requests.post(
    server + endpoint,
    headers=headers,
    params=params,
    json=payload
)

data = response.json()


#=======================Creacion de la tabla=============================

table = data[0].get("transcript_consequences", [])

rows = []

for tab in table:
  rows.append({
      "sample_id": SAMPLE_ID,
      "gene": tab.get("gene_symbol"),
      "transcript": tab.get("transcript_id"),
      "consequence": ",".join(tab.get("consequence_terms", [])) if tab.get("consequence_terms") else None,
      "impact": tab.get("impact"),
      "hgvs_c": tab.get("hgvsc"),
      "protein": tab.get("hgvsp"),
      "MANE": tab.get("mane_select"),
      "canonical": tab.get("canonical"),
      "exon": tab.get("exon"),
  })

final_table = pd.DataFrame(rows)

final_table.to_csv(OUT_ANNOTATION, sep="\t", index=False)
