#creates data frame with 2 columns: hospital visit id and lowest SBP in first 24 hours

#SETUP
library(stringr)

#Load observations file, this should be the exported SQL file containing first 24 hours of cvs/resp/temp obs
x <- file.choose()
day <- read.csv(x)

View(day)
#Retrieve BP measurements only
SBP <-
  subset(day, id_in_application == 5)

View(SBP)
#Create new variable column containing Systolc BP values only
SBP$sbp<-
str_extract(SBP$value_as_text, "\\d+") 

df_LSYS<-
  SBP %>%
  dplyr::group_by(hospital_visit_id) %>%
  dplyr::summarise(LSYS = min(sbp)) #table with min systolic BP
#for each specific hospital_visit(in pre-requisite ITU split locale)
