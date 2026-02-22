#!/usr/bin/env Rscript

#####################################
# This is the script to render web report
######################################

library(rmarkdown)

args <- commandArgs(trailingOnly = TRUE)
rmd_file <- args[1]
out_html <- args[2]
final_report <- args[3]

dir.create(dirname(out_html), recursive = TRUE, showWarnings = FALSE)

rmarkdown::render(
  input = rmd_file,
  output_file = basename(out_html),
  output_dir = dirname(out_html),
  params = list(final_report = normalizePath(final_report)),
  knit_root_dir = getwd(),
  quiet = TRUE
)