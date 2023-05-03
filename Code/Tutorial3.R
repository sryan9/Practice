library(arrow)
library(tidyverse)
library(data.table)


filter_data <- function(file_path, Sex, Region, Health_Outcome){
  Data <- open_dataset(file_path) %>%
    filter(sex == Sex,
           region == Region)%>%
    rename(Outcome = Health_Outcome) %>%
    select(Outcome, Zip, Date, TAVG, RH)%>%
    collect()
}

#source("C:\\Users\\sophi\\OneDrive\\Documents\\LukeTutorial\\R_Tutorial_1\\Tutorial3.R")

MMA <- filter_data(file_path = 'Temp_and_Health.parquet',
            Sex='M',
            Region = 'Mountains',
            Health_Outcome = 'Anxiety')
  