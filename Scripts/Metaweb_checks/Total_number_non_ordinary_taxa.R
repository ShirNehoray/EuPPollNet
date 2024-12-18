
#Load libraries
library(dplyr)
library(iNEXT)

#Load data
data = readRDS("Data/3_Final_data/Interactions.rds") %>% 
mutate(Network_id = paste0(Study_id, Network_id))  

#Filter out main poll groups
bee_fam = c("Apidae", "Megachilidae", "Halictidae",
            "Andrenidae", "Colletidae", "Melittidae")

data = data %>% 
filter(!Pollinator_family == "Syrphidae") %>% 
filter(!Pollinator_family %in% bee_fam) %>% 
filter(!Pollinator_order== "Lepidoptera")

#Pollinators
#Select columns of interest
poll_data = data %>% 
mutate(Network_id = paste0(Study_id, Network_id)) %>% 
filter(Pollinator_rank == "SPECIES") %>% 
dplyr::select(Network_id, Pollinator_accepted_name) %>% 
distinct() 

#Count occurrences of each species in each study
poll_result = poll_data %>%
count(Network_id, Pollinator_accepted_name) %>% 
group_by(Pollinator_accepted_name) %>% 
summarise(Incidence = sum(n))

#Generate incidence matrix with number of sampling units at the begining
poll = matrix(c(length(unique(poll_data$Network_id)) , 
          poll_result %>% pull(Incidence)),  
          ncol = 1)
row.names(poll) = c("Plot", poll_result %>% pull(Pollinator_accepted_name))
poll = data.frame(poll)
colnames(poll) = "Network_id"

#Calculate sampling coverage
poll_output = iNEXT(poll, datatype = 'incidence_freq')
#Save output
#saveRDS(poll_output, "Data/Working_files/pollinator_sampling_coverage.rds")
#Plot
ggiNEXT(poll_output, type=1) 
