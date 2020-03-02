library(testthat)

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



#' -----------------------------------------------------------------------------
#' Start the data cleaning.
#' -----------------------------------------------------------------------------

data_file <- "outside_hubei_20200301.csv"
x <- read.csv(data_file, stringsAsFactors = FALSE)
y <- x

#' -----------------------------------------------------------------------------
#' Fix the missing identifiers such that every record has a unique value.
#' -----------------------------------------------------------------------------
y$id <- 1:nrow(x)


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
#' By virtue of appearing in this table they should have 1 as the value for the
#' not_wuhan column.
#' -----------------------------------------------------------------------------
y$not_wuhan <- 1


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
