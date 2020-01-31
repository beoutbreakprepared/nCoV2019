#!/usr/bin/env Rscript

#' -----------------------------------------------------------------------------
#' entry-checker.R
#'
#' A tool to perform basic checks on a CSV containing data about the ongoing
#' coronavirus outbreak.
#' -----------------------------------------------------------------------------
#' USAGE
#'
#'  $ ./entry-checker.R
#'
#' It will also work from an interactive session:
#'
#'  > source("entry-checker.R")
#'  > main()
#'
#' -----------------------------------------------------------------------------
#' CHANGELOG
#'
#' - 31-01-2020
#'   + Report the IDs that appear to have failed the tests.
#'
#' - 29-01-2020
#'   + Include some sensible tests suggested by Erin Frame.
#'
#' - 28-01-2020
#'   + Basic test to check some entries match regexes
#' -----------------------------------------------------------------------------


#' We want the dates to parse to something that is not in the future and not before January 2019. Since there are multiple ways the data can be expressed, we need to be careful to check that they all make sense.

.is_plausible_date_string <- function(date_string) {
  .as_date <- function(ds) {
    as.Date(ds, format = "%d.%m.%Y")
  }

  .is_plausible <- function(x) {
    (x <= Sys.Date()) & (x > as.Date("01.01.2019", format = "%d.%m.%Y"))
  }

  if (grepl(pattern = "^[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}$", x = date_string)) {
    .is_plausible(.as_date(date_string))
  } else if (grepl(pattern = "^[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}$", x = date_string)) {
    two_dates <- lapply(unlist(strsplit(x = date_string, split = "-")), .as_date)
    all(sapply(two_dates, .is_plausible)) & (two_dates[[1]] < two_dates[[2]])
  } else if (grepl(pattern = "(-[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}$|^[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}-$)", x = date_string)) {
    .is_plausible(.as_date(gsub(x = date_string, pattern = "-", replacement = "")))
  } else {
    FALSE
  }
}

dates_parse_to_plausible_values <- list(
  is_good = function(df) {
    all_date_strings <- c(
      df$date_onset_symptoms,
      df$date_admission_hospital,
      df$date_confirmation
    )
    non_empty_mask <- all_date_strings != ""
    non_empty_date_strings <- all_date_strings[non_empty_mask]
    all(sapply(non_empty_date_strings, .is_plausible_date_string))
  },
  success_message = "all dates can be parsed and are plausible.\n",
  error_message = function(df) {
    all_date_strings <- c(
      df$date_onset_symptoms,
      df$date_admission_hospital,
      df$date_confirmation
    )
    non_empty_mask <- all_date_strings != ""
    non_empty_date_strings <- all_date_strings[non_empty_mask]
    mask <- sapply(non_empty_date_strings, .is_plausible_date_string)

    print("=======================================")
    print("The errors in sensible date test apply to IDs ...")
    print(df$ID[!mask])
    print("but there may be others...")
    print("=======================================")

    "look at the dates_parse_to_plausible_values test for details.\n"
  }
)


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
  success_message = "all dates match regex for dd.mm.yyyy or a range of these.\n",
  error_message = function(df) {
    mask <- function(x) {
      grepl(pattern = "(^$|^[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}$|^[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}-[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}$|-[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}$|^[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}-$)", x = x)
    }

    print("=======================================")
    print("The errors in sensible date test apply to IDs ...")
    print(df$ID[!mask(df$date_onset_symptoms)])
    print(df$ID[!mask(df$date_admission_hospital)])
    print(df$ID[!mask(df$date_confirmation)])
    print("but there may be others...")
    print("=======================================")

    "look at the sensible_dates test for details.\n"
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
    mask <- function(x) {
      grepl(pattern = "(^$|^[0-9]+$|^[0-9]+-[0-9]+)", x = x)
    }

    print("=======================================")
    print("The errors in sensible age test apply to IDs ...")
    print(df$ID[!mask(df$age)])
    print("but there may be others...")
    print("=======================================")

    "look at the sensible_ages test for details.\n"
  }
)

#' We want each ID to be a unique positive integer so this checks that is
#' approximately correct.
distinct_ids <- list(
  is_good = function(df) {
    length(df$ID) == length(unique(df$ID))
  },
  success_message = "all identifiers are distinct\n",
  error_message = function(df) {
    f <- function(x) x[table(x) > 1]
    print("=======================================")
    print("The following IDs appear to be duplicated...")
    print(f(df$ID))
    if (any(is.na(df$ID))) {
      print("There may be missing IDs...")
    }
    print("=======================================")

    "the number of rows does not equal the number of unique ID values.\n"
  }
)

main <- function() {
  cat("Entry checker\n")
  data_file <- "provisional-Hubei.csv"
  cat("\t", sprintf("Checking file: %s\n", data_file))
  df <- read.csv(data_file, stringsAsFactors = FALSE)
  tests <- list(
    sensible_dates,
    dates_parse_to_plausible_values,
    sensible_ages,
    distinct_ids
  )
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
