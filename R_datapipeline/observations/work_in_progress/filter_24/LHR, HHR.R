#SETUP

library(tidyverse)
library(lubridate)


v24 <- file.choose()#loading .csv file with first 24 hours of admission to ITU location
vit24 <- read.csv(v24)

View(vit24) #shows >1 admission date in ITU locations (bed change)
#.'. need to filter table by first admission dates

#subset HR data frame 
#LOOKUP in emap mapping: Heart rate = 8 (https://docs.google.com/spreadsheets
#/d/1k5DqkOfUkPZnYaNRgM-GrM7OC2S4S2alIiyTC8-OqCw/edit#gid=1661666003)
HR <-
  subset(vit24, id_in_application == 8)

#identify "first admisison"
f_at <- 
HR %>%
  group_by(hospital_visit_id) %>%
  summarise(f_at = min(admission_time))

#merge first admission with pre-existing HR
f_HR <- 
merge(x = HR, y = f_at, by = "hospital_visit_id", all = TRUE)

#translate admission time to POSIXlt
f_HR$f_at <- substr(
  f_HR$f_at,1,19
)
f_HR$f_at <- strptime(
  f_HR$f_at,"%d/%m/%Y %T", tz = "GMT"
) 

#new at column for admission datetime + 24hrs in POSIXlt format
f_HR$f_at24 <- f_HR$f_at +
  dhours(24)

#create observation datetime column in POSIXlt format
f_HR$ot <- 
  substr(f_HR$observation_datetime,1,19)

f_HR$ot <-
  strptime(
    f_HR$ot,"%d/%m/%Y %T", tz = "GMT") 

#filter data frame for observations done within first 24 hours of admisison
HR_24 <- 
  f_HR%>%
  filter(f_HR$ot > f_HR$f_at, f_HR$ot < f_HR$f_at24)

#identify minimum and maximum HR in each hospital visit if for first 24 hours admission to ITU setting
mhr_24 <-
  HR_24 %>%
  group_by(hospital_visit_id) %>%
  summarise(LHR = min(value_as_real), HHR = max(value_as_real))
