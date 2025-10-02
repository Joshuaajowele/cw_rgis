#Introduction to GIS for Ecology
#Author: Joshua Ajowele
#Date started: Sept 25, 2025
#Load required packages
if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview)


#vector data####
#vector and raster data are dealt with in different ways

#working with vector data
# read a shapefile (e.g., ESRI Shapefile format)
# `quiet = TRUE` just for cleaner output
(sf_nc_county <- st_read(dsn = "data/nc.shp",
                         quiet = TRUE))
# save as shapefile (overwrites by setting append = FALSE)
st_write(sf_nc_county, 
         dsn = "data/sf_nc_county.shp",
         append = FALSE)

# save as Geopackage (overwrites by setting append = FALSE)
st_write(sf_nc_county, 
         dsn = "data/sf_nc_county.gpkg",
         append = FALSE)
# save as an RDS file (compact and efficient for use within R)
saveRDS(sf_nc_county,
        file = "data/sf_nc_county.rds")
# read from an RDS file
sf_nc_county <- readRDS(file = "data/sf_nc_county.rds")
#point data
(sf_site <- readRDS("data/sf_finsync_nc.rds"))
#view
mapview(sf_site,
        col.regions = "black", # point's fill color
        legend = FALSE) # disable legend
## first 10 sites
(sf_site_f10 <- sf_site %>% 
    slice(1:10))
mapview(sf_site_f10,
        col.regions = "black", # point's fill color
        legend = FALSE) # disable legend
#line data
(sf_str <- readRDS("data/sf_stream_gi.rds"))
#view
mapview(sf_str,
        color = "steelblue", # line's color
        legend = FALSE) # disable legend
#polygon
(sf_nc_county <- readRDS("data/sf_nc_county.rds"))
#view
mapview(sf_nc_county,
        col.regions = "grey", # polygon's fill color
        legend = FALSE) # disable legend
#guilford county
(sf_nc_gi <- sf_nc_county %>% 
    filter(county == "guilford"))
#view
mapview(sf_nc_gi,
        col.regions = "grey", # polygon's fill color
        legend = FALSE) # disable legend
#start with polygon
ggplot() +
  geom_sf(data = sf_nc_county)
#add line layer
ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str)
#add point
ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str) +
  geom_sf(data = sf_site)

#exercise
#read in stream line file
(sf_str_as<-readRDS("data/sf_stream_as.rds"))
sf_nc_county


#filter ashe county
(sf_nc_ashe <- sf_nc_county %>% 
    filter(county == "ashe"))
#ggplot
ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str_as) 
  
#displaying only Ashe county
  #ggplot
ggplot() +
  geom_sf(data = sf_nc_ashe) +
  geom_sf(data = sf_str_as)

#Joining spatial vector data####
#join survey site with county polygon
sf_site_join <- st_join(x = sf_site, # base layer
                        y = sf_nc_county) # overlaying layer

#subsetting points in Guilford county
sf_site_guilford <- sf_site_join %>% 
  filter(county == "guilford")
#recreate map focusing on Guildford
#subsetting Guildford polygon
sf_nc_guilford <- sf_nc_county %>% 
  filter(county == "guilford")
ggplot() +
  geom_sf(data = sf_nc_guilford) +
  geom_sf(data = sf_str) +
  geom_sf(data = sf_site_guilford) +
  theme_bw()
#customize 
ggplot() +
  geom_sf(data = sf_nc_guilford) +
  geom_sf(data = sf_str,
          color = "steelblue") +
  geom_sf(data = sf_site_guilford,
          color = "salmon") +
  theme_bw()

#Geometric analysis####
#geodetic CRS should not be used for calculations...
#transform to an appropriate projected CRS based on location
(sf_str_proj <- st_transform(sf_str, crs = 32617))
#calcuate length of each stream segmentin metres
v_str_l <- st_length(sf_str_proj)

# print the first 10 elements
head(v_str_l)
#add new calculation
(sf_str_w_len <- sf_str %>% 
    mutate(length = v_str_l))

#redo the process in one go
sf_str_w_len <- sf_str %>% 
  st_transform(crs = 32617) %>%       # transform to projected CRS (utm zone 17n) for accurate length calculation
  mutate(length = st_length(.)) %>%   # calculate length of each feature and store it in a new column
  st_transform(crs = 4326)           # transform back to geographic CRS (wgs84) for consistency with other layers

# # the above code returns identical results with the code below
# sf_str_proj <- st_transform(sf_str, crs = 32617)
# v_str_l <- st_length(sf_str_proj)               
# sf_str <- sf_str %>% 
#   mutate(length = v_str_l)                      

#claulate area of polygon
(sf_nc_county_w_area <- sf_nc_county %>% 
    st_transform(crs = 32617) %>%       # transform to projected CRS (utm zone 17n) for accurate area calculation
    mutate(area = st_area(.)) %>%       # calculate area of each polygon and store it in a new column
    st_transform(crs = 4326))           # transform back to geographic CRS (wgs84) for consistency with other layers
#filter area above 1000 km2
(sf_nc_county_1000 <- sf_nc_county_w_area %>% 
    mutate(area = as.numeric(area) / 1e+6) %>% #convert to km2
    filter(area > 1000))

#view
ggplot() +
  geom_sf(data = sf_nc_county_1000) +
  theme_bw()
