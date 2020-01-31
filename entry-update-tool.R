#!/usr/bin/env Rscript

#' ------------------------------------------------------------------------------
#' entry-update-tool.R
#'
#' A tool to download the spreadsheet as a CSV.
#' ------------------------------------------------------------------------------
#' Usage
#'
#'  $ ./entry-update-tool.R <KEY>
#'
#' where the KEY is the key for the google sheet. This file can also be sourced
#' and used in an interactive R session:
#'
#'  > source("entry-update-tool.R")
#'  > main(<KEY>)
#'
#' ------------------------------------------------------------------------------
#' CHANGELOG
#'
#' - 31-01-2020
#'   + Adjust how the key for the sheet is introduced.
#'   + Use the R package httr instead.
#'   + Any use of curl is removed.
#'   + Any use of git is removed.
#'
#' - 30-01-2020
#'   + Prototype which requires manual entry of credentials.
#' ------------------------------------------------------------------------------

#' Predicate for whether the packages are installed.
#'
#' @param pkgNames a character vector of package names
#'
IO.are_installed <- function(pkgNames) {
  installed_packages <- installed.packages()[, "Package"]
  all(sapply(pkgNames, function(pn) pn %in% installed_packages))
}

#' Need to sleep because \code{system2} does not appear to wait properly.
IO.get_sheet_as_csv <- function(key, sheet_name) {
  url <- sprintf("https://docs.google.com/spreadsheets/d/%s/gviz/tq?tqx=out:csv&sheet=%s", key, sheet_name)
  output_filename <- sprintf("provisional-%s.csv", sheet_name)

  httr::GET(url, httr::write_disk(output_filename, overwrite = TRUE))
  Sys.sleep(4)

  if (IO.is_filename(output_filename)) {
    output_filename
  } else {
    NA
  }
}

#' Predicate for whether something is a valid filename or a \code{NA}
#'
#' @param maybe_filename either \code{NA} or a filename
#'
IO.is_filename <- function(maybe_filename) {
  if (!is.na(maybe_filename)) {
    file.exists(maybe_filename)
  } else {
    FALSE
  }
}

main <- function(key) {
  #' Check that the required packages are available without loading them.
  if (!IO.are_installed(c("httr"))) {
    stop("There appear to be missing packages!")
  }


  sheet_names <- c("Hubei", "outside_Hubei")

  cat("\nGetting the CSV files from Google...\n")
  for (sheet_name in sheet_names) {
    cat("\t", sheet_name, "\n")
    maybe_filename <- IO.get_sheet_as_csv(key, sheet_name)
    if (!IO.is_filename(maybe_filename)) {
      warning(sprintf("Failed to get: %s", sheet_name))
    }
  }
}

if (!interactive()) {
  #' Maybe don't include this for security purposes...
  key <- commandArgs(trailingOnly = T)[1]
  main(key)
}
