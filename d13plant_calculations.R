# This script runs the d13C calculations for the isotope samples

library(ggplot2)
library(dplyr)
library(lme4)
library(AICcmodavg)
setwd(dir = "/Users/IsadT/Desktop")


atmosphere <- read.csv('/outputs/CSIRO-Rubino-d13-spline.csv')
isotopes <- read.csv('/data_source/isotope_data.csv.csv')
iso_year <- isotopes$year
atmosphere

atmos <- filter(atmosphere, year %in% iso_year)
data <- merge(isotopes, atmos, by='year')
data$X.x <- NULL
data$X.x <-NULL
data$X.1 <- NULL
data$X.2 <- NULL
data$X.3 <- NULL
data$X.4 <- NULL
data$X.5 <- NULL
data$X.y <- NULL
data$X.y <- NULL
data

colnames(data)[colnames(data)=="d13.disc"] <- "d13.atmosphere"
colnames(data)[colnames(data)=="d.13CVPDB"] <- "d13.plant"

rows <- nrow(data)
data_delta <- rep(0,rows)

for (i in 1:rows){
  x <- data$d13.atmosphere[i]
  y <- data$d13.plant[i]
  
  data_delta[i] <- (x-y)/((1+(y/1000)))
}

data$delta.disc  <- data_delta

data$delta <- NULL

data
write.csv(data, "/outputs/d13plant_fin.csv")

