#!/usr/bin/env python3

###############################################
# This is the script to generate the final report
###############################################

import sys

#================Variables necesarias=========================

ANNOTATION_TSV = sys.argv[1]
CHECK_TXT = sys.argv[2]
OUT_TXT = sys.argv[3]


#=================Lectura del archivo de chequeo==========

with open(CHECK_TXT) as check:
    status = check.read().strip()

# =============Primer caso: no hay variantes anotadas

if status == "NO VARIANTS DETECTED":
    result = "NO VARIANTS DETECTED IN YOUR ANALYSIS\n"

# =============Segundo caso: si hay variantes anotadas

else:

    #Establecer los transcritos mane y no mane
    variant_no_mane = 0
    variant_mane = None

    #Leer el archivo de anotaciones
    with open(ANNOTATION_TSV) as annot:
        header = annot.readline().rstrip("\n\r").split("\t")

        # Buscar la columna MANE
        mane = header.index("MANE")

        for line in annot:
            cells = line.rstrip("\n\r").split("\t")

            #Si MANE esta vacio: no es MANE
            if cells[mane] == "":
                variant_no_mane = variant_no_mane + 1
            #Sino, tiene contenido, es una variante MANE
            else:
                variant_mane = cells
    
    #Construir el reporte

    report_text = []
    report_text.append("VARIANTS DETECTED IN YOUR ANALYSIS\n\n")
    report_text.append(
        f"Number of variant annotations in non-MANE transcripts: {variant_no_mane}\n\n"
        )

    if variant_mane is not None:
        sample = variant_mane[header.index("sample_id")]
        gene = variant_mane[header.index("gene")]
        protein = variant_mane[header.index("protein")]
        hgvs_c = variant_mane[header.index("hgvs_c")]
        transcript = variant_mane[header.index("transcript")]
        exon = variant_mane[header.index("exon")]

        report_text.append("Variant detected in MANE transcript:\n\n")
        report_text.append(f"Your sample ID: {sample}\n")
        report_text.append(f"Gene: {gene}\n")
        report_text.append(f"Transcript (MANE): {transcript}\n")
        report_text.append(f"Protein: {protein}\n")
        report_text.append(f"HGVS_C: {hgvs_c}\n")
        report_text.append(f"Exon: {exon}\n")
    else:
        report_text.append("No variant detected in MANE transcript\n")

    result = "".join(report_text)

#==================Creación del directorio si no existe

import os

os.makedirs("final_report", exist_ok=True)

# ============== Generación del archivo resultante (de momento texto)
with open(OUT_TXT, "w") as out:
    out.write(result + "\n")


