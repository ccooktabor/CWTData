#reads in all RMIS Coho Recoveries from 1950 until today 
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

# read in a tab-delimited file and concatenate them:
getwd()
setwd("/CSP1004/CWTData/Recoveries") #turn the \ around!
# Get a list of files within the directory
files <- dir(pattern = ".txt$")

# Copy the column names
datNames<- c("record_code",	"format_version",	"submission_date",	"reporting_agency",	"sampling_agency",	"recovery_id",	"species",	"run_year",	"recovery_date",	"recovery_date_type",	"period_type",	"period",	"fishery",	"gear",	"adclip_selective_fishery",	"estimation_level",	"recovery_location_code",	"sampling_site",	"recorded_mark",	"sex",	"weight",	"weight_code",	"weight_type",	"length",	"length_code",	"length_type",	"detection_method",	"tag_status",	"tag_code",	"tag_type",	"sequential_number",	"sequential_column_number",	"sequential_row_number",	"catch_sample_id",	"sample_type",	"sampled_maturity",	"sampled_run",	"sampled_length_range",	"sampled_sex",	"sampled_mark",	"estimated_number",	"recovery_location_name", "record_origin")

# Create a blank data.frame
AllRecoveries<- data.frame()

for(i in 1:length(files)){
  # Read in current file
  dat<- read_delim(files[i], delim = "\t", skip = 1, col_names = FALSE, col_types = "ccccccccccccccccccccdccdccccccccccccccccdcc")
  # Give the table names
  names(dat)<- datNames
  # Append the output
  AllRecoveries<-rbind(AllRecoveries, dat)
}

#to check the datatypes within the table
  #str(AllRecoveries) 
#to check the years included!
  #range(AllRecoveries$run_year) 

#now trying to load into a SQLite db:
mydb <- dbConnect(RSQLite::SQLite(), "C:/CSP1004/CWTData/Recoveries/CWTData.sqlite")
#load data into it:
dbWriteTable(mydb, name = "Recoveries", value = AllRecoveries, overwrite = TRUE)

