#SETUP

library(tidyverse)
library(lubridate)

#Load csv file containing EMAP export of ABG for all hospital visit id in itu locations
i <- file.choose() #B:/exported_star/icnarc/ITU_abg_mrn.csv
#name "bg' as blood gas includes venous and arterial
bg <- read.csv(i)#open csv file with all itu patients

#VALIDATION CHECKS
#create list of hospital_visit_ids that have been in ITU locations
itu.list <-
  data.frame(table(itu%>%select(hospital_visit_id)))
#create list of hospital_visit_ids present in bg list
bg.list <-
  data.frame(table(bg %>% select(hospital_visit_id)))
#merge lists - VALIDATION RESULT; all bg ids present in itu patient list
check <-
merge(x=bg.list, y=itu.list, by = "Var1", all.x = TRUE)

#CREATE AND FILTER FOR ADMISSION + 24 HOURS
#create admission time parameters
adm <-
  bg %>%
  group_by(hospital_visit_id) %>%
  summarise(ad = min(admission_time))
adm$add <-
  substr(adm$ad,1,19)
adm$add <-
  strptime(adm$add, "%d/%m/%Y %T", tz = "GMT")
adm$ad24 <-
  adm$add + dhours(24)

#merge admission with blood gases
bg_all <- 
merge(x=bg, y=adm, by = "hospital_visit_id", all.x = TRUE)

#create POSIXlt version of sample collection time 
bg_all$st <-
  substr(bg_all$sample_collection_time,1,19)
bg_all$st <-
  strptime(bg_all$st,"%d/%m/%Y %T", tz = "GMT")

#filter for blood gases taken within 24 hours of admission 
bg_24 <-
  bg_all %>%
  filter (st > add, st < ad24)

#FILTERING OUT POSSIBLE VENOUS SAMPLES
#creating lab sample ids for samples where so2 > 80%
a_lab <-
  bg_24 %>%
  filter(test_lab_code == "sO2") %>%
  filter(value_as_real >80) %>%
  select("ï..lab_sample_id" )

#creating arterial blood gas data frame, where sao2 in samples > 80%
abg_24 <- 
  bg_24 %>%
  filter(ï..lab_sample_id %in% a_lab$ï..lab_sample_id)

#validation sao2 in arterial blood gas database compliant with range - it is
sa <- 
  abg_24 %>%
  filter(test_lab_code == "sO2") %>%
  group_by(hospital_visit_id) %>%
  summarise(min = min(value_as_real), max = max(value_as_real))
   
#CREATING LPH_V3
abg_pH <-
  abg_24 %>%
filter(test_lab_code == "pH") %>%
  group_by(hospital_visit_id) %>%
  summarise(LPH_V3 = min(value_as_real))

#CREATING ILPO
min_pO2 <- 
  abg_24 %>%
  filter(test_lab_code == "pO2") %>%
  group_by(hospital_visit_id) %>%
  summarise(ILPO = min(value_as_real))

#CREATING UNIQUE SAMPLE ID TO BE ABLE TO IDENTIFY FIO2 TO LOWEST POA2
#creating unique id in ILPO file
min_pO2$u_id <-
  paste(min_pO2$hospital_visit_id, min_pO2$ILPO)

#create unique id of po2 and hospital id in arterial blood gas frame
abg_24$u_id <-
  paste(abg_24$hospital_visit_id, abg_24$value_as_real)
#create unique hospital and sample id
abg_24$u_id2 <-
  paste(abg_24$hospital_visit_id, abg_24$ï..lab_sample_id)
  
#find lab sample id in arterial blood gas dataframe for samples with lowest pO2
min_pO2_lab <-
  abg_24 %>%
  filter(abg_24$u_id %in% min_pO2$u_id) %>%
  select(u_id2)

#find FILPO in these samples
FILPO <-
abg_24 %>%
  filter(u_id2 %in% min_pO2_lab$u_id2) %>%
  filter(test_lab_code == "FIO2") %>%
  group_by(hospital_visit_id) %>%
  summarise(FILPO = (value_as_real))

#note - on extraction on EMAP multiple rows created to merge command, may need next step so removing duplicates. 
#can also validate no repeat hospital _visit_ids
d_FILPO <-
  distinct(FILPO, hospital_visit_id, FILPO)
