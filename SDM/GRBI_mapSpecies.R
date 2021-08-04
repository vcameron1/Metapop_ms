#############################################################
## Point process species distribution model with `mapSpecies`
## Victor Cameron
## August 2021
#############################################################

# 0 - Setup ---------------------------------------------------------------


set.seed(123)

# Load mapSpecies package locally
devtools::load_all("../mapSpecies/")
library(mapSpecies)


# 1 - Load data -----------------------------------------------------------


# Load GRBI data
GRBI <- readxl::read_excel("./data_raw/RAPPORT QO_SOS-POP SCF_GRBI.xlsx", sheet = 2)

# Environmental data
climatePresent <- readRDS("./data_clean/bioclim_sQ.RDS")

# Elevation data
elevation <- readRDS("./data_clean/elev_sQ.RDS")

# Forest cover
forestCover <- readRDS("./data_clean/forestCover_sQ.RDS")


# 2 - Clean GRBI data -----------------------------------------------------


# Select one observation/ occurence per PRÉCISION == "S"
GRBI <- GRBI[GRBI$PRÉCISION == "S",]

# Remove recordings of absences
GRBI <- GRBI[GRBI$O_CODEATLA != "0",]

# Select presence in habitat, 
GRBI <- GRBI[GRBI$O_CODEATLA == c("H"),]

# Select one observation per coordinate per year (after 2000)
annee <- unique(GRBI$ANNEE)
annee <- annee[annee >= 2000]
GRBI$lat <- round(GRBI$LATITUDE, 2)
GRBI$lon <- round(GRBI$LONGITUDE, 2)

GRBI2 <- data.frame()
for(i in sort(annee)){
  for(j in unique(GRBI$lat)){
    for(k in unique(GRBI$lon)){
      obs <- which(GRBI$ANNEE == i &
                     GRBI$lat == j &
                     GRBI$lon == k)
      
      if(length(obs)>0) GRBI2 <- rbind(GRBI2, GRBI[obs[1],])
    }
  }
  cat(i, ": complété\n")
}
GRBI <- GRBI2
rm("GRBI2")

# Crop GRBI presence data
GRBI <- GRBI[GRBI$LONGITUDE>=xmin(elevation) & 
               GRBI$LONGITUDE<=xmax(elevation) & 
               GRBI$LATITUDE>=ymin(elevation) & 
               GRBI$LATITUDE<=ymax(elevation),]


# 2 - Format predictors ---------------------------------------------------


# Combine explanatory variables into a rasterStack*
explana_dat <- raster::stack(climatePresent, elevation, forestCover)
names(explana_dat[[which(names(explana_dat) == names(elevation))]]) <- "elevation"

# Build spatialPolygons and use those to select GRBI points within the region of interest
rasterForPoly <- elevation
values(rasterForPoly) <- ifelse(is.na(values(rasterForPoly)), NA, 1)
spacePoly <- rasterToPolygons(rasterForPoly, dissolve = TRUE)

GRBI_points <- SpatialPoints(cbind(GRBI$LONGITUDE, GRBI$LATITUDE),
                                  proj4string = spacePoly@proj4string)


# 3 - Build the mesh ------------------------------------------------------

# Building the mesh
regionBorder <- extent(spacePoly)
xyBasis <- rbind(cbind(c(xmin(spacePoly),xmax(spacePoly),
                         xmin(spacePoly),xmax(spacePoly)),
                       c(ymin(spacePoly),ymax(spacePoly), 
                         ymax(spacePoly),ymin(spacePoly))),
                 coordinates(GRBI_points))
Mesh <- inla.mesh.2d(loc.domain = xyBasis,
                     max.edge = 0.5,
                     min.angle = 20,
                     cutoff = 0.5,
                     offset = c(2,1),
                     crs = crs(spacePoly))

# Number of edges in the mesh
cat("\nThere are ", Mesh$n, " edges in the mesh\n")


# 4 - Organize the explanatory variables ----------------------------------


explana <- explanaMesh(sPoly = spacePoly,
                       mesh = Mesh, 
                       X = explana_dat)


# 5 - Calculate weights associated to each edges of the mesh --------------


weight <- ppWeight(sPoly = spacePoly, mesh = Mesh)


# 6 - Buid the models -----------------------------------------------------


# Spatial model
modelPPspatial <- ppSpace(y ~ 0, sPoints = GRBI_points,
                    explanaMesh = explana,
                    ppWeight = weight,
                    many = TRUE,
                    control.compute = list(waic = TRUE))

# Model with explanatory variables
modelPP <- ppSpace(y ~ ., sPoints = GRBI_points,
             explanaMesh = explana,
             ppWeight = weight,
             many = TRUE,
             control.compute = list(waic = TRUE))


# 7 - Study the estimated parameters --------------------------------------

# Summaries
summary(modelPPspatial) 
summary(modelPP) 

