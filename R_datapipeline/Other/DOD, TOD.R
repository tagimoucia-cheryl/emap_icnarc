#SETUP

library(tidyverse)
library(lubridate)
library(chron)

#import csv death detail files
d <- file.choose()"B:/exported_star/icnarc/death.csv"
rip <- read.csv(d)

#import ITU patients
i <- file.choose()"B:/exported_star/icnarc/ITU_patients.csv"
pt <- read.csv(i)

#create itu patient list
itu_pt <-
  data.frame(table(pt$hospital_visit_id))
itu_pt_list <- itu_pt$Var1

#Filter out deaths only by ITU hospital visit id and non-NA value for datetime of death
itu_rip <-
  rip%>%
  filter(hospital_visit_id %in% itu_pt_list) %>%
  filter(datetime_of_death != "NA")

#FORMATTING FOR ICNARC
#format dod as per icnarc
itu_rip$dod <-
  substr(itu_rip$ï..date_of_death,1,10)
itu_rip$DOD <-
  as.Date(as.character(itu_rip$dod), format = "%d/%m/%Y")
#isolating time of death from datetime
itu_rip$tod <-
  substr(itu_rip$datetime_of_death,12,19)
#adjusting tod 00:00:00 to 00:00:01 as per icnarc field specifications
itu_rip$tod[itu_rip$tod == "00:00:00"] <-  "00:00:01"
#format tod as per icnarc into hh:mm:ss
itu_rip$TOD <-
chron(time=itu_rip$tod)

#FINISH
#select out desired variables
itu_rip_icnarc <-
  itu_rip%>%
  select(hospital_visit_id,
         DOD,
         TOD)
