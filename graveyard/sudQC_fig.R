####
# title: Hypothetical contraction of high elevation habitat figure
# author: Victor Cameron
# date: 2021
####


# Dependencies
library(elevatr)
library(raster)
source(here::here("conceptual_fig", "patchArea_metrics.R"))

#### Load data ####

# Québec shapefile map
topo <- raster(here::here("data_clean", "templateRaster.tif"))

# Québec contour map
mask <- sf::read_sf(here::here("data_clean", "quebec_nad83.shp"))
mask_proj <- sf::st_transform(mask, crs(topo))

# Get elevation
elevation <- get_elev_raster(topo, z = 5)
elevation_c <- raster::mask(elevation, mask_proj)

#### Redefine map extent ####

# Crop map extent
extent = c(xmin = -514009, xmax = 356398, ymin = 110389, ymax = 633143)
e <- raster::extent(extent) # LatLong limits
elevation_reduced <- raster::crop(elevation, e)
elevation_reduced <- raster::mask(elevation_reduced, mask_proj)
# elevation_reduced[elevation_reduced<0] <- 0

# Get more precise elevation
#elevation2 <- get_elev_raster(elevation_reduced, z = 10)


#### Compute landscape metrics ####

land <- patchArea_metrics(elevation_reduced)

patchArea700 <- land$patchArea700
patchArea800 <- land$patchArea800

#### Draw the map ####

# Save plot in file
png('./manuscript/img/mapHab_GRBI.png', width = 250, height = 167, units='mm', res = 700, bg="transparent")

# South of Quebec base plot
raster::plot(elevation_reduced, legend=T,
             bty = "o", yaxs="i", xaxs="i")
# plot(elevation_reduced, legend.only=TRUE,
#         legend.args = list(text='Elevation (m)', line = 0))


# raster::plot(elevation_reduced<=0, bty="n", box=FALSE, legend = F, axes = F,  col = c('transparent', 'white'), add=T)

# Scale bar
# scalebar(d=200000, xy=c(0, 2e+5), type='bar', divs=4, lonlat=FALSE, below = 'm')

arrows(x0=2e+5, x1=2e+5, y0=2e+5, y1=2.5e+5,
        length=0.15, lwd=4)
text(x=2e+5, y=1.8e+5, label = "N", cex=1, font=2)

# 700m altitude contour
contour(elevation_reduced>=700, lwd=3, add=T, drawlabels=F)

# 800m altitude contour
contour(elevation_reduced>=800, col='red', lwd=1, add=T, drawlabels=F)

# Distribution of patch area
#par(fig=c(0.55,0.8,.2,0.65), lwd=3, new=TRUE)
#hist(log(patchArea800$area), angle=45, density=5, col='red', main='', xlab='', ylab='')
#mtext(side=1, 'Log patch area', line=2)
#mtext(side=2, 'Frequency', line=2)
#mtext(side=3, 'Distribution of patch area', line=0, cex=1.2)
#hist(log(patchArea700$area), col='black', angle=135, density=5, border='black', add=T, fill='transparent', cex=2)

# Close file
dev.off()
