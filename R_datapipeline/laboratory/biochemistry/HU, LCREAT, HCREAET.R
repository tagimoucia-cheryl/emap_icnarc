#SETUP

library(tidyverse)
library(lubridate)

#load files with laboratory values
l <- file.choose()
lab <- read.csv(l)

#test lab codes Crea, CREA, urea, UREA, Na+ noted
table(lab$test_lab_code)


#create table with only urea, crea
uc <- c("Urea", "UREA","Crea", "CREA")
uc_df <-
  lab %>%
  filter(test_lab_code %in% ucn)

#CREATE NEW DATA FRAME with samples taken between admission and admission + 24
#create admission parameters
uc_df$ad <- 
substr(uc_df$admission_time,1,19)
uc_df$ad2 <-
  strptime(uc_df$ad, "%d/%m/%Y %T", tz = "GMT")
uc_df$ad_24 <-
  uc_df$ad2 + dhours(24)

#recode request datetime into POSIXlt format
uc_df$rt <-
  substr(uc_df$request_datetime,1,19)
uc_df$rt <-
  strptime(uc_df$rt, "%d/%m/%Y %T", tz = "GMT")
  
#filter sample taken according to admission parameters
uc_24 <-
  uc_df %>%
  filter(rt > ad2, rt < ad_24)

#EXTRACT icnarc parameters
u <- c("Urea", "UREA")
c <- c("Crea", "CREA")

HU_df <-
  uc_24 %>%
  filter(test_lab_code %in% u) %>%
  group_by(hospital_visit_id) %>%
  summarise(HU = max(value_as_real))

CREAT_df <-
  uc_24 %>%
  filter(test_lab_code %in% c) %>%
  group_by(hospital_visit_id) %>%
  summarise(LCREAT = min(value_as_real), 
            HCREAT = max(value_as_real))

#note unable to extract Na parameters using this code as request_datetime not provided for Na
#appropriate code provided elsewhere
