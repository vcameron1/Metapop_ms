#############################################################
## Generate an elevation raster* for the south of Quebec
## Victor Cameron 
## Spetember 2021
#############################################################

#############################################################
## Elevation data was downloaded at a precision of ~90m
#############################################################


# 1 - Import raw data -----------------------------------------------------


template <- readRDS("./data_clean/templateRaster_sQ.RDS")
elev <- elevatr::get_elev_raster(template, z = 11)


# 2 - Standardize the raster extent and resolution ------------------------


elev <- raster::resample(elev, template, method = 'bilinear') 


# 3 - save data -----------------------------------------------------------


saveRDS(elev, "./data_clean/elev_sQ.RDS")

