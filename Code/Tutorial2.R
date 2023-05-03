library(arrow)
library(data.table)
library(tidyverse)

setwd("~/LukeTutorial/R_Tutorial_1")

Regions <- fread('Regions.csv')

#Regions

Mountains <- Regions %>%
  filter(Region == 'Mountains')%>%
  select(ZCTA)

Piedmont <- Regions %>%
  filter(Region == 'Piedmont')%>%
  select(ZCTA)

Coast <- Regions %>%
  filter(Region == 'Coast')%>%
  select(ZCTA)

#Left Join
temp_and_health <- left_join(open_dataset('Temperature_Data.parquet')%>%
                               select(Zip, Date, TAVG, RH),
                             open_dataset('Health_Data.parquet') %>%
                               select(admitdt, zip5, sex, Mental_Health, Anxiety) %>%
                               group_by(admitdt, zip5, sex) %>%
                               summarise(Mental_Health = sum(Mental_Health),
                                         Anxiety=sum(Anxiety))%>%
                               rename(Date = admitdt, Zip = zip5),
                             by=c('Date', 'Zip'))%>%
  collect() %>% #converts from list to dataframe
  filter(Date >= '2018-01-01') %>%
  mutate(region = ifelse(Zip %in% Mountains$ZCTA, 'Mountains',
      ifelse(Zip %in% Coast$ZCTA, 'Coast',
        ifelse(Zip %in% Piedmont$ZCTA, 'Piedmont', ""))))

temp_and_health[is.na(temp_and_health)]<- 0

write_parquet(temp_and_health, 'Temp_and_Health.parquet')
