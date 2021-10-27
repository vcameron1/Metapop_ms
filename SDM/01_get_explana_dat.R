################
# This script creates the explana_dat object
# Victor Cameron
# 02/08/21
###############

# Import data
## Environmental
climatePresent <- readRDS("./data_clean/bioclim_sQ.RDS")
## Elevation
elevation <- readRDS("./data_clean/elev_sQ.RDS")
## Forest cover
forestCover <- readRDS("./data_clean/forestFactor_sQ.RDS")

# Explana_dat
explana_dat <- raster::stack(climatePresent, elevation, forestCover)
names(explana_dat[[3]]) <- "elevation"

# Save
saveRDS(explana_dat, "./SDM/explana_dat.RDS")
