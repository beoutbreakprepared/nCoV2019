#Hashing for de-dupe
#Samuel V. Scarpino (s.scarpino@northeastern.edu) 
#Jan. 30th 20202
#see http://amunategui.github.io/feature-hashing/

#You need to create a folder called "secrets" and add the path to the Google sheets and a file with your service API key

###########
#libraries#
###########
library(FeatureHashing)
library(glmnet)
library(googlesheets4)
library(googledrive)

###############
#Global Params#
###############
cols_to_use <- c("ID", "age", "sex", "city", "province", "country" ,"date_onset_symptoms", "date_admission_hospital", "date_confirmation", "symptoms", "lives_in_Wuhan", "travel_history_dates", "travel_history_location", "reported_market_exposure", "sequence_available", "outcome", "source")

cols_to_match <- c("ID", "age", "sex", "city", "province", "country", "latitude", "longitude", "date_onset_symptoms", "date_admission_hospital", "date_confirmation", "symptoms", "lives_in_Wuhan", "travel_history_dates", "travel_history_location", "reported_market_exposure", "sequence_available", "outcome", "source")

google_sheet_name <- readLines("secrets/google_sheet_name.txt")
sheets_auth(path = "secrets/service_google_api_key.json", use_oob = TRUE)

###############
#Acc functions#
###############
source("de_dupe_functions.R")

######
#Data#
######
wuhan_data <- sheets_get(ss = google_sheet_name) %>%
  read_sheet(sheet = "Hubei")

#changing wuhan resident column
find_Wuhan_resident <- which(colnames(wuhan_data) == "Wuhan_resident")
if(length(find_Wuhan_resident) == 1){
  colnames(wuhan_data)[find_Wuhan_resident] <- "lives_in_Wuhan" #this is the column in the outside wuhan sheet
}

wuhan_data$ID <- paste0(wuhan_data$ID, "-Wuhan")

outside_wuhan_data <- sheets_get(ss = google_sheet_name) %>%
  read_sheet(sheet = "outside_Hubei")

outside_wuhan_data$ID <- paste0(outside_wuhan_data$ID, "-Outside-Wuhan")

full_data <- rbind(wuhan_data[,cols_to_match], outside_wuhan_data[,cols_to_match])
full_data$age <- as.character(full_data$age)
full_data$lives_in_Wuhan <- as.character(full_data$lives_in_Wuhan)

############
#Find dupes#
############
dupes <- main(data = full_data)
