#Introduction to GIS for Ecology
#Author: Joshua Ajowele

#Load required packages
if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview,
               here)
#read in fish data
df_fish <- read_csv(here::here("data/data_finsync_nc.csv"))

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
        file =here::here("data/sf_finsync_nc.rds"))

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


#Exercise####
#load data and convert to tibble
df_quakes<-as_tibble(quakes)

sf_quakes <- df_quakes %>% 
  distinct(stations, long, lat) %>% # get unique combinations of longitude & latitude
  st_as_sf(coords = c("long", "lat"),
           crs = 4326)

print(sf_quake)

#view map
mapview(sf_quakes,
        legend = FALSE)
#convert from geodetic to projected####
#subset to two rows for 
sf_ft_quake <- sf_quakes %>% 
  slice(c(1, 2))

print(sf_ft_quake)
#change geodetic to projected (3 dimen to 2 dimension, using UTM60S)
sf_ft_utm_quake <- sf_ft_quake %>% 
  st_transform(crs = 32760)

print(sf_ft_utm_quake)


#distance between two points
st_distance(sf_ft_utm_quake)
mapview(sf_ft_utm_quake)

#calculating distance before projection based on approximation
st_distance(sf_ft_quake)#close to the previous


#save as rds file
saveRDS(sf_quakes, file = here::here("data/sf_quakes.rds"))

