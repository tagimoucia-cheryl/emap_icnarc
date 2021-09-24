#SETUP

library(tidyverse)
library(lubridate)

#import file; WCC for itu patients (whole admission)
w <- file.choose() 
wcc <- read.csv(w)

#FILTER FOR FRIST 24 HOURS OF ITU ADMISSION
#create admission time parameters
adm <-
  wcc %>%
  group_by(hospital_visit_id) %>%
  summarise(ad = min(admission_time))

#merge with wcc df
a_wcc <-
merge(x=wcc, y=adm, by = "hospital_visit_id", all.x = TRUE)

#change first admission time format to POSIXlt
a_wcc$ad2 <-
  substr(a_wcc$ad,1,19)
a_wcc$ad2 <-
  strptime(a_wcc$ad2, "%d/%m/%Y %T", tz = "GMT")

#create outer admission parameter value of admission time + 24 hours
a_wcc$ad_24 <-
  a_wcc$ad2 + dhours(24)

#change requesttime format to POSIXlt
a_wcc$rt <-
  substr(a_wcc$request_datetime,1,19)
a_wcc$rt <-
  strptime(a_wcc$rt, "%d/%m/%Y %T", tz = "GMT")

#filter request time for first 24 hrs itu admission 
wcc_24 <-
  a_wcc %>%
  filter(rt >ad2, rt < ad_24)

#EXTRACT ICNARC VALUES
#identify min and max Na per hospital visit id
i_na <-
  wcc_24 %>%
  group_by(hospital_visit_id) %>%
  summarise(LNA = min(value_as_real), HNA = max(value_as_real))

