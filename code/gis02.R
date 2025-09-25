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
  