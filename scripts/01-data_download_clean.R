#### Preamble ####
# Purpose: Download and clean the data from opendatatoronto
# Author: Rayhan Walia
# Data: 31 January 2021
# Contact: rayhan.walia@mail.utoronto.ca [PROBABLY CHANGE THIS ALSO!!!!]
# License: MIT


#### Workspace setup ####

library(tidyverse)
library(ggplot2)
library(car)
library(janitor)
library(opendatatoronto)


package <- show_package("ac77f532-f18b-427c-905c-4ae87ce69c93")
package


# get all resources for this package
resources <- list_package_resources("ac77f532-f18b-427c-905c-4ae87ce69c93")

# identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))

# load the first datastore resource as a sample
data <- filter(datastore_resources, row_number()==1) %>% get_resource()
data

#cleaning data
data<-clean_names(data)
data <- data[complete.cases(data),]
#names
names(data)[names(data) == 'date_mmm_yy'] = 'date'

#creating total number variable
data <- data %>% 
  mutate(total=ageunder16+age16_24+age25_44+age45_64+age65over)

#converting dates
data <- data %>% 
  mutate(date=as.Date(paste('01',substr(date,1,3),
                            '20',substr(date,5,6),sep=''),'%d%B%Y'))

#removing id
data <- data %>% 
  select(-id)

         
# Save Data #

write_csv(data,'inputs/data/shelter_flow.csv')


         