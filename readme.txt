# Information on this repository is provided here

About the folder:
source: Contains all the R code
out: Contains all the outputs. Only plots in this case.  Map based visualization cannot be saved as plots in directory.
data: Contains data, none in this case

About the files:

Kindly execute the files in the order below
1. 1_data_fetch.R :- Contains code to fetch the data from Open Data Platform. Remember to delete downloaded json files before re-executing the script as default setting for OVERWRITING is FALSE.
2. 2a_preprocess_analysis :- Contains code to select, extract and some basic visual analysis
3. 2b_map_viz :- Contains code for map based visualization
4. 3a_spatial_data_clustering :- Contains code to cluster the spatial data
5. 3b_get_optimum_clusters :- Code to find the optimal number of clusters. This is an independent program.

Packages needed to run the code: 
(sf),(tidyverse),(httr),(plotly),(scales),(purrr),(ggspatial),(tidyverse),(ggthemes),(ggrepel),(maps),(leaflet),(leaflet.extras),(sp),(geosphere),(dplyr)

Code to install the package: (Copy/Paste and Run)
 if (!require("leaflet")) install.packages("leaflet")
 if (!require("leaflet.extras")) install.packages("leaflet.extras"); 
 if (!require("sp")) install.packages("sp")
 if (!require("geosphere")) install.packages("geosphere"); 
 if (!require("dplyr")) install.packages("dplyr")
 if (!require("maps")) install.packages("maps")
 if (!require("ggrepel")) install.packages("ggrepel")
 if (!require("ggthemes")) install.packages("ggthemes")
 if (!require("tidyverse")) install.packages("tidyverse")
 if (!require("purrr")) install.packages("purrr")
 if (!require("plotly")) install.packages("plotly")
 if (!require("ggspatial")) install.packages("ggspatial")
 if (!require("scales")) install.packages("scales")
 if (!require("httr")) install.packages("httr")
 if (!require("tidyverse")) install.packages("tidyverse")
 if (!require("sf")) install.packages("sf")


Kindly contact sujithroy.apps@gmail.com for any clarifications.


