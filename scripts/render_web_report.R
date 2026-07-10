#!/usr/bin/env Rscript

#####################################
# This is the script to render web report
######################################

library(rmarkdown)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 10) {
  stop(
    paste0(
      "Expected 10 arguments: rmd_file, out_html, final_report_json, qc_summary_tsv, raw_multiqc, clean_multiqc, coverage_plot, coverage_gaps_tsv, target_bed, gap_min_coverage. ",
      "Received ", length(args), " arguments: ",
      paste(args, collapse = " | ")
    )
  )
}

rmd_file <- args[1]
out_html <- args[2]
final_report_json <- args[3]
qc_summary_tsv <- args[4]
raw_multiqc_html <- args[5]
clean_multiqc_html <- args[6]
coverage_plot <- args[7]
coverage_gaps_tsv <- args[8]
target_bed <- args[9]
gap_min_coverage <- args[10]

out_dir <- dirname(out_html)
out_file <- basename(out_html)

dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

#Copy external files to final_report directory to can be included in the web report
sample_prefix <- sub(
  "\\.web_report\\.html$",
  "",
  out_file
)

coverage_plot_report <- file.path(
  out_dir,
  basename(coverage_plot)
)

raw_multiqc_report <- file.path(
  out_dir,
  paste0(sample_prefix, ".raw_multiqc.html")
)

clean_multiqc_report <- file.path(
  out_dir,
  paste0(sample_prefix, ".post_filtering_multiqc.html")
)

coverage_copy_ok <- file.copy(
  from = coverage_plot,
  to = coverage_plot_report,
  overwrite = TRUE
)

if (!coverage_copy_ok) {
  stop("Coverage plot could not be copied to the final report directory.")
}

raw_multiqc_copy_ok <- file.copy(
  from = raw_multiqc_html,
  to = raw_multiqc_report,
  overwrite = TRUE
)

if (!raw_multiqc_copy_ok) {
  stop("Raw MultiQC report could not be copied to the final report directory.")
}

clean_multiqc_copy_ok <- file.copy(
  from = clean_multiqc_html,
  to = clean_multiqc_report,
  overwrite = TRUE
)

if (!clean_multiqc_copy_ok) {
  stop(
    "Post-filtering MultiQC report could not be copied ",
    "to the final report directory."
  )
}

final_report_json_abs <- normalizePath(final_report_json, mustWork = TRUE)
qc_summary_abs <- normalizePath(qc_summary_tsv, mustWork = TRUE)
coverage_plot_abs <- normalizePath(coverage_plot_report, mustWork = TRUE)
coverage_gaps_tsv_abs <- normalizePath(coverage_gaps_tsv, mustWork = TRUE)
target_bed_abs <- normalizePath(target_bed, mustWork = TRUE)
raw_multiqc_report_name <- basename(raw_multiqc_report)
clean_multiqc_report_name <- basename(clean_multiqc_report)

rmarkdown::render(
  input = rmd_file,
  output_file = out_file,
  output_dir = out_dir,
  params = list(
    final_report_json = final_report_json_abs,
    qc_summary_tsv = qc_summary_abs,
    raw_multiqc_report = raw_multiqc_report_name,
    clean_multiqc_report = clean_multiqc_report_name,
    target_region_evaluability_plot = coverage_plot_abs,
    coverage_gaps_tsv = coverage_gaps_tsv_abs,
    target_bed = target_bed_abs,
    gap_min_coverage = as.numeric(gap_min_coverage)
  ),
  knit_root_dir = getwd(),
  envir = new.env(),
  quiet = TRUE
)