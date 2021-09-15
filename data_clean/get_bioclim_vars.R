#############################################################
## Generate a bioclim rasterStack* for the south of Quebec
## Victor Cameron 
## September 2021
#############################################################

#############################################################
## Data generated using BioSim (https://cfs.nrcan.gc.ca/projects/133)
## Temperature and precipitation are annual means for the 1981-2010 period
## Data was simulated at a precision of 250m2
#############################################################


# 1 - Import raw data -----------------------------------------------------


temp <- raster::raster("./data_raw/mat.tif")
prec <- raster::raster("./data_raw/tap.tif")
template <- readRDS("./data_clean/templateRaster_sQ.RDS")


# 2 - Crop bioclim map to south of Quebec ---------------------------------


# Reproject bioclim to match template (which also have a ~250m2 resolution)
temp <- raster::projectRaster(temp, crs = raster::crs(template))

# Crop to Québec meridional
temp <- raster::crop(temp, raster::extent(template)) # May require to download forest cover data in steps 1-2 of get_forest_cover.R script

# Resample to match template resolution
temp <- raster::resample(temp, template, method = 'bilinear') 


prec <- raster::projectRaster(prec, crs = raster::crs(template))
bioclim <- raster::stack(temp, prec)

# Crop to Québec meridional
bioclim <- raster::crop(bioclim, raster::extent(template)) # May require to download forest cover data in steps 1-2 of get_forest_cover.R script


# 3 - transform temperature back in degrees C -----------------------------


# Temperatures were multiplied by 10 to avoid decimals
raster::values(bioclim[["mat"]]) <- raster::values(bioclim[["mat"]])/10


# 4 - Save bioclimate variable --------------------------------------------


saveRDS(bioclim, "./data_clean/bioclim_sQ.RDS")

