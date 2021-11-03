# Script Info -------------------------------------------------------------
# This script is used to find the optimal number of clusters

# Setting data
lat <- data$latitude
long <- data$longitude
df <- data.frame(long,lat)

# Calculating Variance
variance=apply(df,2,var)

# Calculating the sum of squares for 1 cluster
Sumofsq= (nrow(df)-1)*sum(variance)

# Calculating the sum of squares for 2 to 15 clusters
for (i in 2:15) {
  ClusterInfo=kmeans(df, centers=i)
  Sumofsq[i] = sum(ClusterInfo$withinss)
}

# Plot to find the optimum no. of clusters
plot(1:15, Sumofsq, main = "Optimum No. of Clusters", type="b", col="blue", xlab="Number of Clusters",ylab="Within groups sum of squares")
