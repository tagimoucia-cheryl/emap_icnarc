library(tidyverse)

x <- file.choose()#choose "vent_rr_24.csv" (or equivalent if saved differently)
RRv <- read.csv(x)


#identify "first admisison"
f_at <- 
RRv %>%
  group_by(hospital_visit_id) %>%
  summarise(f_at = min(admission_time))

#merge first admission with pre-existing HR
f_RRv <- 
merge(x = RRv, y = f_at, by = "hospital_visit_id", all = TRUE)

#translate admission time to POSIXlt
f_RRv$f_at <- substr(
 f_RRv$f_at,1,19
)
f_RRv$f_at <- strptime(
f_RRv$f_at,"%d/%m/%Y %T", tz = "GMT"
) 

#new at column for admission datetime + 24hrs in POSIXlt format
f_RRv$f_at24 <- f_RRv$f_at +
  dhours(24)

#create observation datetime column in POSIXlt format
f_RRv$ot <- 
  substr(f_RRv$observation_datetime,1,19)

f_RRv$ot <-
  strptime(
   f_RRv$ot,"%d/%m/%Y %T", tz = "GMT") 

#filter data frame for observations done within first 24 hours of admisison
RRv_24 <- 
  f_RRv %>%
  filter(f_RRv$ot > f_RRv$f_at, f_RRv$ot < f_RRv$f_at24)


#concatenate hospital visit id with observation_datetime to make unique observation
#time point for specifc patient (otherwise filtering by datetime alone may refer to
#different patient)
uRRv <- RRv_24
uRRv$HO <-
  paste(uRRv$hospital_visit_id, uRRv$observation_datetime)

#split the vent from non vent
vent <-
  subset(uRRv, value_as_text == "Yes")
nonv <-
  subset(uRRv, value_as_text == "No")

#create data frames with RR of ventilated and non-ventilated patients separately
vent_rr <-
  filter(uRRv, uRRv$HO %in% vent$HO)
nonv_rr <-
  filter(uRRv, uRRv$HO %in% nonv$HO)

#remove 'na' rows from both vent and non vent rr data frames (otherwise will interfere with identifying minimum value)
f_vent_rr <-
  vent_rr %>%
  filter(!is.na(value_as_real))
f_nonv_rr <- 
  nonv_rr %>%
  filter(!is.na(value_as_real))

#identify minimum RR from non vent

min_nv <-
  f_nonv_rr %>%
  group_by(hospital_visit_id) %>%
  summarise(LNVRR = min(value_as_real))

#identify min and max RR from ventilated patients

m_vent <-
  f_vent_rr %>%
  group_by(hospital_visit_id) %>%
  summarise(LVRR = min(value_as_real), HVRR = max(value_as_real))

