
#====
# Bioclimatic variables data at 30sec precision (~1 km2)
# Data downloaded from https://www.worldclim.org/data/worldclim21.html
#====


# Verify data within wc2 file
dir("./data/wc2")
nvar <- length(dir("./data/wc2"))

# Extent of South of Québec
xmin = -75
xmax = -63
ymin = 45
ymax = 49.5
e <- raster::extent(c(xmin, xmax, ymin, ymax)) # LatLong limits

# Extract bioclim variables
for(var in 1:nvar){
  assign(paste0("bio", var), raster::raster(paste0("./data/wc2/wc2.1_30s_bio_",var,".tif")))
  
  # Crop map to south of Qc
  assign(paste0("bio", var), raster::crop(get(paste0("bio", var)), e))
}

# Create rasterStack* with the variables
bioclim <- raster::stack(mget(paste0("bio", 1:nvar)))
rm(list = paste0("bio", 1:nvar))

# Save bioclimatic variables
saveRDS(bioclim, "./data/bioclim_sQ.RDS")
