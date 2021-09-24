#SETUP

library(tidyverse)
library(lubridate)

#Load csv file with ITU Na values

n <- file.choose()
na <- read.csv(n)


#FILTER FOR FRIST 24 HOURS OF ITU ADMISSION
#create admission time parameters
adm <-
  na %>%
  group_by(hospital_visit_id) %>%
  summarise(ad = min(admission_time))

#merge with na df
a_na <-
  merge(x=na, y=adm, by = "hospital_visit_id", all.x = TRUE)

#change first admission time format to POSIXlt
a_na$ad2 <-
  substr(a_na$ad,1,19)
a_na$ad2 <-
  strptime(a_na$ad2, "%d/%m/%Y %T", tz = "GMT")

#create outer admission parameter value of admission time + 24 hours
a_na$ad_24 <-
  a_na$ad2 + dhours(24)

#change requesttime format to POSIXlt
a_na$rt <-
  substr(a_na$request_datetime,1,19)
a_na$rt <-
  strptime(a_na$rt, "%d/%m/%Y %T", tz = "GMT")

#filter request time for first 24 hrs itu admission 
na_24 <-
  a_na %>%
  filter(rt >ad2, rt < ad_24)

#EXTRACT ICNARC VALUES
#identify min and max Na per hospital visit id
i_na <-
  na_24 %>%
  group_by(hospital_visit_id) %>%
  summarise(LNA = min(value_as_real), HNA = max(value_as_real))
