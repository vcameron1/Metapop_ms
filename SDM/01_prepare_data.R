##############################################################################
# Prepare data for the species distribution model
#
# Victor Cameron
# October 2021
##############################################################################

#==============================================================================
# 0. Create template raster
#
# Biomass raster (from Boulanger and Pascual Puigdevall (2021)) is used as template
#==============================================================================

# Initiate raster based upon forest biomass projections
load("./data_raw/RCP45_GrowthBudwormBaselineFire_ABIE.BAL_0_merged.RData")
template <- MergedRasters >= 0

# Save template
raster::writeRaster(template, filename="./data_clean/templateRaster.tif", overwrite=TRUE)


#==============================================================================
# 1. Prepare BITH observation data
#
# Generate a raster* of presences and pseudo absences
# Return spatial points that actually are the raster cells centroids
#==============================================================================

# 1 - Import data ---------------------------------------------------------

GRBI <- readxl::read_excel("./data_raw/RAPPORT QO_SOS-POP SCF_GRBI_subset.xlsx", sheet = 2)


# 2 - Explore GRBI data ---------------------------------------------------

# Available variables/data
#colnames(GRBI)

# Spatial distribution of points
#plot(GRBI$'LONGITUDE_SIGN GÉO ASSOCIÉ À LA MENTION', GRBI$'LATITUDE_SIGN GÉO ASSOCIÉ À LA MENTION')
#NA %in% unique(GRBI$'LONGITUDE_SIGN GÉO ASSOCIÉ À LA MENTION')
#NA %in% unique(GRBI$'LATITUDE_SIGN GÉO ASSOCIÉ À LA MENTION')

# Spatial distribution of points by site
#sunflowerplot(GRBI$LONGITUDE, GRBI$LATITUDE)

# Temporal distribution of occurences
#hist(GRBI$ANNEE) # Year 1000?
#sort(unique(GRBI$ANNEE)) 
#GRBI[GRBI$ANNEE < 2000, c("NOM SITE", "LATITUDE_SIGN GÉO ASSOCIÉ À LA MENTION", "LONGITUDE_SIGN GÉO ASSOCIÉ À LA MENTION", "ANNEE" )]
#hist(GRBI$ANNEE[GRBI$ANNEE > 1990])

# Distribution of precisions
#table(GRBI$PRÉCISION)

# Distribution of classifications
#table(GRBI$CLASSIFICATION)

# Distribution of usage
#table(GRBI$USAGE)

# Distribution of types of occurences
#table(GRBI$O_CODEATLA)


# 3 - Clean GRBI data -----------------------------------------------------

# DNOTE: ata provided is the clean version of the original raw data. The following steps were followed :

# # Select occurences that have coordinates data
# GRBI <- GRBI[!is.na(GRBI$'LONGITUDE_SIGN GÉO ASSOCIÉ À LA MENTION') & !is.na(GRBI$'LATITUDE_SIGN GÉO ASSOCIÉ À LA MENTION'),]

# # Select occurences with PRÉCISION == "S" 
# # which corresponds to coordinates precise to the second
# GRBI <- GRBI[GRBI$PRÉCISION == "S",]
  
# # Remove recordings of absences
# GRBI <- GRBI[GRBI$O_CODEATLA != "0",]

# # Select occurences with classification "R" 
# # occurences that are certain
# GRBI <- GRBI[GRBI$CLASSIFICATION == "R",]

# # Select nidification usage
# GRBI <- GRBI[GRBI$USAGE == "Nidification",]


# 3 - Reproject spatial points --------------------------------------------

# Load reference raster
template <- raster::raster("./data_clean/templateRaster.tif")

# Coordinates to spatial points
GRBI_points <- sp::SpatialPoints(cbind(GRBI$'LONGITUDE_SIGN GÉO ASSOCIÉ À LA MENTION', GRBI$'LATITUDE_SIGN GÉO ASSOCIÉ À LA MENTION'), proj4string = raster::crs("+proj=longlat +datum=WGS84 +no_defs"))

# Reproject points
GRBI_points <- sp::spTransform(GRBI_points, raster::crs(template))


# 4 - Rasterize BITH occurences -------------------------------------------

