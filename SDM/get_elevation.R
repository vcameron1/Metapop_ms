
#====
# Elevation data at 30sec precision (~1 km2)
# Data downloaded from https://www.worldclim.org/data/worldclim21.html
#====

# Import data
elev <- raster::raster("./data/wc2.1_30s_elev.tif")

# Crop to South of Québec
xmin = -75
xmax = -63
ymin = 45
ymax = 49.5
e <- raster::extent(c(xmin, xmax, ymin, ymax)) # LatLong limits
elev <- raster::crop(elev, e)

raster::plot(elev)

# Save data
saveRDS(elev, "./data/elev_sQ.RDS")
