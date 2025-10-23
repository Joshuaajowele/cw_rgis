#Introduction to GIS for Ecology
#Author: Joshua Ajowele
#Date started: Oct 9, 2025
#Load required packages

if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars)
#load rasta data
(spr_ex <- rast("data/spr_example.tif"))

# overwrite = TRUE enables overwriting
writeRaster(x = spr_ex, 
            filename = "data/spr_elev.tif",
            overwrite = TRUE)
#map raster
ggplot() +
  geom_spatraster(data = spr_ex)

#convert to stars to use mapview
star_ex <- st_as_stars(spr_ex)
mapview(star_ex)

#examine values of raster 
v_elev <- values(spr_ex)
head(v_elev)

#extract values from lat and long (specific location)
extract(spr_ex, y = cbind(6.0000, 50.0000))

#extract for multiple location
(df_point <- tibble(lon = c(6, 5.9), lat = c(50, 49.96)))
extract(spr_ex, y = df_point)

#binary data####
## load forest raster
(spr_for <- rast("data/spr_forest_nc.tif"))
#view
ggplot() +
  geom_spatraster(data = spr_for)#0 amd 1 indicating non-forested cells and forested cells
#check
unique(spr_for)

#easy to get summary stat with binary data
v_binary <- values(spr_for)
(p_forest <- mean(v_binary))

#data with multiple categories####
(spr_land <- rast("data/spr_land_reclass.tif"))
unique(spr_land)
#extract info on a location
extract(spr_land, cbind(-79.8063, 36.0701))

# write a conversion matrix
# left, original value
# right, value after conversion
(cm <- cbind(c(0, 1001, 1010, 1100),
             c(0, 1, 0, 0)))
#apply the matrix
spr_bin <- classify(spr_land,
                    rcl = cm)
#same result as before
v_bin <- values(spr_bin)
mean(v_bin)

#raster data manipulation####
(spr_prec <- rast("data/spr_prec_us.tif"))
#geograohic civerage
ext(spr_prec)
## crop to:
## longitude range: -80 to -75
## latitude range: 34 to 37 #order matters (xmin, xmax, ymin, ymax)
spr_prec_crop <- crop(x = spr_prec,
                      y = c(-80, -75, 34, 37))

## load county vector 
sf_nc_county <- readRDS("data/sf_nc_county.rds")#need vector data to show the cropped raster data location

ggplot() +
  geom_spatraster(data = spr_prec_crop) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25) ## alpha = 0.25 makes the polygon layer transparent

#cropping the raster based on vector for proper alignment
spr_prec_nc <- crop(x = spr_prec,
                    y = sf_nc_county)
#write file
writeRaster(spr_prec_nc, 
            filename ="data/spr_prec_nc.tif")

#view
ggplot() +
  geom_spatraster(data = spr_prec_nc) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25) ## alpha = 0.25 makes the polygon layer transparent

##combine raster data####
#load each dataset
spr_nw <- rast("data/spr_prec_ncnw.tif") # Northwest NC
spr_ne <- rast("data/spr_prec_ncne.tif") # Northeast NC
spr_sw <- rast("data/spr_prec_ncsw.tif") # Southwest NC
spr_se <- rast("data/spr_prec_ncse.tif") # Southeast NC
#view dataset
ggplot() +
  geom_spatraster(data = spr_nw) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)
#merge
spr_n <- merge(spr_nw, spr_ne)
ggplot() +
  geom_spatraster(data = spr_n) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)
##merge multiple
#create a list
list_spr <- list(spr_nw,
                 spr_ne,
                 spr_sw,
                 spr_se)
#use the spatialraster collection function
spr_col <- sprc(list_spr)
#merge
spr_merge <- merge(spr_col)
ggplot() +
  geom_spatraster(data = spr_merge) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)
##stack raster####
spr_prec_nc <- rast("data/spr_prec_nc.tif")
spr_tmp_nc <- rast("data/spr_tmp_nc.tif")

# print precipitation layer - do the same for spr_tmp_nc as well!
print(spr_prec_nc)
#stack
(spr_pt_nc <- c(spr_prec_nc,
                spr_tmp_nc))

# precipitation
spr_pt_nc$precipitation

#convert projected 
(spr_prec_nc_proj <- project(x = spr_prec_nc,
                             y = "EPSG:32617"))
#terra::project uses automatic resampling method= near for discrete abd bilinear for continous
#reprojecrion to geodetic CRS with raster data will not yield the original Geodetic values
#because of the resampling method applied. However, reprojection will be the same with vector data


