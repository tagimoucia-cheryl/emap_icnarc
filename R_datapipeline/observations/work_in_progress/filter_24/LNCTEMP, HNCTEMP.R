#SETUP

library(tidyverse)

t <- file.choose()
temp <- read.csv(t) #open csv file containing ITU patient temperature in first 24h


#filter for celsius reading only
temc <-
  subset(temp, id_in_application == 3040100959)

#identify "first admisison"
f_at <- 
temc %>%
  group_by(hospital_visit_id) %>%
  summarise(f_at = min(admission_time))

#merge first admission with pre-existing HR
f_temc <- 
merge(x = temc, y = f_at, by = "hospital_visit_id", all = TRUE)

#translate admission time to POSIXlt
f_temc$f_at <- substr(
  f_HR$f_at,1,19
)
f_temc$f_at <- strptime(
  f_HR$f_at,"%d/%m/%Y %T", tz = "GMT"
) 

#new at column for admission datetime + 24hrs in POSIXlt format
f_temc$f_at24 <- f_temc$f_at +
  dhours(24)

#create observation datetime column in POSIXlt format
f_temc$ot <- 
  substr(f_temc$observation_datetime,1,19)

f_temc$ot <-
  strptime(
  f_temc$ot,"%d/%m/%Y %T", tz = "GMT") 

#filter data frame for observations done within first 24 hours of admisisontemc_24 <- 
  temc_24 >%
  filter(f_temc$ot > f_temc$f_at, f_temc$ot < f_temc$f_at24)

#identify min and max temp for 1st 24h patient admission
m_temp <-
  temc_24 %>%
  group_by(hospital_visit_id) %>%
  summarise(LNCTEMP = min(value_as_real), HNCTEMP = max(value_as_real))

