#SETUP

library(tidyverse)
library(lubridate)
library(chron)


#Load ITU admission
i <- file.choose() #load file with "ITU patients"
itu <- read.csv(i)

#FORMAT ADMISSION DATA
#identify admission day (min admission)
ad <-
  itu %>%
  group_by(hospital_visit_id) %>%
  summarise(ad = min(admission_time))
#format admission day to ccyy-mm-dd
ad$ad1 <-
  substr(ad$ad,1,10)
ad$ad2 <-
as.Date(as.character(ad$ad), format = "%d/%m/%Y") #this does ccyy-mm-dd!!
#format admission time hh:mm:ss
ad$at <-
  substr(ad$ad,12,19)
ad$at2 <-
chron(time=ad$at)
#select desired variables
adm_icnarc <-
  ad %>%
  select(hospital_visit_id,
         DAICU = ad2,
           TAICU = at2)


#FORMAT DISCHARGE DATA
#identify discharge day
dc <- 
  itu %>%
  group_by(hospital_visit_id) %>%
  summarise(dd = max(discharge_time))
#format discharge day to ccyy-mm-dd
dc$dd2 <- substr(dc$dd,1,10)
dc$dd2 <- 
  as.Date(as.character(dc$dd2), format = "%d/%m/%Y")
#format discharge time hh:mm:ss
dc$dt <- 
  substr(dc$dd,12,19)
dc$dt2 <-
  chron(time=dc$dt)
#select wanted variables
icnarc_dc <-
  dc %>%
  select(hospital_visit_id,
         DDICU = dd2,
         TDICU = dt2)
#MERGE
los_itu<-
merge(x=adm_icnarc, y=icnarc_dc, by = "hospital_visit_id", all = TRUE)

