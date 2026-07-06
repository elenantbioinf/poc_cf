#!/usr/bin/env python3

##############################################
# This script detects low-coverage gaps from a
# target-filtered mosdepth per-base BED file.
##############################################

#Import libraries
import gzip
import os
import sys

#Arguments
if len(sys.argv) != 5:
    print("Usage: python scripts/detect_coverage_gaps.py <target_per_base_bed_gz> <output_tsv> <sample_id> <min_coverage>")
    sys.exit(1)

TARGET_PER_BASE_BED_GZ = sys.argv[1]
OUTPUT_TSV = sys.argv[2]
SAMPLE_ID = sys.argv[3]
MIN_COVERAGE = int(sys.argv[4])

#Create output directory
os.makedirs(os.path.dirname(OUTPUT_TSV), exist_ok=True)

#Inizializate gaps 
gaps = []
current_chrom = None
current_start = None
current_end = None

#Open the input file
with gzip.open(TARGET_PER_BASE_BED_GZ, 'rt') as input_file:
    for line in input_file:
        line = line.strip()

        #Avoid empty lines
        if line == "":
            continue

        #Avoid incomplete lines
        fields = line.split('\t')

        if len(fields) < 4:
            continue
        
        #Parse fields
        chrom = fields[0]
        start = int(fields[1])
        end = int(fields[2])
        coverage = int(float(fields[3]))

        #Set low coverage flag
        low_coverage = coverage < MIN_COVERAGE

        #If the coverage is low, check if we are in a gap
        if low_coverage:

            #Set the chromosome and start position for the first low-coverage interval
            if current_chrom is None:
                current_chrom = chrom
                current_start = start
                current_end = end

            #If the interval is contiguous, extend the current gap
            elif chrom == current_chrom and start == current_end:
                current_end = end

            #If the interval is not contiguous, save the current gap and start a new one
            else:
                gaps.append([
                    SAMPLE_ID,
                    current_chrom, 
                    current_start, 
                    current_end,
                    current_end - current_start,
                    MIN_COVERAGE,
                    ])
                
                current_chrom = chrom
                current_start = start
                current_end = end

        #If the coverage is not low, close the current gap if one is open
        else:
            if current_chrom is not None:
                gaps.append([
                    SAMPLE_ID,
                    current_chrom, 
                    current_start, 
                    current_end,
                    current_end - current_start,
                    MIN_COVERAGE,
                    ])
                current_chrom = None
                current_start = None
                current_end = None

#Save the last gap if one is open
if current_chrom is not None:
    gaps.append([
        SAMPLE_ID,
        current_chrom, 
        current_start, 
        current_end,
        current_end - current_start,
        MIN_COVERAGE,
        ])
    
#Write the output file
with open(OUTPUT_TSV, 'w') as output_file:
    output_file.write("sample_id\tchrom\tstart\tend\tlength\tmin_coverage\n")
    
    for gap in gaps:
        output_file.write(
            f"{gap[0]}\t{gap[1]}\t{gap[2]}\t{gap[3]}\t{gap[4]}\t{gap[5]}\n"
        )

#Final message
print("Coverage gap detection completed.")
print(f"Input file: {TARGET_PER_BASE_BED_GZ}")
print(f"Output file: {OUTPUT_TSV}")
print(f"Minimum coverage threshold: {MIN_COVERAGE}")
print(f"Number of low-coverage gaps: {len(gaps)}")