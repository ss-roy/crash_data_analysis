# Script Info -------------------------------------------------------------
# Taking the unsupervised approach as the given data is unlabelled
# Spatial data points are clustered using Hierarchical clustering algorithm by Brute force approach
# The optimal number of clusters is identified by visualizing the elbow graph
# The elbow graph can be obtained by running the (3b_optimum_clustering.R) script.

# Importing Libraries -----------------------------------------------------
library(sp)
library(geosphere)
library(dplyr)

# Setting data
data <- separated_coord
lat <- data$latitude
long <- data$longitude

# Converting data to a Spatial Points DataFrame object
df <- SpatialPointsDataFrame(
  matrix(c(long,lat), ncol=2), data.frame(ID=seq(1:length(lat))),
  proj4string=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84"))

# Calculating Distance Matrix
mdist <- distm(df)

# Cluster all points using a hierarchical clustering approach
hc <- hclust(as.dist(mdist), method="complete")    
plot(hc)

# Slicing the dendrogram to generate the obtained optimum number of clusters (4 Clusters)
# source("source/3b_get_optimum_clusters.R") # To find the optimal number of clusters
df$clust <- cutree(hc,k=4)

# Plotting the Clusters
plot(df, col = df$clust, main="Spatial Data Clustering")
legend(x="bottomright", title="Clusters",legend=c("Cluster 1", "Cluster 2", "Cluster 3", "Cluster 4"), fill = c("black","red","blue","green"))
