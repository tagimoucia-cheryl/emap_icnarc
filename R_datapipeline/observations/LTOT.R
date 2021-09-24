#SETUP

library(tidyverse)
library(lubridate)

#Load csv file with ITU gcs scores
g <- file.choose()
gcs <- read.csv(g)


#FILTER FOR FRIST 24 HOURS OF ITU ADMISSION
#create admission time parameters
adm <-
  gcs %>%
  group_by(hospital_visit_id) %>%
  summarise(ad = min(admission_time))

#merge with gcs df
a_gcs <-
  merge(x=gcs, y=adm, by = "hospital_visit_id", all.x = TRUE)

#change first admission time format to POSIXlt
a_gcs$ad2 <-
  substr(a_gcs$ad,1,19)
a_gcs$ad2 <-
  strptime(a_gcs$ad2, "%d/%m/%Y %T", tz = "GMT")

#create outer admission parameter value of admission time + 24 hours
a_gcs$ad_24 <-
  a_gcs$ad2 + dhours(24)

#change requesttime format to POSIXlt
a_gcs$ot <-
  substr(a_gcs$observation_datetime,1,19)
a_gcs$ot <-
  strptime(a_gcs$ot, "%d/%m/%Y %T", tz = "GMT")

#filter request time for first 24 hrs itu admission 
gcs_24 <-
  a_gcs %>%
  filter(ot >ad2, ot < ad_24)

#EXTRACT ICNARC VALUES
#identify min and max gcs per hospital visit id
i_gcs <-
  gcs_24 %>%
  group_by(hospital_visit_id) %>%
  summarise(LTOT = min(value_as_real))

