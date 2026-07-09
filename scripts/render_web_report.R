#!/usr/bin/env Rscript

#####################################
# This is the script to render web report
######################################

library(rmarkdown)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 4) {
  stop(
    paste0(
      "Expected 4 arguments: rmd_file, out_html, final_report_json, coverage_plot. ",
      "Received ", length(args), " arguments: ",
      paste(args, collapse = " | ")
    )
  )
}

rmd_file <- args[1]
out_html <- args[2]
final_report_json <- args[3]
coverage_plot <- args[4]

out_dir <- dirname(out_html)
out_file <- basename(out_html)

dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

coverage_plot_report <- file.path(
  out_dir,
  basename(coverage_plot)
)

copy_ok <- file.copy(
  from = coverage_plot,
  to = coverage_plot_report,
  overwrite = TRUE
)

if (!copy_ok) {
  stop("Coverage plot could not be copied to the final report directory.")
}

final_report_json_abs <- normalizePath(final_report_json, mustWork = TRUE)
coverage_plot_abs <- normalizePath(coverage_plot_report, mustWork = TRUE)

rmarkdown::render(
  input = rmd_file,
  output_file = out_file,
  output_dir = out_dir,
  params = list(
    final_report_json = final_report_json_abs,
    target_region_evaluability_plot = coverage_plot_abs
  ),
  knit_root_dir = getwd(),
  envir = new.env(),
  quiet = TRUE
)