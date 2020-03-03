#' -----------------------------------------------------------------------------
#' This file contains some tools that may be useful in cleaning up plain text
#' files.
#'
#' -----------------------------------------------------------------------------
#' Usage:
#'
#' > source("tools.cleaner.R")
#'
#' -----------------------------------------------------------------------------
#' ChangeLog:
#'
#' - 03-03-20: Documentation and \code{extended_ids} function added.
#' - 02-03-20: Initial draft.
#'
#' -----------------------------------------------------------------------------

library(testthat)


#' -----------------------------------------------------------------------------
#' Regular expression tools
#' -----------------------------------------------------------------------------

anchor_wrap <- function(r) sprintf("^%s$", r)

boolean_or <- function(...) sprintf("(%s)", paste0(c(...), collapse="|"))

na_string <- "NA"

.rgx_na_value <- na_string

.rgx_single_age <- "(0|[1-9]{1}[0-9]{0,2})"

expect_true(all(grepl(pattern = anchor_wrap(.rgx_single_age), x = c("0", "1", "10", "123"))))
expect_true(all(!grepl(pattern = anchor_wrap(.rgx_single_age), x = c("4 ", " 7", "01", "1234"))))

.rgx_age_range <- sprintf("%s-%s", .rgx_single_age, .rgx_single_age)

expect_true(all(grepl(pattern = anchor_wrap(.rgx_age_range), x = c("0-1", "1-74", "20-0", "110-123"))))
expect_true(all(!grepl(pattern = anchor_wrap(.rgx_age_range), x = c("1-4 ", "1233-7", "10-01", "1234"))))

rgx_age <- anchor_wrap(boolean_or(.rgx_na_value, .rgx_single_age, .rgx_age_range))

.sex_values <- c("male", "female")

rgx_sex <- anchor_wrap(boolean_or(.sex_values, .rgx_na_value))


.rgx_country <- "[A-Z]{1}[a-z]+(\\s[A-Z]{1}[a-z]+)*"

expect_true(all(grepl(pattern = anchor_wrap(.rgx_country), x = c("Japan", "North Macedonia", "United Arab Emirates"))))
expect_true(all(!grepl(pattern = anchor_wrap(.rgx_country), x = c("china", "", "Sri lanka"))))

rgx_country <- anchor_wrap(boolean_or(.rgx_country, .rgx_na_value))

.rgx_latlong <- "-?[0-9]+(\\.[0-9]+)?"

rgx_latlong <- anchor_wrap(boolean_or(.rgx_latlong, .rgx_na_value))

.rgx_geo_res_values <- c("point", "admin[0123]{1}")

rgx_geo_resolution <- anchor_wrap(boolean_or(.rgx_geo_res_values, .rgx_na_value))

.rgx_date <- "[0-9]{2}\\.[0-9]{2}\\.20(19|20)"

.rgx_date_range <- sprintf("%s - %s", .rgx_date, .rgx_date)

.rgx_left_date_range <- sprintf("- %s", .rgx_date)
.rgx_right_date_range <- sprintf("%s -", .rgx_date)

rgx_date <- anchor_wrap(boolean_or(.rgx_date, .rgx_date_range, .rgx_left_date_range, .rgx_right_date_range, .rgx_na_value))


rgx_lives_in_wuhan <- anchor_wrap(boolean_or("yes", "no", .rgx_na_value))

#' -----------------------------------------------------------------------------
#' Miscellaneous tools
#' -----------------------------------------------------------------------------

extended_ids <- function(maybe_ids) {
    ## type Id = Integer
    ## extended_ids :: [Maybe Id] -> [Id]
    na_mask <- is.na(maybe_ids)
    num_nas <- sum(na_mask)
    existing_ids <- maybe_ids[!na_mask]
    fresh_ids <- 1:num_nas + max(existing_ids)
    ids <- maybe_ids
    ids[na_mask] <- fresh_ids
    return(ids)
}

expect_true(all(c(1,4,3) == extended_ids(c(1,NA,3))))
expect_true(all(c(1,3,2) == extended_ids(c(1,NA,2))))
expect_true(all(c(1,2,3) == extended_ids(c(1,2,3))))
expect_true(all(c(1,2,6,7) == extended_ids(c(1,2,6,NA))))
