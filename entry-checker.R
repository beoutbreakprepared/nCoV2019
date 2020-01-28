#!/usr/bin/env Rscript

#' We want the dates to match either the empty string (missing date), a single
#' date in form \code{dd.mm.yyyy} or a pair of these values separated by a
#' hyphen. If one of the hyphen-separated values is the empty string we assume a
#' one sided interval.
.date_regex_check <- function(x) all(grepl(pattern = "(^$|^[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}$|^[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}-[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}$|-[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}$|^[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}-$)", x = x))
sensible_dates <- list(
  is_good = function(df) {
    all(c(
      .date_regex_check(df$date_onset_symptoms),
      .date_regex_check(df$date_admission_hospital),
      .date_regex_check(df$date_confirmation)
    ))
  },
  success_message = "all dates match regex\n",
  error_message = function(df) {
    "at least one date string does not look right.\n"
  }
)


#' We want the ages to match either the empty string (missing age), a single
#' number, or a range of numbers.
sensible_ages <- list(
  is_good = function(df) {
    all(grepl(pattern = "(^$|^[0-9]+$|^[0-9]+-[0-9]+)", x = df$age))
  },
  success_message = "all ages match regex\n",
  error_message = function(df) {
    "at least one age entry does not look right.\n"
  }
)

distinct_ids <- list(
  is_good = function(df) {
    nrow(df) == length(unique(df$ID))
  },
  success_message = "all identifiers are distinct\n",
  error_message = function(df) {
    "the number of rows does not equal the number of unique ID values.\n"
  }
)

main <- function() {
  cat("Entry checker\n")
  data_file <- "ncov_hubei.csv"
  cat("\t", sprintf("Checking file: %s\n", data_file))
  df <- read.csv(data_file, stringsAsFactors = FALSE)
  tests <- list(sensible_dates, sensible_ages, distinct_ids)
  for (test in tests) {
    if (test$is_good(df)) {
      cat("\t\t", test$success_message)
    } else {
      cat("\t\t", "there was a problem...\n\t\t\t", test$error_message(df))
    }
  }
}

if (!interactive()) {
  main()
}
