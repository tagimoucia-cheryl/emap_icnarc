#SETUP

library(tidyverse)

t <- file.choose()
temp <- read.csv(t) #open csv file containing ITU patient temperature in first 24h


#filter for celsius reading only
temc <-
  subset(temp, id_in_application == 3040100959)

#identify min and max temp for 1st 24h patient admission
m_temp <-
  temc %>%
  group_by(hospital_visit_id) %>%
  summarise(LNCTEMP = min(value_as_real), HNCTEMP = max(value_as_real))

