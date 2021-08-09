#Load essential starters

library(tidyverse)
library(lubridate)

respfile <- file.choose()

cvs_resp <- read.csv(respfile)#retrieving db Forge exported csv
#containing cvs and resp obs


r <- cvs_resp #create resp working files


Rw <- 
  subset(r, id_in_application == 9) #subset RR information only

colnames(Rw)

#subsetting to include first 24 hours admission only
Rw$at <- Rw$admission_time

Rw$at <- substr(
  Rw$admission_time,1,19
)

Rw$at <- strptime(
  Rw$at, "%d/%m/%Y %T", tz = "GMT"
) #new at column for admission datetime in POSIXlt format


Rw$at_24 <- Rw$at +
  dhours(24)#new at column for admission datetime + 24hrs in POSIXlt format


Rw$ot <- Rw$observation_datetime

Rw$ot <- substr(
  Rw$observation_datetime,1,19
)

Rw$ot <- strptime(
  Rw$ot, "%d/%m/%Y %T", tz = "GMT"
) #new at column for result_last_modified datetime in POSIXlt format

#filtering out non- first 24 hour admission results

Rw24 <- Rw %>%
  filter(Rw$ot > Rw$at, Rw$ot < Rw$at_24)

View(Rw24)

#creating working data for ABG 24 hours 

Rwd24 <- Rw24 %>%
  select (hospital_visit_id,
          visit_observation_type_id,
          value_as_real,
          at,
          at_24,
          ot)

#trying to identify minimum in each hospital visit

Rwd24 %>%
  group_by(hospital_visit_id) %>%
  summarize (minimum = min(value_as_real)) #TODO - need to also add in observation_datetime

write.csv(Rwd24,file = 'RR.csv')

#creating separate ventilated and non ventilated lists 

file.vent <- file.choose() #loading vent and non vent patients, *already filtered for 
#first 24 hours of admission

ventstat <- read.csv(file.vent)

View(ventstat)

vent24 <- #creating df with those ventilated at ANY time in first 24h of admission ITU
  subset(ventstat, value_as_text == 'Yes')

sv24 <- #creating df with those non-ventilated at ANY time in first 24h admission ITU
  subset(ventstat, value_as_text == 'No')
