#Build network matrices from long format
#Note: This code generates binary matrices
#Comment line as indicated in Step 5 to generate quantitative ones
#Load libraries
library(dplyr)
library(stringr)
library(tidyr)
library(lubridate)

#Step 1: Read data
data = readRDS("Data/3_Final_data/Interaction_data.rds")
#Step 2: Split date into 3 cols to have year in a single column
data = data %>%
dplyr::mutate(Year = year(Date), 
                Month = month(Date), 
                Day = day(Date))
#Step 3: Generate a unique a id for a network per study
long_format = data %>% 
mutate(Network_id = paste0(Study_id, "_", Network_id, "_", Year)) %>% 
mutate(Network_id = str_replace_all(Network_id, " ","_")) #Make sure there is no space
#Step 4: Split the data frame based on Network_id
long_format_list = split(long_format, long_format$Network_id)
#Step 5: Function to convert to matrix and sum interactions of same plants and polls
sum_interactions = function(data) {
  data %>% 
  group_by(Plant_accepted_name, Pollinator_accepted_name) %>%
  summarise(Interactions = n()) %>%
  #Comment next line if you want quantitative matrices  
  mutate(Interactions = if_else(Interactions > 0, 1, 0)) %>% 
  pivot_wider(names_from = Pollinator_accepted_name, 
                      values_from = Interactions,
                      values_fill = 0) %>% 
  tibble::column_to_rownames("Plant_accepted_name") %>% 
  as.matrix()
}
#Step 6: Apply function to each network within the list
matrices_list = map(long_format_list, sum_interactions)