# Rasterize BITH occurences as presences/absences
#GRBI_points <- sp::SpatialPoints(cbind(GRBI$'LONGITUDE_SIGN GÉO ASSOCIÉ À LA MENTION', GRBI$'LATITUDE_SIGN GÉO ASSOCIÉ À LA MENTION'), proj4string = spacePoly@proj4string)
GRBI <- raster::rasterize(GRBI_points, template, fun='count')


# 5 - Crop BITH data to region of interest --------------------------------

GRBI <- raster::crop(GRBI, template)
GRBI <- raster::mask(GRBI, template)

# Set presences as 1
GRBI[GRBI > 0] <- 1


# 6 - BITH raster back to spatialPoints -----------------------------------

# Back to spatialPoints
#GRBI_points <- raster::rasterToPoints(GRBI) # Keep cell centroids
#GRBI_points <- sp::SpatialPoints(GRBI_points, proj4string = raster::crs(template))


# 7 - Save rasterized BITH occurences -----------------------------------

write.csv(raster::values(GRBI), "./data_clean/GRBI_rasterized.csv")
#saveRDS(GRBI_points, "./data_clean/GRBI_rasterPoints.RDS")


#==============================================================================
# 2. Prepare explanatory variables for model parametrization
#
# Steps:
# 1. Load data and projections
# 2. Combine all explanatory variables in a raster object
# 3. Save explanatory variables in one file
#
# Explanatory variables are saved as raster objects in RDS files.
#==============================================================================

# 1 - Useful function -----------------------------------------------------

# # Function that standardizes rasters
# standardize.raster <- function(raster, template, spacePoly, resample = FALSE){
#     # Reproject bioclim to match template (which also have a ~250m2 resolution)
#     raster <- raster::projectRaster(raster, crs = raster::crs(template))

#     # Crop to Québec meridional
#     raster <- raster::crop(raster, raster::extent(template))

#     # Resample to match template resolution
#     if (resample){
#         raster <- raster::resample(raster, template, method = 'bilinear')}

#     # Cut raster with polygon of the region
#     #raster <- raster::mask(raster, spacePoly)

#     return(raster)
# }

# 1 - Load biomass data and projections ------------------------------------------

#biomass is expressed as g.m-2 of total pixel

# Load projections for 2020, 2040, 2070, 2100
proj <- c(0, 20, 50, 80)
names <- c(2020, 2040, 2070, 2100)

# Abie Balsamea biomass
filenames <- paste0("RCP45_GrowthBudwormBaselineFire_ABIE.BAL_", proj,"_merged.RData")

load(paste0("./data_raw/", filenames[1]))
abie.bal_RCP45 <- MergedRasters
for(file in filenames[-1]){
    load(paste0("./data_raw/", file))
    abie.bal_RCP45 <- raster::addLayer(abie.bal_RCP45, MergedRasters)
}
names(abie.bal_RCP45) <- paste0("abie.bal_RCP45_", names)

# Total biomass
filenames <- paste0("RCP45_GrowthBudwormBaselineFire_TotalBiomass_", proj,"_merged.RData")
load(paste0("./data_raw/", filenames[1]))
TotalBiomass_RCP45 <- MergedRasters
for(file in filenames[-1]){
    load(paste0("./data_raw/", file))
    TotalBiomass_RCP45 <- raster::addLayer(TotalBiomass_RCP45, MergedRasters)
}
names(TotalBiomass_RCP45) <- paste0("TotalBiomass_RCP45_", names)

# Proportion of biomass of Abie balsamea
prop <- TotalBiomass_RCP45[[1]]
raster::values(prop) <- raster::values(abie.bal_RCP45[[1]]) / raster::values(TotalBiomass_RCP45[[1]])
propAbie.bal_RCP45 <- prop
for (i in seq_along(names(abie.bal_RCP45))[-1]){
    raster::values(prop) <- raster::values(abie.bal_RCP45[[i]]) / raster::values(TotalBiomass_RCP45[[i]])
    propAbie.bal_RCP45 <- raster::addLayer(propAbie.bal_RCP45, prop)
}
names(propAbie.bal_RCP45) <- paste0("propAbie.bal_", names)

# 2 - Load climate data and projections ------------------------------------------

# Mean from 1981-2010
temp <- raster::raster("./data_raw/MappingQc_AnnualVar_1981_2010Tmean0.tif")
prec <- raster::raster("./data_raw/MappingQc_AnnualVar_1981_2010Prcp0.tif")

