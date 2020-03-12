#reads in all RMIS Coho Data from 1950 until today 
# Data pulled MARCH 10, 2020
# code must be ran in a linear fashion or the files will keep concatenating to the dataframe

require(stringr)
require(tidyverse)
library(dplyr)
library(ggplot2)

require(RSQLite)
require(odbc)
require(DBI)
require(readxl)
require(tidyverse)

#Release Data:
# read in a tab-delimited file and concatenate them:
setwd("/CSP1004/CWTData/Releases") #turn the \ around!
# Get a list of files within the directory
Relfiles <- dir(pattern = ".txt$")

# Copy the column names
ReldatNames <- c("record_code",	"format_version",	"submission_date",	"reporting_agency",	"release_agency",	"coordinator",	"tag_code_or_release_id",	"tag_type",	"first_sequential_number",	"last_sequential_number", "related_group_type",	"related_group_id",	"species",	"run",	"brood_year",	"first_release_date",	"last_release_date",	"release_location_code",	"hatchery_location_code",	"stock_location_code",	"release_stage",	"rearing_type",	"study_type",	"release_strategy",	"avg_weight",	"avg_length",	"study_integrity",	"cwt_1st_mark",	"cwt_1st_mark_count",	"cwt_2nd_mark",	"cwt_2nd_mark_count",	"non_cwt_1st_mark",	"non_cwt_1st_mark_count",	"non_cwt_2nd_mark",	"non_cwt_2nd_mark_count",	"counting_method",	"tag_loss_rate",	"tag_loss_days",	"tag_loss_sample_size",	"tag_reused",	"comments", "release_location_name",	"hatchery_location_name",	"stock_location_name",	"release_location_state",	"release_location_rmis_region",	"release_location_rmis_basin",	"record_origin",	"tagged_adclipped",	"tagged_unclipped",	"untagged_adclipped",	"untagged_unclipped",	"untagged_unknown")

# Create a blank data.frame
AllReleases<- data.frame()

for(i in 1:length(Relfiles)){
  # Read in current file
  Reldat<- read_delim(Relfiles[i], delim = "\t", skip = 1, col_names = FALSE, col_types = "ccccccccccccccccccccccccddccicicicicdiiccccccccciiiii")
  # Give the table names
  names(Reldat)<- ReldatNames
  
  # Append the output
  AllReleases<-rbind(AllReleases, Reldat)
}

#Recovery data:
# read in a tab-delimited file and concatenate them:
setwd("/CSP1004/CWTData/Recoveries") #turn the \ around!
# Get a list of files within the directory
Recfiles <- dir(pattern = ".txt$")

# Copy the column names
RecdatNames <- c("record_code",	"format_version",	"submission_date",	"reporting_agency",	"sampling_agency",	"recovery_id",	"species",	"run_year",	"recovery_date",	"recovery_date_type",	"period_type",	"period",	"fishery",	"gear",	"adclip_selective_fishery",	"estimation_level",	"recovery_location_code",	"sampling_site",	"recorded_mark",	"sex",	"weight",	"weight_code",	"weight_type",	"length",	"length_code",	"length_type",	"detection_method",	"tag_status",	"tag_code",	"tag_type",	"sequential_number",	"sequential_column_number",	"sequential_row_number",	"catch_sample_id",	"sample_type",	"sampled_maturity",	"sampled_run",	"sampled_length_range",	"sampled_sex",	"sampled_mark",	"estimated_number",	"recovery_location_name", "record_origin")

# Create a blank data.frame
AllRecoveries<- data.frame()

for(i in 1:length(Recfiles)){
  # Read in current file
  Recdat<- read_delim(Recfiles[i], delim = "\t", skip = 1, col_names = FALSE, col_types = "ccccccccccccccccccccdccdccccccccccccccccdcc")
  # Give the table names
  names(Recdat)<- RecdatNames
  # Append the output
  AllRecoveries<-rbind(AllRecoveries, Recdat)
}

#grab the location file:
setwd("/CSP1004/CWTData")

AllLocations<- read_delim("Locations.txt", delim = "\t", col_names = TRUE, col_types = "cccccccddccccccddc")

#now trying to load into a SQLite db:
#disconnect (any previous connections)
dbDisconnect(mydb)
#create blank db:
mydb <- dbConnect(RSQLite::SQLite(), "CWTData.sqlite")

#load release data into it:
dbWriteTable(mydb, name = "Releases", value = AllReleases, overwrite = TRUE)
dbWriteTable(mydb, name = "Recoveries", value = AllRecoveries, overwrite = TRUE)
dbWriteTable(mydb, name = "Locations", value = AllLocations, overwrite = TRUE)

#trying to sum the total releases:
AllReleases2 <- AllReleases %>%
  mutate_if(is.integer, ~replace(., is.na(.), 0)) %>%
  mutate_if(is.numeric, ~replace(., is.na(.), 0)) %>%
  mutate(TotalReleases = (AllReleases2$cwt_1st_mark_count + AllReleases2$cwt_2nd_mark_count + AllReleases2$non_cwt_1st_mark_count + AllReleases2$non_cwt_2nd_mark_count))

#if you want to remove the column:
#AllReleases2$TotalReleases<- NULL

