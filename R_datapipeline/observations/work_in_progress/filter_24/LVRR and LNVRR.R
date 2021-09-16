library(tidyverse)

x <- file.choose()#choose "vent_rr_24.csv" (or equivalent if saved differently)
RRv <- read.csv(x)

#concatenate hospital visit id with observation_datetime to make unique observation
#time point for specifc patient (otherwise filtering by datetime alone may refer to
#different patient)
uRRv <- RRv
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

