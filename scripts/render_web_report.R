#!/usr/bin/env Rscript

#####################################
# This is the script to render web report
######################################

library(rmarkdown)

rmd_file <- "reports/web_report.Rmd"
out_dir  <- "final_report"
out_file <- "web_report.html"

if (!dir.exists(out_dir)) {
  dir.create(out_dir, recursive = TRUE)
}

rmarkdown::render(
  input = rmd_file,
  output_file = out_file,
  output_dir = out_dir,
  quiet = TRUE
)