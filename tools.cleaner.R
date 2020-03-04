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
#' - 03-03-20
#'   + \code{is.na_or_true} to avoid issues with NA values.
#'   + \code{strpdate} for filtering dates.
#'   + \code{extended_ids} for including new ids where these are missing.
#'   + Documentation.
#'
#' - 02-03-20 Initial draft.
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

strpdate <- function(date_strings) {
    ## strpdate :: String -> Maybe Date
    .strpdate <- function(strings) {
        as.Date(strings, format = "%d.%m.%Y", origin = "01.01.1970")
    }
    ## validate input.
    na_mask <- date_strings == "NA"
    range_mask <- grepl(pattern = anchor_wrap(.rgx_date_range), x = date_strings)
    single_mask <- grepl(pattern = anchor_wrap(.rgx_date), x = date_strings)
    left_mask <- grepl(pattern = anchor_wrap(.rgx_left_date_range), x = date_strings)
    if (!all(na_mask | range_mask | single_mask | left_mask)) {
        browser()
    }
    ## construct result
    maybe_dates <- rep(NA, length(date_strings))
    maybe_dates[na_mask] <- NA
    maybe_dates[range_mask] <- vapply(strsplit(x = date_strings[range_mask], split = " - "), function(x) .strpdate(x[2]), FUN.VALUE = numeric(1))
    maybe_dates[single_mask] <- vapply(date_strings[single_mask], .strpdate, FUN.VALUE = numeric(1))
    if (any(left_mask)) {
        maybe_dates[left_mask] <- vapply(date_strings[left_mask], function(x) .strpdate(gsub(pattern = "- ", replacement = "", x = x)), FUN.VALUE = numeric(1))
    }
    return(maybe_dates)
}

expect_true(as.Date("20.01.2020", format = "%d.%m.%Y") == strpdate("20.01.2020"))
expect_true(as.Date("20.01.2020", format = "%d.%m.%Y") == strpdate("- 20.01.2020"))
expect_true(as.Date("20.01.2020", format = "%d.%m.%Y") == strpdate("19.12.2019 - 20.01.2020"))
expect_true(is.na(strpdate("NA")))
expect_true({
    tmp1 <- as.Date(c("19.01.2020",NA,"20.01.2020"), format = "%d.%m.%Y");
    tmp2 <- strpdate(c("19.12.2019 - 19.01.2020", "NA", "20.01.2020"));
    all(c(tmp1[1] == tmp2[1],
          is.na(tmp2[2]),
          tmp1[3] == tmp2[3]))
})

is.na_or_true <- function(xs) {

    .f <- function(x) if (is.na(x)) {TRUE} else {x}

    vapply(X = xs, FUN = .f, FUN.VALUE = logical(1))
}

expect_true(is.na_or_true(NA))
expect_true(is.na_or_true(TRUE))
expect_true(!is.na_or_true(FALSE))
expect_true(all(c(TRUE,FALSE,TRUE) == is.na_or_true(c(T,F,NA))))
