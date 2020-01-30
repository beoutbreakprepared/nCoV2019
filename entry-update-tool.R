#!/usr/bin/env Rscript

#' ------------------------------------------------------------------------------
#' entry-update-tool.R
#'
#' A tool to download the spreadsheet as a CSV and upload it to git.
#' ------------------------------------------------------------------------------
#' Usage
#'
#'  ./entry-update-tool.R <KEY>
#'
#' where the KEY is the key for the google sheet. When you run this script it
#' will prompt you for your github username and password.
#'
#' ------------------------------------------------------------------------------
#' CHANGELOG
#'
#' - 30-01-2020
#'   + Prototype which requires manual entry of credentials.
#' ------------------------------------------------------------------------------


#' Check the dependencies are there.
IO.deps_all_found <- function() {
    deps <- c("curl",
              "git")

    no_missing_deps <- TRUE
    for (d in deps) {
        is_present <- 0 == system2("which", d)

        if (!is_present) {
            message(sprintf("Missing dependency: %s", d))
            no_missing_deps <- FALSE
        }
    }

    return(no_missing_deps)
}


#' Need to sleep because \code{system2} does not appear to wait properly.
IO.get_sheet_as_csv <- function(key, sheet_name) {
    url <- sprintf("https://docs.google.com/spreadsheets/d/%s/gviz/tq?tqx=out:csv&sheet=%s", key, sheet_name)
    output_file <- sprintf("provisional-%s.csv", sheet_name)
    did_work <- 0 == system2("curl", args = c("-o", output_file, url), wait = TRUE)

    Sys.sleep(4)
    if (did_work) {
        output_file
    } else {
        NA
    }
}

is_filename <- function(maybe_filename) {
    if (!is.na(maybe_filename)) {
        file.exists(maybe_filename)
    } else {
        FALSE
    }
}

IO.git_add <- function(filename) {
    if (file.exists(filename)) {
        system2("git", args = c("add", filename))
    } else {
        stop("Attempting to add non-existant file to git")
    }
}

IO.git_commit <- function() {
    msg <- "\"Automatic commit from entry-update-tool.R\""
    result <- 0 == system2("git", args = c("commit", "-m", msg))
    Sys.sleep(1)
    return(result)
}

IO.push_csv_files <- function() {
    result <- 0 == system2("git", args = c("push"))
    Sys.sleep(1)
    return(result)
}


main <- function() {
    #' Maybe don't include this for security purposes...
    key <- commandArgs(trailingOnly = T)[1]

    sheet_names <- c("Hubei")

    cat("\nChecking for dependencies...\n")
    if (IO.deps_all_found()) {
        cat("\nGetting the CSV files from Google...\n")
        for (sheet_name in sheet_names) {
            cat("\t", sheet_name, "\n")
            maybe_filename <- IO.get_sheet_as_csv(key, sheet_name)
            if (is_filename(maybe_filename)) {
                IO.git_add(maybe_filename)
            } else {
                warning(sprintf("Failed to get: %s", sheet_name))
            }
        }
        cat("\nCommiting the CSV files...\n")
        is_good <- IO.git_commit()
        if (is_good) {
            cat("\nPushing the commit...\n")
            is_good <- IO.push_csv_files()
            if (is_good) {
                cat("All done :)\n")
                result <- 0
            } else {
                warning("Failed to push to github...")
                result <- 1
            }
        } else {
            warning("Failed to commit files...")
            result <- 1
        }
    } else {
        stop("There are missing dependencies.")
    }
}

if (!interactive()) {
    main()
}
