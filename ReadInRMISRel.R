#reads in all RMIS Coho Releases from 1950 until today 
# Data pulled MARCH 10, 2020
# code must be ran in a linear fashion or the files will keep concatenating to the dataframe
# lower half of code attempts to filter out the non-viable releases

require(stringr)
require(tidyverse)
library(dplyr)
library(ggplot2)

require(RSQLite)
require(odbc)
require(DBI)
require(readxl)
require(tidyverse)

# read in a tab-delimited file and concatenate them:
getwd()
setwd("/CSP1004/CWTData/Releases") #turn the \ around!
# Get a list of files within the directory
files <- dir(pattern = ".txt$")

# Copy the column names
datNames<- c("record_code",	"format_version",	"submission_date",	"reporting_agency",	"release_agency",	"coordinator",	"tag_code_or_release_id",	"tag_type",	"first_sequential_number",	"last_sequential_number", "related_group_type",	"related_group_id",	"species",	"run",	"brood_year",	"first_release_date",	"last_release_date",	"release_location_code",	"hatchery_location_code",	"stock_location_code",	"release_stage",	"rearing_type",	"study_type",	"release_strategy",	"avg_weight",	"avg_length",	"study_integrity",	"cwt_1st_mark",	"cwt_1st_mark_count",	"cwt_2nd_mark",	"cwt_2nd_mark_count",	"non_cwt_1st_mark",	"non_cwt_1st_mark_count",	"non_cwt_2nd_mark",	"non_cwt_2nd_mark_count",	"counting_method",	"tag_loss_rate",	"tag_loss_days",	"tag_loss_sample_size",	"tag_reused",	"comments", "release_location_name",	"hatchery_location_name",	"stock_location_name",	"release_location_state",	"release_location_rmis_region",	"release_location_rmis_basin",	"record_origin",	"tagged_adclipped",	"tagged_unclipped",	"untagged_adclipped",	"untagged_unclipped",	"untagged_unknown")

# Create a blank data.frame
AllReleases<- data.frame()

for(i in 1:length(files)){
  # Read in current file
  dat<- read_delim(files[i], delim = "\t", skip = 1, col_names = FALSE, col_types = "ccccccccccccccccccccccccddccicicicicdiiccccccccciiiii")
  # Give the table names
  names(dat)<- datNames

  # Append the output
  AllReleases<-rbind(AllReleases, dat)
}

#count(AllReleases$record_code)

#to check the datatypes within the table
  #str(AllReleases) 
#to check the years included!
  #range(AllReleases$brood_year) 

#now I am going to filter the releases to not include eggs, emergent fry, fed fry, and adults:

#AllReleases %>%
  #select (tag_code_or_release_id,	tag_type,	related_group_type,	related_group_id,	species,	run,	brood_year,	first_release_date,	last_release_date,	release_location_code,	hatchery_location_code,	stock_location_code,	release_stage,	rearing_type,	study_type,	release_strategy,	avg_weight,	avg_length,	study_integrity,	cwt_1st_mark,	cwt_1st_mark_count,	cwt_2nd_mark,	cwt_2nd_mark_count,	non_cwt_1st_mark,	non_cwt_1st_mark_count,	non_cwt_2nd_mark,	non_cwt_2nd_mark_count,	tag_reused,	comments,	release_location_name,	hatchery_location_name,	stock_location_name,	release_location_state,	release_location_rmis_region,	release_location_rmis_basin,	tagged_adclipped,	tagged_unclipped,	untagged_adclipped,	untagged_unclipped,	untagged_unknown) %>%
  #filter(release_stage %in% c("G", "M", "P", "S", "V", "Y", "NA")) 

#now trying to load into a SQLite db:
#dbDisconnect(mydb)
#create blank db:
#mydb <- dbConnect(RSQLite::SQLite(), "CWTData.sqlite")

#load release data into it:
#dbWriteTable(mydb, name = "Releases", value = AllReleases, overwrite = TRUE)

#load recovery data into it:
#dbWriteTable(mydb, name = "Recoveries", value = AllRecoveries, overwrite = TRUE)

#load location data into it:


