#Load libraries
library(googlesheets4) #To upload to google sheets
library(lubridate) #To operate with dates
library(dplyr) #Handling data
library(tidyr) #Reshape data (wide format)
library(stringr)
library(readr)
#Load data 
data = readRDS("Data/3_Final_data/Interaction_data.rds")
data = data %>%
dplyr::mutate(Year = lubridate::year(Date), 
                Month = lubridate::month(Date), 
                Day = lubridate::day(Date))

orders = data %>% 
distinct(Pollinator_order)
length(orders$Pollinator_order) - 4 



#Select cols of interest and prepare data for processing
taxo_info = data %>% 
dplyr::select(Study_id, 
       Pollinator_accepted_name, Pollinator_order) %>% 
group_by(Pollinator_order) %>% 
summarise(Percent = n()/nrow(.)*100,
          Interactions = n()) %>%
  mutate_if(is.numeric, round, 5)

v = c("Hymenoptera", "Coleoptera", "Lepidoptera", "Diptera")
taxo_info1 = taxo_info %>% 
filter(!Pollinator_order %in% v)

sum(taxo_info1$Percent)