# RCP4.5 projections
prec_RCP45_2040 <- raster::raster("./data_raw/MappingQc_AnnualVar_AnnualVar_RCP45_2011_2040Prcp0.tif")
temp_RCP45_2040 <- raster::raster("./data_raw/MappingQc_AnnualVar_AnnualVar_RCP45_2011_2040Tmean0.tif")
prec_RCP45_2070 <- raster::raster("./data_raw/MappingQc_AnnualVar_RCP45_2041_2070Prcp0.tif")
temp_RCP45_2070 <- raster::raster("./data_raw/MappingQc_AnnualVar_RCP45_2041_2070Tmean0.tif")
prec_RCP45_2100 <- raster::raster("./data_raw/MappingQc_AnnualVar_RCP45_2071_2100Prcp0.tif")
temp_RCP45_2100 <- raster::raster("./data_raw/MappingQc_AnnualVar_RCP45_2071_2100Tmean0.tif")

# Crop data to template extent
prec_RCP45_2010 <- raster::crop(prec, raster::extent(template))
temp_RCP45_2010 <- raster::crop(temp, raster::extent(template))
prec_RCP45_2011_2040 <- raster::crop(prec_RCP45_2040, raster::extent(template))
temp_RCP45_2011_2040 <- raster::crop(temp_RCP45_2040, raster::extent(template))
prec_RCP45_2041_2070 <- raster::crop(prec_RCP45_2070, raster::extent(template))
temp_RCP45_2041_2070 <- raster::crop(temp_RCP45_2070, raster::extent(template))
prec_RCP45_2071_2100 <- raster::crop(prec_RCP45_2100, raster::extent(template))
temp_RCP45_2071_2100 <- raster::crop(temp_RCP45_2100, raster::extent(template))

# Mask
prec_RCP45_2010 <- raster::mask(prec, template)
temp_RCP45_2010 <- raster::mask(temp, template)
prec_RCP45_2011_2040 <- raster::mask(prec_RCP45_2040, template)
temp_RCP45_2011_2040 <- raster::mask(temp_RCP45_2040, template)
prec_RCP45_2041_2070 <- raster::mask(prec_RCP45_2070, template)
temp_RCP45_2041_2070 <- raster::mask(temp_RCP45_2070, template)
prec_RCP45_2071_2100 <- raster::mask(prec_RCP45_2100, template)
temp_RCP45_2071_2100 <- raster::mask(temp_RCP45_2100, template)


# 5 - Get elevation data ------------------------------------------

## Elevation data was downloaded at a precision of 186.803m

# Load elevation
#template <- raster::raster("./data_clean/templateRaster.tif")
elev <- elevatr::get_elev_raster(template, z = 8, clip = "bbox") # Error when downloading more precise (z > 8) elevation data


# Standardize the raster extent and resolution
# in response to slightly different resolution
elev <- raster::resample(elev, template, method = 'bilinear') 

# Mask
elev <- raster::mask(elev, template)

# 6 - Combine all explanatory variables for model -------------------------

# Stack layers
explana_dat <- raster::stack(propAbie.bal_RCP45[[1]], abie.bal_RCP45[[1]], elev, prec_RCP45_2010, temp_RCP45_2010)

# Set useful names
names(explana_dat) <- c("abie.balPropBiomass", "abie.balBiomass", "elevation", "prec", "temp")

# Add temp^2
explana_dat[["temp2"]] <- explana_dat[["temp"]]
raster::values(explana_dat[["temp2"]]) <- raster::values(explana_dat[["temp"]])^2

# 7 - Save explanatory variables in one file -------------------------

explana_dat_df <- as.data.frame(raster::values(explana_dat))
saveRDS(explana_dat_df[,-"V1"], "./SDM/explana_dat_df.rds")


#==============================================================================
# 3. Prepare parameter values (projected explanatory variables) for model projections
#
# Steps:
# 0. Data was imported at previous step
# 1. Combine all explanatory variables for RCP4.5 scenario 
# 2. Combine all explanatory variables for biomass scenario 
#
# Projected explanatory variables are saved as raster objects in RDS files.
#==============================================================================

# 1 - Combine data for model projections ----------------------------------

#### RCP4.5 ####

