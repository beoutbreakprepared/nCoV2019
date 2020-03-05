#' -----------------------------------------------------------------------------
#' This script walks through cleaning a CSV downloaded from the google sheets.
#'
#' -----------------------------------------------------------------------------
#' Usage:
#'
#' $ Rscript outside-hubei.cleaner.R
#'
#' -----------------------------------------------------------------------------
#' ChangeLog:
#'
#' - 05-03-20
#'   + Rename this file and input/output files.
#'   + Remove some confirmation dates from the future.
#'   + Fix broken missing value in chronic_disease_binary.
#'   + Remove any empty strings in country and province.
#'
#' - 04-03-20
#'   + Remove data moderator initials column.
#'   + Write the result to file "cleaned-outside-hubei-20200301.csv".
#'   + Finish including missing value codes in the remaining columns.
#'
#' - 03-03-20
#'   + Fix the id values and filter for not after 05-02-20.
#'
#' - 02-03-20
#'   + Initial draft.
#'
#' -----------------------------------------------------------------------------

source("src/tools.cleaner.R")

#' -----------------------------------------------------------------------------
#' Start the data cleaning.
#' -----------------------------------------------------------------------------

data_file <- "raw-data/outside-hubei.csv"
x <- subset(read.csv(data_file, stringsAsFactors = FALSE), select = -not_wuhan)
y <- x


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
#' The range for date_confirmation needs a whitespace for consistency.
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_confirmation == "25.02.2020-26.02.2020"
y$date_confirmation[tmp_mask] <- "25.02.2020 - 26.02.2020"
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' We can't have confirmation dates in the future.
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_confirmation %in% c("02.03.2021",
                                       "02.03.2022",
                                       "02.03.2023",
                                       "02.03.2024",
                                       "02.03.2025")
