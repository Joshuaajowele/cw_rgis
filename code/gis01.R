#Introduction to GIS for Ecology
#Author: Joshua Ajowele

#Load required packages
if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview)
#read in fish data
df_fish <- read_csv("data/data_finsync_nc.csv")

#convert dataframe/tibblee to georeferenced data
sf_site <- df_fish %>% 
  distinct(site_id, lon, lat) %>% # get unique combinations of longitude & latitude
  st_as_sf(coords = c("lon", "lat"),
           crs = 4326)

print(sf_site)

#view map
gg<-mapview(sf_site,
        legend = FALSE)
gg