# # 2020
RCP45_2020 <- explana_dat
RCP45_2020_df <- explana_dat_df
# # 2040
RCP45_2040 <- raster::stack(propAbie.bal_RCP45[[1]], abie.bal_RCP45[[1]], elev, prec_RCP45_2011_2040, temp_RCP45_2011_2040)
names(RCP45_2040) <- names(explana_dat)[1:5]
RCP45_2040[["temp2"]] <- RCP45_2040[["temp"]]
raster::values(RCP45_2040[["temp2"]]) <- raster::values(RCP45_2040[["temp"]])^2
RCP45_2040_df <- as.data.frame(raster::values(RCP45_2040))
# # 2070
RCP45_2070 <- raster::stack(propAbie.bal_RCP45[[1]], abie.bal_RCP45[[1]], elev, prec_RCP45_2041_2070, temp_RCP45_2041_2070)
names(RCP45_2070) <- names(explana_dat)[1:5]
RCP45_2070[["temp2"]] <- RCP45_2070[["temp"]]
raster::values(RCP45_2070[["temp2"]]) <- raster::values(RCP45_2070[["temp"]])^2
RCP45_2070_df <- as.data.frame(raster::values(RCP45_2070))
# # 2100
RCP45_2100 <- raster::stack(propAbie.bal_RCP45[[1]], abie.bal_RCP45[[1]], elev, prec_RCP45_2071_2100, temp_RCP45_2071_2100)
names(RCP45_2100) <- names(explana_dat)[1:5]
RCP45_2100[["temp2"]] <- RCP45_2100[["temp"]]
raster::values(RCP45_2100[["temp2"]]) <- raster::values(RCP45_2100[["temp"]])^2
RCP45_2100_df <- as.data.frame(raster::values(RCP45_2100))

# # Save projections as DF
saveRDS(RCP45_2020_df[,-"V1"], "./SDM/RCP45_2020_df.rds")
saveRDS(RCP45_2040_df[,-"V1"], "./SDM/RCP45_2040_df.rds")
saveRDS(RCP45_2070_df[,-"V1"], "./SDM/RCP45_2070_df.rds")
saveRDS(RCP45_2100_df[,-"V1"], "./SDM/RCP45_2100_df.rds")


#### Biomass ####

# # 2020
biomass_2020 <- explana_dat
biomass_2020_df <- explana_dat_df
# # 2040
biomass_2040 <- raster::stack(propAbie.bal_RCP45[[2]], abie.bal_RCP45[[2]], elev, prec_RCP45_2010, temp_RCP45_2010)
names(biomass_2040) <- names(explana_dat)[1:5]
biomass_2040[["temp2"]] <- biomass_2040[["temp"]]
raster::values(biomass_2040[["temp2"]]) <- raster::values(biomass_2040[["temp"]])^2
biomass_2040_df <- as.data.frame(raster::values(biomass_2040))
# # 2070
biomass_2070 <- raster::stack(propAbie.bal_RCP45[[3]], abie.bal_RCP45[[3]], elev, prec_RCP45_2010, temp_RCP45_2010)
names(biomass_2070) <- names(explana_dat)[1:5]
biomass_2070[["temp2"]] <- biomass_2070[["temp"]]
raster::values(biomass_2070[["temp2"]]) <- raster::values(biomass_2070[["temp"]])^2
biomass_2070_df <- as.data.frame(raster::values(biomass_2070))
# # 2100
biomass_2100 <- raster::stack(propAbie.bal_RCP45[[4]], abie.bal_RCP45[[4]], elev, prec_RCP45_2010, temp_RCP45_2010)
names(biomass_2100) <- names(explana_dat)[1:5]
biomass_2100[["temp2"]] <- biomass_2100[["temp"]]
raster::values(biomass_2100[["temp2"]]) <- raster::values(biomass_2100[["temp"]])^2
biomass_2100_df <- as.data.frame(raster::values(biomass_2100))

# # Save projections as DF
saveRDS(biomass_2020_df[,-"V1"], "./SDM/biomass_2020_df.rds")
saveRDS(biomass_2040_df[,-"V1"], "./SDM/biomass_2040_df.rds")
saveRDS(biomass_2070_df[,-"V1"], "./SDM/biomass_2070_df.rds")
saveRDS(biomass_2100_df[,-"V1"], "./SDM/biomass_2100_df.rds")
