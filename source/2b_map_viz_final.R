# Script Info -------------------------------------------------------------
# This script is used to visualize the data in a map

# Importing Libraries -----------------------------------------------------
library(sf)
library(ggspatial)#
library(tidyverse)
library(ggthemes)
library(ggrepel)
library(maps)
library(leaflet)
library(leaflet.extras)

# Setting bounds for maps ------------------------------------------------
bounds <- list()
bounds$min_lon <- min(separated_coord$long, na.rm = T) 
bounds$min_lat <- min(separated_coord$lat, na.rm = T) 
bounds$max_lon <- max(separated_coord$long, na.rm = T) 
bounds$max_lat <- max(separated_coord$lat, na.rm = T)

# Calculating regional totals to display on Map
region_agg <- 
  separated_coord %>%
  select(-geometry) %>%
  group_by(.$tlaName) %>%
  summarise(
    reg_lat = mean(latitude),
    reg_lon = mean(longitude),
    nCrashes = n()
  )

# 1. Showing all of crashes from 2018 - 2020 - Not used as its highly cluttered.
m <- 
  leaflet() %>%
  addTiles() %>% 
  addCircleMarkers(map = ., data = separated_coord , lng = ~longitude, lat = ~latitude, color = 'blue'
  ) %>%
  addCircleMarkers(map = ., data = region_agg , lng = ~reg_lon, lat = ~reg_lat, color = 'red', radius = ~nCrashes / 100, fillOpacity = 0.2,
                   label = ~htmltools::htmlEscape(sprintf('%s:  nCrashes: %s', region_agg$`.$tlaName`, region_agg$nCrashes))) 

m

# 2. Displaying Crashes by Severity by 2018, 2019, 2020

pal <- colorFactor(
  palette = c('red', 'blue', 'green', 'yellow'),
  domain = separated_coord$crashSeverity
)

m <- 
  leaflet() %>%
  addTiles() %>% 
  addCircleMarkers(map = ., data = separated_coord %>% filter(crashYear==2018) , lng = ~longitude, lat = ~latitude, color = ~pal(separated_coord$crashSeverity),  #show individual
  ) %>% 
  addLegend(map=.,data = separated_coord,
            "topleft", pal = pal, values = ~crashSeverity, title = "Crash Severity 2018")
m

m <- 
  leaflet() %>%
  addTiles() %>% 
  addCircleMarkers(map = ., data = separated_coord %>% filter(crashYear==2019) , lng = ~longitude, lat = ~latitude, color = ~pal(separated_coord$crashSeverity),  #show individual
  ) %>% 
  addLegend(map=.,data = separated_coord,
            "topleft", pal = pal, values = ~crashSeverity, title = "Crash Severity 2019")
m

m <- 
  leaflet() %>%
  addTiles() %>% 
  addCircleMarkers(map = ., data = separated_coord %>% filter(crashYear==2020) , lng = ~longitude, lat = ~latitude, color = ~pal(separated_coord$crashSeverity),  #show individual
  ) %>% 
  addLegend(map=.,data = separated_coord,
            "topleft", pal = pal, values = ~crashSeverity, title = "Crash Severity 2020")
m

# 3. Displaying only Fatal Crashes across all years
m <- 
  leaflet() %>%
  addTiles() %>% 
  addCircleMarkers(map = ., data = separated_coord %>% filter(crashSeverity=="Fatal Crash") , lng = ~longitude, lat = ~latitude, color = "red"  #show individual
  ) 
m

# 4. Fatal Crash by region - Yellow shows total crashes count - Not used

region_agg <-
  separated_coord %>%
  select(-geometry) %>%
  group_by(.$tlaName,crashSeverity) %>%
  summarise(
    reg_lat = mean(latitude),
    reg_lon = mean(longitude),
    nCrashes = n()
  )

m <- 
  leaflet() %>%
  addTiles() %>% 
  addCircleMarkers(map = ., data = separated_coord %>% filter(crashSeverity=="Fatal Crash") , lng = ~longitude, lat = ~latitude, color = 'blue', 
                   
  ) %>%
  addCircleMarkers(map = ., data = region_agg%>% filter(crashSeverity=="Fatal Crash") , lng = ~reg_lon, lat = ~reg_lat, color = 'yellow', radius = ~nCrashes , fillOpacity = 0.2,
                   label = ~htmltools::htmlEscape(sprintf('%s:  nCrashes: %s', region_agg$`.$tlaName`, region_agg$nCrashes))) 

m

# 5. Fatal Crash - Break down by Year

pal2 <- colorFactor(
  palette = c('blue', 'black', 'green'),
  domain = separated_coord$crashYear
)

m <- 
  leaflet() %>%
  addTiles() %>% 
  addCircleMarkers(map = ., data = separated_coord %>% filter(crashSeverity =="Fatal Crash"& crashYear==2018) , lng = ~longitude, lat = ~latitude,color="blue",  #show individual
  ) %>% 
  addCircleMarkers(map = ., data = separated_coord %>% filter(crashSeverity =="Fatal Crash"& crashYear==2019) , lng = ~longitude, lat = ~latitude,color="green",  #show individual
  )%>% 
  addCircleMarkers(map = ., data = separated_coord %>% filter(crashSeverity =="Fatal Crash"& crashYear==2020) , lng = ~longitude, lat = ~latitude, color="black", #show individual
  )%>%
  addLegend(map=.,data = separated_coord,
            "topleft", pal = pal2, values = ~crashYear, title = "Fatal Crash by Year")

m
