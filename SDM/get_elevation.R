#############################################################
## Generate an elevation raster* for the south of Quebec
## Victor Cameron 
## July 2021
#############################################################

#############################################################
## Data downloaded from https://www.worldclim.org/data/worldclim21.html
## Elevation data was downloaded at a precision of 30 seconds (~1 km2)
#############################################################


# 0 - Set directory -------------------------------------------------------


setwd("~/Documents/Git/Metapop_ms")


# 1 - Download data -------------------------------------------------------


# Url to access data
url <- "https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_30s_elev.zip"

# Directories and files
dir <- "./data_raw/"
destFile <- paste0(dir, "wc2.1_30s_elev.tif")

# Download file
download.file(url, destFile, method='curl')

# Unzip file
#unzip(destFile[1], exdir = dir)


# 2 - Import data ---------------------------------------------------------


# Import data
elev <- raster::raster("./data/wc2.1_30s_elev.tif")


# 3 - Crop elevation map to south of Quebec -------------------------------


# Crop to South of Québec
xmin = -75
xmax = -63
ymin = 45
ymax = 49.5
e <- raster::extent(c(xmin, xmax, ymin, ymax)) # LatLong limits
elev <- raster::crop(elev, e)


# 4 - Save transformed data -----------------------------------------------


# Save data
saveRDS(elev, "./data/elev_sQ.RDS")


# 5 - Remove downloaded files to save memory space ------------------------


# Remove all downloaded files to free memory space
unlink(destFile, recursive = TRUE)