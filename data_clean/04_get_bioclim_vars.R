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


# Mean from 1981-2010
temp <- raster::raster("./data_raw/MappingQc_AnnualVar_1981_2010Tmean0.tif")
prec <- raster::raster("./data_raw/MappingQc_AnnualVar_1981_2010Prcp0.tif")
template <- readRDS("./data_clean/templateRaster_sQ.RDS")

# RCP4.5 projections
prec_RCP45_2040 <- raster::raster("./data_raw/MappingQc_AnnualVar_AnnualVar_RCP45_2011_2040Prcp0.tif")
temp_RCP45_2040 <- raster::raster("./data_raw/MappingQc_AnnualVar_AnnualVar_RCP45_2011_2040Tmean0.tif")
prec_RCP45_2070 <- raster::raster("./data_raw/MappingQc_AnnualVar_RCP45_2041_2070Prcp0.tif")
temp_RCP45_2070 <- raster::raster("./data_raw/MappingQc_AnnualVar_RCP45_2041_2070Tmean0.tif")
prec_RCP45_2100 <- raster::raster("./data_raw/MappingQc_AnnualVar_RCP45_2071_2100Prcp0.tif")
temp_RCP45_2100 <- raster::raster("./data_raw/MappingQc_AnnualVar_RCP45_2071_2100Tmean0.tif")

# RCP8.5 projections



# 2 - Helper function to standardize rasters ------------------------------


# Fuction that standardizes bioclim rasters
standardize.bioclimRas <- function(raster, template){
    # Reproject bioclim to match template (which also have a ~250m2 resolution)
    raster <- raster::projectRaster(raster, crs = raster::crs(template))

    # Crop to Québec meridional
    raster <- raster::crop(raster, raster::extent(template)) 

    # Resample to match template resolution
    raster <- raster::resample(raster, template, method = 'bilinear')

    return(raster)
}


# 3 - Crop 1981-2010 bioclim map to south of Quebec -----------------------


# Standardize temp and prec
temp <- standardize.bioclimRas(temp, template)
prec <- standardize.bioclimRas(prec, template)

# Stack bioclim variables
bioclim <- raster::stack(temp, prec)

# Rename variables
names(bioclim) <- c("temp","prec")

# Save
saveRDS(bioclim, "./data_clean/bioclim_sQ.RDS")


# 4 - Crop projected bioclim map to south of Quebec -----------------------


# Standardize RCP4.5 projections
prec_RCP45_2011_2040 <- standardize.bioclimRas(prec_RCP45_2040, template) 
temp_RCP45_2011_2040 <- standardize.bioclimRas(temp_RCP45_2040, template) ## +1.7°C
prec_RCP45_2041_2070 <- standardize.bioclimRas(prec_RCP45_2070, template) 
temp_RCP45_2041_2070 <- standardize.bioclimRas(temp_RCP45_2070, template) ## +3.5°C
prec_RCP45_2071_2100 <- standardize.bioclimRas(prec_RCP45_2100, template) 
temp_RCP45_2071_2100 <- standardize.bioclimRas(temp_RCP45_2100, template) ## +4.3°C

# Standardize RCP8.5 projections

# Stack bioclim variables
bioclim_proj <- raster::stack(prec, temp, prec_RCP45_2011_2040, temp_RCP45_2011_2040, prec_RCP45_2041_2070, temp_RCP45_2041_2070, prec_RCP45_2071_2100, temp_RCP45_2071_2100)

# Rename variables
names(bioclim_proj) <- c("prec_1981_2010", "temp_1981_2010","prec_RCP45_2011_2040", "temp_RCP45_2011_2040", "prec_RCP45_2041_2070", "temp_RCP45_2041_2070", "prec_RCP45_2071_2100", "temp_RCP45_2071_2100")

# Save 
saveRDS(bioclim_proj, "./data_clean/bioclim_proj_sQ.RDS")

