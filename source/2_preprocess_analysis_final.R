# Script Info -------------------------------------------------------------
# This script is used to select/extract features needed for analysis
# Includes some descriptive and exploratory data analysis

# Importing Libraries -----------------------------------------------------
library(plotly)
library(tidyverse)
library(scales)
library(purrr)
library(sf)

# Preprocessing -----------------------------------------------------------

# Selecting features
data_welly %>% head()

df_welly <- data_welly %>% select(areaUnitID,crashFinancialYear,crashSeverity,crashYear,
                                  holiday,meshblockId,minorInjuryCount,NumberOfLanes,region,roadLane,roadSurface,
                                  seriousInjuryCount,speedLimit,tlaId,tlaName,carStationWagon,
                                  crashLocation1,directionRoleDescription,flatHill,light,urban,weatherA)
df_welly$crashYear <- as.factor(df_welly$crashYear)
df_welly<-df_welly %>% filter(!(tlaId == 67)) # Removing Chatham Islands given extremely low count
summary(df_welly)

# Extracting Feature - Latitude & Longitude -------------------------------

separated_coord <- df_welly %>%
  mutate(longitude = unlist(purrr::map(df_welly$geometry,1)),
         latitude = unlist(purrr::map(df_welly$geometry,2)))

separated_coord

# Exploratory Data Analysis ---------------------------------------------

# 1a. Crashes by year - totals
fig <- ggplot(df_welly, aes(x = crashYear)) +ggtitle("Total Number of Crashes across Years ")+
  geom_bar()

fig<- ggplotly(fig)
fig
ggsave("out/1_crashes_by_year_totals.png")

# 1b. Crashes by year - Proportions
ggplot(df_welly, aes(x = as.factor(crashYear))) +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  geom_text(aes(y = ((..count..)/sum(..count..)), label = scales::percent((..count..)/sum(..count..))), stat = "count", vjust = -0.25) +
  scale_y_continuous(labels = percent) +  theme_bw()+
  labs(title = "Proportion of crashes by Year", y = "Percent", x = "Year")

# 2a. Crashes by year - breakdown by Severity

fig<-ggplot(df_welly, aes(x = crashYear,fill = crashSeverity)) +  
  ggtitle("Distribution of crashes by Crash Severity ")+
  geom_bar(position = position_dodge()) +
  geom_text(stat='count', aes(label=..count..), vjust=-0.5)
fig<- ggplotly(fig)
fig

ggsave("out/2a_crashes_by_year_Severity_totals.png")

# 2b. Crash Severity - Proportions
ggplot(df_welly, aes(x = as.factor(crashSeverity))) +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  geom_text(aes(y = ((..count..)/sum(..count..)), label = scales::percent((..count..)/sum(..count..))), stat = "count", vjust = -0.25) +
  scale_y_continuous(labels = percent) +  theme_bw()+
  labs(title = "Proportion by Severity", y = "Percent", x = "Crash Severity")

ggsave("out/2b_crashes_by_Severity_propor.png")

# 3. Distribution of crashes by TLA breakdown by Year

ggplot(df_welly, aes(x = tlaName,fill = crashYear)) +
  geom_bar(position = position_dodge()) +
  ggtitle("Distribution of crashes by TLA ")+
  facet_wrap(~crashYear, scale="free_x",dir="v")+ theme_bw()+
  geom_text(stat='count', aes(label=..count..), vjust=-0.5)

ggsave("out/3_crashes_by_tla_year.png")


# 4a. Weather - Proportion 
ggplot(df_welly, aes(x = as.factor(weatherA))) +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  geom_text(aes(y = ((..count..)/sum(..count..)), label = scales::percent((..count..)/sum(..count..))), stat = "count", vjust = -0.25) +
  scale_y_continuous(labels = percent) +
  labs(title = "Proportion by Weather", y = "Percent", x = "Weather")

ggsave("out/4_crashes_by_weather_prop.png")

# 4b. Weather - Counts by year totals 
ggplot(df_welly, aes(x = weatherA,fill = crashYear)) +
  geom_bar(position = position_dodge()) +
  ggtitle("Distribution of crashes by Weather ")+ theme_bw()+
  facet_wrap(~crashYear, scale="free_x",dir="v")+ geom_text(stat='count', aes(label=..count..), vjust=-0.9)

ggsave("out/5_crashes_by_year_weather_totals.png")

# 5a. Light Conditions - Proportions
ggplot(df_welly, aes(x = as.factor(light))) +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  geom_text(aes(y = ((..count..)/sum(..count..)), label = scales::percent((..count..)/sum(..count..))), stat = "count", vjust = -0.25) +
  scale_y_continuous(labels = percent) +
  labs(title = "Proportion by lighting conditions", y = "Percent", x = "Light Conditions")

ggsave("out/5a_crashes_by_lighting_proportions.png")

# 5b. Light Conditions - Totals  by year
ggplot(df_welly, aes(x = light,fill = crashYear)) +
  geom_bar(position = position_dodge()) +
  ggtitle("Distribution of crashes by lighting conditions ")+
  theme_bw()+
  facet_wrap(~crashYear, scale="free_x",dir="v")+ geom_text(stat='count', aes(label=..count..), vjust=-0.5)

ggsave("out/5b_crashes_by_lighting_totals.png")


# 6a. Flat or hill - Proportions
ggplot(df_welly, aes(x = as.factor(flatHill))) +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  geom_text(aes(y = ((..count..)/sum(..count..)), label = scales::percent((..count..)/sum(..count..))), stat = "count", vjust = -0.25) +
  scale_y_continuous(labels = percent) +  theme_bw()+
  labs(title = "Proportion of crashes by topography", y = "Percent", x = "Topography")

ggsave("out/6a_crashes_by_topo_propo.png")

# 6b. Flat or hill - Totals by year
ggplot(df_welly, aes(x = flatHill,fill = crashYear)) +
  geom_bar(position = position_dodge()) +
  ggtitle("Distribution of crashes by topography ")+ theme_bw()+
  facet_wrap(~crashYear, scale="free_x",dir="v")+ geom_text(stat='count', aes(label=..count..), vjust=-0.5)

ggsave("out/6b_crashes_by_topo_totals.png")

# 7. Urban or Open - Proportions
ggplot(df_welly, aes(x = as.factor(urban))) +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  geom_text(aes(y = ((..count..)/sum(..count..)), label = scales::percent((..count..)/sum(..count..))), stat = "count", vjust = -0.25) +
  scale_y_continuous(labels = percent) +  theme_bw()+
  labs(title = "Proportion by location", y = "Percent", x = "Roads")

ggsave("out/7_crashes_by_road_type_propor.png")

# 8. Speedlimit - Proportions
ggplot(df_welly, aes(x = as.factor(speedLimit))) +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = percent) +  theme_bw()+
  labs(title = "Total Crashes by Speed Limit", y = "Percent", x = "Speed Limit")

ggsave("out/8_crashes_by_Speedlimit_propor.png")

# 9. NumberOfLanes -Proportions
ggplot(df_welly, aes(x = as.factor(NumberOfLanes))) +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = percent) +  theme_bw()+
  labs(title = "Proportion by lanes", y = "Percent", x = "Number of Lanes")

ggsave("out/9_crashes_by_lanes_propor.png")
