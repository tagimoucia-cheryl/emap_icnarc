#SETUP
library(tidyverse)
library(lubridate)

#IMPORT CSV FILES
#import csv death detail files
d <- file.choose()#"B:/exported_star/icnarc/death.csv"
rip <- read.csv(d)

#import ITU patients
i <- file.choose()#"B:/exported_star/icnarc/ITU_patients.csv"
pt <- read.csv(i)

#CREATE PATIENT LISTS
#create itu patient list
itu_pt <-
  data.frame(table(pt$hospital_visit_id))
itu_pt_list <- itu_pt$Var1

#create list of hospital visit id  with recorded deaths in patients with ITU location stay
itu_rip <-
  rip%>%
  filter(hospital_visit_id %in% itu_pt_list)

#FORMAT DATES INTO POSIXlt
#create death date in POSIXlt
itu_rip$dd <-
  substr(itu_rip$datetime_of_death, 1,19)
itu_rip$dd <-
  strptime(itu_rip$dd, "%d/%m/%Y %T", tz = "GMT")

#create discharge date in POSIXlt
dc <-
  pt%>%
  group_by(hospital_visit_id) %>%
  summarise(dcd = max(discharge_time))
dc$dcd2 <-
  substr(dc$dcd, 1,19)
dc$dcd2 <- 
  strptime(dc$dcd2, "%d/%m/%Y %T", tz = "GMT")

#MERGE DEATH AND DISCHARGE DATES TOOGETHER
#merge discharge dates and death date together
rip_dc <-
merge(x = itu_rip, y = dc, by = "hospital_visit_id", all = TRUE)


#identify deaths on discharge
rip_dc$dis_rip <-
  if_else(rip_dc$dd < rip_dc$dcd2, 1, (if_else(rip_dc$dd == rip_dc$dcd2,
                                               1,0)))
#ICNARC EXTRACTION
rip_dc$extra_DIS <-
  if_else(is.na(rip_dc$dd), 0, rip_dc$dis_rip)

#######EXTRA VALIDATION AND REVIEW OFHOSPITAL VISIT IDS THAT HAD HAVE 'extra_DIS' OF "NA"
#1. filter out cases where discharge date not completed
#shows 58 without date of death .'. dis_EXTRA likely 0
dis_na <-
  rip_dc %>%
  filter (is.na(dcd))
dis_na$extra_extra_DIS <-
  if_else(is.na(dis_na$datetime_of_death),0,2)

#filter out hospital numbers of not dead to merge with original extra_DIS df above, if desired
not_dd <-
  dis_na %>%
  filter(extra_extra_DIS < 2) %>%
  select(hospital_visit_id, extra_extra_DIS)

#2.Filter out those that know died but not given a discharge date
#shows 13 died without discharge date for ITU
rip_na <-
  dis_na %>%
  filter(is.na(extra_DIS))

#CHECK IF ADMITTED TO ITU BEFORE DATE OF DEATH (by last admission registered in hospital visit)
rip_adm <-
 pt%>%
  filter(hospital_visit_id %in% rip_na$hospital_visit_id) %>%
group_by(hospital_visit_id) %>%
  summarise(last_adm = max(admission_time))
 
#Reformat admission time to POSIXlt
rip_adm$ad <-
  substr(rip_adm$last_adm,1,19)
rip_adm$ad <-
  strptime(rip_adm$ad, "%d/%m/%Y %T", tz = "GMT")

#merge admission date with rip_na
rip_na_adm <- 
merge(x = rip_na, y = rip_adm, by = "hospital_visit_id", all.x = TRUE)

#check if admitted pre-date of death, 10 of 13 admitted to ITU before date of death
rip_na_adm$adm_pre_dd <-
  if_else(rip_na_adm$ad < rip_na_adm$dd, 1, 0)

#populate icnarc parameter, can filter out and merge with original if desired. 
rip_na_adm$extra_extra_DIS <-
  rip_na_adm$adm_pre_dd
  
 ## if desired, can also check EMAP for these patients' location at time of death in star.hospital_visit for thoroughness.
