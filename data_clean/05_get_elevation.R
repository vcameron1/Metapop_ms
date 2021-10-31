#############################################################
## Generate an elevation raster* for the south of Quebec
## Victor Cameron
## Spetember 2021
#############################################################

#############################################################
## Elevation data was downloaded at a precision of 186.803sm
#############################################################


# 1 - Import raw data -----------------------------------------------------


template <- raster::raster("./data_clean/templateRaster.tif")
elev <- elevatr::get_elev_raster(template, z = 8, clip = "bbox") # Error when downloading more precise (z > 8) elevation data


# 2 - Standardize the raster extent and resolution ------------------------


# In response to slightly different resolutions
elev <- raster::resample(elev, template, method = 'bilinear') 


# 3 - Cut raster with polygon of the region -------------------------------


# Import spacePoly
spacePoly <- 

# Mak
elev <- raster::mask(elev, spacePoly)


# 4 - save data -----------------------------------------------------------


raster::writeRaster(template, filename="./data_clean/elev.tif", overwrite=TRUE)
