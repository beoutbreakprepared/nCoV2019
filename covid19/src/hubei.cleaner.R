#' -----------------------------------------------------------------------------
#' This script walks through cleaning a CSV downloaded from the google sheets.
#'
#' -----------------------------------------------------------------------------
#' Usage:
#'
#' $ Rscript hubei.cleaner.R
#'
#' -----------------------------------------------------------------------------
#' ChangeLog:
#'
#' - 05-03-20
#'   + Rename this file and input/output files.
#'   + Remove any empty strings in country and province.
#'
#' - 04-03-20
#'   + Write the result to file "cleaned-hubei-20200301.csv".
#'   + Finish including missing value codes in the remaining columns.
#'
#' - 03-03-20
#'   + Fix a "not sure" date that had been missed initially.
#'   + Fix the id values to avoid overwriting.
#'   + Filter for confirmed date before 05-02-2020.
#
#' - 02-03-20
#'   + Initial draft.
#'
#' -----------------------------------------------------------------------------

source("src/tools.cleaner.R")


#' -----------------------------------------------------------------------------
#' Start the data cleaning.
#' -----------------------------------------------------------------------------

data_file <- "raw-data/hubei.csv"
x <- read.csv(data_file, stringsAsFactors = FALSE)
y <- subset(x, select = -not_wuhan)

#' -----------------------------------------------------------------------------
#' Fix the missing identifiers such that every record has a unique value without
#' ever overwriting an existing identifier.
#' -----------------------------------------------------------------------------
tmp_ids <- extended_ids(x$id)
stopifnot(!any(is.na(tmp_ids)))
y$id <- tmp_ids
stopifnot(!any(is.na(y$id)))

#' -----------------------------------------------------------------------------
#' The valid missing value for date_confirmation is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_confirmation == ""
y$date_confirmation[tmp_mask] <- na_string
rm(tmp_mask)


#' -----------------------------------------------------------------------------
#' The valid missing value for date_confirmation is not "not sure".
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_confirmation == "not sure"
y$date_confirmation[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The range for date_confirmation needs a whitespace for consistency.
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_confirmation == "25.02.2020-26.02.2020"
y$date_confirmation[tmp_mask] <- "25.02.2020 - 26.02.2020"
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' Filter for only values where the confirmation date is not after 5th Feb 2020.
#' -----------------------------------------------------------------------------
tmp_mask <- is.na_or_true(strpdate(y$date_confirmation) <= as.Date("05.02.2020", format = "%d.%m.%Y", origin = "01.01.1970"))
y <- y[tmp_mask,]
stopifnot(!any(is.na(y$id)))
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' When the age is given as the empty string, replace it with "NA".
#' -----------------------------------------------------------------------------
tmp_mask <- y$age == ""
y$age[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The empty string for sex should be "NA".
#' -----------------------------------------------------------------------------
tmp_mask <- y$sex == ""
y$sex[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for province is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$province == ""
y$province[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for country is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$country == ""
y$country[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for geo_resolution is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$geo_resolution == "admin"
y$geo_resolution[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for date_onset_symptoms is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_onset_symptoms == ""
y$date_onset_symptoms[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' Date of onset symptoms needs correction
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_onset_symptoms == "pre 18.01.2020"
y$date_onset_symptoms[tmp_mask] <- "- 18.01.2020"
rm(tmp_mask)
tmp_mask <- y$date_onset_symptoms == "early january"
y$date_onset_symptoms[tmp_mask] <- "01.01.2020 - 31.01.2020"
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for date_admission_hospital is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_admission_hospital == ""
y$date_admission_hospital[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for symptoms is not the empty string
#' -----------------------------------------------------------------------------
tmp_mask <- y$symptoms == ""
y$symptoms[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for travel_history_dates is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$travel_history_dates == ""
y$travel_history_dates[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for travel_history_dates is not a literal NA
#' -----------------------------------------------------------------------------
tmp_mask <- is.na(y$travel_history_dates)
y$travel_history_dates[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for travel_history_location is not a literal NA
#' -----------------------------------------------------------------------------
tmp_mask <- is.na(y$travel_history_location)
y$travel_history_location[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for reported_market_exposure is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$reported_market_exposure == ""
y$reported_market_exposure[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for additional_information is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$additional_information == ""
y$additional_information[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for chronic_disease is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$chronic_disease == ""
y$chronic_disease[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for sequence_available is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$sequence_available == ""
y$sequence_available[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for outcome is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$outcome == ""
y$outcome[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for date_death_or_discharge is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_death_or_discharge == ""
y$date_death_or_discharge[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for lives_in_wuhan is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$lives_in_wuhan == ""
y$lives_in_wuhan[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for location is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$location == ""
y$location[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for admin3 is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$admin3 == ""
y$admin3[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for admin2 is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$admin2 == ""
y$admin2[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for admin1 is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$admin1 == ""
y$admin1[tmp_mask] <- na_string
rm(tmp_mask)


#' This data frame should be empty!
y[!grepl(pattern = rgx_age, x = y$age), c("id", "age")]

#' This data frame should be empty!
y[!grepl(pattern = rgx_sex, x = y$sex), c("id", "sex")]

#' This data frame should be empty!
y[!grepl(pattern = rgx_country, x = y$country), c("id", "country")]

#' This data frame should be empty!
y[!grepl(pattern = rgx_latlong, x = y$latitude), c("id", "latitude")]

#' This data frame should be empty!
y[!grepl(pattern = rgx_latlong, x = y$longitude), c("id", "longitude")]

#' This data frame should be empty!
y[!grepl(pattern = rgx_geo_resolution, x = y$geo_resolution), c("id", "geo_resolution")]

#' This data frame should be empty!
y[!grepl(pattern = rgx_date, x = y$date_onset_symptoms), c("id", "date_onset_symptoms")]

#' This data frame should be empty!
y[!grepl(pattern = rgx_date, x = y$date_admission_hospital), c("id", "date_admission_hospital")]

#' This data frame should be empty!
y[!grepl(pattern = rgx_date, x = y$date_confirmation), c("id", "date_confirmation")]

#' This data frame should be empty!
y[!grepl(pattern = rgx_date, x = y$travel_history_dates), c("id", "travel_history_dates")]

#' This data frame should be empty!
y[!grepl(pattern = rgx_date, x = y$date_death_or_discharge), c("id", "date_death_or_discharge")]

#' This data frame should be empty!
y[!grepl(pattern = rgx_lives_in_wuhan, x = y$lives_in_wuhan), c("id", "lives_in_wuhan")]

write.csv(y,"data/clean-hubei.csv", row.names = FALSE)
