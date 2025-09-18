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
mapview(sf_site,
        legend = FALSE)

#save new data as a r file
saveRDS(sf_site,
        file = "data/sf_finsync_nc.rds")

#convert from geodetic to projected####
#subset to two rows for 
sf_ft_wgs <- sf_site %>% 
  slice(c(1, 2))

print(sf_ft_wgs)
#change geodetic to projected (3 dimen to 2 dimension)
sf_ft_utm <- sf_ft_wgs %>% 
  st_transform(crs = 32617)

print(sf_ft_utm)


#distance between two points
st_distance(sf_ft_utm)
