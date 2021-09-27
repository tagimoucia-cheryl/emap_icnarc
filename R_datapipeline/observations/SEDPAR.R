#SETUP

library(tidyverse)
library(lubridate)

#Load csv file with itu patient who received sedation during their itu visit/admission
s <- file.choose()
sed <- read.csv(s)


#Load itu patient list
i <- file.choose()
itu <- read.csv(i)



#Review of sedation record keeping in one patient
#subselect for one hospital visit id
#insight - sedation amount no recorded every hour - ?establish 24hrs as non zero  values from admission to non admission?

a <- 
  subset(sed, hospital_visit_id == 446, 
         select = ï..admission_time:value_as_real)

#create - annotate sedation id codes 
sed$name <-
  if_else(sed$visit_observation_type_id == 235982409, "clonidine",
          if_else(sed$visit_observation_type_id == 236038935, "dexmed",
                  if_else(sed$visit_observation_type_id == 236038975, "midazolam",
                          if_else(sed$visit_observation_type_id == 236056891, "propofol", "none"))))


#FILTER FOR FIRST 24 HOURS OF ITU ADMISSION
#create admission datetime vector for each hospital visit
ad <-
  sed%>% 
  group_by(hospital_visit_id) %>%
  summarise(ad = min(ï..admission_time))
#merge with sed file
sed <- 
  merge(x = sed, y = ad, by = "hospital_visit_id", all.x = TRUE)
#create POSIXlt format of admission datetime
sed$at <-
  substr(sed$ad, 1, 19)
sed$at <-
  strptime(sed$at, "%d/%m/%Y %T", tz = "GMT")
#create outer admission time parameters, at 24 and 25 hours
sed$at_24 <-
  sed$at + dhours(24)
sed$at_25 <-
  sed$at + dhours(25)
#create POSIXlt format of observation_datetime
sed$ot <-
  substr(sed$observation_datetime, 1, 19)
sed$ot <-
  strptime(sed$ot, "%d/%m/%Y %T", tz = "GMT")
#filter original sed file
sed_24 <-
  sed %>%
  filter((ot >at)& (ot < at_25))

#DURATION OF SEDATION
# duration sedation, < 24 hours = partial sedation .'. either 'S' or 'N'
dur <- 
  sed_24  %>%
  group_by(hospital_visit_id) %>%
  summarise(earl = min(ot), late = max(ot))
#create duration vector
dur$dur_hrs <- (dur$late - dur$earl) / (60 * 60)
#create partial icnarc vector (containing sedation categories only)
dur$sed_sedpar <-
  if_else(dur$dur_hrs > 23.499999999, "S", "N")
#trim duration df
sedpar_sn <-
  dur %>%
  select(hospital_visit_id,sed_sedpar)

#merge with full ITU patient list
itu_pt <- data.frame(table(itu$hospital_visit_id))
#create itu patient list with 'S' and 'N' annotations
itu_sn <-
merge(x=itu_pt, y=sedpar_sn, 
      by.x = "Var1",
      by.y = "hospital_visit_id",
      all.x = TRUE)
#create icnarc sedpar df
icnarc_sedpar <-
  itu_sn %>%
  select("hospital_visit id" = Var1,
         sed_sedpar)
#complete icnarc sedpar annotation to include non sedated
s <- c("S", "N")
icnarc_sedpar$sedpar <-
  if_else(icnarc_sedpar$sed_sedpar %in% s, icnarc_sedpar$sed_sedpar, "V")
