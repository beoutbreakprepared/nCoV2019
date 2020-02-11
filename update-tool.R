#!/usr/bin/env Rscript

#' ------------------------------------------------------------------------------
#' update-tool.R
#'
#' A tool to download the spreadsheet as a CSV.
#' ------------------------------------------------------------------------------
#' Usage
#'
#'  $ ./update-tool.R <KEY>
#'
#' where the KEY is the key for the google sheet. This file can also be sourced
#' and used in an interactive R session:
#'
#'  > source("update-tool.R")
#'  > main(<KEY>)
#'
#' ------------------------------------------------------------------------------
#' CHANGELOG
#'
#' - 11-02-2020
#'   + Compute summary statistics about data completeness for "age".
#'   + Compute summary statistics regarding sources used
#'   + Renamed: entry-update-tool.R --> update-tool.R
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
#' Dependencies
#'
#' - httr
#' - xtable
#' - dplyr
#' - reshape2
#'

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

#' Write an xtable to an HTML file
#'
#' @param xtab xtable of the summary
#' @param filename file to write table to
#'
IO.write_summary_table <- function(xtab, filename) {
    xtable::print.xtable(xtab)
}

#' Return a data frame listing the sources and their frequency of use.
#'
#' @param df data.frame of data.
#'
source_summary <- function(df) {
    source_count <- as.data.frame(table(sapply(strsplit(df$source, split = "/"), function(x) do.call(paste0, c(list(x[1:3]), list(collapse = "/"))))))
    source_count <- source_count[sort.int(source_count$Freq, index.return=TRUE, decreasing = TRUE)$ix,]
    names(source_count) <- c("source", "frequency")
    return(source_count)
}


.age_summary_func <- function(df) {
    ages <- df$age
    age_regex <- "^[0-9]+$"
    num_missing <- sum(is.na(ages))
    num_valid <- sum(grepl(pattern = age_regex, x = ages))
    data.frame(field = "age", num_missing = num_missing, num_valid = num_valid, num_broken = nrow(df) - (num_valid + num_missing))
}

#' Return a data frame describing the completeness of the data.
#'
#' @param df data.frame of data.
#'
#' @details The functions in the \code{summary_funcs} list are used to check the
#' completeness of particular columns since this is hard to do in general. These
#' functions should have names which match a suitable pattern:
#' \code{"\.[a-z]*_summary_func"}.
#'
completeness_summary <- function(df) {
    summary_funcs <- list(.age_summary_func)
    do.call(rbind, lapply(summary_funcs, function(f) f(df)))
}

#' Write the unique sources to the lines of a text file.
#'
#' @param df data.frame of data
#' @param filename character describing the target file
#'
IO.write_all_sources <- function(df, filename) {
    urls <- unique(df$source)
    writeLines(urls, con = filename)
}


main <- function(key) {
  #' Check that the required packages are available without loading them.
  if (!IO.are_installed(c("httr", "xtable", "dplyr", "reshape2"))) {
    stop("There appear to be missing packages!")
  }

  sheet_names <- c("Hubei", "outside_Hubei")

  cat("\nGetting the CSV files from Google...\n")
  for (sheet_name in sheet_names) {
    cat("\t", sheet_name, "\n")
    maybe_filename <- IO.get_sheet_as_csv(key, sheet_name)
    if (!IO.is_filename(maybe_filename)) {
      warning(sprintf("Failed to get: %s", sheet_name))
    } else {
        cat("\t", "Writting summary tables...", "\n")
        df <- read.csv(maybe_filename, stringsAsFactors = FALSE)
        IO.write_all_sources(df, sprintf("provisional-all-sources-%s.txt", sheet_name))
        print(source_summary(df))
        print(completeness_summary(df))
        ## IO.write_summary_table(source_summary(df), sprintf("provisional-source-summary-%s.html", sheet_name)) #
        ## IO.write_summary_table(completeness_summary(df), sprintf("provisional-completeness-summary-%s.html", sheet_name))
    }
  }
}

if (!interactive()) {
  #' Maybe don't include this for security purposes...
  key <- commandArgs(trailingOnly = T)[1]
  main(key)
}
