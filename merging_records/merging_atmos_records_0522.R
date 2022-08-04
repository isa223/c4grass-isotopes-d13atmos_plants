## Merging atmospheric records from the Rubino and CSIRO records.

# importing libraries
library(ggplot2)
library(dplyr)
library(lme4)
library(AICcmodavg)

# set directories
setwd(dir = "/Users/IsadT/Desktop")


# open and format CSIRO data
csiro <- read.table('expanded.txt')
colnames(csiro)[colnames(csiro)=="V2"] <- "year"
colnames(csiro)[colnames(csiro)=="V14"] <- "delta.disc"

csiro <- csiro %>% filter(delta.disc != -999.999)

csiro_annual_avg <- csiro %>%
  group_by(year) %>%
  summarise_at(vars(delta.disc), funs(mean(., na.rm=TRUE)))

csiro_years <- csiro_annual_avg$year



# open and format the Rubino data
rubino <- read.csv('/Users/IsadT/Desktop/Carbon/data/atmosphere/d13C/data_source/rubino_data.csv')
colnames(rubino)[colnames(rubino)=="age"] <- "year"


# filter the Rubino data for the years that overlap with the CSIRO data
overlap <- filter(rubino, year %in% csiro_years)

# merge Rubino with CSIRO
merged <- merge(overlap, annual_average, by='year')
colnames(merged)[colnames(merged)=="d13"] <- "d13.rubino"
colnames(merged)[colnames(merged)=="delta.disc"] <- "d13.csiro"


# correcting the CSIRO values according to the overlap with the Rubino record
rows_csiro <- nrow(annual_average)
annual_avg_corr <- rep(0,rows_csiro)

for (i in 1:rows_csiro){
  x<-annual_average$delta.disc[i]
  annual_avg_corr[i] <- x - 0.04851815 
}

annual_average$corrected <- annual_avg_corr
annual_average


# creating the merged dataset
annual_average$delta.disc<-NULL
colnames(annual_average)[colnames(annual_average)=="corrected"] <- "d13_atmos"
atmos_compiled <- rbind(rubino, annual_average)

# write csv of data
write.csv(atmos_compiled, "/Users/IsadT/Desktop/Carbon/data/atmosphere/d13C/outputs/merged_Rubino_CSIRO.csv")

