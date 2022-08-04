# This R script makes a data spline for the CSIRO Rubno C13 dataset.

library(ggplot2)
library(dplyr)
library(lme4)
setwd(dir = "/Users/IsadT/Desktop")


# Importing the merged Rubino-CSIRO data set, establishing the length of time to build the spline for. 
setwd(dir = "/Users/IsadT/Desktop/Carbon/data/")
data <- read.csv('merged_Rubino_CSIRO.csv')

# establish post 1700 time split
data_spline <- data %>% filter(year > 1700)
x <- data_spline$year
y <- data_spline$d13
#Length of sequence establishes the time interval the spline accounts for. 
xs <- seq(1700,2010, by=1)
data_spline


# spline function
pp <- spline(x,y)
ppfun <- splinefun(x,y)
vals <- ppfun(xs)

# Write to CSV
values <- data.frame("year"=xs, "d13_atmos"=vals)
values
write.csv(values,"/Users/IsadT/Desktop/Carbon/data/atmosphere/d13C/outputs/CSIRO-Rubino-d13-spline.csv")

# plotting spline values
colors <- c("antiquewhite4", "gray16")
f <- ggplot(values, mapping = aes(x=year, y=d13_atmos)) +
  geom_point(alpha = 0.8, color="antiquewhite4") + 
  geom_point(data=data_spline, color='red', alpha=0.6) +
  labs(x= "year", y="δ13Ca", color="pathway") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), axis.line =  
          element_line(colour = "black"), plot.title = element_text(hjust = 0.5), legend.background = element_rect(colour = NA), legend.key = element_rect(colour = "white", fill = NA), legend.title = element_blank())
f
ggsave('spline.png', plot=f)

