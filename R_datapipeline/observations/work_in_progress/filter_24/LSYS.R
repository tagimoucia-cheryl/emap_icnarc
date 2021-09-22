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

#identify "first admisison"
f_at <- 
SBP %>%
  group_by(hospital_visit_id) %>%
  summarise(f_at = min(admission_time))

#merge first admission with pre-existing HR
f_SBP <- 
merge(x = SBP, y = f_at, by = "hospital_visit_id", all = TRUE)

#translate admission time to POSIXlt
f_SBP$f_at <- substr(
  f_SBP$f_at,1,19
)
f_SBP$f_at <- strptime(
 f_SBP$f_at,"%d/%m/%Y %T", tz = "GMT"
) 

#new at column for admission datetime + 24hrs in POSIXlt format
f_SBP$f_at24 <- f_SBP$f_at +
  dhours(24)

#create observation datetime column in POSIXlt format
f_SBP$ot <- 
  substr(f_SBP$observation_datetime,1,19)

f_SBP$ot <-
  strptime(
    f_SBP$ot,"%d/%m/%Y %T", tz = "GMT") 

#filter data frame for observations done within first 24 hours of admisison
SBP_24 <- 
  f_HR%>%
  filter(f_SBP$ot > f_SBP$f_at, f_SBP$ot < f_SBP$f_at24)


df_LSYS<-
  SBP_24 %>%
  dplyr::group_by(hospital_visit_id) %>%
  dplyr::summarise(LSYS = min(sbp)) #table with min systolic BP
#for each specific hospital_visit(in pre-requisite ITU split locale)
