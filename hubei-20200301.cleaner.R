source("tools.cleaner.R")


#' -----------------------------------------------------------------------------
#' Start the data cleaning.
#' -----------------------------------------------------------------------------

data_file <- "hubei_20200301.csv"
x <- read.csv(data_file, stringsAsFactors = FALSE)
y <- x

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
#' The valid missing value for date_confirmation is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_confirmation == ""
y$date_confirmation[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for date_confirmation is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_confirmation == "not sure"
y$date_confirmation[tmp_mask] <- na_string
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