# Save models
dir.create("./SDM/results/", showWarnings = FALSE)
saveRDS(modelPPspatial, "./SDM/results/modelPPspatial.RDS")
saveRDS(modelPP, "./SDM/results/modelPP.RDS")


# 8 - Species distribution map for spatial model --------------------------


#--------------------------
# Construct prediction maps
#--------------------------
# Mean
mapMean <- mapSpace(modelPPspatial,
                    dims = dim(explana_dat)[1:2],
                    type = "mean",
                    sPoly = spacePoly)
# Standard deviation
mapSd <- mapSpace(modelPPspatial,
                    dims = dim(explana_dat)[1:2],
                    type = "sd",
                    sPoly = spacePoly)
# Lower boundary of the 95% confidence interval
map.025 <- mapSpace(modelPPspatial,
                    dims = dim(explana_dat)[1:2],
                    type = "0.025quant",
                    sPoly = spacePoly)
# Upper boundary of the 95% confidence interval
map.975 <- mapSpace(modelPPspatial,
                    dims = dim(explana_dat)[1:2],
                    type = "0.975quant",
                    sPoly = spacePoly)
#--------------------------------------
# Cut raster with polygon of the region
#--------------------------------------
mapMaskMean <- mask(mapMean, spacePoly)
mapMaskSd <- mask(mapSd, spacePoly)
mapMask.025 <- mask(map.025, spacePoly)
mapMask.975 <- mask(map.975, spacePoly)

# Colour to use for the maps
colo <- colorRampPalette(c("grey90", "steelblue4", 
                           "steelblue2", "steelblue1", 
                           "gold", "red1", "red4"))(200)
png('./SDM/results/spatialModel.png', width = 500, height = 500, units='mm', res = 700)
par(mfrow = c(2,2), mar = c(1,1,5,8))
plot(mapMaskMean, col = colo, zlim = c(0, 50),
     axes = FALSE, box = FALSE, main = "Mean")
points(coordinates(GRBI_points), pch = 19, cex = 0.2)
plot(mapMaskSd, col = colo,  zlim = c(0, 50),
     axes = FALSE, box = FALSE, main = "Sd")
points(coordinates(GRBI_points), pch = 19, cex = 0.2)
plot(mapMask.025, col = colo,  zlim = c(0, 50),
     axes = FALSE, box = FALSE, main = "2.5%")
points(coordinates(GRBI_points), pch = 19, cex = 0.2)
plot(mapMask.975, col = colo,  zlim = c(0, 50),
     axes = FALSE, box = FALSE, main = "97.5")
points(coordinates(GRBI_points), pch = 19, cex = 0.2)
dev.off()


# 9 - Species distribution map for full model -----------------------------


#--------------------------
# Construct prediction maps
#--------------------------
# Mean
mapMean <- mapSpace(modelPP,
                    dims = dim(explana_dat)[1:2],
                    type = "mean",
                    sPoly = spacePoly)
# Standard deviation
mapSd <- mapSpace(modelPP,
                    dims = dim(explana_dat)[1:2],
                    type = "sd",
                    sPoly = spacePoly)
# Lower boundary of the 95% confidence interval
map.025 <- mapSpace(modelPP,
                    dims = dim(explana_dat)[1:2],
                    type = "0.025quant",
                    sPoly = spacePoly)
# Upper boundary of the 95% confidence interval
map.975 <- mapSpace(modelPP,
                    dims = dim(explana_dat)[1:2],
                    type = "0.975quant",
                    sPoly = spacePoly)
#--------------------------------------
# Cut raster with polygon of the region
#--------------------------------------
mapMaskMean <- mask(mapMean, spacePoly)
mapMaskSd <- mask(mapSd, spacePoly)
mapMask.025 <- mask(map.025, spacePoly)
mapMask.975 <- mask(map.975, spacePoly)

png('./SDM/results/fullModel.png', width = 500, height = 500, units='mm', res = 700)
par(mfrow = c(2,2), mar = c(1,1,5,8))
plot(mapMaskMean, col = colo, zlim = c(0, 50),
     axes = FALSE, box = FALSE, main = "Mean")
points(coordinates(GRBI_points), pch = 19, cex = 0.2)
plot(mapMaskSd, col = colo,  zlim = c(0, 50),
     axes = FALSE, box = FALSE, main = "Sd")
points(coordinates(GRBI_points), pch = 19, cex = 0.2)
plot(mapMask.025, col = colo,  zlim = c(0, 50),
     axes = FALSE, box = FALSE, main = "2.5%")
points(coordinates(GRBI_points), pch = 19, cex = 0.2)
plot(mapMask.975, col = colo,  zlim = c(0, 50),
     axes = FALSE, box = FALSE, main = "97.5")
points(coordinates(GRBI_points), pch = 19, cex = 0.2)
dev.off()