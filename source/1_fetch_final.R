# Script Info -------------------------------------------------------------
# This script fetches the data using API services provided by NZTA Open Data Platform
# Scope is limited to Wellington Region
# Other regions data can also be fetched by making minor adjustments to fetch filter
#
# Remember to delete downloaded json files before re-executing the script as default setting for OVERWRITING is FALSE.
# Importing Libraries -----------------------------------------------------
library(sf)
library(tidyverse)
library(httr)

# Data Fetch --------------------------------------------------------------
# &resultType=standard
datalist_welly = list()

for (y in 2018:2020){
  url<-paste0("https://services.arcgis.com/CXBb7LAjgIIdcsPt/arcgis/rest/services/CAS_Data_Public/FeatureServer/0/query?where=region%20%3D%20'WELLINGTON%20REGION'%20AND%20%20(crashYear%20%3D%20",
              y,
              "%20OR%20crashYear%20%3D%20",
              y,
              ")%20&outFields=*&resultType=standard&outSR=4326&f=json")
  httr::GET(
    url = url,
    httr::write_disk(basename(url)),
    httr::progress()
  )
  welly <- st_read(basename(url))
  welly$i <- y  # Keep track of which iteration produced it
  datalist_welly[[y]] <- welly # Add it to your list
  
}

# Final Data - To be used for analysis ------------------------------------
data_welly = do.call(rbind, datalist_welly)

data_welly %>% head()
rm(list=setdiff(ls(), "data_welly"))
