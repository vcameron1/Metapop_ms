#############################################################
## Generate a bioclimate raster* for the south of Quebec
## Victor Cameron 
## July 2021
#############################################################

#############################################################
## Data downloaded from https://www.worldclim.org/data/worldclim21.html
## Bioclimatic variables were downloaded at a precision of 30 seconds (~1 km2)
#############################################################


# 0 - Set directory -------------------------------------------------------


setwd("~/Documents/Git/Metapop_ms")


# 1 - Download data -------------------------------------------------------


# Url to access data
url <- "https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_30s_bio.zip"

# Directories and files
dir <- "./data_raw/"
destFile <- paste0(dir, "wc2.1_30s_bio.zip")

# Download file
download.file(url, destFile)

# Unzip file
unzip(destFile[1])


# 2 - Verify files within downloaded folder -------------------------------


# Variables downloaded
file <- dir("./data_raw/wc2.1_30s_bio")



# 3 - Extract bioclim variables from folder -------------------------------


nvar <- length(file)

# Extent of South of Québec
xmin = -75
xmax = -63
ymin = 45
ymax = 49.5
e <- raster::extent(c(xmin, xmax, ymin, ymax)) # LatLong limits

# Import all bioclimatic variables
for(i in 1:nvar){
  assign(paste0("bio", i), raster::raster(paste0("./data_raw/wc2.1_30s_bio/", file[i])))
  
  # Crop map to south of Qc
  assign(paste0("bio", i), raster::crop(get(paste0("bio", i)), e))
    
  # Increase resolution of raster*
  # Split raster cells into 4 smaller cells (~25000m2)
  assign(paste0("bio", i), raster::disaggregate(get(paste0("bio", i)), fact = 4))
}


# 4 - Create rasterStack* with the variables ------------------------------


bioclim <- raster::stack(mget(paste0("bio", 1:nvar)))
rm(list = paste0("bio", 1:nvar))


# 5 - Save bioclimatic variables ------------------------------------------


saveRDS(bioclim, "./data_clean/bioclim_sQ.RDS")


# 6 - Remove downloaded files to save memory space ------------------------


# Remove all downloaded files to free memory space
unlink(destFile, recursive = TRUE)
unlink("./data/wc2", recursive = TRUE)
