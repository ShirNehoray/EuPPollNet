### Table of contents

* [Project description](#Project)

* [Manuscript information](#Article)

* [Abstract](#Abstract)

* [Usage](#Usage)

* [Citation guidelines](#Citation-guidelines)

* [Indexing](#Indexing)


### Project

- **SAFEGUARD** (Safeguarding European wild pollinators). Horizon 2020 (No. 101003476). Task 1.5: Mapping European Pollinator species interactions and community assembly

### Article

- **Title: "EuPPollNet: A European database of plant-pollinator networks"**
- **Jounal: Global Ecology and Biogeography**
- **DOI:** http://dx.doi.org/10.1111/geb.70000

### Abstract

- **Motivation**: Pollinators play a crucial role in maintaining Earth’s terrestrial biodiversity and human food production by mediating sexual reproduction for most flowering plants. Indeed, the network of interactions formed by plants and pollinators constitutes the backbone of plant-pollinator community stability and functioning. However, rapid human-induced environmental changes are compromising the long-term persistence of plant-pollinator interaction networks. One of the major challenges for pollinator conservation is the lack of robust generalisable data capturing how plant-pollinator communities are structured across space and time. Here, we present the EuPPollNet (European Plant-Pollinator Networks) database, a fully open and reproducible European-level database containing harmonized taxonomic data on plant-pollinator interactions referenced in both space and time, along with other ecological variables of interest. This database offers an open workflow that allows researchers to track data-curation decisions and edit them according to their preferences. We present the taxonomic and sampling coverage of EuPPollNet, and summarize key structural properties in plant-pollinator networks. We hope EuPPollNet will stimulate future research that fills the taxonomic, ecological, and geographical data gaps on plant-pollinator interactions that we have identified. Further, the variation in the structure of the networks in EuPPollNet provides a strong basis for future studies aimed at quantifying drivers of plant-pollinator network change and guiding future conservation planning for plants and pollinators.

- **Main Types of Variables Included**: EuPPollNet contains 1,162,913 interactions between plants and pollinators from 1,864 distinct networks (i.e., distinct sampling event in space or time), which belong to 54 different studies distributed across 23 European countries. In addition, information about sampling methodology, habitat type, bio-climatic region, and further taxonomic rank information for both plant and pollinator species are also provided (i.e., genus, family and order).

- **Spatial location and grain**: The database contains 1,214 different sampling locations from 13 different natural and anthropogenic habitats that fall in 7 different bio-climatic regions. All records are geo-referenced and presented in the World Geodetic System 1984 (WGS84).

- **Time period and grain**: Species interaction data was collected between 2004 and 2021. All records are time-referenced and most of the studies documented interactions within a single flowering season (68.52%).

- **Major taxa and level of measurement**: The database contains interaction data at the species level for 94% of the records, including a total of 1,411 plant and 2,223 pollinator species. The database includes data on 6% of the European species of flowering plants, 34% of bees, 26% of butterflies, and 33% of syrphid species at the European level.

- **Software format**: The database was built with the R programming language and is stored as “.rds” and “.csv” formats. The construction of the database is fully reproducible and can be accessed in this repository.

### Usage

The [interaction data](Data/3_Final_data/Interaction_data.rds) and [flower count data](Data/3_Final_data/Flower_counts.rds) data can be found in the folder `Data/3_Final_data/` and both datasets can be merged by the 'Flower_data_merger' column. Raw networks can be accessed at `Data/1_Raw_data/` and all code to produce this work is located in the `Scripts/` folder. To run the scripts, it is advised to use `renv::restore()` to restore the libraries to their required versions. The `renv.lock` file contains specific information about the version of each library.

- **Example to generate network matrices from long format:**


``` r
#Build network matrices from long format
#Note: This code generates binary matrices
#Comment line as indicated in Step 5 to generate quantitative ones
#Load libraries
library(dplyr)
library(stringr)
library(tidyr)
library(lubridate)
library(tibble)

#Step 1: Read data
data = readRDS("Data/3_Final_data/Interaction_data.rds")

#Step 2: Split date into 3 cols to have year in a single column
data = data %>%
mutate(Year = year(Date), 
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
  column_to_rownames("Plant_accepted_name") %>% 
  as.matrix()
}

#Step 6: Apply function to each network within the list
matrices_list = map(long_format_list, sum_interactions)

```

### Citation guidelines

If you use this database in your research, please make sure to cite this data paper:

``` r
@article{https://doi.org/10.1111/geb.70000,
author = {Lanuza, Jose B. and Knight, Tiffany M. and Montes-Perez, Nerea and Glenny, Will and Acuña, Paola and Albrecht, Matthias and Artamendi, Maddi and Badenhausser, Isabelle and Bennett, Joanne M. and Biella, Paolo and Bommarco, Ricardo and Cappellari, Andree and Castro, Sílvia and Clough, Yann and Colom, Pau and Costa, Joana and Cyrille, Nathan and de Manincor, Natasha and Dominguez-Lapido, Paula and Dominik, Christophe and Dupont, Yoko L. and Feldmann, Reinart and Felten, Emeline and Ferrero, Victoria and Fiordaliso, William and Fisogni, Alessandro and Fitzpatrick, Úna and Galloni, Marta and Gaspar, Hugo and Gazzea, Elena and Goia, Irina and Gómez-Martínez, Carmelo and González-Estévez, Miguel A. and González-Varo, Juan Pedro and Grass, Ingo and Hadrava, Jiří and Hautekèete, Nina and Hederström, Veronica and Heleno, Ruben and Hervias-Parejo, Sandra and Heuschele, Jonna M. and Hoiss, Bernhard and Holzschuh, Andrea and Hopfenmüller, Sebastian and Iriondo, José M. and Jauker, Birgit and Jauker, Frank and Jersáková, Jana and Kallnik, Katharina and Karise, Reet and Kleijn, David and Klotz, Stefan and Krausl, Theresia and Kühn, Elisabeth and Lara-Romero, Carlos and Larkin, Michelle and Laurent, Emilien and Lázaro, Amparo and Librán-Embid, Felipe and Liu, Yicong and Lopes, Sara and López-Núñez, Francisco and Loureiro, João and Magrach, Ainhoa and Mänd, Marika and Marini, Lorenzo and Mas, Rafel Beltran and Massol, François and Maurer, Corina and Michez, Denis and Molina, Francisco P. and Morente-López, Javier and Mullen, Sarah and Nakas, Georgios and Neuenkamp, Lena and Nowak, Arkadiusz and O'Connor, Catherine J. and O'Rourke, Aoife and Öckinger, Erik and Olesen, Jens M. and Opedal, Øystein H. and Petanidou, Theodora and Piquot, Yves and Potts, Simon G. and Power, Eileen F. and Proesmans, Willem and Rakosy, Demetra and Reverté, Sara and Roberts, Stuart P. M. and Rundlöf, Maj and Russo, Laura and Schatz, Bertrand and Scheper, Jeroen and Schweiger, Oliver and Serra, Pau Enric and Siopa, Catarina and Smith, Henrik G. and Stanley, Dara and Ştefan, Valentin and Steffan-Dewenter, Ingolf and Stout, Jane C. and Sutter, Louis and Švara, Elena Motivans and Świerszcz, Sebastian and Thompson, Amibeth and Traveset, Anna and Trefflich, Annette and Tropek, Robert and Tscharntke, Teja and Vanbergen, Adam J. and Vilà, Montserrat and Vujić, Ante and White, Cian and Wickens, Jennifer B. and Wickens, Victoria B. and Winsa, Marie and Zoller, Leana and Bartomeus, Ignasi},
title = {EuPPollNet: A European Database of Plant-Pollinator Networks},
journal = {Global Ecology and Biogeography},
volume = {34},
number = {2},
pages = {e70000},
doi = {https://doi.org/10.1111/geb.70000},
url = {https://onlinelibrary.wiley.com/doi/abs/10.1111/geb.70000},
year = {2025}
}
```


### Indexing

[![GloBI Review by Elton](../../actions/workflows/review.yml/badge.svg)](../../actions/workflows/review.yml) [![GloBI](https://api.globalbioticinteractions.org/interaction.svg?accordingTo=globi:JoseBSL/EuPPollNet&refutes=true&refutes=false)](https://globalbioticinteractions.org/?accordingTo=globi:JoseBSL/EuPPollNet)

EuPPollNet is configured to be indexed by Global Biotic Interactions (GloBI, https://globalbioticinteractions.org).




