
#Create csv with Unique plants,
#unique pollinators, unique interactions
data = readRDS("Data/3_Final_data/Interaction_data.rds")

library(dplyr)
pollinators = data %>% 
select(Pollinator_rank, Pollinator_accepted_name)%>%
filter(Pollinator_rank == "SPECIES") %>% 
select(Pollinator_accepted_name) %>%
distinct() %>% 
rename(Species = Pollinator_accepted_name) %>% 
mutate(Trophic_level = "Pollinator")


plants = data %>% 
select(Plant_rank, Plant_accepted_name)%>%
filter(Plant_rank == "SPECIES") %>% 
select(Plant_accepted_name) %>%
distinct() %>% 
rename(Species = Plant_accepted_name) %>% 
mutate(Trophic_level = "Plant")

accepted_species_euppolnet = rbind(plants, pollinators)

write.csv(accepted_species_euppolnet, "Data/Working_files/accepted_species_euppolnet.csv")
