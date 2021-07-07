


# Dependencies
library(elevatr)
library(raster)
source(here::here("conceptual_fig", "patchArea_metrics.R"))

#### Load data ####

# Données oiseaux
GRBI <- readxl::read_excel(here::here("data", "RAPPORT QO_SOS-POP SCF_GRBI.xlsx"), sheet = 2)

# Québec shapefile map
topo <- sf::read_sf(here::here("data", "topo_t.shp"))

# Get elevation
elevation <- get_elev_raster(topo, z = 5)


#### Redefine map extent ####

# Set LatLong limits
## Eastern townships
# xmin = -73
# xmax = -70
# ymin = 45
# ymax = 46
## South of Québec
xmin = -73
xmax = -64
ymin = 45
ymax = 49.5

# Crop map extent
e <- raster::extent(c(xmin, xmax, ymin, ymax)) # LatLong limits
elevation_reduced <- raster::crop(elevation, e)
elevation_reduced[elevation_reduced<0] <- 0

# Get more precise elevation
#elevation2 <- get_elev_raster(elevation_reduced, z = 10)


#### Compute landscape metrics ####

land <- patchArea_metrics(elevation_reduced)

patchArea700 <- land$patchArea700
patchArea800 <- land$patchArea800

#### Draw the map ####

# Save plot in file
png('./manuscript/img/mapHab_GRBI.png', width = 250, height = 193, units='mm', res = 700)

# South of Quebec base plot
raster::plot(elevation_reduced, legend=F,
             bty = "o", yaxs="i", xaxs="i")
raster::plot(elevation_reduced<=0, bty="n", box=FALSE, legend = F, axes = F,  col = c('transparent', 'lightblue'), add=T)

# Scale bar
scalebar(200, xy=c(-67.5, 45.2), type='bar', divs=4, lonlat=TRUE, adj=c(1,-2))

# 700m altitude contour
contour(elevation_reduced>=700, lwd=3, add=T, drawlabels=F)

# 800m altitude contour
contour(elevation_reduced>=800, col='red', lwd=1, add=T, drawlabels=F)

# Distribution of patch area
par(fig=c(0.55,0.8,.2,0.65), lwd=3, new=TRUE)
hist(log(patchArea800$area), angle=45, density=5, col='red', main='', xlab='', ylab='')
mtext(side=1, 'Log patch area', line=2)
mtext(side=2, 'Frequency', line=2)
mtext(side=3, 'Distribution of patch area', line=0, cex=1.2)
hist(log(patchArea700$area), col='black', angle=135, density=5, border='black', add=T, fill='transparent', cex=2)

# Close file
dev.off()
