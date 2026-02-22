#!/usr/bin/env python3

###############################################
# This is the script to generate the final report
###############################################

import sys
import os
import json


#================Variables necesarias=========================

ANNOTATION_TSV = sys.argv[1]
CHECK_TXT = sys.argv[2]
OUT_TXT = sys.argv[3]
OUT_JSON = os.path.splitext(OUT_TXT)[0] + ".json"
OUTDIR = sys.argv[4]
DISEASE = sys.argv[5]
GENE = sys.argv[6]
REFERENCE = sys.argv[7]
SAMPLE_ID = sys.argv[8]



#=================Lectura del archivo de chequeo==========

with open(CHECK_TXT) as check:
    status = check.read().strip()

#=================Creación de la cabecera del reporte final==========

report_text = []
report_text.append("FINAL ANALYSIS REPORT\n\n")
report_text.append(f"Sample ID: {SAMPLE_ID}\n")
report_text.append(f"Disease: {DISEASE}\n")
report_text.append(f"Target gene: {GENE}\n")
report_text.append(f"Reference genome: {REFERENCE}\n\n")

#=================Creación de diccionario JSON==========

report_json = {
    "sample_id": SAMPLE_ID,
    "disease": DISEASE,
    "gene": GENE,
    "reference_genome": REFERENCE,
    "status": status,
    "summary": {},
    "variants": []
}

# =============Primer caso: no hay variantes anotadas

if status == "NO VARIANTS DETECTED":
    report_text.append("NO VARIANTS DETECTED IN YOUR ANALYSIS\n")
    result = "".join(report_text)

    report_json["summary"] = {
        "total_unique_variants": 0,
        "variants_with_mane": 0,
        "variants_without_mane": 0,
        "transcript_rows_with_mane": 0,
        "transcript_rows_without_mane": 0
    }

# =============Segundo caso: si hay variantes anotadas

else:

    #Establecer los transcritos mane y no mane
    rows_no_mane = 0
    rows_mane = 0

    # Agrupar la info por variantes, generando un diccionario vacio
    variants = {}

    #Leer el archivo de anotaciones
    with open(ANNOTATION_TSV) as annot:

        # Establecer la cabecera
        header = annot.readline().rstrip("\n\r").split("\t")

        # Buscar la variante y su columna MANE
        id_input_variant = header.index("input_variant")
        id_mane = header.index("MANE")

        for line in annot:
            cells = line.rstrip("\n\r").split("\t")

            input_variant = cells[id_input_variant]

            if input_variant not in variants:
                variants[input_variant] = {"mane_rows": [], "non_mane_rows": []}

            if cells[id_mane] == "":
                rows_no_mane += 1
                variants[input_variant]["non_mane_rows"].append(cells)
            
            else:
                rows_mane += 1
                variants[input_variant]["mane_rows"].append(cells)
    

    #Construir el reporte
   
    report_text.append("VARIANTS DETECTED IN YOUR ANALYSIS\n\n")
    
    total_variants = len(variants)

    variants_with_mane = 0
    for info in variants.values():
        if len(info["mane_rows"]) > 0:
            variants_with_mane += 1

    report_text.append(f"Total unique variants: {total_variants}\n")
    report_text.append(f"Variants with MANE annotation: {variants_with_mane}\n")
    report_text.append(f"Variants without MANE annotation: {total_variants - variants_with_mane}\n\n")

    # Esto son FILAS/anotaciones por transcrito (no variantes)
    report_text.append(f"Transcript rows with MANE: {rows_mane}\n")
    report_text.append(f"Transcript rows without MANE: {rows_no_mane}\n\n")

    # Explicacion de cada variante
    report_text.append("SUMMARY (one block per variant)\n\n")

    # ====== JSON summary ======
    report_json["summary"] = {
        "total_unique_variants": total_variants,
        "variants_with_mane": variants_with_mane,
        "variants_without_mane": total_variants - variants_with_mane,
        "transcript_rows_with_mane": rows_mane,
        "transcript_rows_without_mane": rows_no_mane
    }

    for input_variant, info in variants.items():

        report_text.append(f"Variant: {input_variant}\n")

        # Elegimos una fila representativa:
        # - si hay MANE -> primera MANE
        # - si no -> primera non-MANE
        if len(info["mane_rows"]) > 0:
            row = info["mane_rows"][0]
            report_text.append("  Best annotation: MANE\n")
        else:
            row = info["non_mane_rows"][0]
            report_text.append("  Best annotation: non-MANE\n")

        best = "MANE" if len(info["mane_rows"]) > 0 else "non-MANE"

        report_json["variants"].append({
            "input_variant": input_variant,
            "best_annotation": best,
            "gene": row[header.index("gene")],
            "transcript": row[header.index("transcript")],
            "exon": row[header.index("exon")],
            "consequence": row[header.index("consequence")],
            "impact": row[header.index("impact")],
            "hgvs_c": row[header.index("hgvs_c")],
            "protein": row[header.index("protein")],
            "transcript_annotations_rows": len(info["mane_rows"]) + len(info["non_mane_rows"])
        })

        report_text.append(f"  Gene: {row[header.index('gene')]}\n")
        report_text.append(f"  Transcript: {row[header.index('transcript')]}\n")
        report_text.append(f"  Exon: {row[header.index('exon')]}\n")
        report_text.append(f"  Consequence: {row[header.index('consequence')]}\n")
        report_text.append(f"  Impact: {row[header.index('impact')]}\n")
        report_text.append(f"  HGVS_C: {row[header.index('hgvs_c')]}\n")
        report_text.append(f"  Protein: {row[header.index('protein')]}\n")

        report_text.append(
            f"  Transcript annotations (rows): {len(info['mane_rows']) + len(info['non_mane_rows'])}\n\n"
        )

    result = "".join(report_text)


#==================Creación del directorio si no existe

os.makedirs(OUTDIR, exist_ok=True)

# ============== Generación del archivo resultante (de momento texto)
with open(OUT_TXT, "w") as out:
    out.write(result + "\n")

# ============== Generación del JSON estructurado
with open(OUT_JSON, "w") as outj:
    json.dump(report_json, outj, indent=2, ensure_ascii=False)