y$date_confirmation[tmp_mask] <- na_string
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
#' When the age is given as "N/A" replace it with "NA".
#' -----------------------------------------------------------------------------
tmp_mask <- y$age == "N/A"
y$age[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' When the age is already coded as an NA replace it with "NA".
#' -----------------------------------------------------------------------------
tmp_mask <- is.na(y$age)
y$age[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' There are some "Aug-68" values, replace it with "NA".
#' -----------------------------------------------------------------------------
tmp_mask <- y$age == "Aug-68"
y$age[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' There are ages that appear to be different representations of age 1
#' -----------------------------------------------------------------------------
tmp_mask <- y$age == "1.75"
y$age[tmp_mask] <- "1"
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' There are ages that appear to be different representations of age 0
#' -----------------------------------------------------------------------------
tmp_mask <- y$age %in% c("0.58333", "0.08333", "0.5", "0.25", "19-Oct", "7 months")
y$age[tmp_mask] <- "0"
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The empty string for sex should be "NA".
#' -----------------------------------------------------------------------------
tmp_mask <- y$sex == ""
y$sex[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The empty string for sex should be "NA".
#' -----------------------------------------------------------------------------
tmp_mask <- y$sex == "N/A"
y$sex[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid sex strings are "male" and "female" in lower case.
#' -----------------------------------------------------------------------------
tmp_mask <- y$sex == "Female"
y$sex[tmp_mask] <- "female"
rm(tmp_mask)
tmp_mask <- y$sex == "Male"
y$sex[tmp_mask] <- "male"
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
#' "China" starts with a capital letter
#' -----------------------------------------------------------------------------
tmp_mask <- y$country == "china"
y$country[tmp_mask] <- "China"
rm(tmp_mask)


#' -----------------------------------------------------------------------------
#' Latitude and longitude should have the correct missing value.
#' -----------------------------------------------------------------------------
tmp_mask <- y$latitude == ""
y$latitude[tmp_mask] <- na_string
rm(tmp_mask)
tmp_mask <- y$longitude == ""
y$longitude[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' Latitude and longitude should have the correct missing value.
#' -----------------------------------------------------------------------------
tmp_mask <- y$latitude == "#N/A"
y$latitude[tmp_mask] <- na_string
rm(tmp_mask)
tmp_mask <- y$longitude == "#N/A"
y$longitude[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for geo_resolution is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$geo_resolution == ""
y$geo_resolution[tmp_mask] <- na_string
rm(tmp_mask)


#' -----------------------------------------------------------------------------
#' The valid missing value for geo_resolution is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$geo_resolution == "#N/A"
y$geo_resolution[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for geo_resolution is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$geo_resolution == "admin"
y$geo_resolution[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' Administrative levels should be formatted correctly.
#' -----------------------------------------------------------------------------
tmp_mask <- y$geo_resolution == "admin 1"
y$geo_resolution[tmp_mask] <- "admin1"
rm(tmp_mask)


#' -----------------------------------------------------------------------------
#' The valid missing value for date_onset_symptoms is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_onset_symptoms == ""
y$date_onset_symptoms[tmp_mask] <- na_string
rm(tmp_mask)


#' -----------------------------------------------------------------------------
#' The valid missing value for date_onset_symptoms is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_onset_symptoms %in% c("N/A", "none", "end of December 2019", "-25.02.2020")
y$date_onset_symptoms[tmp_mask] <- na_string
rm(tmp_mask)


#' -----------------------------------------------------------------------------
#' There are some obvious typographical errors in the date_onset_symptoms
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_onset_symptoms == "20.02.220"
y$date_onset_symptoms[tmp_mask] <- "20.02.2020"
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for date_admission_hospital is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_admission_hospital == ""
y$date_admission_hospital[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' There are some obvious typographical errors in the date_onset_symptoms
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_admission_hospital == "24.02.2929"
y$date_admission_hospital[tmp_mask] <- "24.02.2020"
rm(tmp_mask)
tmp_mask <- y$date_admission_hospital == "9.01.2020"
y$date_admission_hospital[tmp_mask] <- "09.01.2020"
rm(tmp_mask)



#' -----------------------------------------------------------------------------
#' The valid missing value for travel_history_dates is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$travel_history_dates == ""
y$travel_history_dates[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for travel_history_dates is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- is.na(y$travel_history_dates)
y$travel_history_dates[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' Some of the travel history dates need correction.
#' -----------------------------------------------------------------------------
## 13.01.2020 -15.01.2020
tmp_mask <- y$travel_history_dates == "13.01.2020 -15.01.2020"
y$travel_history_dates[tmp_mask] <- "13.01.2020 - 15.01.2020"
rm(tmp_mask)
## 20.12.2019 - 09.01. 2020
tmp_mask <- y$travel_history_dates == "20.12.2019 - 09.01. 2020"
y$travel_history_dates[tmp_mask] <- "20.12.2019 - 09.01.2020"
rm(tmp_mask)
## from a foreign country
tmp_mask <- y$travel_history_dates == "from a foreign country"
y$travel_history_dates[tmp_mask] <- na_string
rm(tmp_mask)
## 16.01.2020-22.01.2020
tmp_mask <- y$travel_history_dates == "16.01.2020-22.01.2020"
y$travel_history_dates[tmp_mask] <- "16.01.2020 - 22.01.2020"
rm(tmp_mask)
## came from abroad
tmp_mask <- y$travel_history_dates == "came from abroad"
y$travel_history_dates[tmp_mask] <- na_string
rm(tmp_mask)
## 21.01.2020-25.01.2020
tmp_mask <- y$travel_history_dates == "21.01.2020-25.01.2020"
y$travel_history_dates[tmp_mask] <- "21.01.2020 - 25.01.2020"
rm(tmp_mask)
## 15.01.2020-27.01.2020
tmp_mask <- y$travel_history_dates == "15.01.2020-27.01.2020"
y$travel_history_dates[tmp_mask] <- "15.01.2020 - 27.01.2020"
rm(tmp_mask)
## 15.01.2020-28.01.2020
tmp_mask <- y$travel_history_dates == "15.01.2020-28.01.2020"
y$travel_history_dates[tmp_mask] <- "15.01.2020 - 28.01.2020"
rm(tmp_mask)
## 20,01,2020
tmp_mask <- y$travel_history_dates == "20,01,2020"
y$travel_history_dates[tmp_mask] <- "20.01.2020"
rm(tmp_mask)
## December; 17.01.2020 - 02.02.2020
tmp_mask <- y$travel_history_dates == "December; 17.01.2020 - 02.02.2020"
y$travel_history_dates[tmp_mask] <- "01.12.2019 - 02.02.2020"
rm(tmp_mask)
## 06.01.2020, 11.01.2020, 17.01.2020
tmp_mask <- y$travel_history_dates == "06.01.2020, 11.01.2020, 17.01.2020"
y$travel_history_dates[tmp_mask] <- "06.01.2020 - 17.01.2020"
rm(tmp_mask)
## 21.01.2020 - 23.012020
tmp_mask <- y$travel_history_dates == "21.01.2020 - 23.012020"
y$travel_history_dates[tmp_mask] <- "21.01.2020 - 23.01.2020"
rm(tmp_mask)
## 1.16.2020
tmp_mask <- y$travel_history_dates == "1.16.2020"
y$travel_history_dates[tmp_mask] <- "16.01.2020"
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for date_death_or_discharge is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_death_or_discharge == ""
y$date_death_or_discharge[tmp_mask] <- na_string
rm(tmp_mask)


#' -----------------------------------------------------------------------------
#' Missing values for date_death_or_discharge due to typos
#' -----------------------------------------------------------------------------
tmp_mask <- y$date_death_or_discharge == "discharge"
y$date_death_or_discharge[tmp_mask] <- na_string
rm(tmp_mask)
tmp_mask <- y$date_death_or_discharge == "02.02.2021"
y$date_death_or_discharge[tmp_mask] <- na_string
rm(tmp_mask)
tmp_mask <- y$date_death_or_discharge == "02.02.2022"
y$date_death_or_discharge[tmp_mask] <- na_string
rm(tmp_mask)


#' -----------------------------------------------------------------------------
#' The valid missing value for symptoms is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$symptoms == ""
y$symptoms[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for lives_in_wuhan is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$lives_in_wuhan == ""
y$lives_in_wuhan[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' Correct some mis-codings for lives_in_wuhan
#' -----------------------------------------------------------------------------
tmp_mask <- y$lives_in_wuhan == "No"
y$lives_in_wuhan[tmp_mask] <- "no"
rm(tmp_mask)
tmp_mask <- y$lives_in_wuhan == "Yes"
y$lives_in_wuhan[tmp_mask] <- "yes"
rm(tmp_mask)
tmp_mask <- y$lives_in_wuhan == "1"
y$lives_in_wuhan[tmp_mask] <- "yes"
rm(tmp_mask)
tmp_mask <- y$lives_in_wuhan == "0"
y$lives_in_wuhan[tmp_mask] <- "no"
rm(tmp_mask)
#' Perhaps these should be recorded elsewhere...
tmp_mask <- y$lives_in_wuhan %in% c("business trip", "medical trip", "study trip", "return from Wuhan")
y$lives_in_wuhan[tmp_mask] <- "no"
rm(tmp_mask)
tmp_others <- c("travel"
 ,"N/A"
 ,"work in Wuhan"
 ,"lived in Wuhan for two months and then went back to Cangzhou"
 ,"used to be"
 ,"work in Wuhan"
 ,"Xiantao City resident"
 ,"no, work in Wuhan"
 ,"shanghai resident, travel history"
 ,"tourism"
 ,"thai national"
 ,"Chinese"
 ,"live in Hangzhou")
tmp_mask <- y$lives_in_wuhan %in% tmp_others
y$lives_in_wuhan[tmp_mask] <- "no"
rm(tmp_mask,tmp_others)

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
#' The valid missing value for chronic_disease_binary is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$chronic_disease_binary == ""
y$chronic_disease_binary[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for chronic_disease_binary is not "N/A".
#' -----------------------------------------------------------------------------
tmp_mask <- y$chronic_disease_binary == "N/A"
y$chronic_disease_binary[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for chronic_disease is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$chronic_disease == ""
y$chronic_disease[tmp_mask] <- na_string
rm(tmp_mask)

#' -----------------------------------------------------------------------------
#' The valid missing value for source is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$source == ""
y$source[tmp_mask] <- na_string
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
#' The valid missing value for notes_for_discussion is not the empty string.
#' -----------------------------------------------------------------------------
tmp_mask <- y$notes_for_discussion == ""
y$notes_for_discussion[tmp_mask] <- na_string
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




stopifnot(!any(is.na(y$id)))
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

y <- subset(y, select = -data_moderator_initials)

write.csv(y,"data/clean-outside-hubei.csv", row.names = FALSE)
